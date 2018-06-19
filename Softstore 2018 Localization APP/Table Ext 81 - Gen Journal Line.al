tableextension 50108 "Gen. Journal Line Ext" extends "Gen. Journal Line"
{
    fields
    {
        field(31022900; "Acc: cash-flow code"; Code[10])
        {
            Caption='Acc: cash-flow code';
            TableRelation="Cash-Flow Plan"."No." WHERE (Type=CONST(Posting));
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                BankConfig:Record "Bank Account Posting Group";
            begin
                IF ("Account Type" <> "Account Type"::"G/L Account") AND
                    ("Account Type" <> "Account Type"::"Bank Account") THEN
                    "Acc: cash-flow code" := ''
                    ELSE
                    IF "Account No." <> '' THEN
                        CASE "Account Type" OF
                        "Account Type"::"G/L Account":
                            BEGIN
                            GLAcc.GET("Account No.");
                            IF NOT (GLAcc."Cash-flow code assoc.") THEN
                                "Acc: cash-flow code" := ''
                            ELSE
                                Rec.TESTFIELD("Acc: cash-flow code");
                            END;
                        "Account Type"::"Bank Account":
                            BEGIN
                            BankAcc.GET("Account No.");
                            BankConfig.GET(BankAcc."Bank Acc. Posting Group");
                            GLAcc.GET(BankConfig."G/L Bank Account No.");
                            IF NOT (GLAcc."Cash-flow code assoc.") THEN
                                Rec."Acc: cash-flow code" := ''
                            ELSE
                                Rec.TESTFIELD("Acc: cash-flow code");
                            END;
                        END;
            end;
        }
        field(31022902; "Bal: cash-flow code"; Code[10])
        {
            Caption='Bal: cash-flow code';
            TableRelation="Cash-Flow Plan"."No." WHERE (Type=CONST(Posting));
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                BankConfig:Record "Bank Account Posting Group";
                
            begin
                IF ("Bal. Account Type" <> "Bal. Account Type"::"G/L Account") AND
                    ("Bal. Account Type" <> "Bal. Account Type"::"Bank Account") THEN
                    "Bal: cash-flow code" := ''
                    ELSE
                    IF "Bal. Account No." <> '' THEN
                        CASE "Bal. Account Type" OF
                        "Bal. Account Type"::"G/L Account":
                            BEGIN
                            GLAcc.GET("Bal. Account No.");
                                IF NOT (GLAcc."Cash-flow code assoc.") THEN
                                "Bal: cash-flow code" := ''
                                ELSE
                                Rec.TESTFIELD("Bal: cash-flow code");
                            END;
                        "Bal. Account Type"::"Bank Account":
                            BEGIN
                            BankAcc.GET("Bal. Account No.");
                            BankConfig.GET(BankAcc."Bank Acc. Posting Group");
                            GLAcc.GET(BankConfig."G/L Bank Account No.");
                            IF NOT (GLAcc."Cash-flow code assoc.") THEN
                                Rec."Bal: cash-flow code" := ''
                            ELSE
                                Rec.TESTFIELD("Bal: cash-flow code");
                            END;
                        END;
            end;
        }
    }
    
    var
        GLAcc:Record "G/L Account";
        BankAcc:Record "Bank Account";
}