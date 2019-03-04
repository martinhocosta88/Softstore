codeunit 31022937 "PTSS GenJnlLineEventHandler"
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
}