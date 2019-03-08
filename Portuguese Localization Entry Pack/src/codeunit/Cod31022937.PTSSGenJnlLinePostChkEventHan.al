codeunit 31022937 "PTSS GenJnlLinePostChkEventHan"
{
    //Regras de Negocio
    [EventSubscriber(ObjectType::Table, 81, 'OnAfterAccountNoOnValidateGetCustomerAccount', '', true, true)]
    local procedure GetCustomerInfo(var GenJournalLine: Record "Gen. Journal Line"; var Customer: Record Customer; FieldNo: Integer)
    begin
        GenJournalLine.GetCustInfo(Customer);
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterAccountNoOnValidateGetVendorAccount', '', true, true)]
    local procedure GetVendorInfo(var GenJournalLine: Record "Gen. Journal Line"; var Vendor: Record Vendor; FieldNo: Integer)
    begin
        GenJournalLine.GetVendInfo(Vendor);
    end;

    [EventSubscriber(ObjectType::Codeunit, 11, 'OnAfterCheckGenJnlLine', '', true, true)]
    local procedure RunCheckPT(Var GenJournalLine: Record "Gen. Journal Line")
    var
        Text31022891: Label 'You cannot insert spaces on %1.';
    begin
        With GenJournalLine DO begin
            IF STRPOS("Document No.", ' ') > 0 THEN
                ERROR(Text31022891, "Document No.");
            TESTFIELD(Description);
        END;
    end;
}