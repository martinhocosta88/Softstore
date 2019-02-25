tableextension 31023062 "PTSS Service Line" extends "Service Line" //MyTargetTableId
{
    //Configuracao SAFT
    //Notas de Crédito de Acordo com Fatura
    fields
    {
        field(31022898; "PTSS Credit-to Doc. No."; Code[20])
        {
            Caption = 'Credit-to Doc. No.';
            DataClassification = CustomerContent;
            trigger OnLookup()
            var
                ServInvHeader: Record "Service Invoice Header";
                ServInvoices: Page "Posted Service Invoices";
            begin
                ServInvHeader.SETRANGE("Bill-to Customer No.", "Bill-to Customer No.");
                IF "PTSS Credit-to Doc. No." <> '' THEN
                    ServInvHeader.SETRANGE("No.", "PTSS Credit-to Doc. No.");
                IF ServInvHeader.FINDFIRST THEN;
                ServInvHeader.SETRANGE("No.");

                ServInvoices.SETTABLEVIEW(ServInvHeader);
                ServInvoices.SETRECORD(ServInvHeader);
                ServInvoices.LOOKUPMODE(TRUE);
                IF ServInvoices.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    ServInvoices.GetServiceInvoice(ServInvHeader);
                    "PTSS Credit-to Doc. No." := ServInvHeader."No.";
                END;
                CLEAR(ServInvoices);
            end;
        }
        field(31022899; "PTSS Credit-to Doc. Line No."; Integer)
        {
            Caption = 'Credit - to Doc. Line No.';
            DataClassification = CustomerContent;
            trigger OnLookup()
            var
                ServInvLine: Record "Service Invoice Line";
                ServInvLines: Page "Posted Service Invoice Lines";
            begin
                ServInvLine.SETRANGE("Bill-to Customer No.", "Bill-to Customer No.");
                IF "PTSS Credit-to Doc. Line No." <> 0 THEN BEGIN
                    ServInvLine.SETRANGE("Document No.", "PTSS Credit-to Doc. No.");
                    ServInvLine.SETRANGE("Line No.", "PTSS Credit-to Doc. Line No.");
                    IF ServInvLine.FINDFIRST THEN;
                    ServInvLine.SETRANGE("Document No.");
                    ServInvLine.SETRANGE("Line No.");
                END ELSE
                    IF "PTSS Credit-to Doc. No." <> '' THEN BEGIN
                        ServInvLine.SETRANGE("Document No.", "PTSS Credit-to Doc. No.");
                        IF ServInvLine.FINDFIRST THEN;
                        ServInvLine.SETRANGE("Document No.");
                    END;
                ServInvLines.SETTABLEVIEW(ServInvLine);
                ServInvLines.SETRECORD(ServInvLine);
                ServInvLines.LOOKUPMODE(TRUE);
                IF ServInvLines.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    ServInvLines.GetServInvLines(ServInvLine);
                    "PTSS Credit-to Doc. No." := ServInvLine."Document No.";
                    "PTSS Credit-to Doc. Line No." := ServInvLine."Line No.";
                END;
                CLEAR(ServInvLines);
            end;
        }
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                TestSAFTFields();
            end;
        }
        modify(Quantity)
        {
            trigger OnAfterValidate()
            begin
                IF ("Document Type" = "Document Type"::"Credit Memo") AND (NOT (Type IN [Type::" ", Type::Item])) AND GetNoSeries THEN
                    CheckQty;
            end;
        }
        modify("Unit Price")
        {
            trigger OnBeforeValidate()
            begin
                IF ("Document Type" = "Document Type"::"Credit Memo") AND (Type <> Type::" ") AND GetNoSeries THEN
                    CheckAmt;
            end;
        }
        modify("Line Amount")
        {
            trigger OnAfterValidate()
            begin
                IF ("Document Type" = "Document Type"::"Credit Memo") AND (Type <> Type::" ") AND GetNoSeries THEN
                    CheckLineAmt;
                IF "Line Amount" > (Quantity * "Unit Price") THEN
                    IF CONFIRM(Text31022895, TRUE) THEN
                        VALIDATE("Unit Price", "Line Amount" / Quantity)
                    ELSE
                        ERROR(Text31022896);
            end;
        }
    }
    local procedure TestSAFTFields()
    var
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        IF Type In [Type::Item, Type::"G/L Account"] THEN begin
            VATPostingSetup.get("VAT Bus. Posting Group", "VAT Prod. Posting Group");
            IF VATPostingSetup."VAT %" = 0 then
                VATPostingSetup.TestField("VAT Clause Code");
            VATPostingSetup.TestField("PTSS SAF-T PT VAT Code");
            VATPostingSetup.TestField("PTSS SAF-T PT VAT Type Description");
        END;
    end;

    procedure GetNoSeries(): Boolean
    begin
        IF "PTSS Credit-to Doc. No." <> '' THEN BEGIN
            GetServHeader;
            EXIT(TestNoSeries(ServHeader."No. Series"));
        END ELSE
            EXIT(FALSE);
    end;

    local procedure GetServHeader() //replicated from standard
    begin
        TESTFIELD("Document No.");
        IF ("Document Type" <> ServHeader."Document Type") OR ("Document No." <> ServHeader."No.") THEN BEGIN
            ServHeader.GET("Document Type", "Document No.");
            IF ServHeader."Currency Code" = '' THEN
                Currency.InitRoundingPrecision
            ELSE BEGIN
                ServHeader.TESTFIELD("Currency Factor");
                Currency.GET(ServHeader."Currency Code");
                Currency.TESTFIELD("Amount Rounding Precision");
            END;
        END;
    end;

    local procedure TestNoSeries(NoSeriesCode: Code[20]): Boolean
    begin
        NoSeries.GET(NoSeriesCode);
        EXIT(NoSeries."PTSS Credit Invoice");
    end;

    local procedure CheckQty()
    begin
        IF NOT GetRelatedDocs THEN
            EXIT;
        IF NOT ServiceCrMemoLine.ISEMPTY THEN BEGIN
            ServiceCrMemoLine.FINDSET;
            ServiceCrMemoLine.CALCSUMS(Quantity);

            CheckQtyValues(ServiceInvLine.Quantity - ServiceCrMemoLine.Quantity, Quantity, ServiceInvLine."Document No.", ServiceInvLine."Line No.");

        END ELSE
            IF (Quantity > ServiceInvLine.Quantity) THEN
                ERROR(STRSUBSTNO(Text31022893, FIELDCAPTION(Quantity), ServiceInvLine.Quantity));
    end;

    local procedure GetRelatedDocs(): Boolean
    begin
        IF NOT ServiceInvLine.GET("PTSS Credit-to Doc. No.", "PTSS Credit-to Doc. Line No.") THEN
            EXIT(FALSE);
        ServiceCrMemoLine.SETRANGE("PTSS Credit-to Doc. No.", "PTSS Credit-to Doc. No.");
        ServiceCrMemoLine.SETRANGE("PTSS Credit-to Doc. Line No.", "PTSS Credit-to Doc. Line No.");
        EXIT(TRUE);
    end;

    local procedure CheckQtyValues(QtyAvailable: Decimal; CurrQty: Decimal; InvDocNo: Code[20]; InvDocLineNo: Integer)
    begin
        IF QtyAvailable = 0 THEN
            ERROR(STRSUBSTNO(Text31022894, InvDocNo, InvDocLineNo));

        IF CurrQty > QtyAvailable THEN
            ERROR(STRSUBSTNO(Text31022893, FIELDCAPTION(Quantity), QtyAvailable))
    end;

    local procedure CheckAmt()
    begin
        IF NOT GetRelatedDocs THEN
            EXIT;
        TotalAmtCrd := 0;

        IF NOT ServiceCrMemoLine.ISEMPTY THEN BEGIN
            ServiceCrMemoLine.FINDSET;
            REPEAT
                TotalAmtCrd += ServiceCrMemoLine.Quantity * ServiceCrMemoLine."Unit Price";
            UNTIL ServiceCrMemoLine.NEXT = 0;

            AmtRem := (ServiceInvLine.Quantity * ServiceInvLine."Unit Price") - TotalAmtCrd;

            ServiceCrMemoLine.CALCSUMS(Quantity);
            CheckAmtValues(Quantity * "Unit Price", ServiceInvLine."Document No.", ServiceInvLine."Line No.", ServiceInvLine.Quantity - ServiceCrMemoLine.Quantity);

        END ELSE
            IF (Quantity * "Unit Price") > (ServiceInvLine.Quantity * ServiceInvLine."Unit Price") THEN
                ERROR(STRSUBSTNO(Text31022898, ServiceInvLine.Quantity * ServiceInvLine."Unit Price"));
    end;

    local procedure CheckAmtValues(CurrAmt: Decimal; InvDocNo: Code[20]; InvDocLineNo: Integer; Qty: Decimal)
    begin
        IF AmtRem = 0 THEN
            ERROR(STRSUBSTNO(Text31022894, InvDocNo, InvDocLineNo));

        IF CurrAmt > AmtRem THEN
            ERROR(STRSUBSTNO(Text31022897, Qty, AmtRem))
    end;

    local procedure CheckLineAmt()
    begin
        IF NOT GetRelatedDocs THEN
            EXIT;
        IF NOT ServiceCrMemoLine.ISEMPTY THEN BEGIN
            ServiceCrMemoLine.FINDSET;
            ServiceCrMemoLine.CALCSUMS("Line Amount");

            CheckLineAmtValues(ServiceInvLine."Line Amount" - ServiceCrMemoLine."Line Amount", "Line Amount", ServiceInvLine."Document No.", ServiceInvLine."Line No.");
        END ELSE
            IF "Line Amount" > ServiceInvLine."Line Amount" THEN
                ERROR(STRSUBSTNO(Text31022898, ServiceInvLine."Line Amount"));
    end;

    local procedure CheckLineAmtValues(LineAmtAvailable: Decimal; CurrLineAmt: Decimal; InvDocNo: Code[20]; InvDocLineNo: Integer)
    begin
        IF LineAmtAvailable = 0 THEN
            ERROR(STRSUBSTNO(Text31022894, InvDocNo, InvDocLineNo));

        IF CurrLineAmt > LineAmtAvailable THEN
            ERROR(STRSUBSTNO(Text31022898, LineAmtAvailable))
    end;


    //Funcao tem que ser chamada na funcao ClearFields. Pedido de evento/external
    local procedure NoSeriesCreditInvoice(DocNo: Code[20]; LineNo: Integer; NoSeriesCode: Code[20])
    begin
        IF DocNo <> '' THEN BEGIN
            NoSeries.GET(NoSeriesCode);
            IF NoSeries."PTSS Credit Invoice" THEN BEGIN
                "PTSS Credit-to Doc. No." := DocNo;
                "PTSS Credit-to Doc. Line No." := LineNo;
            END;
        END;
    end;


    var
        ServHeader: Record "Service Header";
        Currency: Record Currency;
        NoSeries: Record "No. Series";
        ServiceInvLine: Record "Service Invoice Line";
        ServiceCRMemoLine: Record "Service Cr.Memo Line";
        TotalAmtCrd: Decimal;
        AmtRem: Decimal;
        Text31022893: Label '%1 cannot be more then %2.';
        Text31022894: Label 'Invoice %1, Line %2  already has been fully credited.';
        Text31022895: Label 'Negative Discount not allowed. \Do you wish to recalculate Unit Price?';
        Text31022896: Label 'Negative Discount not allowed.';
        Text31022897: Label 'Cannot credit more then Qty: %1 for a line total of %2.';
        Text31022898: Label 'Cannot credit more then %1.';

}