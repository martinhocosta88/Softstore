tableextension 31023009 "PTSS Purchase Header" extends "Purchase Header"
{
    //Cash-Flow
    //Intrastat
    //Comunicacao AT
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

        modify("Pay-to Vendor No.")
        {
            trigger OnAfterValidate()
            var
                Vend: Record Vendor;
            begin
                Vend.Get("Pay-to Vendor No.");
                CheckMasterData(Vend);
            end;
        }
        field(31022898; "PTSS Shipment Start Date"; Date)
        {
            Caption = 'Shipment Start Date';
            DataClassification = CustomerContent;
        }
        field(31022899; "PTSS Shipment Start Time"; Time)
        {
            Caption = 'Shipment Start Time';
            DataClassification = CustomerContent;
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
    }

    procedure InitRecordPT(var PurchHdr: Record "Purchase Header")
    begin
        //Desenvolvimentos ainda não feitos
        // IF "Debit Memo" THEN
        //     "Posting Description" := Text31022894 + ' ' + "No.";
        // IF NoSeries.GET("No. Series") THEN
        //     "Series Group" := NoSeries."Series Group";

        IF PurchHdr."Document Type" IN [PurchHdr."Document Type"::Order, PurchHdr."Document Type"::Invoice, PurchHdr."Document Type"::"Return Order", PurchHdr."Document Type"::Quote] THEN BEGIN
            PurchHdr."PTSS Shipment Start Time" := TIME;
            PurchHdr."PTSS Shipment Start Date" := WORKDATE;
        END;
    end;

    local procedure UpdateIntrastat()
    var
        CountryRegion: Record "Country/Region";
        CompanyInfo: Record "Company Information";
        PurchSetup: Record "Purchases & Payables Setup";
    begin
        IF (xRec."Ship-to Country/Region Code" = Rec."Ship-to Country/Region Code") AND (xRec."Buy-from Country/Region Code" = Rec."Buy-from Country/Region Code") THEN
            EXIT;

        IF NOT "CountryRegion".GET("Buy-from Country/Region Code") THEN
            EXIT;

        IF "CountryRegion"."Intrastat Code" = '' THEN
            EXIT;

        CompanyInfo.GET;
        IF ("Buy-from Country/Region Code" = CompanyInfo."Country/Region Code") OR ("CountryRegion"."EU Country/Region Code" = '') THEN
            EXIT;

        CLEAR("Transaction Type");
        CLEAR("Transport Method");
        CLEAR("Entry Point");
        CLEAR(Area);
        CLEAR("Transaction Specification");

        PurchSetup.GET;

        IF ("Document Type" = "Document Type"::"Credit Memo") OR ("Document Type" = "Document Type"::"Return Order") THEN BEGIN
            "Transaction Type" := PurchSetup."PTSS Return Transaction Type";
            "Transport Method" := PurchSetup."PTSS Return Transport Method";
            "Entry Point" := PurchSetup."PTSS Return Entry/Exit Point";
            Area := PurchSetup."PTSS Return Area";
            "Transaction Specification" := PurchSetup."PTSS Return Transaction Spec.";
        END ELSE BEGIN
            "Transaction Type" := PurchSetup."PTSS Transaction Type";
            "Transport Method" := PurchSetup."PTSS Transport Method";
            "Entry Point" := PurchSetup."PTSS Entry/Exit Point";
            Area := PurchSetup."PTSS Area";
            "Transaction Specification" := PurchSetup."PTSS Transaction Specification";
        END;
    end;

    local procedure CheckMasterData(Vend: Record Vendor)
    begin
        With Vend Do BEGIN
            TESTFIELD(Name);
            TESTFIELD("Post Code");
            TESTFIELD("Country/Region Code");
            TESTFIELD(Address);
            TESTFIELD(City);
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