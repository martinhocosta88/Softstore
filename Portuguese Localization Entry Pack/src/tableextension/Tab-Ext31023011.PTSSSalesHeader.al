tableextension 31023011 "PTSS Sales Header" extends "Sales Header"
{
    //Cash-Flow
    //Comunicacao AT
    //Intrastat
    //Regras Negocio
    fields
    {
        modify("Payment Method Code")
        {
            trigger OnAfterValidate()
            var
                PaymentMethod: Record "Payment Method";
                GLAcc: Record "G/L Account";
                BankAcc: Record "Bank Account";
                BankAccPostingGroup: Record "Bank Account Posting Group";
            begin
                "PTSS Cash-Flow Code" := '';
                CASE PaymentMethod."Bal. Account Type" OF
                    PaymentMethod."Bal. Account Type"::"G/L Account":
                        IF GLAcc.GET(PaymentMethod."Bal. Account No.") THEN
                            "PTSS Cash-Flow Code" := GLAcc."PTSS Cash-flow code";
                    PaymentMethod."Bal. Account Type"::"Bank Account":
                        IF BankAcc.GET(PaymentMethod."Bal. Account No.") AND
                        BankAccPostingGroup.GET(BankAcc."Bank Acc. Posting Group") AND
                        GLAcc.GET(BankAccPostingGroup."G/L Bank Account No.") THEN
                            "PTSS Cash-Flow Code" := GLAcc."PTSS Cash-flow code";
                END;
            end;
        }
        modify("Bill-to Customer No.")
        {
            trigger OnAfterValidate()
            var
                Cust: Record Customer;
            begin
                Cust.get("Bill-to Customer No.");
                CheckMasterData(Cust);
            end;
        }

        field(31022895; "PTSS Cash-flow code"; Code[10])
        {
            TableRelation = "PTSS Cash-Flow Plan"."No." WHERE (Type = CONST (Posting));
            DataClassification = CustomerContent;
            Caption = 'Cash-flow code';
            trigger OnValidate()
            var
                Text31022890: Label 'ATTENTION:\For this payment method there isn t a corresponding Cash-Flow Code.';
                PaymentMethod: Record "Payment Method";
                GLACC: Record "G/L Account";
                BankAcc: Record "Bank Account";
                BankConfig: record "Bank Account Posting Group";
            begin
                IF "Payment Method Code" = '' THEN
                    "PTSS Cash-flow code" := ''
                ELSE BEGIN
                    PaymentMethod.GET("Payment Method Code");
                    CASE PaymentMethod."Bal. Account Type" OF
                        "Bal. Account Type"::"G/L Account":
                            IF NOT (GLAcc.GET(PaymentMethod."Bal. Account No.")) OR
                               NOT (GLAcc."PTSS Cash-flow code assoc.")
                            THEN BEGIN
                                Rec."PTSS Cash-flow code" := '';
                                MESSAGE(Text31022890);
                            END ELSE
                                Rec.TESTFIELD("PTSS Cash-flow code");
                        "Bal. Account Type"::"Bank Account":
                            IF NOT BankAcc.GET(PaymentMethod."Bal. Account No.") OR
                               NOT (BankConfig.GET(BankAcc."Bank Acc. Posting Group")) OR
                               NOT (GLAcc.GET(BankConfig."G/L Bank Account No."))
                            THEN
                                Rec."PTSS Cash-flow code" := ''
                            ELSE
                                IF GLAcc."PTSS Cash-flow code assoc." THEN
                                    Rec.TESTFIELD("PTSS Cash-flow code")
                                ELSE BEGIN
                                    MESSAGE(Text31022890);
                                    Rec."PTSS Cash-flow code" := '';
                                END;
                    END;
                END;
            end;
        }
        field(31022899; "PTSS Shipment Start Time"; Time)
        {
            Caption = 'Shipment Start Time';
            DataClassification = CustomerContent;
        }

    }
    procedure InitRecordPT(var SalesHdr: Record "Sales Header")
    begin
        IF SalesHdr."Document Type" IN [SalesHdr."Document Type"::Order, SalesHdr."Document Type"::Invoice, SalesHdr."Document Type"::Quote] THEN
            SalesHdr."PTSS Shipment Start Time" := TIME;
    end;

    local procedure UpdateIntrastat()
    var
        CountryRegion: Record "Country/Region";
        CompanyInfo: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        IF (xRec."Ship-to Country/Region Code" = Rec."Ship-to Country/Region Code") AND (xRec."Sell-to Country/Region Code" = Rec."Sell-to Country/Region Code") THEN
            EXIT;

        IF NOT "CountryRegion".GET("Sell-to Country/Region Code") THEN
            EXIT;

        IF "CountryRegion"."Intrastat Code" = '' THEN
            EXIT;

        CompanyInfo.GET;
        IF ("Sell-to Country/Region Code" = CompanyInfo."Country/Region Code") OR ("CountryRegion"."EU Country/Region Code" = '') THEN
            EXIT;

        CLEAR("Transaction Type");
        CLEAR("Transport Method");
        CLEAR("Exit Point");
        CLEAR(Area);
        CLEAR("Transaction Specification");

        SalesSetup.GET;

        IF ("Document Type" = "Document Type"::"Credit Memo") OR ("Document Type" = "Document Type"::"Return Order") THEN BEGIN
            "Transaction Type" := SalesSetup."PTSS Return Transaction Type";
            "Transport Method" := SalesSetup."PTSS Return Transport Method";
            "Exit Point" := SalesSetup."PTSS Return Entry/Exit Point";
            Area := SalesSetup."PTSS Return Area";
            "Transaction Specification" := SalesSetup."PTSS Return Transaction Spec.";
        END ELSE BEGIN
            "Transaction Type" := SalesSetup."PTSS Transaction Type";
            "Transport Method" := SalesSetup."PTSS Transport Method";
            "Exit Point" := SalesSetup."PTSS Entry/Exit Point";
            Area := SalesSetup."PTSS Area";
            "Transaction Specification" := SalesSetup."PTSS Transaction Specification";
        END;
    end;

    local procedure CheckMasterData(Cust: Record Customer)
    begin
        With Cust do begin
            IF NOT "PTSS End Consumer" THEN BEGIN
                TESTFIELD(Name);
                TESTFIELD("Post Code");
                TESTFIELD("Country/Region Code");
                TESTFIELD(Address);
                TESTFIELD(City);
                TESTFIELD("VAT Registration No.");
                TESTFIELD("Payment Terms Code");
            END;
        END;
    end;

    trigger OnAfterInsert()
    begin
        UpdateIntrastat();
    end;

    trigger OnAfterModify()
    begin
        UpdateIntrastat();
    end;
}