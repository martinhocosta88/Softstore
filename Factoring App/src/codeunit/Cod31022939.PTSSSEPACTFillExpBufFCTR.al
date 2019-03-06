codeunit 31022939 "PTSS SEPA CTFillExp. Buf. FCTR"
{
    //Factoring
    //version NAVW111.00
    //Codeunit duplicada

    Permissions = TableData 1226 = rimd;
    TableNo = 1226;

    trigger OnRun()
    begin
    end;

    var
        HasErrorsErr: Label 'The file export has one or more errors.\\For each line to be exported, resolve the errors displayed to the right and then try to export again.';
        FieldIsBlankErr: Label 'Field %1 must be specified.', Comment = '%1=field name, e.g. Post Code.';
        SameBankErr: Label 'All lines must have the same bank account as the balancing account.';
        RemitMsg: Label '%1 %2', Comment = '%1=Document type, %2=Document no., e.g. Invoice A123';

    [Scope('Personalization')]
    procedure FillExportBuffer(var GenJnlLine: Record "Gen. Journal Line"; var PaymentExportData: Record "Payment Export Data")
    var
        TempGenJnlLine: Record "Gen. Journal Line" temporary;
        GeneralLedgerSetup: Record "General Ledger Setup";
        BankAccount: Record "Bank Account";
        Customer: Record Customer;
        Vendor: Record Vendor;
        Employee: Record Employee;
        VendorBankAccount: Record "Vendor Bank Account";
        CustomerBankAccount: Record "Customer Bank Account";
        CreditTransferRegister: Record "Credit Transfer Register";
        CreditTransferEntry: Record "Credit Transfer Entry";
        BankExportImportSetup: Record "Bank Export/Import Setup";
        MessageID: Code[20];
    begin
        TempGenJnlLine.COPYFILTERS(GenJnlLine);
        CODEUNIT.RUN(CODEUNIT::"SEPA CT-Prepare Source", TempGenJnlLine);

        TempGenJnlLine.RESET;
        TempGenJnlLine.FINDSET;
        BankAccount.GET(TempGenJnlLine."Bal. Account No.");
        BankAccount.TESTFIELD(IBAN);
        BankAccount.GetBankExportImportSetup(BankExportImportSetup);
        BankExportImportSetup.TESTFIELD("Check Export Codeunit");
        TempGenJnlLine.DeletePaymentFileBatchErrors;
        REPEAT
            CODEUNIT.RUN(BankExportImportSetup."Check Export Codeunit", TempGenJnlLine);
            IF TempGenJnlLine."Bal. Account No." <> BankAccount."No." THEN
                TempGenJnlLine.InsertPaymentFileError(SameBankErr);
        UNTIL TempGenJnlLine.NEXT = 0;

        IF TempGenJnlLine.HasPaymentFileErrorsInBatch THEN BEGIN
            COMMIT;
            ERROR(HasErrorsErr);
        END;

        GeneralLedgerSetup.GET;
        GeneralLedgerSetup.TESTFIELD("LCY Code");

        MessageID := BankAccount.GetCreditTransferMessageNo;
        CreditTransferRegister.CreateNew(MessageID, BankAccount."No.");

        WITH PaymentExportData DO BEGIN
            RESET;
            IF FINDLAST THEN;

            TempGenJnlLine.FINDSET;
            REPEAT
                INIT;
                "Entry No." += 1;
                SetPreserveNonLatinCharacters(BankExportImportSetup."Preserve Non-Latin Characters");
                SetBankAsSenderBank(BankAccount);
                "Transfer Date" := TempGenJnlLine."Posting Date";
                "Document No." := TempGenJnlLine."Document No.";
                "Applies-to Ext. Doc. No." := TempGenJnlLine."Applies-to Ext. Doc. No.";
                Amount := TempGenJnlLine.Amount;
                IF TempGenJnlLine."Currency Code" = '' THEN
                    "Currency Code" := GeneralLedgerSetup."LCY Code"
                ELSE
                    "Currency Code" := TempGenJnlLine."Currency Code";

                CASE TempGenJnlLine."Account Type" OF
                    TempGenJnlLine."Account Type"::Customer:
                        BEGIN
                            Customer.GET(TempGenJnlLine."Account No.");
                            CustomerBankAccount.GET(Customer."No.", TempGenJnlLine."Recipient Bank Account");
                            SetCustomerAsRecipient(Customer, CustomerBankAccount);
                        END;
                    TempGenJnlLine."Account Type"::Vendor:
                        BEGIN
                            //soft,sn
                            IF TempGenJnlLine."PTSS Factoring to Vendor No." <> '' then
                                Vendor.Get(TempGenJnlLine."PTSS Factoring to Vendor No.")
                            else
                                //soft,en
                                Vendor.GET(TempGenJnlLine."Account No.");
                            VendorBankAccount.GET(Vendor."No.", TempGenJnlLine."Recipient Bank Account");
                            SetVendorAsRecipient(Vendor, VendorBankAccount);
                        END;
                    TempGenJnlLine."Account Type"::Employee:
                        BEGIN
                            Employee.GET(TempGenJnlLine."Account No.");
                            SetEmployeeAsRecipient(Employee);
                        END;
                END;

                VALIDATE("SEPA Instruction Priority", "SEPA Instruction Priority"::NORMAL);
                VALIDATE("SEPA Payment Method", "SEPA Payment Method"::TRF);
                VALIDATE("SEPA Charge Bearer", "SEPA Charge Bearer"::SLEV);
                "SEPA Batch Booking" := FALSE;
                SetCreditTransferIDs(MessageID);

                IF "Applies-to Ext. Doc. No." <> '' THEN
                    AddRemittanceText(STRSUBSTNO(RemitMsg, TempGenJnlLine."Applies-to Doc. Type", "Applies-to Ext. Doc. No."))
                ELSE
                    AddRemittanceText(TempGenJnlLine.Description);
                IF TempGenJnlLine."Message to Recipient" <> '' THEN
                    AddRemittanceText(TempGenJnlLine."Message to Recipient");

                ValidatePaymentExportData(PaymentExportData, TempGenJnlLine);
                INSERT(TRUE);
                CreditTransferEntry.CreateNew(
                  CreditTransferRegister."No.", "Entry No.",
                  TempGenJnlLine."Account Type", TempGenJnlLine."Account No.",
                  TempGenJnlLine.GetAppliesToDocEntryNo,
                  "Transfer Date", "Currency Code", Amount, COPYSTR("End-to-End ID", 1, MAXSTRLEN("End-to-End ID")),
                  TempGenJnlLine."Recipient Bank Account", TempGenJnlLine."Message to Recipient");
            UNTIL TempGenJnlLine.NEXT = 0;
        END;
    end;

    local procedure ValidatePaymentExportData(var PaymentExportData: Record "Payment Export Data"; var GenJnlLine: Record "Gen. Journal Line")
    begin
        ValidatePaymentExportDataField(PaymentExportData, GenJnlLine, PaymentExportData.FIELDNAME("Sender Bank Account No."));
        ValidatePaymentExportDataField(PaymentExportData, GenJnlLine, PaymentExportData.FIELDNAME("Recipient Name"));
        ValidatePaymentExportDataField(PaymentExportData, GenJnlLine, PaymentExportData.FIELDNAME("Recipient Bank Acc. No."));
        ValidatePaymentExportDataField(PaymentExportData, GenJnlLine, PaymentExportData.FIELDNAME("Transfer Date"));
        ValidatePaymentExportDataField(PaymentExportData, GenJnlLine, PaymentExportData.FIELDNAME("Payment Information ID"));
        ValidatePaymentExportDataField(PaymentExportData, GenJnlLine, PaymentExportData.FIELDNAME("End-to-End ID"));
    end;

    local procedure ValidatePaymentExportDataField(var PaymentExportData: Record "Payment Export Data"; var GenJnlLine: Record "Gen. Journal Line"; FieldName: Text)
    var
        "Field": Record Field;
        RecRef: RecordRef;
        FieldRef: FieldRef;
    begin
        RecRef.GETTABLE(PaymentExportData);
        Field.SETRANGE(TableNo, RecRef.NUMBER);
        Field.SETRANGE(FieldName, FieldName);
        Field.FINDFIRST;
        FieldRef := RecRef.FIELD(Field."No.");
        IF (Field.Type = Field.Type::Text) AND (FORMAT(FieldRef.VALUE) <> '') THEN
            EXIT;
        IF (Field.Type = Field.Type::Code) AND (FORMAT(FieldRef.VALUE) <> '') THEN
            EXIT;
        IF (Field.Type = Field.Type::Decimal) AND (FORMAT(FieldRef.VALUE) <> '0') THEN
            EXIT;
        IF (Field.Type = Field.Type::Integer) AND (FORMAT(FieldRef.VALUE) <> '0') THEN
            EXIT;
        IF (Field.Type = Field.Type::Date) AND (FORMAT(FieldRef.VALUE) <> '0D') THEN
            EXIT;

        PaymentExportData.AddGenJnlLineErrorText(GenJnlLine, STRSUBSTNO(FieldIsBlankErr, Field."Field Caption"));
    end;
}

