codeunit 31022926 "Cash-flow Management"
{
    //Cash-Flow
    trigger OnRun()
    begin

    end;
    procedure GetCashFlowCode(BalAccountType: Integer; BalAccountNo: Code[20]): Code[10] 
    var
        GLAccount:Record "G/L Account";
        BankAccount:Record "Bank Account";
        BankAccPostingGroup:Record "Bank Account Posting Group";
    begin
        CASE BalAccountType OF
            0:
                IF GLAccount.GET(BalAccountNo) AND (GLAccount."Cash-flow code assoc.") THEN
                    EXIT(GLAccount."Cash-flow code");
            1:
                IF BankAccount.GET(BalAccountNo) AND (BankAccPostingGroup.GET(BankAccount."Bank Acc. Posting Group")) AND (GLAccount.GET(BankAccPostingGroup."G/L Bank Account No.")) AND (GLAccount."Cash-flow code assoc.") THEN
                    EXIT(GLAccount."Cash-flow code");
        END;
        EXIT('');
    end;
    // procedure GetCashFlowCodeForSalesPaymentMethod(SalesHeader: Record "Sales Header";PaymentMethod:Record "Payment Method")
    // var
    //     GLAcc: Record "G/L Account";
    //     BankAcc:Record "Bank Account";
    //     BankAccPostingGroup:Record "Bank Account Posting Group";
    // begin
    //     SalesHeader."Cash-Flow Code" := '';
    //     CASE PaymentMethod."Bal. Account Type" OF
    //     PaymentMethod."Bal. Account Type"::"G/L Account":
    //         IF GLAcc.GET(PaymentMethod."Bal. Account No.") THEN
    //         SalesHeader."Cash-Flow Code" := GLAcc."Cash-flow code";
    //     PaymentMethod."Bal. Account Type"::"Bank Account":
    //         IF BankAcc.GET(PaymentMethod."Bal. Account No.") AND
    //         BankAccPostingGroup.GET(BankAcc."Bank Acc. Posting Group") AND
    //         GLAcc.GET(BankAccPostingGroup."G/L Bank Account No.") THEN
    //         SalesHeader."Cash-Flow Code" := GLAcc."Cash-flow code";
    //     END;
    // end;

}