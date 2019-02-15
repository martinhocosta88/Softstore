tableextension 31023011 "PTSS Sales Header" extends "Sales Header"
{
    //Cash-Flow
    // Comunicacao AT
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
    procedure InitRecordPT()
    begin
        // Por Desenvolver
        //
        // IF "Debit Memo" THEN
        //     "Posting Description" := Text31022894 + ' ' + "No.";
        // IF NoSeries.GET("No. Series") THEN
        //     "Series Group" := NoSeries."Series Group";

        IF "Document Type" IN ["Document Type"::Order, "Document Type"::Invoice, "Document Type"::Quote] THEN
            "PTSS Shipment Start Time" := TIME;

    end;

}