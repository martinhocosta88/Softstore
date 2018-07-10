codeunit 31022952 "Cash-flow Management"
{
    //Cash-Flow
    trigger OnRun()
    begin

    end;
    procedure GetCashFlowCode(BalAccountType: Integer; BalAccountNo: Code[20]): Code[10] 
    var
        GLAccount:Record "G/L Account";
        BankAccount:Record "Bank Account";
        BankAccountPostingGroup:Record "Bank Account Posting Group";
    begin
        CASE BalAccountType OF
            0:
                IF GLAccount.GET(BalAccountNo) AND (GLAccount."Cash-flow code assoc.") THEN
                    EXIT(GLAccount."Cash-flow code");
            1:
                IF BankAccount.GET(BalAccountNo) AND (BankAccountPostingGroup.GET(BankAccount."Bank Acc. Posting Group")) AND (GLAccount.GET(BankAccountPostingGroup."G/L Bank Account No.")) AND (GLAccount."Cash-flow code assoc.") THEN
                    EXIT(GLAccount."Cash-flow code");
        END;
        EXIT('');
    end;

}