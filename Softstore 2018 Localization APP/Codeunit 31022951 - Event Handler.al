codeunit 31022951 EventHandler
{
    trigger OnRun()
    begin
        
    end;
    [EventSubscriber(ObjectType::Table, 17, 'OnAfterCopyGLEntryFromGenJnlLine', '', true, true)]
    local procedure OnAfterCopyGLEntryFromGenJnlLine(VAR GLEntry : Record "G/L Entry";VAR GenJournalLine : Record "Gen. Journal Line")
    begin
        with GLEntry do begin
        "Acc: cash-flow code" := GenJournalLine."Acc: cash-flow code";
        "Bal: cash-flow code" := GenJournalLine."Bal: cash-flow code";
        end;
    end;
    [EventSubscriber(ObjectType::Table, 81, 'OnAfterCopyGenJnlLineFromInvPostBuffer', '', true, true)]
    local procedure CopyFromInvoicePostBuffer(InvoicePostBuffer : Record "Invoice Post. Buffer")
    var
        GLAcc: Record "G/L Account";
        GenJnlLine:Record "Gen. Journal Line";
    begin
    IF GLAcc.GET(InvoicePostBuffer."G/L Account") THEN
        GenJnlLine."Acc: cash-flow code":=Glacc."Cash-flow code";    
    end;
    [EventSubscriber(ObjectType::Codeunit, 366, 'OnAfterOnRun', '', true, true)]
    local procedure MyExchangeAccounts(VAR GenJournalLine : Record "Gen. Journal Line";GenJournalLine2 : Record "Gen. Journal Line")
    begin
        GenJournalLine."Acc: cash-flow code" := GenJournalLine2."Bal: cash-flow code";
        GenJournalLine."Bal: cash-flow code" := GenJournalLine2."Acc: cash-flow code";        
    end;
    [EventSubscriber(ObjectType::Codeunit, 12, 'OnAfterInitGLEntry', '', true, true)]
    local procedure InitGLEntry(VAR GLEntry : Record "G/L Entry";GenJnlLine : Record "Gen. Journal Line";GLAccNo : Code[20])
    var
        Text31022890:Label 'The account no. %1 needs a cash-flow code';
        SourceCodeSetup:Record "Source Code Setup";
        GLAcc:Record "G/L Account";
    begin    
        SourceCodeSetup.GET;
        IF GenJnlLine."Source Code" <> SourceCodeSetup."Exchange Rate Adjmt." THEN BEGIN
        IF GLAcc."Cash-flow code assoc." AND
            (GenJnlLine."Account Type"  IN [GenJnlLine."Account Type"::"G/L Account",GenJnlLine."Account Type"::"Bank Account"])
        THEN BEGIN
            IF GenJnlLine."Acc: cash-flow code" = '' THEN
                ERROR(Text31022890,GLAccNo);
            GLEntry."Acc: cash-flow code" := GenJnlLine."Acc: cash-flow code";
            GLEntry."Bal: cash-flow code" := GenJnlLine."Bal: cash-flow code";
        END;
        END;
    end;
    [EventSubscriber(ObjectType::Codeunit, 90, 'OnAfterSetApplyToDocNo', '', true, true)]
    local procedure SetApplytoDocNoPurch(PurchaseHeader : Record "Purchase Header";VAR GenJnlLine : Record "Gen. Journal Line")
    begin
        GenJnlLine."Bal: cash-flow code" := PurchaseHeader."Cash-flow code";
    end;
    [EventSubscriber(ObjectType::Codeunit, 80, 'OnAfterSetApplyToDocNo', '', true, true)]
    local procedure SetApplytoDocNoSales(SalesHeader : Record "Sales Header";VAR GenJnlLine : Record "Gen. Journal Line")
    begin
        GenJnlLine."Bal: cash-flow code" := SalesHeader."Cash-flow code";
    end;

}