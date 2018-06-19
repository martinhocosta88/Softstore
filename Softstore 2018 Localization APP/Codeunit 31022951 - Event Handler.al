codeunit 31022951 EventHandler
{
    trigger OnRun()
    begin
        
    end;
    [EventSubscriber(ObjectType::Table, 17, 'OnAfterCopyGLEntryFromGenJnlLine', '', true, true)]
    local procedure OnAfterCopyGLEntryFromGenJnlLine(VAR GLEntry : Record "G/L Entry";VAR GenJnlLine : Record "Gen. Journal Line")
    begin
        with GLEntry do begin
        "Acc: cash-flow code" := GenJnlLine."Acc: cash-flow code";
        "Bal: cash-flow code" := GenJnlLine."Bal: cash-flow code";
        end;
    end;
    var
        myInt: Integer;
}