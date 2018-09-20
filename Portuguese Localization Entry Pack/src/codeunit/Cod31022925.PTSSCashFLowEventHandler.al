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

    [EventSubscriber(ObjectType::Codeunit, 90, 'OnAfterSetApplyToDocNo', '', true, true)]
    local procedure SetApplytoDocNoPurch(VAR GenJournalLine: Record "Gen. Journal Line"; PurchaseHeader: Record "Purchase Header")
    begin
        GenJournalLine."PTSS Bal: cash-flow code" := PurchaseHeader."PTSS Cash-flow code";
    end;

    [EventSubscriber(ObjectType::Codeunit, 80, 'OnAfterSetApplyToDocNo', '', true, true)]
    local procedure SetApplytoDocNoSales(VAR GenJournalLine: Record "Gen. Journal Line"; SalesHeader: Record "Sales Header")
    begin
        GenJournalLine."PTSS Bal: cash-flow code" := SalesHeader."PTSS Cash-flow code";
    end;

}