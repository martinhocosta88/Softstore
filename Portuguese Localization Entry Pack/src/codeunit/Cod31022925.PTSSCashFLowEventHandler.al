codeunit 31022925 "PTSS Cash-FLow Event Handler"
{
    //Cash-Flow
    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Table, 17, 'OnAfterCopyGLEntryFromGenJnlLine', '', true, true)]
    local procedure OnAfterCopyGLEntryFromGenJnlLine(VAR GLEntry: Record "G/L Entry"; VAR GenJournalLine: Record "Gen. Journal Line")
    begin
        with GLEntry do begin
            "PTSS Acc: cash-flow code" := GenJournalLine."PTSS Acc: cash-flow code";
            "PTSS Bal: cash-flow code" := GenJournalLine."PTSS Bal: cash-flow code";
        end;
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterCopyGenJnlLineFromInvPostBuffer', '', true, true)]
    local procedure CopyFromInvoicePostBuffer(InvoicePostBuffer: Record "Invoice Post. Buffer")
    var
        GLAcc: Record "G/L Account";
        GenJnlLine: Record "Gen. Journal Line";
    begin
        IF GLAcc.GET(InvoicePostBuffer."G/L Account") THEN
            GenJnlLine."PTSS Acc: cash-flow code" := Glacc."PTSS Cash-flow code";
    end;

    [EventSubscriber(ObjectType::Codeunit, 366, 'OnAfterOnRun', '', true, true)]
    local procedure MyExchangeAccounts(VAR GenJournalLine: Record "Gen. Journal Line"; GenJournalLine2: Record "Gen. Journal Line")
    begin
        GenJournalLine."PTSS Acc: cash-flow code" := GenJournalLine2."PTSS Bal: cash-flow code";
        GenJournalLine."PTSS Bal: cash-flow code" := GenJournalLine2."PTSS Acc: cash-flow code";
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnAfterInitGLEntry', '', true, true)]
    local procedure InitGLEntry(VAR GLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line")
    var
        Text31022890: Label 'The account no. %1 needs a cash-flow code';
        SourceCodeSetup: Record "Source Code Setup";
        GLAcc: Record "G/L Account";
    begin
        SourceCodeSetup.GET;
        IF GenJournalLine."Source Code" <> SourceCodeSetup."Exchange Rate Adjmt." THEN BEGIN
            IF GLAcc."PTSS Cash-flow code assoc." AND
                (GenJournalLine."Account Type" IN [GenJournalLine."Account Type"::"G/L Account", GenJournalLine."Account Type"::"Bank Account"])
            THEN BEGIN
                IF GenJournalLine."PTSS Acc: cash-flow code" = '' THEN
                    ERROR(Text31022890, GLEntry."G/L Account No.");
                GLEntry."PTSS Acc: cash-flow code" := GenJournalLine."PTSS Acc: cash-flow code";
                GLEntry."PTSS Bal: cash-flow code" := GenJournalLine."PTSS Bal: cash-flow code";
            END;
        END;
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterCopyGenJnlLineFromPurchHeader', '', true, true)]
    local procedure CopyFromPurchHeader(PurchaseHeader: Record "Purchase Header"; VAR GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."PTSS Bal: cash-flow code" := PurchaseHeader."PTSS Cash-flow code";
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterCopyGenJnlLineFromSalesHeader', '', true, true)]
    local procedure CopyFromSalesHeader(SalesHeader: Record "Sales Header"; VAR GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."PTSS Bal: cash-flow code" := SalesHeader."PTSS Cash-flow code";
    end;

    [EventSubscriber(ObjectType::Table, 271, 'OnAfterCopyFromGenJnlLine', '', true, true)]
    local procedure CopyFromGenJnlLine(var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    var
    begin
        BankAccountLedgerEntry."PTSS Cash-Flow Code" := GenJournalLine."PTSS Acc: cash-flow code";
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterAccountNoOnValidateGetGLAccount', '', true, true)]
    local procedure GetGLAccount(var GenJournalLine: Record "Gen. Journal Line"; var GLAccount: Record "G/L Account")
    begin
        GenJournalLine."PTSS Acc: cash-flow code" := '';
        IF GLAccount."PTSS Cash-flow code assoc." THEN
            GenJournalLine."PTSS Acc: cash-flow code" := GLAccount."PTSS Cash-flow code";
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterAccountNoOnValidateGetGLBalAccount', '', true, true)]
    local procedure GetGLBalAccount(var GenJournalLine: Record "Gen. Journal Line"; var GLAccount: Record "G/L Account")
    begin
        GenJournalLine."PTSS Bal: cash-flow code" := '';
        IF GLAccount."PTSS Cash-flow code assoc." THEN
            GenJournalLine."PTSS Bal: cash-flow code" := GLAccount."PTSS Cash-flow code";
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterAccountNoOnValidateGetCustomerAccount', '', true, true)]
    local procedure GetCustomerAccount(var GenJournalLine: Record "Gen. Journal Line"; var Customer: Record Customer; FieldNo: Integer)
    begin
        GenJournalLine."PTSS Acc: cash-flow code" := '';
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterAccountNoOnValidateGetCustomerBalAccount', '', true, true)]
    local procedure GetCustomerBalAccount(var GenJournalLine: Record "Gen. Journal Line"; var Customer: Record Customer; FieldNo: Integer)
    begin
        GenJournalLine."PTSS Bal: cash-flow code" := '';
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterAccountNoOnValidateGetVendorAccount', '', true, true)]
    local procedure GetVendorAccount(var GenJournalLine: Record "Gen. Journal Line"; var Vendor: Record Vendor; FieldNo: Integer)
    begin
        GenJournalLine."PTSS Acc: cash-flow code" := '';
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterAccountNoOnValidateGetVendorBalAccount', '', true, true)]
    local procedure GetVendorBalAccount(var GenJournalLine: Record "Gen. Journal Line"; var Vendor: Record Vendor; FieldNo: Integer)
    begin
        GenJournalLine."PTSS Bal: cash-flow code" := '';
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterAccountNoOnValidateGetBankAccount', '', true, true)]
    local procedure GetBankAccount(var GenJournalLine: Record "Gen. Journal Line"; var BankAccount: Record "Bank Account"; FieldNo: Integer)
    var
        GLAcc: Record "G/L Account";
        BankPostingGroup: Record "Bank Account Posting Group";
    begin
        GenJournalLine."PTSS Acc: cash-flow code" := '';
        IF GenJournalLine."Account Type" <> GenJournalLine."Account Type"::"Fixed Asset" THEN
            IF BankAccount.GET(GenJournalLine."Account No.") AND BankPostingGroup.GET(BankAccount."Bank Acc. Posting Group") AND GLAcc.GET(BankPostingGroup."G/L Bank Account No.") AND GLAcc."PTSS Cash-flow Code Assoc." THEN
                GenJournalLine."PTSS Acc: cash-flow code" := GLAcc."PTSS Cash-flow code";
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterAccountNoOnValidateGetBankBalAccount', '', true, true)]
    local procedure GetBankBalAccount(var GenJournalLine: Record "Gen. Journal Line"; var BankAccount: Record "Bank Account"; FieldNo: Integer)
    var
        GLAcc: Record "G/L Account";
        BankPostingGroup: Record "Bank Account Posting Group";
    begin
        GenJournalLine."PTSS Bal: cash-flow code" := '';
        IF GenJournalLine."Bal. Account Type" <> GenJournalLine."Bal. Account Type"::"Fixed Asset" THEN
            IF BankAccount.GET(GenJournalLine."Bal. Account No.") AND BankPostingGroup.GET(BankAccount."Bank Acc. Posting Group") AND GLAcc.GET(BankPostingGroup."G/L Bank Account No.") AND GLAcc."PTSS Cash-flow code assoc." THEN
                GenJournalLine."PTSS Bal: cash-flow code" := GLAcc."PTSS Cash-flow code";
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterAccountNoOnValidateGetFAAccount', '', true, true)]
    local procedure GetFAAccount(var GenJournalLine: Record "Gen. Journal Line"; var FixedAsset: Record "Fixed Asset")
    var
        BankAccount: Record "Bank Account";
        GLAcc: Record "G/L Account";
        BankPostingGroup: Record "Bank Account Posting Group";
    begin
        GenJournalLine."PTSS Acc: cash-flow code" := '';
        IF GenJournalLine."Account Type" <> GenJournalLine."Account Type"::"Fixed Asset" THEN
            IF BankAccount.GET(GenJournalLine."Account No.") AND BankPostingGroup.GET(BankAccount."Bank Acc. Posting Group") AND GLAcc.GET(BankPostingGroup."G/L Bank Account No.") AND GLAcc."PTSS Cash-flow Code Assoc." THEN
                GenJournalLine."PTSS Acc: cash-flow code" := GLAcc."PTSS Cash-flow code";
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterAccountNoOnValidateGetFABalAccount', '', true, true)]
    local procedure GetFABalAccount(var GenJournalLine: Record "Gen. Journal Line"; var FixedAsset: Record "Fixed Asset")
    var
        BankAccount: Record "Bank Account";
        GLAcc: Record "G/L Account";
        BankPostingGroup: Record "Bank Account Posting Group";
    begin
        GenJournalLine."PTSS Bal: cash-flow code" := '';
        IF GenJournalLine."Bal. Account Type" <> GenJournalLine."Bal. Account Type"::"Fixed Asset" THEN
            IF BankAccount.GET(GenJournalLine."Bal. Account No.") AND BankPostingGroup.GET(BankAccount."Bank Acc. Posting Group") AND GLAcc.GET(BankPostingGroup."G/L Bank Account No.") AND GLAcc."PTSS Cash-flow code assoc." THEN
                GenJournalLine."PTSS Bal: cash-flow code" := GLAcc."PTSS Cash-flow code";
    end;
}