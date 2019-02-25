tableextension 31023033 "PTSS Sales Line" extends "Sales Line" //MyTargetTableId
{
    //Notas de Crédito de Acordo com a Fatura
    //Configuracao SAFT
    fields
    {
        field(31022898; "PTSS Credit-to Doc. No."; Code[20])
        {
            Caption = 'Credit-to Doc. No.';
            DataClassification = CustomerContent;
            TableRelation = "Sales Invoice Header"."No." where ("Sell-to Customer No." = field ("Sell-to Customer No."));
        }
        field(31022899; "PTSS Credit-to Doc. Line No."; Integer)
        {
            Caption = 'Credit-to Doc. Line No.';
            DataClassification = CustomerContent;
            TableRelation = "Sales Invoice Line"."Line No." where ("Document No." = field ("PTSS Credit-to Doc. No."));
        }
        modify(Quantity)
        {
            trigger OnBeforeValidate()
            begin
                IF ("Document Type" IN ["Document Type"::"Credit Memo", "Document Type"::"Return Order"]) AND
                    (NOT (Type IN [Type::" ", Type::Item])) AND GetNoSeries THEN
                    CheckQty;
            end;
        }
        modify("Unit Price")
        {
            trigger OnBeforeValidate()
            begin
                IF ("Document Type" IN ["Document Type"::"Credit Memo", "Document Type"::"Return Order"]) AND
                (Type <> Type::" ") AND GetNoSeries THEN
                    CheckAmt;
            end;
        }
        modify("Line Amount")
        {
            trigger OnBeforeValidate()
            begin
                IF ("Document Type" IN ["Document Type"::"Credit Memo", "Document Type"::"Return Order"]) AND
                (Type <> Type::" ") AND GetNoSeries THEN
                    CheckLineAmt;
            end;
        }
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                //Configuracao SAFT
                TestSAFTFields();
            end;
        }
    }
    procedure NoSeriesCreditInvoice(DocNo: Code[20]; LineNo: Integer; NoSeriesCode: Code[20])
    var
        NoSeries: Record "No. Series";
    begin
        IF DocNo <> '' THEN BEGIN
            NoSeries.GET(NoSeriesCode);
            IF NoSeries."PTSS Credit Invoice" THEN BEGIN
                "PTSS Credit-to Doc. No." := DocNo;
                "PTSS Credit-to Doc. Line No." := LineNo;
            END;
        END;
    end;

    local procedure GetRelatedDocs(): Boolean
    begin
        SalesInvLine.GET("PTSS Credit-to Doc. No.", "PTSS Credit-to Doc. Line No.");
        IF "Document Type" = "Document Type"::"Credit Memo" THEN BEGIN
            SalesCrMemoLine.SETRANGE("PTSS Credit-to Doc. No.", "PTSS Credit-to Doc. No.");
            SalesCrMemoLine.SETRANGE("PTSS Credit-to Doc. Line No.", "PTSS Credit-to Doc. Line No.");
            CLEAR(ReturnRcptLine);
        END ELSE BEGIN
            ReturnRcptLine.SETRANGE("PTSS Credit-to Doc. No.", "PTSS Credit-to Doc. No.");
            ReturnRcptLine.SETRANGE("PTSS Credit-to Doc. Line No.", "PTSS Credit-to Doc. Line No.");
            CLEAR(SalesCrMemoLine);
        END;
    end;

    local procedure GetNoSeries(): Boolean
    begin
        IF "PTSS Credit-to Doc. No." <> '' THEN BEGIN
            GetSalesHeader;
            EXIT(TestNoSeries(SalesHeader."No. Series"));
        END ELSE
            EXIT(FALSE);
    end;

    procedure TestNoSeries(NoSeriesCode: Code[20]): Boolean
    var
        NoSeries: Record "No. Series";
    begin
        NoSeries.GET(NoSeriesCode);
        EXIT(NoSeries."PTSS Credit Invoice");
    end;

    procedure CheckQty()
    begin
        GetRelatedDocs;
        IF ("Document Type" = "Document Type"::"Credit Memo") AND (NOT SalesCrMemoLine.ISEMPTY) THEN BEGIN
            SalesCrMemoLine.FINDSET;
            SalesCrMemoLine.CALCSUMS(Quantity);
            CheckQtyValues(SalesInvLine.Quantity - SalesCrMemoLine.Quantity, Quantity, SalesInvLine."Document No.", SalesInvLine."Line No.");
        END ELSE
            IF ("Document Type" = "Document Type"::"Return Order") AND (NOT ReturnRcptLine.ISEMPTY) THEN BEGIN
                ReturnRcptLine.FINDSET;
                ReturnRcptLine.CALCSUMS(Quantity);
                CheckQtyValues(SalesInvLine.Quantity - ReturnRcptLine."Return Qty. Rcd. Not Invd.", "Return Qty. to Receive", SalesInvLine."Document No.", SalesInvLine."Line No.");
            END ELSE
                IF (Quantity > SalesInvLine.Quantity) THEN
                    ERROR(STRSUBSTNO(Text31022895, FIELDCAPTION(Quantity), SalesInvLine.Quantity));
    end;

    local procedure CheckQtyValues(QtyAvailable: Decimal; CurrQty: Decimal; InvDocNo: Code[20]; InvDocLineNo: Integer)
    begin
        IF QtyAvailable < 0 THEN
            ERROR(STRSUBSTNO(Text31022896, InvDocNo, InvDocLineNo));
        IF CurrQty > QtyAvailable THEN
            ERROR(STRSUBSTNO(Text31022895, FIELDCAPTION(Quantity), QtyAvailable))
    end;

    procedure CheckAmt()
    begin
        GetRelatedDocs;
        TotalAmtCrd := 0;
        IF ("Document Type" = "Document Type"::"Credit Memo") AND (NOT SalesCrMemoLine.ISEMPTY) THEN BEGIN
            SalesCrMemoLine.FINDSET;
            REPEAT
                TotalAmtCrd += SalesCrMemoLine.Quantity * SalesCrMemoLine."Unit Price";
            UNTIL SalesCrMemoLine.NEXT = 0;
            AmtRem := (SalesInvLine.Quantity * SalesInvLine."Unit Price") - TotalAmtCrd;
            SalesCrMemoLine.CALCSUMS(Quantity);
            CheckAmtValues(Quantity * "Unit Price", SalesInvLine."Document No.", SalesInvLine."Line No.", SalesInvLine.Quantity - SalesCrMemoLine.Quantity);
        END ELSE
            IF ("Document Type" = "Document Type"::"Return Order") AND (NOT ReturnRcptLine.ISEMPTY) THEN BEGIN
                ReturnRcptLine.FINDSET;
                REPEAT
                    TotalAmtCrd += ReturnRcptLine."Return Qty. Rcd. Not Invd." * ReturnRcptLine."Unit Price";
                UNTIL ReturnRcptLine.NEXT = 0;
                AmtRem := (SalesInvLine.Quantity * SalesInvLine."Unit Price") - TotalAmtCrd;
                ReturnRcptLine.CALCSUMS(Quantity);
                CheckAmtValues("Return Qty. to Receive" * "Unit Price", SalesInvLine."Document No.", SalesInvLine."Line No.", SalesInvLine.Quantity - ReturnRcptLine.Quantity);
            END ELSE
                IF (Quantity * "Unit Price") > (SalesInvLine.Quantity * SalesInvLine."Unit Price") THEN
                    ERROR(STRSUBSTNO(Text31022894, SalesInvLine.Quantity * SalesInvLine."Unit Price"));
    end;

    local procedure CheckAmtValues(Curramt: Decimal; InvDocNo: Code[20]; InvDocLineNo: Integer; Qty: Decimal)
    begin
        IF AmtRem < 0 THEN
            ERROR(STRSUBSTNO(Text31022896, InvDocNo, InvDocLineNo));
        IF CurrAmt > AmtRem THEN
            ERROR(STRSUBSTNO(Text31022898, Qty, AmtRem))
    end;

    procedure CheckLineAmt()
    begin
        GetRelatedDocs;
        IF ("Document Type" = "Document Type"::"Credit Memo") AND (NOT SalesCrMemoLine.ISEMPTY) THEN BEGIN
            SalesCrMemoLine.FINDSET;
            SalesCrMemoLine.CALCSUMS("Line Amount");
            CheckLineAmtValues(SalesInvLine."Line Amount" - SalesCrMemoLine."Line Amount", "Line Amount", SalesInvLine."Document No.", SalesInvLine."Line No.");
        END ELSE
            IF ("Document Type" = "Document Type"::"Credit Memo") AND ("Line Amount" > SalesInvLine."Line Amount") THEN
                ERROR(STRSUBSTNO(Text31022894, SalesInvLine."Line Amount"));
    end;

    local procedure CheckLineAmtValues(LineAmtAvailable: Decimal; CurrLineAmt: Decimal; InvDocNo: Code[20]; InvDocLineNo: Integer)
    begin
        IF LineAmtAvailable = 0 THEN
            ERROR(STRSUBSTNO(Text31022896, InvDocNo, InvDocLineNo));
        IF CurrLineAmt > LineAmtAvailable THEN
            ERROR(STRSUBSTNO(Text31022894, LineAmtAvailable))
    end;

    procedure TestSAFTFields()
    var
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        //Configuracao SAFT
        IF Type IN [Type::Item, Type::"Fixed Asset", Type::"G/L Account"] THEn begin
            VATPostingSetup.GET("VAT Bus. Posting Group", "VAT Prod. Posting Group");
            IF VATPostingSetup."VAT %" = 0 then
                VATPostingSetup.TestField("VAT Clause Code");
            VATPostingSetup.TestField("PTSS SAF-T PT VAT Code");
            VATPostingSetup.TestField("PTSS SAF-T PT VAT Type Description");
        end;
    end;

    var
        SalesInvLine: Record "Sales Invoice Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        ReturnRcptLine: Record "Return Receipt Line";
        SalesHeader: Record "Sales Header";
        Text31022894: Label 'Cannot credit more then %1.';
        Text31022895: Label '%1 cannot be more then %2.';
        Text31022896: Label 'Invoice %1, Line %2  has already been fully credited.';
        Text31022898: Label 'Cannot credit more then Qty: %1 for a line total of %2.';
        TotalAmtCrd: Decimal;
        AmtRem: Decimal;
}