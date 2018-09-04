tableextension 31023013 "Bank Acc. Reconciliation Line" extends "Bank Acc. Reconciliation Line" //MyTargetTableId
{
    //Cash-Flow
    fields
    {
        field(31022900; "Acc: cash-flow code"; Code[10])
        {
            Caption = 'Acc: cash-flow code';
            DataClassification = CustomerContent;
            TableRelation = "Cash-Flow Plan"."No.";
            trigger Onvalidate()
            var
                GLAccount: Record "G/L Account";
                BankAccount: Record "Bank Account";
                BankPostingGroup: Record "Bank Account Posting Group";
            begin
                IF ("Account Type" <> "Account Type"::"G/L Account") AND
                ("Account Type" <> "Account Type"::"Bank Account") THEN
                    "Acc: cash-flow code" := ''
                ELSE
                    IF "Account No." <> '' THEN BEGIN
                        CASE "Account Type" OF
                            "Account Type"::"G/L Account":
                                BEGIN
                                    GLAccount.GET("Account No.");
                                    IF NOT (GLAccount."Cash-flow code assoc.") THEN
                                        "Acc: cash-flow code" := ''
                                    ELSE
                                        Rec.TESTFIELD("Acc: cash-flow code");
                                END;
                            "Account Type"::"Bank Account":
                                BEGIN
                                    BankAccount.GET("Account No.");
                                    BankPostingGroup.GET(BankAccount."Bank Acc. Posting Group");
                                    GLAccount.GET(BankPostingGroup."G/L Bank Account No.");
                                    IF NOT GLAccount."Cash-flow code assoc." THEN
                                        Rec."Acc: cash-flow code" := ''
                                    ELSE
                                        Rec.TESTFIELD("Acc: cash-flow code");
                                END;
                        END;
                    END ELSE
                        "Acc: cash-flow code" := '';
            end;
        }

    }

}