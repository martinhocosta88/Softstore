codeunit 31022928 "PTSS BPEventHandler"
{
    //COPE
    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Table, 271, 'OnAfterCopyFromGenJnlLine', '', true, true)]
    local procedure CopyFromGenJnlLine(var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    var
    begin
        BankAccountLedgerEntry."PTSS BP Active Country Code" := GenJournalLine."PTSS BP Active Country Code";
        IF BankAccountLedgerEntry."Bal. Account No." = '' THEN BEGIN
            BankAccountLedgerEntry."PTSS BP Statistic Code" := GenJournalLine."PTSS BP Statistic Code";
            BankAccountLedgerEntry."PTSS BP Countrp. Country Code" := GenJournalLine."PTSS BP Countrpt. Country Code";
        END ELSE BEGIN
            BankAccountLedgerEntry."PTSS BP Statistic Code" := GenJournalLine."PTSS BP Bal. Statistic Code";
            BankAccountLedgerEntry."PTSS BP Countrp. Country Code" := GenJournalLine."PTSS BP Bal. Count. Ctry. Code";
        END;
        BankAccountLedgerEntry."PTSS BP NPC 2nd Intervener" := GenJournalLine."PTSS BP NPC 2nd Intervener";
        BankAccountLedgerEntry."PTSS BP Account Type Code" := GenJournalLine."PTSS BP Account Type Code";
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterAccountNoOnValidateGetCustomerAccount', '', true, true)]
    local procedure GetCustomerAccount(var GenJournalLine: Record "Gen. Journal Line"; var Customer: Record Customer; FieldNo: Integer)
    begin
        GenJournalLine.GetBPInfo(Customer."Country/Region Code", Customer."PTSS BP Statistic Code");
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterAccountNoOnValidateGetVendorAccount', '', true, true)]
    local procedure GetVendorAccount(var GenJournalLine: Record "Gen. Journal Line"; var Vendor: Record Vendor; FieldNo: Integer)
    begin
        GenJournalLine.GetBPInfo(Vendor."Country/Region Code", Vendor."PTSS BP Statistic Code");
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterAccountNoOnValidateGetBankAccount', '', true, true)]
    local procedure GetBankAccount(var GenJournalLine: Record "Gen. Journal Line"; var BankAccount: Record "Bank Account"; FieldNo: Integer)
    begin
        GenJournalLine.GetBPInfo(BankAccount."Country/Region Code", BankAccount."PTSS BP Statistic Code");
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterAccountNoOnValidateGetCustomerBalAccount', '', true, true)]
    local procedure GetCustomerBalAccount(var GenJournalLine: Record "Gen. Journal Line"; var Customer: Record Customer; FieldNo: Integer)
    begin
        GenJournalLine.GetBalBPInfo(Customer."Country/Region Code", Customer."PTSS BP Statistic Code")
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterAccountNoOnValidateGetVendorBalAccount', '', true, true)]
    local procedure GetVendorBalAccount(var GenJournalLine: Record "Gen. Journal Line"; var Vendor: Record Vendor; FieldNo: Integer)
    begin
        GenJournalLine.GetBalBPInfo(Vendor."Country/Region Code", Vendor."PTSS BP Statistic Code")
    end;

    [EventSubscriber(ObjectType::Table, 81, 'OnAfterAccountNoOnValidateGetBankBalAccount', '', true, true)]
    local procedure GetBankBalAccount(var GenJournalLine: Record "Gen. Journal Line"; var BankAccount: Record "Bank Account"; FieldNo: Integer)
    begin
        GenJournalLine.GetBalBPInfo(BankAccount."Country/Region Code", BankAccount."PTSS BP Statistic Code")
    end;

    [EventSubscriber(ObjectType::Codeunit, 90, 'OnBeforePostBalancingEntry', '', true, true)]
    local procedure CopyBPInfoPurch(var GenJnlLine: Record "Gen. Journal Line"; PurchHeader: Record "Purchase Header"; var TotalPurchLine: Record "Purchase Line"; var TotalPurchLineLCY: Record "Purchase Line"; PreviewMode: Boolean; CommitIsSupressed: Boolean)
    var
        Vendor: Record Vendor;
        Country: Record "Country/Region";
    begin
        Vendor.GET(PurchHeader."Pay-to Vendor No.");
        Country.GET(Vendor."Country/Region Code");
        GenJnlLine."PTSS BP Statistic Code" := Vendor."PTSS BP Statistic Code";
        GenJnlLine."PTSS BP Countrpt. Country Code" := Country."PTSS BP Territory Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, 80, 'OnBeforePostBalancingEntry', '', True, True)]
    local procedure CopyBPInfoSales(var GenJnlLine: Record "Gen. Journal Line"; SalesHeader: Record "Sales Header"; var TotalSalesLine: Record "Sales Line"; var TotalSalesLineLCY: Record "Purchase Line"; CommitIsSuppressed: Boolean; PreviewMode: Boolean)
    var
        Customer: Record Customer;
        Country: Record "Country/Region";
    begin
        Customer.GET(SalesHeader."Bill-to Customer No.");
        Country.GET(Customer."Country/Region Code");
        GenJnlLine."PTSS BP Statistic Code" := Customer."PTSS BP Statistic Code";
        GenJnlLine."PTSS BP Countrpt. Country Code" := Country."PTSS BP Territory Code";
    end;

    [EventSubscriber(ObjectType::Codeunit, 366, 'OnAfterOnRun', '', True, True)]
    local procedure ExchangeAccGLJnlLine(var GenJournalLine: Record "Gen. Journal Line"; GenJournalLine2: Record "Gen. Journal Line")
    begin
        With GenJournalLine DO BEGIN
            "PTSS BP Statistic Code" := GenJournalLine2."PTSS BP Bal. Statistic Code";
            "PTSS BP Countrpt. Country Code" := GenJournalLine2."PTSS BP Bal. Count. Ctry. Code";
            "PTSS BP Active Country Code" := GenJournalLine2."PTSS BP Bal. Active Ctry. Code";
            "PTSS BP NPC 2nd Intervener" := GenJournalLine2."PTSS BP Bal. NPC 2nd Interv.";
            "PTSS BP Bal. Statistic Code" := GenJournalLine2."PTSS BP Statistic Code";
            "PTSS BP Bal. Count. Ctry. Code" := GenJournalLine2."PTSS BP Countrpt. Country Code";
            "PTSS BP Bal. Active Ctry. Code" := GenJournalLine2."PTSS BP Active Country Code";
            "PTSS BP Bal. NPC 2nd Interv." := GenJournalLine2."PTSS BP NPC 2nd Intervener";
        END;
    end;

    [EventSubscriber(ObjectType::Table, 382, 'OnAfterCopyFromVendLedgerEntry', '', True, true)]
    local procedure CopyFromVendLedgEntry(var CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer"; VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
        CVLedgerEntryBuffer."PTSS BP Statistic Code" := VendorLedgerEntry."PTSS BP Statistic Code";
    end;

    [EventSubscriber(ObjectType::Table, 383, 'OnAfterCopyFromCVLedgEntryBuf', '', true, true)]
    local procedure CopyFromCVLEdgEntryBuf(var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer")
    begin
        DetailedCVLedgEntryBuffer."PTSS Initial BP Statistic Code" := CVLedgerEntryBuffer."PTSS BP Statistic Code";
    end;
}