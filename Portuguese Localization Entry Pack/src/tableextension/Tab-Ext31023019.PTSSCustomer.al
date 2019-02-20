tableextension 31023019 "PTSS Customer" extends Customer //MyTargetTableId
{
    //COPE
    //Regras de Negocio
    fields
    {
        field(31022950; "PTSS BP Statistic Code"; Code[5])
        {
            Caption = 'BP Statistic Code';
            TableRelation = "PTSS BP Statistic";
            DataClassification = CustomerContent;
        }
        field(31022951; "PTSS Debit Pos. Stat. Code"; Code[5])
        {
            Caption = 'Debit Pos. Statistic Code';
            TableRelation = "PTSS BP Statistic";
            DataClassification = CustomerContent;
        }
        field(31022952; "PTSS Credit Pos. Stat. Code"; Code[5])
        {
            Caption = 'BP Credit Pos. Statistic Code';
            TableRelation = "PTSS BP Statistic";
            DataClassification = CustomerContent;
        }
        field(31022953; "PTSS BP Balance at Date (LCY)"; Decimal)
        {
            Caption = 'BP Balance at Date (LCY)';
            Editable = False;
            FieldClass = FlowField;
            CalcFormula = Sum ("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE ("Customer No." = FIELD ("No."), "Currency Code" = FIELD ("Currency Filter"), "PTSS Excluded From Calculation" = CONST (false), "PTSS Initial BP Statistic Code" = FIELD ("PTSS BP Statistic Filter"), "Posting Date" = FIELD (UPPERLIMIT ("Date Filter"))));
        }
        field(31022954; "PTSS BP Statistic Filter"; Code[5])
        {
            Caption = 'BP Statistic Filter';
            TableRelation = "PTSS BP Statistic";
            FieldClass = FlowFilter;
        }
        field(31022972; "PTSS End Consumer"; Boolean)
        {
            Caption = 'End Consumer';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                UpdateCustInfo();
            end;
        }
        modify("VAT Registration No.")
        {
            trigger OnAfterValidate()
            begin
                IF "VAT Registration No." <> xRec."VAT Registration No." THEN BEGIN
                    IF ("VAT Registration No." = EndConsVATRegNo) OR ("VAT Registration No." = EndConsVATRegNo1) THEN
                        VALIDATE("PTSS End Consumer", TRUE);
                    CheckVATRegNoDocs("No.");
                END;
            end;
        }
    }
    trigger OnBeforeDelete()
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        Text31022894: Label 'You cannot delete %1 &2 - %3, because it has posted entries.';
    begin
        CustLedgerEntry.RESET;
        CustLedgerEntry.SETRANGE("Customer No.", "No.");
        IF NOT CustLedgerEntry.ISEMPTY THEN
            ERROR(Text31022894, Rec.TABLECAPTION, "No.", Name);
    end;

    local procedure UpdateCustInfo()
    begin
        IF "PTSS End Consumer" THEN BEGIN
            "VAT Registration No." := EndConsVATRegNo;
            Name := EndConsName;
        END ELSE
            IF ("VAT Registration No." = EndConsVATRegNo) AND ("VAT Registration No." = EndConsVATRegNo1) THEN BEGIN
                CLEAR("VAT Registration No.");
                CLEAR(Name);
                CLEAR(Address);
                CLEAR(City);
                CLEAR("Post Code");
                CLEAR("Country/Region Code");
            END;
    end;

    local procedure CheckVATRegNoDocs(CustomerNo: Code[20])
    var
        Customer: Record Customer;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        SalesHeader: Record "Sales Header";
    begin
        IF Name = xRec.Name THEN
            EXIT;
        IF CustomerNo = '' THEN
            EXIT;

        Customer.GET(CustomerNo);
        CustLedgerEntry.RESET;
        CustLedgerEntry.SETRANGE("Customer No.", CustomerNo);
        IF NOT CustLedgerEntry.ISEMPTY THEN BEGIN
            IF xRec."VAT Registration No." <> Rec."VAT Registration No." THEN
                ErrorMessage(FIELDCAPTION("VAT Registration No."), Customer."VAT Registration No.", CustomerNo);
            IF (xRec.Name <> Rec.Name) THEN
                ErrorMessage(FIELDCAPTION(Name), Customer."VAT Registration No.", CustomerNo);
        END;

        SalesHeader.RESET;
        SalesHeader.SETRANGE("Sell-to Customer No.", CustomerNo);
        IF NOT SalesHeader.ISEMPTY THEN BEGIN
            IF xRec."VAT Registration No." <> Rec."VAT Registration No." THEN
                ErrorMessage(FIELDCAPTION("VAT Registration No."), Customer."VAT Registration No.", CustomerNo);

            IF (xRec.Name <> Rec.Name) THEN
                ErrorMessage(FIELDCAPTION(Name), Customer."VAT Registration No.", CustomerNo);
        END;
    end;

    local procedure ErrorMessage(CustFieldCaption: Text[80]; VATRegNo: Text[20]; CustomerNo: Code[20])
    begin
        IF (VATRegNo <> EndConsVATRegNo) AND (VATRegNo <> EndConsVATRegNo1) AND (VATRegNo <> '') THEN
            ERROR(Text31022890, CustFieldCaption, CustomerNo);
    end;

    var
        EndConsName: Label 'End Consumer';
        EndConsVATRegNo: Label '999999990';
        EndConsVATRegNo1: Label '999999999';
        Text31022890: Label 'Field %1 cannot be modified because at least one entry related to customer %2 exists.';
}