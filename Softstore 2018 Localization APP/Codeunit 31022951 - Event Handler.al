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
    var
        myInt: Integer;
}