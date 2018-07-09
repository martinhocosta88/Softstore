tableextension 50109 "Purchase Header" extends "Purchase Header"
{
    //Cash-Flow
    fields
    {
        modify("Payment Method Code")
        {
            trigger OnAfterValidate()
            var
                PaymentMethod: Record "Payment Method";
            begin
                PaymentMethod.Init;
                IF "Payment Method Code" <> '' THEN
                    PaymentMethod.GET("Payment Method Code")
                ELSE BEGIN
                    "Cash-flow code" := '';
                END;
                "Cash-flow code" := PaymentMethod."Purch. Cash-flow Code";
            end;
        }
        field(31022895; "Cash-flow code"; Code[10])
        {
            TableRelation = "Cash-Flow Plan"."No." WHERE (Type = CONST (Posting));
            DataClassification = ToBeClassified;
            Caption = 'Cash-flow code';
            trigger OnValidate()
            var
                Text31022890:Label 'ATTENTION:\For this payment method there isn t a corresponding Cash-Flow Code.';
                PaymentMethod: Record "Payment Method";
                GLACC: Record "G/L Account";
                BankAcc: Record "Bank Account";
                BankConfig: record "Bank Account Posting Group";
            begin
                IF "Payment Method Code" = '' THEN
                    "Cash-flow code" := ''
                ELSE BEGIN
                    PaymentMethod.GET("Payment Method Code");
                    CASE PaymentMethod."Bal. Account Type" OF
                        "Bal. Account Type"::"G/L Account":
                            IF NOT (GLAcc.GET(PaymentMethod."Bal. Account No.")) OR
                                NOT (GLAcc."Cash-flow code assoc.")
                            THEN BEGIN
                                Rec."Cash-flow code" := '';
                                MESSAGE(Text31022890);
                            END ELSE
                                Rec.TESTFIELD("Cash-flow code");
                        "Bal. Account Type"::"Bank Account":
                            IF NOT BankAcc.GET(PaymentMethod."Bal. Account No.") OR
                                NOT (BankConfig.GET(BankAcc."Bank Acc. Posting Group")) OR
                                NOT (GLAcc.GET(BankConfig."G/L Bank Account No."))
                            THEN
                                Rec."Cash-flow code" := ''
                            ELSE
                                IF GLAcc."Cash-flow code assoc." THEN
                                    Rec.TESTFIELD("Cash-flow code")
                                ELSE BEGIN
                                    MESSAGE(Text31022890);
                                    Rec."Cash-flow code" := '';
                                END;
                    END;
                END;
            end;
        }
    }
}