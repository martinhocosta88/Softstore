codeunit 31022926 "PTSS Cash-flow Management"
{
    //Cash-Flow
    trigger OnRun()
    begin

    end;

    procedure GetCashFlowCode(BalAccountType: Integer; BalAccountNo: Code[20]): Code[10]
    var
        GLAccount: Record "G/L Account";
        BankAccount: Record "Bank Account";
        BankAccPostingGroup: Record "Bank Account Posting Group";
    begin
        CASE BalAccountType OF
            0:
                IF GLAccount.GET(BalAccountNo) AND (GLAccount."PTSS Cash-flow code assoc.") THEN
                    EXIT(GLAccount."PTSS Cash-flow code");
            1:
                IF BankAccount.GET(BalAccountNo) AND (BankAccPostingGroup.GET(BankAccount."Bank Acc. Posting Group")) AND (GLAccount.GET(BankAccPostingGroup."G/L Bank Account No.")) AND (GLAccount."PTSS Cash-flow code assoc.") THEN
                    EXIT(GLAccount."PTSS Cash-flow code");
        END;
        EXIT('');
    end;


}