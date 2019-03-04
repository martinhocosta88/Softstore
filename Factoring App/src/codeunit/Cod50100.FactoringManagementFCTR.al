codeunit 50100 "FactoringManagement FCTR"
{
    [EventSubscriber(ObjectType::Table, 25, 'OnAfterCopyVendLedgerEntryFromGenJnlLine', '', true, true)]
    local procedure CopyFromGenJnlLinePT(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        VendorLedgerEntry."PTSS Factoring to Vendor No." := GenJournalLine."PTSS Factoring to Vendor No.";
    end;
}