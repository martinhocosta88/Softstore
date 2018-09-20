tableextension 31023013 "PTSS Bank Acc. Reconc. Line" extends "Bank Acc. Reconciliation Line" //MyTargetTableId
{
    //Cash-Flow
    fields
    {
        field(31022900; "PTSS Acc: cash-flow code"; Code[10])
        {
            Caption = 'Acc: cash-flow code';
            DataClassification = CustomerContent;
            TableRelation = "PTSS Cash-Flow Plan"."No.";
            trigger Onvalidate()
            var
                GLAccount: Record "G/L Account";
                BankAccount: Record "Bank Account";
                BankPostingGroup: Record "Bank Account Posting Group";
            begin
                IF ("Account Type" <> "Account Type"::"G/L Account") AND
                ("Account Type" <> "Account Type"::"Bank Account") THEN
                    "PTSS Acc: cash-flow code" := ''
                ELSE
                    IF "Account No." <> '' THEN BEGIN
                        CASE "Account Type" OF
                            "Account Type"::"G/L Account":
                                BEGIN
                                    GLAccount.GET("Account No.");
                                    IF NOT (GLAccount."PTSS Cash-flow code assoc.") THEN
                                        "PTSS Acc: cash-flow code" := ''
                                    ELSE
                                        Rec.TESTFIELD("PTSS Acc: cash-flow code");
                                END;
                            "Account Type"::"Bank Account":
                                BEGIN
                                    BankAccount.GET("Account No.");
                                    BankPostingGroup.GET(BankAccount."Bank Acc. Posting Group");
                                    GLAccount.GET(BankPostingGroup."G/L Bank Account No.");
                                    IF NOT GLAccount."PTSS Cash-flow code assoc." THEN
                                        Rec."PTSS Acc: cash-flow code" := ''
                                    ELSE
                                        Rec.TESTFIELD("PTSS Acc: cash-flow code");
                                END;
                        END;
                    END ELSE
                        "PTSS Acc: cash-flow code" := '';
            end;
        }

    }

}