report 31023102 "PTSS Adjust Exchange Rates"
{
    //Ajuste Divisas

    DefaultLayout = RDLC;
    RDLCLayout = './Adjust Exchange Rates Layout.rdl';
    ApplicationArea = all;
    Caption = 'Adjust Exchange Rates';
    Permissions = TableData 21 = rimd,
                  TableData 25 = rimd,
                  TableData 86 = rimd,
                  TableData 254 = rimd,
                  TableData 379 = rimd,
                  TableData 380 = rimd;
    UsageCategory = Tasks;

    dataset
    {
        dataitem(Currency; Currency)
        {
            DataItemTableView = SORTING (Code);
            RequestFilterFields = "Code";
            column(ReportNameCaption; ReportNameCaptionLbl)
            {
            }
            column(CompanyName; COMPANYNAME)
            {
            }
            column(FORMAT_today; FORMAT(TODAY, 0, 4))
            {
            }
            column(TextAdjustmentPeriod; Text31022890 + FORMAT(StartDate))
            {
            }
            column(TextCurrencyCodeSelected; ': ' + CurrencyCodeSelected)
            {
            }
            column(Format_EndDateReq; FORMAT(EndDateReq))
            {
            }
            dataitem("Bank Account"; "Bank Account")
            {
                DataItemLink = "Currency Code" = FIELD (Code);
                DataItemTableView = SORTING ("Bank Acc. Posting Group");
                column(BankAccount_PostingDate; FORMAT(PostingDate))
                {
                }
                column(BankAccount_AccNo; AccNo)
                {
                }
                column(BankAccount_AccountName; AccountName)
                {
                }
                column(BankAccount_DocNo; DocNo)
                {
                }
                column(BankAccount_Currency_Code; Currency.Code)
                {
                }
                column(BankAccount_Currency_CurrencyFactor; Currency."Currency Factor")
                {
                }
                column(BankAccount_AdjustBase; AdjustBase)
                {
                }
                column(BankAccount_AdjustBaseLCY; AdjustBaseLCY)
                {
                }
                column(BankAccount_NewBaseLCY; NewBaseLCY)
                {
                }
                column(BankAccount_AdjustedAmtLCY; AdjustedAmtLCY)
                {
                }
                column(BankAccount_AccType; AccType)
                {
                }
                column(BankAdjusted; BankAdjusted)
                {
                }
                dataitem(BankAccountGroupTotal; Integer)
                {
                    DataItemTableView = SORTING (Number);
                    MaxIteration = 1;

                    trigger OnAfterGetRecord()
                    var
                        BankAccount: Record "Bank Account";
                        GroupTotal: Boolean;
                    begin
                        BankAccount.COPY("Bank Account");
                        IF BankAccount.NEXT = 1 THEN BEGIN
                            IF BankAccount."Bank Acc. Posting Group" <> "Bank Account"."Bank Acc. Posting Group" THEN
                                GroupTotal := TRUE;
                        END ELSE
                            GroupTotal := TRUE;

                        IF GroupTotal THEN
                            IF TotalAdjAmount <> 0 THEN BEGIN
                                AdjExchRateBufferUpdate(
                                  "Bank Account"."Currency Code", "Bank Account"."Bank Acc. Posting Group",
                                  //soft,o TotalAdjBase,TotalAdjBaseLCY,TotalAdjAmount,0,0,0,PostingDate,'');
                                  //soft,sn
                                  TotalAdjBase, TotalAdjBaseLCY, TotalAdjAmount, 0, 0, 0, PostingDate, '',
                                  GetBankAccNo("Bank Account"."Bank Acc. Posting Group"), BankAccount."No.");
                                //soft,en
                                InsertExchRateAdjmtReg(3, "Bank Account"."Bank Acc. Posting Group", "Bank Account"."Currency Code");
                                TotalBankAccountsAdjusted += 1;
                                AdjExchRateBuffer.RESET;
                                AdjExchRateBuffer.DELETEALL;
                                TotalAdjBase := 0;
                                TotalAdjBaseLCY := 0;
                                TotalAdjAmount := 0;
                            END;
                    end;
                }

                trigger OnAfterGetRecord()
                var
                    "//--soft-local--//": Integer;
                    BankAccLedgEntry: Record "Bank Account Ledger Entry";
                begin
                    TempEntryNoAmountBuf.DELETEALL;
                    BankAccNo := BankAccNo + 1;
                    Window.UPDATE(1, ROUND(BankAccNo / BankAccNoTotal * 10000, 1));

                    TempDimSetEntry.RESET;
                    TempDimSetEntry.DELETEALL;
                    TempDimBuf.RESET;
                    TempDimBuf.DELETEALL;

                    CALCFIELDS("Balance at Date", "Balance at Date (LCY)");
                    //soft,so
                    // AdjBase := "Balance at Date";
                    // AdjBaseLCY := "Balance at Date (LCY)";
                    // AdjAmount :=
                    //  ROUND(
                    //    CurrExchRate.ExchangeAmtFCYToLCYAdjmt(
                    //      PostingDate,Currency.Code,"Balance at Date",Currency."Currency Factor")) -
                    //  "Balance at Date (LCY)";
                    //soft,eo
                    //soft,sn
                    //XXX,begin
                    // BankAccPostingBuffer[1].DELETEALL;
                    // BankAccLedgEntry.RESET;
                    // BankAccLedgEntry.SETRANGE("Bank Account No.", "No.");
                    // BankAccLedgEntry.SETRANGE("Posting Date", 0D, EndDate);
                    // IF NOT BankAccLedgEntry.ISEMPTY THEN BEGIN
                    //     BankAccLedgEntry.FINDSET;
                    //     REPEAT
                    //         FillBankAccPostingBuffer(BankAccLedgEntry);
                    //     UNTIL BankAccLedgEntry.NEXT = 0;
                    // END;

                    // IF BankAccPostingBuffer[1].FINDLAST THEN
                    //     REPEAT
                    //         IF BankAccPostingBuffer[1]."Amount (LCY)" <> 0 THEN BEGIN
                    //             AdjBase := BankAccPostingBuffer[1].Amount;
                    //             AdjBaseLCY := BankAccPostingBuffer[1]."Amount (LCY)";
                    //             AdjAmount := ROUND(CurrExchRate.ExchangeAmtFCYToLCYAdjmt(
                    //                   PostingDate, Currency.Code, BankAccPostingBuffer[1].Amount, Currency."Currency Factor")) -
                    //                         BankAccPostingBuffer[1]."Amount (LCY)";
                    //             GetAdjustmentValues(
                    //                   AdjBase, AdjBaseLCY, AdjAmount, 3, "Bank Account".Name, PostingDocNo, "Bank Account"."No.", PostingDate, Currency.Code);
                    //             //soft,en

                    //             IF AdjAmount <> 0 THEN BEGIN
                    //                 GenJnlLine.VALIDATE("Posting Date", PostingDate);
                    //                 GenJnlLine."Document No." := PostingDocNo;
                    //                 GenJnlLine."Account Type" := GenJnlLine."Account Type"::"Bank Account";
                    //                 GenJnlLine.VALIDATE("Account No.", "No.");
                    //                 //soft,o GenJnlLine.Description := PADSTR(STRSUBSTNO(PostingDescription,Currency.Code,AdjBase),MAXSTRLEN(GenJnlLine.Description));
                    //                 GenJnlLine.Description := STRSUBSTNO(PostingDescription, Currency.Code, AdjBase); //soft,n
                    //                 GenJnlLine.VALIDATE(Amount, 0);
                    //                 GenJnlLine."Amount (LCY)" := AdjAmount;
                    //                 GenJnlLine."Source Currency Code" := Currency.Code;
                    //                 IF Currency.Code = GLSetup."Additional Reporting Currency" THEN
                    //                     GenJnlLine."Source Currency Amount" := 0;
                    //                 GenJnlLine."Source Code" := SourceCodeSetup."Exchange Rate Adjmt.";
                    //                 GenJnlLine."System-Created Entry" := TRUE;
                    //                 GenJnlLine."Cash-Flow Code" := BankAccPostingBuffer[1]."Cash Flow Code"; //soft,n
                    //                 GetJnlLineDefDim(GenJnlLine, TempDimSetEntry);
                    //                 CopyDimSetEntryToDimBuf(TempDimSetEntry, TempDimBuf);
                    //                 PostGenJnlLine(GenJnlLine, TempDimSetEntry);
                    //                 WITH TempEntryNoAmountBuf DO BEGIN
                    //                     INIT;
                    //                     "Business Unit Code" := '';
                    //                     "Entry No." := "Entry No." + 1;
                    //                     //soft,so
                    //                     //Amount := AdjAmount;
                    //                     // Amount2 := AdjBase;
                    //                     //soft,eo
                    //                     IF NOT FIND THEN //soft,n
                    //                         INSERT;
                    //                     //soft,sn
                    //                     Amount := Amount + AdjAmount;
                    //                     Amount2 := Amount2 + AdjBase;
                    //                     MODIFY;
                    //                     //soft,en
                    //                 END;
                    //                 TempDimBuf2.INIT;
                    //                 TempDimBuf2."Table ID" := TempEntryNoAmountBuf."Entry No.";
                    //                 TempDimBuf2."Entry No." := GetDimCombID(TempDimBuf);
                    //                 TempDimBuf2.INSERT;
                    //                 TotalAdjBase := TotalAdjBase + AdjBase;
                    //                 TotalAdjBaseLCY := TotalAdjBaseLCY + AdjBaseLCY;
                    //                 TotalAdjAmount := TotalAdjAmount + AdjAmount;
                    //                 Window.UPDATE(4, TotalAdjAmount);

                    //                 IF TempEntryNoAmountBuf.Amount <> 0 THEN BEGIN
                    //                     TempDimSetEntry.RESET;
                    //                     TempDimSetEntry.DELETEALL;
                    //                     TempDimBuf.RESET;
                    //                     TempDimBuf.DELETEALL;
                    //                     TempDimBuf2.SETRANGE("Table ID", TempEntryNoAmountBuf."Entry No.");
                    //                     IF TempDimBuf2.FINDFIRST THEN
                    //                         DimBufMgt.GetDimensions(TempDimBuf2."Entry No.", TempDimBuf);
                    //                     DimMgt.CopyDimBufToDimSetEntry(TempDimBuf, TempDimSetEntry);
                    //                     IF TempEntryNoAmountBuf.Amount > 0 THEN
                    //                         PostAdjmt(
                    //                           Currency.GetRealizedGainsAccount, -TempEntryNoAmountBuf.Amount, TempEntryNoAmountBuf.Amount2,
                    //                           "Currency Code", TempDimSetEntry, PostingDate, '')
                    //                     ELSE
                    //                         PostAdjmt(
                    //                           Currency.GetRealizedLossesAccount, -TempEntryNoAmountBuf.Amount, TempEntryNoAmountBuf.Amount2,
                    //                           "Currency Code", TempDimSetEntry, PostingDate, '');
                    //                 END;
                    //             END;
                    //             //soft,sn
                    //         END ELSE
                    //             CurrReport.SKIP;
                    //     UNTIL BankAccPostingBuffer[1].NEXT(-1) = 0;
                    // BankAdjusted := TRUE;
                    // //soft,en
                    //XXX,end

                    TempDimBuf2.DELETEALL;
                end;

                trigger OnPreDataItem()
                begin
                    //soft,sn
                    IF NOT AdjCustVendBank THEN
                        CurrReport.BREAK;
                    //soft,en
                    SETRANGE("Date Filter", StartDate, EndDate);
                    TempDimBuf2.DELETEALL;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                "Last Date Adjusted" := PostingDate;
                MODIFY;

                "Currency Factor" :=
                  CurrExchRate.ExchangeRateAdjmt(PostingDate, Code);

                Currency2 := Currency;
                Currency2.INSERT;
            end;

            trigger OnPostDataItem()
            begin
                //soft,o IF (Code = '') AND AdjCustVendBank THEN
                IF (Code = '') AND (AdjCustVendBank OR AdjCustVendBank1 OR AdjCustVendBank2) THEN //soft,n
                    ERROR(Text011);
            end;

            trigger OnPreDataItem()
            begin
                CheckPostingDate;

                //soft,o IF NOT AdjCustVendBank THEN
                IF NOT (AdjCustVendBank OR AdjCustVendBank1 OR AdjCustVendBank2) THEN //soft,n
                    CurrReport.BREAK;

                Window.OPEN(
                  Text006 +
                  Text007 +
                  Text008 +
                  Text009 +
                  Text010);

                CustNoTotal := Customer.COUNT;
                VendNoTotal := Vendor.COUNT;
                COPYFILTER(Code, "Bank Account"."Currency Code");
                FILTERGROUP(2);
                "Bank Account".SETFILTER("Currency Code", '<>%1', '');
                FILTERGROUP(0);
                BankAccNoTotal := "Bank Account".COUNT;
                "Bank Account".RESET;
                //soft,sn
                CurrCode := Currency.GETFILTER(Currency.Code);
                IF CurrCode = '' THEN
                    CurrencyCodeSelected := Text31022891
                ELSE
                    CurrencyCodeSelected := CurrCode;
                //soft,en
            end;
        }
        dataitem(Customer; Customer)
        {
            DataItemTableView = SORTING ("No.");
            dataitem(CustomerLedgerEntryLoop; Integer)
            {
                DataItemTableView = SORTING (Number);
                column(Customer_No; Customer."No.")
                {
                }
                column(CustomerLedgerEntry_PostingDate; FORMAT(PostingDate))
                {
                }
                column(CustomerLedgerEntry_AccNo; AccNo)
                {
                }
                column(CustomerLedgerEntry_AccountName; AccountName)
                {
                }
                column(CustomerLedgerEntry_DocNo; DocNo)
                {
                }
                column(CustomerLedgerEntry_Currency_Code; CurrCode)
                {
                }
                column(CustomerLedgerEntry_Currency_CurrencyFactor; CurrencyFactor)
                {
                }
                column(CustomerLedgerEntry_AdjustBase; AdjustBase)
                {
                }
                column(CustomerLedgerEntry_AdjustBaseLCY; AdjustBaseLCY)
                {
                }
                column(CustomerLedgerEntry_NewBaseLCY; NewBaseLCY)
                {
                }
                column(CustomerLedgerEntry_AdjustedAmtLCY; AdjustedAmtLCY)
                {
                }
                column(CustomerLedgerEntry_AccType; AccType)
                {
                }
                dataitem("Detailed Cust. Ledg. Entry"; "Detailed Cust. Ledg. Entry")
                {
                    DataItemTableView = SORTING ("Cust. Ledger Entry No.", "Posting Date");
                    column(CustAdjusted; CustAdjusted)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        Detail := TRUE; //soft,n
                        AdjustCustomerLedgerEntry(CustLedgerEntry, "Posting Date");
                    end;

                    trigger OnPreDataItem()
                    begin
                        SETCURRENTKEY("Cust. Ledger Entry No.");
                        SETRANGE("Cust. Ledger Entry No.", CustLedgerEntry."Entry No.");
                        SETFILTER("Posting Date", '%1..', CALCDATE('<+1D>', PostingDate));
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    TempDtldCustLedgEntrySums.DELETEALL;

                    IF FirstEntry THEN BEGIN
                        TempCustLedgerEntry.FIND('-');
                        FirstEntry := FALSE
                    END ELSE
                        IF TempCustLedgerEntry.NEXT = 0 THEN
                            CurrReport.BREAK;
                    CustLedgerEntry.GET(TempCustLedgerEntry."Entry No.");
                    Detail := FALSE; //soft,n
                    AdjustCustomerLedgerEntry(CustLedgerEntry, PostingDate);
                end;

                trigger OnPreDataItem()
                begin
                    IF NOT TempCustLedgerEntry.FIND('-') THEN
                        CurrReport.BREAK;
                    FirstEntry := TRUE;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CustNo := CustNo + 1;
                Window.UPDATE(2, ROUND(CustNo / CustNoTotal * 10000, 1));

                TempCustLedgerEntry.DELETEALL;

                Currency.COPYFILTER(Code, CustLedgerEntry."Currency Code");
                CustLedgerEntry.FILTERGROUP(2);
                CustLedgerEntry.SETFILTER("Currency Code", '<>%1', '');
                CustLedgerEntry.FILTERGROUP(0);

                DtldCustLedgEntry.RESET;
                DtldCustLedgEntry.SETCURRENTKEY("Customer No.", "Posting Date", "Entry Type");
                DtldCustLedgEntry.SETRANGE("Customer No.", "No.");
                DtldCustLedgEntry.SETRANGE("Posting Date", CALCDATE('<+1D>', EndDate), DMY2DATE(31, 12, 9999));
                IF DtldCustLedgEntry.FIND('-') THEN
                    REPEAT
                        CustLedgerEntry."Entry No." := DtldCustLedgEntry."Cust. Ledger Entry No.";
                        IF CustLedgerEntry.FIND('=') THEN
                            IF (CustLedgerEntry."Posting Date" >= StartDate) AND
                               (CustLedgerEntry."Posting Date" <= EndDate)
                            THEN BEGIN
                                TempCustLedgerEntry."Entry No." := CustLedgerEntry."Entry No.";
                                IF TempCustLedgerEntry.INSERT THEN;
                            END;
                    UNTIL DtldCustLedgEntry.NEXT = 0;

                CustLedgerEntry.SETCURRENTKEY("Customer No.", Open);
                CustLedgerEntry.SETRANGE("Customer No.", "No.");
                CustLedgerEntry.SETRANGE(Open, TRUE);
                CustLedgerEntry.SETRANGE("Posting Date", 0D, EndDate);
                IF CustLedgerEntry.FIND('-') THEN
                    REPEAT
                        TempCustLedgerEntry."Entry No." := CustLedgerEntry."Entry No.";
                        IF TempCustLedgerEntry.INSERT THEN;
                    UNTIL CustLedgerEntry.NEXT = 0;
                CustLedgerEntry.RESET;
            end;

            trigger OnPostDataItem()
            begin
                IF CustNo <> 0 THEN
                    HandlePostAdjmt(1); // Customer
            end;

            trigger OnPreDataItem()
            begin
                //soft,o IF NOT AdjCustVendBank THEN
                IF NOT AdjCustVendBank1 THEN //soft,n
                    CurrReport.BREAK;

                DtldCustLedgEntry.LOCKTABLE;
                CustLedgerEntry.LOCKTABLE;

                CustNo := 0;

                IF DtldCustLedgEntry.FIND('+') THEN
                    NewEntryNo := DtldCustLedgEntry."Entry No." + 1
                ELSE
                    NewEntryNo := 1;

                CLEAR(DimMgt);
                TempEntryNoAmountBuf.DELETEALL;
            end;
        }
        dataitem(Vendor; Vendor)
        {
            DataItemTableView = SORTING ("No.");
            dataitem(VendorLedgerEntryLoop; Integer)
            {
                DataItemTableView = SORTING (Number);
                column(Vendor_No; Vendor."No.")
                {
                }
                column(VendorLedgerEntry_PostingDate; FORMAT(PostingDate))
                {
                }
                column(VendorLedgerEntry_AccNo; AccNo)
                {
                }
                column(VendorLedgerEntry_AccountName; AccountName)
                {
                }
                column(VendorLedgerEntry_DocNo; DocNo)
                {
                }
                column(VendorLedgerEntry_Currency_Code; CurrCode)
                {
                }
                column(VendorLedgerEntry_Currency_CurrencyFactor; CurrencyFactor)
                {
                }
                column(VendorLedgerEntry_AdjustBase; AdjustBase)
                {
                }
                column(VendorLedgerEntry_AdjustBaseLCY; AdjustBaseLCY)
                {
                }
                column(VendorLedgerEntry_NewBaseLCY; NewBaseLCY)
                {
                }
                column(VendorLedgerEntry_AdjustedAmtLCY; AdjustedAmtLCY)
                {
                }
                column(VendorLedgerEntry_AccType; AccType)
                {
                }
                dataitem("Detailed Vendor Ledg. Entry"; "Detailed Vendor Ledg. Entry")
                {
                    DataItemTableView = SORTING ("Vendor Ledger Entry No.", "Posting Date");
                    column(VendAdjusted; VendAdjusted)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        Detail := TRUE; //soft,n
                        AdjustVendorLedgerEntry(VendorLedgerEntry, "Posting Date");
                    end;

                    trigger OnPreDataItem()
                    begin
                        SETCURRENTKEY("Vendor Ledger Entry No.");
                        SETRANGE("Vendor Ledger Entry No.", VendorLedgerEntry."Entry No.");
                        SETFILTER("Posting Date", '%1..', CALCDATE('<+1D>', PostingDate));
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    TempDtldVendLedgEntrySums.DELETEALL;

                    IF FirstEntry THEN BEGIN
                        TempVendorLedgerEntry.FIND('-');
                        FirstEntry := FALSE
                    END ELSE
                        IF TempVendorLedgerEntry.NEXT = 0 THEN
                            CurrReport.BREAK;
                    VendorLedgerEntry.GET(TempVendorLedgerEntry."Entry No.");
                    Detail := FALSE; //soft,n
                    AdjustVendorLedgerEntry(VendorLedgerEntry, PostingDate);
                end;

                trigger OnPreDataItem()
                begin
                    IF NOT TempVendorLedgerEntry.FIND('-') THEN
                        CurrReport.BREAK;
                    FirstEntry := TRUE;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                VendNo := VendNo + 1;
                Window.UPDATE(3, ROUND(VendNo / VendNoTotal * 10000, 1));

                TempVendorLedgerEntry.DELETEALL;

                Currency.COPYFILTER(Code, VendorLedgerEntry."Currency Code");
                VendorLedgerEntry.FILTERGROUP(2);
                VendorLedgerEntry.SETFILTER("Currency Code", '<>%1', '');
                VendorLedgerEntry.FILTERGROUP(0);

                DtldVendLedgEntry.RESET;
                DtldVendLedgEntry.SETCURRENTKEY("Vendor No.", "Posting Date", "Entry Type");
                DtldVendLedgEntry.SETRANGE("Vendor No.", "No.");
                DtldVendLedgEntry.SETRANGE("Posting Date", CALCDATE('<+1D>', EndDate), DMY2DATE(31, 12, 9999));
                IF DtldVendLedgEntry.FIND('-') THEN
                    REPEAT
                        VendorLedgerEntry."Entry No." := DtldVendLedgEntry."Vendor Ledger Entry No.";
                        IF VendorLedgerEntry.FIND('=') THEN
                            IF (VendorLedgerEntry."Posting Date" >= StartDate) AND
                               (VendorLedgerEntry."Posting Date" <= EndDate)
                            THEN BEGIN
                                TempVendorLedgerEntry."Entry No." := VendorLedgerEntry."Entry No.";
                                IF TempVendorLedgerEntry.INSERT THEN;
                            END;
                    UNTIL DtldVendLedgEntry.NEXT = 0;

                VendorLedgerEntry.SETCURRENTKEY("Vendor No.", Open);
                VendorLedgerEntry.SETRANGE("Vendor No.", "No.");
                VendorLedgerEntry.SETRANGE(Open, TRUE);
                VendorLedgerEntry.SETRANGE("Posting Date", 0D, EndDate);
                IF VendorLedgerEntry.FIND('-') THEN
                    REPEAT
                        TempVendorLedgerEntry."Entry No." := VendorLedgerEntry."Entry No.";
                        IF TempVendorLedgerEntry.INSERT THEN;
                    UNTIL VendorLedgerEntry.NEXT = 0;
                VendorLedgerEntry.RESET;
            end;

            trigger OnPostDataItem()
            begin
                IF VendNo <> 0 THEN
                    HandlePostAdjmt(2); // Vendor
            end;

            trigger OnPreDataItem()
            begin
                //soft,o IF NOT AdjCustVendBank THEN
                IF NOT AdjCustVendBank2 THEN //soft,n
                    CurrReport.BREAK;

                DtldVendLedgEntry.LOCKTABLE;
                VendorLedgerEntry.LOCKTABLE;

                VendNo := 0;

                IF DtldVendLedgEntry.FIND('+') THEN
                    NewEntryNo := DtldVendLedgEntry."Entry No." + 1
                ELSE
                    NewEntryNo := 1;

                CLEAR(DimMgt);
                TempEntryNoAmountBuf.DELETEALL;
            end;
        }
        dataitem("VAT Posting Setup"; "VAT Posting Setup")
        {
            DataItemTableView = SORTING ("VAT Bus. Posting Group", "VAT Prod. Posting Group");

            trigger OnAfterGetRecord()
            begin
                VATEntryNo := VATEntryNo + 1;
                Window.UPDATE(1, ROUND(VATEntryNo / VATEntryNoTotal * 10000, 1));

                VATEntry.SETRANGE("VAT Bus. Posting Group", "VAT Bus. Posting Group");
                VATEntry.SETRANGE("VAT Prod. Posting Group", "VAT Prod. Posting Group");

                IF "VAT Calculation Type" <> "VAT Calculation Type"::"Sales Tax" THEN BEGIN
                    AdjustVATEntries(VATEntry.Type::Purchase, FALSE);
                    IF (VATEntry2.Amount <> 0) OR (VATEntry2."Additional-Currency Amount" <> 0) THEN BEGIN
                        AdjustVATAccount(
                          GetPurchAccount(FALSE),
                          VATEntry2.Amount, VATEntry2."Additional-Currency Amount",
                          VATEntryTotalBase.Amount, VATEntryTotalBase."Additional-Currency Amount");
                        IF "VAT Calculation Type" = "VAT Calculation Type"::"Reverse Charge VAT" THEN
                            AdjustVATAccount(
                              GetRevChargeAccount(FALSE),
                              -VATEntry2.Amount, -VATEntry2."Additional-Currency Amount",
                              -VATEntryTotalBase.Amount, -VATEntryTotalBase."Additional-Currency Amount");
                    END;
                    IF (VATEntry2."Remaining Unrealized Amount" <> 0) OR
                       (VATEntry2."Add.-Curr. Rem. Unreal. Amount" <> 0)
                    THEN BEGIN
                        TESTFIELD("Unrealized VAT Type");
                        AdjustVATAccount(
                          GetPurchAccount(TRUE),
                          VATEntry2."Remaining Unrealized Amount",
                          VATEntry2."Add.-Curr. Rem. Unreal. Amount",
                          VATEntryTotalBase."Remaining Unrealized Amount",
                          VATEntryTotalBase."Add.-Curr. Rem. Unreal. Amount");
                        IF "VAT Calculation Type" = "VAT Calculation Type"::"Reverse Charge VAT" THEN
                            AdjustVATAccount(
                              GetRevChargeAccount(TRUE),
                              -VATEntry2."Remaining Unrealized Amount",
                              -VATEntry2."Add.-Curr. Rem. Unreal. Amount",
                              -VATEntryTotalBase."Remaining Unrealized Amount",
                              -VATEntryTotalBase."Add.-Curr. Rem. Unreal. Amount");
                    END;

                    AdjustVATEntries(VATEntry.Type::Sale, FALSE);
                    IF (VATEntry2.Amount <> 0) OR (VATEntry2."Additional-Currency Amount" <> 0) THEN
                        AdjustVATAccount(
                          GetSalesAccount(FALSE),
                          VATEntry2.Amount, VATEntry2."Additional-Currency Amount",
                          VATEntryTotalBase.Amount, VATEntryTotalBase."Additional-Currency Amount");
                    IF (VATEntry2."Remaining Unrealized Amount" <> 0) OR
                       (VATEntry2."Add.-Curr. Rem. Unreal. Amount" <> 0)
                    THEN BEGIN
                        TESTFIELD("Unrealized VAT Type");
                        AdjustVATAccount(
                          GetSalesAccount(TRUE),
                          VATEntry2."Remaining Unrealized Amount",
                          VATEntry2."Add.-Curr. Rem. Unreal. Amount",
                          VATEntryTotalBase."Remaining Unrealized Amount",
                          VATEntryTotalBase."Add.-Curr. Rem. Unreal. Amount");
                    END;
                END ELSE BEGIN
                    IF TaxJurisdiction.FIND('-') THEN
                        REPEAT
                            VATEntry.SETRANGE("Tax Jurisdiction Code", TaxJurisdiction.Code);
                            AdjustVATEntries(VATEntry.Type::Purchase, FALSE);
                            AdjustPurchTax(FALSE);
                            AdjustVATEntries(VATEntry.Type::Purchase, TRUE);
                            AdjustPurchTax(TRUE);
                            AdjustVATEntries(VATEntry.Type::Sale, FALSE);
                            AdjustSalesTax;
                        UNTIL TaxJurisdiction.NEXT = 0;
                    VATEntry.SETRANGE("Tax Jurisdiction Code");
                END;
                CLEAR(VATEntryTotalBase);
            end;

            trigger OnPreDataItem()
            begin
                IF NOT AdjGLAcc OR
                   (GLSetup."VAT Exchange Rate Adjustment" = GLSetup."VAT Exchange Rate Adjustment"::"No Adjustment")
                THEN
                    CurrReport.BREAK;

                Window.OPEN(
                  Text012 +
                  Text013);

                VATEntryNoTotal := VATEntry.COUNT;
                IF NOT
                   VATEntry.SETCURRENTKEY(
                     Type, Closed, "VAT Bus. Posting Group", "VAT Prod. Posting Group", "Posting Date")
                THEN
                    VATEntry.SETCURRENTKEY(
                      Type, Closed, "Tax Jurisdiction Code", "Use Tax", "Posting Date");
                VATEntry.SETRANGE(Closed, FALSE);
                VATEntry.SETRANGE("Posting Date", StartDate, EndDate);
            end;
        }
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = SORTING ("No.")
                                WHERE ("Exchange Rate Adjustment" = FILTER ("Adjust Amount" .. "Adjust Additional-Currency Amount"));

            trigger OnAfterGetRecord()
            begin
                GLAccNo := GLAccNo + 1;
                Window.UPDATE(1, ROUND(GLAccNo / GLAccNoTotal * 10000, 1));
                IF "Exchange Rate Adjustment" = "Exchange Rate Adjustment"::"No Adjustment" THEN
                    CurrReport.SKIP;

                TempDimSetEntry.RESET;
                TempDimSetEntry.DELETEALL;
                CALCFIELDS("Net Change", "Additional-Currency Net Change");
                CASE "Exchange Rate Adjustment" OF
                    "Exchange Rate Adjustment"::"Adjust Amount":
                        PostGLAccAdjmt(
                          "No.", "Exchange Rate Adjustment"::"Adjust Amount",
                          ROUND(
                            CurrExchRate2.ExchangeAmtFCYToLCYAdjmt(
                              PostingDate, GLSetup."Additional Reporting Currency",
                              "Additional-Currency Net Change", AddCurrCurrencyFactor) -
                            "Net Change"),
                          "Net Change",
                          "Additional-Currency Net Change");
                    "Exchange Rate Adjustment"::"Adjust Additional-Currency Amount":
                        PostGLAccAdjmt(
                          "No.", "Exchange Rate Adjustment"::"Adjust Additional-Currency Amount",
                          ROUND(
                            CurrExchRate2.ExchangeAmtLCYToFCY(
                              PostingDate, GLSetup."Additional Reporting Currency",
                              "Net Change", AddCurrCurrencyFactor) -
                            "Additional-Currency Net Change",
                            Currency3."Amount Rounding Precision"),
                          "Net Change",
                          "Additional-Currency Net Change");
                END;
            end;

            trigger OnPostDataItem()
            begin
                IF AdjGLAcc THEN BEGIN
                    GenJnlLine."Document No." := PostingDocNo;
                    GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                    GenJnlLine."Posting Date" := PostingDate;
                    GenJnlLine."Source Code" := SourceCodeSetup."Exchange Rate Adjmt.";

                    IF GLAmtTotal <> 0 THEN BEGIN
                        IF GLAmtTotal < 0 THEN
                            GenJnlLine."Account No." := Currency3.GetRealizedGLLossesAccount
                        ELSE
                            GenJnlLine."Account No." := Currency3.GetRealizedGLGainsAccount;
                        GenJnlLine.Description :=
                          STRSUBSTNO(
                            PostingDescription,
                            GLSetup."Additional Reporting Currency",
                            GLAddCurrNetChangeTotal);
                        GenJnlLine."Additional-Currency Posting" := GenJnlLine."Additional-Currency Posting"::"Amount Only";
                        GenJnlLine."Currency Code" := '';
                        GenJnlLine.Amount := -GLAmtTotal;
                        GenJnlLine."Amount (LCY)" := -GLAmtTotal;
                        GetJnlLineDefDim(GenJnlLine, TempDimSetEntry);
                        PostGenJnlLine(GenJnlLine, TempDimSetEntry);
                    END;
                    IF GLAddCurrAmtTotal <> 0 THEN BEGIN
                        IF GLAddCurrAmtTotal < 0 THEN
                            GenJnlLine."Account No." := Currency3.GetRealizedGLLossesAccount
                        ELSE
                            GenJnlLine."Account No." := Currency3.GetRealizedGLGainsAccount;
                        GenJnlLine.Description :=
                          STRSUBSTNO(
                            PostingDescription, '',
                            GLNetChangeTotal);
                        GenJnlLine."Additional-Currency Posting" := GenJnlLine."Additional-Currency Posting"::"Additional-Currency Amount Only";
                        GenJnlLine."Currency Code" := GLSetup."Additional Reporting Currency";
                        GenJnlLine.Amount := -GLAddCurrAmtTotal;
                        GenJnlLine."Amount (LCY)" := 0;
                        GetJnlLineDefDim(GenJnlLine, TempDimSetEntry);
                        PostGenJnlLine(GenJnlLine, TempDimSetEntry);
                    END;

                    WITH ExchRateAdjReg DO BEGIN
                        "No." := "No." + 1;
                        "Creation Date" := PostingDate;
                        "Account Type" := "Account Type"::"G/L Account";
                        "Posting Group" := '';
                        "Currency Code" := GLSetup."Additional Reporting Currency";
                        "Currency Factor" := CurrExchRate2."Adjustment Exch. Rate Amount";
                        "Adjusted Base" := 0;
                        "Adjusted Base (LCY)" := GLNetChangeBase;
                        "Adjusted Amt. (LCY)" := GLAmtTotal;
                        "Adjusted Base (Add.-Curr.)" := GLAddCurrNetChangeBase;
                        "Adjusted Amt. (Add.-Curr.)" := GLAddCurrAmtTotal;
                        INSERT;
                    END;

                    TotalGLAccountsAdjusted += 1;
                END;
            end;

            trigger OnPreDataItem()
            begin
                IF NOT AdjGLAcc THEN
                    CurrReport.BREAK;

                Window.OPEN(
                  Text014 +
                  Text015);

                GLAccNoTotal := COUNT;
                SETRANGE("Date Filter", StartDate, EndDate);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    group("Adjustment Period")
                    {
                        Caption = 'Adjustment Period';
                        field(StartingDate; StartDate)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Starting Date';
                            ToolTip = 'Specifies the beginning of the period for which entries are adjusted. This field is usually left blank, but you can enter a date.';
                        }
                        field(EndingDate; EndDateReq)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Ending Date';
                            ToolTip = 'Specifies the last date for which entries are adjusted. This date is usually the same as the posting date in the Posting Date field.';

                            trigger OnValidate()
                            begin
                                PostingDate := EndDateReq;
                            end;
                        }
                    }
                    field(PostingDescription; PostingDescription)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posting Description';
                        ToolTip = 'Specifies text for the general ledger entries that are created by the batch job. The default text is Exchange Rate Adjmt. of %1 %2, in which %1 is replaced by the currency code and %2 is replaced by the currency amount that is adjusted. For example, Exchange Rate Adjmt. of DEM 38,000.';
                    }
                    field(PostingDate; PostingDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posting Date';
                        ToolTip = 'Specifies the date on which the general ledger entries are posted. This date is usually the same as the ending date in the Ending Date field.';

                        trigger OnValidate()
                        begin
                            CheckPostingDate;
                        end;
                    }
                    field(DocumentNo; PostingDocNo)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Document No.';
                        ToolTip = 'Specifies the document number that will appear on the general ledger entries that are created by the batch job.';
                    }
                    field(AdjCustVendBank; AdjCustVendBank)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Bank Accounts';
                        MultiLine = true;
                        ToolTip = 'Specifies if you want to adjust customer, vendor, and bank accounts for currency fluctuations.';
                    }
                    field(AdjCustVendBank1; AdjCustVendBank1)
                    {
                        Caption = 'Adjust Customer';
                    }
                    field(AdjCustVendBank2; AdjCustVendBank2)
                    {
                        Caption = 'Adjust Vendor';
                    }
                    field(AdjGLAcc; AdjGLAcc)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Adjust G/L Accounts for Add.-Reporting Currency';
                        MultiLine = true;
                        ToolTip = 'Specifies if you want to post in an additional reporting currency and adjust general ledger accounts for currency fluctuations between LCY and the additional reporting currency.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            IF PostingDescription = '' THEN
                PostingDescription := Text016;
            //soft,so
            //IF NOT (AdjCustVendBank OR AdjGLAcc) THEN
            //  AdjCustVendBank := TRUE;
            //soft,eo
            //soft,sn
            IF NOT ((AdjCustVendBank OR AdjCustVendBank1 OR AdjCustVendBank2) OR AdjGLAcc) THEN BEGIN
                AdjCustVendBank := TRUE;
                AdjCustVendBank1 := TRUE;
                AdjCustVendBank2 := TRUE;
            END;
            //soft,en
        end;
    }

    labels
    {
        PageCaptionLbl = 'Page';
        ToCaptionLbl = ' to ';
        CurrencyCodeCaptionLbl = 'Currency Code';
        CurrencyFactorCaptionLbl = 'Currency Factor';
        PostingDateCaptionLbl = 'Posting Date';
        AccountNoCaptionLbl = 'Account No.';
        NameCaptionLbl = 'Name';
        DocNoCaptionLbl = 'Document No.';
        AdjustedBaseCaptionLbl = 'Adjusted Base';
        AdjustedBaseLCYCaptionLbl = 'Adjusted Base (LCY)';
        NewBaseLCYCaptionLbl = 'New Base (LCY)';
        AdjustedAmtLCYCaptionLbl = 'Adjusted Amt. (LCY)';
        AccountTypeCaptionLbl = 'Account Type: Bank Account';
        AccountType1CaptionLbl = 'Account Type: Customer';
        AccountType2CaptionLbl = 'Account Type: Vendor';
    }

    trigger OnInitReport()
    var
        IsHandled: Boolean;
    begin
        IsHandled := FALSE;
        OnBeforeOnInitReport(IsHandled);
        IF IsHandled THEN
            EXIT;
    end;

    trigger OnPostReport()
    begin
        UpdateAnalysisView.UpdateAll(0, TRUE);

        IF TotalCustomersAdjusted + TotalVendorsAdjusted + TotalBankAccountsAdjusted + TotalGLAccountsAdjusted < 1 THEN
            MESSAGE(NothingToAdjustMsg)
        ELSE
            MESSAGE(RatesAdjustedMsg);
    end;

    trigger OnPreReport()
    begin
        IF EndDateReq = 0D THEN
            EndDate := DMY2DATE(31, 12, 9999)
        ELSE
            EndDate := EndDateReq;
        IF PostingDocNo = '' THEN
            ERROR(Text000, GenJnlLine.FIELDCAPTION("Document No."));


        //soft,o IF NOT AdjCustVendBank AND AdjGLAcc THEN
        IF NOT (AdjCustVendBank OR AdjCustVendBank1 OR AdjCustVendBank2) AND AdjGLAcc THEN //soft,n
            IF NOT CONFIRM(Text001 + Text004, FALSE) THEN
                ERROR(Text005);

        SourceCodeSetup.GET;

        IF ExchRateAdjReg.FINDLAST THEN
            ExchRateAdjReg.INIT;

        GLSetup.GET;

        IF AdjGLAcc THEN BEGIN
            GLSetup.TESTFIELD("Additional Reporting Currency");

            Currency3.GET(GLSetup."Additional Reporting Currency");
            "G/L Account".GET(Currency3.GetRealizedGLGainsAccount);
            "G/L Account".TESTFIELD("Exchange Rate Adjustment", "G/L Account"."Exchange Rate Adjustment"::"No Adjustment");

            "G/L Account".GET(Currency3.GetRealizedGLLossesAccount);
            "G/L Account".TESTFIELD("Exchange Rate Adjustment", "G/L Account"."Exchange Rate Adjustment"::"No Adjustment");

            WITH VATPostingSetup2 DO
                IF FIND('-') THEN
                    REPEAT
                        IF "VAT Calculation Type" <> "VAT Calculation Type"::"Sales Tax" THEN BEGIN
                            CheckExchRateAdjustment(
                              "Purchase VAT Account", TABLECAPTION, FIELDCAPTION("Purchase VAT Account"));
                            CheckExchRateAdjustment(
                              "Reverse Chrg. VAT Acc.", TABLECAPTION, FIELDCAPTION("Reverse Chrg. VAT Acc."));
                            CheckExchRateAdjustment(
                              "Purch. VAT Unreal. Account", TABLECAPTION, FIELDCAPTION("Purch. VAT Unreal. Account"));
                            CheckExchRateAdjustment(
                              "Reverse Chrg. VAT Unreal. Acc.", TABLECAPTION, FIELDCAPTION("Reverse Chrg. VAT Unreal. Acc."));
                            CheckExchRateAdjustment(
                              "Sales VAT Account", TABLECAPTION, FIELDCAPTION("Sales VAT Account"));
                            CheckExchRateAdjustment(
                              "Sales VAT Unreal. Account", TABLECAPTION, FIELDCAPTION("Sales VAT Unreal. Account"));
                        END;
                    UNTIL NEXT = 0;

            WITH TaxJurisdiction2 DO
                IF FIND('-') THEN
                    REPEAT
                        CheckExchRateAdjustment(
                          "Tax Account (Purchases)", TABLECAPTION, FIELDCAPTION("Tax Account (Purchases)"));
                        CheckExchRateAdjustment(
                          "Reverse Charge (Purchases)", TABLECAPTION, FIELDCAPTION("Reverse Charge (Purchases)"));
                        CheckExchRateAdjustment(
                          "Unreal. Tax Acc. (Purchases)", TABLECAPTION, FIELDCAPTION("Unreal. Tax Acc. (Purchases)"));
                        CheckExchRateAdjustment(
                          "Unreal. Rev. Charge (Purch.)", TABLECAPTION, FIELDCAPTION("Unreal. Rev. Charge (Purch.)"));
                        CheckExchRateAdjustment(
                          "Tax Account (Sales)", TABLECAPTION, FIELDCAPTION("Tax Account (Sales)"));
                        CheckExchRateAdjustment(
                          "Unreal. Tax Acc. (Sales)", TABLECAPTION, FIELDCAPTION("Unreal. Tax Acc. (Sales)"));
                    UNTIL NEXT = 0;

            AddCurrCurrencyFactor :=
              CurrExchRate2.ExchangeRateAdjmt(PostingDate, GLSetup."Additional Reporting Currency");
        END;
        BankAdjusted := FALSE; //soft,n
    end;

    var
        Text000: Label '%1 must be entered.';
        Text001: Label 'Do you want to adjust general ledger entries for currency fluctuations without adjusting customer, vendor and bank ledger entries? This may result in incorrect currency adjustments to payables, receivables and bank accounts.\\ ';
        Text004: Label 'Do you wish to continue?';
        Text005: Label 'The adjustment of exchange rates has been canceled.';
        Text006: Label 'Adjusting exchange rates...\\';
        Text007: Label 'Bank Account    @1@@@@@@@@@@@@@\\';
        Text008: Label 'Customer        @2@@@@@@@@@@@@@\';
        Text009: Label 'Vendor          @3@@@@@@@@@@@@@\';
        Text010: Label 'Adjustment      #4#############';
        Text011: Label 'No currencies have been found.';
        Text012: Label 'Adjusting VAT Entries...\\';
        Text013: Label 'VAT Entry    @1@@@@@@@@@@@@@';
        Text014: Label 'Adjusting general ledger...\\';
        Text015: Label 'G/L Account    @1@@@@@@@@@@@@@';
        Text016: Label 'Adjmt. of %1 %2, Ex.Rate Adjust.', Comment = '%1 = Currency Code, %2= Adjust Amount';
        Text017: Label '%1 on %2 %3 must be %4. When this %2 is used in %5, the exchange rate adjustment is defined in the %6 field in the %7. %2 %3 is used in the %8 field in the %5. ';
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        TempDtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry" temporary;
        TempDtldCustLedgEntrySums: Record "Detailed Cust. Ledg. Entry" temporary;
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        TempDtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry" temporary;
        TempDtldVendLedgEntrySums: Record "Detailed Vendor Ledg. Entry" temporary;
        ExchRateAdjReg: Record "Exch. Rate Adjmt. Reg.";
        CustPostingGr: Record "Customer Posting Group";
        VendPostingGr: Record "Vendor Posting Group";
        GenJnlLine: Record "Gen. Journal Line";
        SourceCodeSetup: Record "Source Code Setup";
        AdjExchRateBuffer: Record "Adjust Exchange Rate Buffer" temporary;
        AdjExchRateBuffer2: Record "Adjust Exchange Rate Buffer" temporary;
        Currency2: Record Currency temporary;
        Currency3: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        CurrExchRate2: Record "Currency Exchange Rate";
        GLSetup: Record "General Ledger Setup";
        VATEntry: Record "VAT Entry";
        VATEntry2: Record "Vat Entry";
        VATEntryTotalBase: Record "VAT Entry";
        TaxJurisdiction: Record "Tax Jurisdiction";
        VATPostingSetup2: Record "VAT Posting Setup";
        TaxJurisdiction2: Record "Tax Jurisdiction";
        TempDimBuf: Record "Dimension Buffer" temporary;
        TempDimBuf2: Record "Dimension Buffer" temporary;
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        TempEntryNoAmountBuf: Record "Entry No. Amount Buffer" temporary;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        TempCustLedgerEntry: Record "Cust. Ledger Entry" temporary;
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        TempVendorLedgerEntry: Record "Vendor Ledger Entry" temporary;
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        UpdateAnalysisView: Codeunit "Update Analysis View";
        DimMgt: Codeunit DimensionManagement;
        DimBufMgt: Codeunit "Dimension Buffer Management";
        Window: Dialog;
        TotalAdjBase: Decimal;
        TotalAdjBaseLCY: Decimal;
        TotalAdjAmount: Decimal;
        GainsAmount: Decimal;
        LossesAmount: Decimal;
        PostingDate: Date;
        PostingDescription: Text[50];
        AdjBase: Decimal;
        AdjBaseLCY: Decimal;
        AdjAmount: Decimal;
        CustNo: Decimal;
        CustNoTotal: Decimal;
        VendNo: Decimal;
        VendNoTotal: Decimal;
        BankAccNo: Decimal;
        BankAccNoTotal: Decimal;
        GLAccNo: Decimal;
        GLAccNoTotal: Decimal;
        GLAmtTotal: Decimal;
        GLAddCurrAmtTotal: Decimal;
        GLNetChangeTotal: Decimal;
        GLAddCurrNetChangeTotal: Decimal;
        GLNetChangeBase: Decimal;
        GLAddCurrNetChangeBase: Decimal;
        PostingDocNo: Code[20];
        StartDate: Date;
        EndDate: Date;
        EndDateReq: Date;
        Correction: Boolean;
        OK: Boolean;
        AdjCustVendBank: Boolean;
        AdjGLAcc: Boolean;
        AddCurrCurrencyFactor: Decimal;
        VATEntryNoTotal: Decimal;
        VATEntryNo: Decimal;
        NewEntryNo: Integer;
        Text018: Label 'This posting date cannot be entered because it does not occur within the adjustment period. Reenter the posting date.';
        FirstEntry: Boolean;
        MaxAdjExchRateBufIndex: Integer;
        RatesAdjustedMsg: Label 'One or more currency exchange rates have been adjusted';
        NothingToAdjustMsg: Label 'There is nothing to adjust';
        TotalBankAccountsAdjusted: Integer;
        TotalCustomersAdjusted: Integer;
        TotalVendorsAdjusted: Integer;
        TotalGLAccountsAdjusted: Integer;
        //XXX ClosedDoc: Record "31022937";
        //XXX Doc: Record "31022935";
        //XXX PostedDoc: Record "31022936";
        DtldCustLedgEntry2: Record "Detailed Cust. Ledg. Entry";
        DtldVendLedgEntry2: Record "Detailed Vendor Ledg. Entry";
        //XXX BankAccPostingBuffer: array [2] of Record "31022929" temporary;
        //XXX CarteraManagement: Codeunit "31022901";
        AdjCustVendBank1: Boolean;
        AdjCustVendBank2: Boolean;
        BankAdjusted: Boolean;
        CustAdjusted: Boolean;
        VendAdjusted: Boolean;
        CurrencyCodeSelected: Code[100];
        CurrCode: Code[100];
        DocNo: Code[20];
        AccNo: Code[20];
        AdjustBase: Decimal;
        AdjustBaseLCY: Decimal;
        NewBaseLCY: Decimal;
        AdjustedAmtLCY: Decimal;
        CurrencyFactor: Decimal;
        AccType: Option "G/L Account",Customer,Vendor,"Bank Account";
        AccountName: Text[50];
        ReportNameCaptionLbl: Label 'Exchange Rate Adjustment';
        Detail: Boolean;
        CurrencyFilters: Text;
        Text31022890: Label 'Adjustment Period: ';
        Text31022891: Label 'ALL';

    local procedure PostAdjmt(GLAccNo: Code[20]; PostingAmount: Decimal; AdjBase2: Decimal; CurrencyCode2: Code[10]; var DimSetEntry: Record "Dimension Set Entry"; PostingDate2: Date; ICCode: Code[20]) TransactionNo: Integer
    var
    begin
        WITH GenJnlLine DO
            IF PostingAmount <> 0 THEN BEGIN
                INIT;
                VALIDATE("Posting Date", PostingDate2);
                "Document No." := PostingDocNo;
                GenJnlLine.
                "Account Type" := "Account Type"::"G/L Account";
                VALIDATE("Account No.", GLAccNo);
                Description := PADSTR(STRSUBSTNO(PostingDescription, CurrencyCode2, AdjBase2), STRLEN(PostingDescription));
                VALIDATE(Amount, PostingAmount);
                "Source Currency Code" := CurrencyCode2;
                "IC Partner Code" := ICCode;
                IF CurrencyCode2 = GLSetup."Additional Reporting Currency" THEN
                    "Source Currency Amount" := 0;
                "Source Code" := SourceCodeSetup."Exchange Rate Adjmt.";
                "System-Created Entry" := TRUE;
                TransactionNo := PostGenJnlLine(GenJnlLine, DimSetEntry);
            END;
    end;

    local procedure InsertExchRateAdjmtReg(AdjustAccType: Integer; PostingGrCode: Code[20]; CurrencyCode: Code[10])
    begin
        IF Currency2.Code <> CurrencyCode THEN
            Currency2.GET(CurrencyCode);

        WITH ExchRateAdjReg DO BEGIN
            "No." := "No." + 1;
            "Creation Date" := PostingDate;
            "Account Type" := AdjustAccType;
            "Posting Group" := PostingGrCode;
            "Currency Code" := Currency2.Code;
            "Currency Factor" := Currency2."Currency Factor";
            "Adjusted Base" := AdjExchRateBuffer.AdjBase;
            "Adjusted Base (LCY)" := AdjExchRateBuffer.AdjBaseLCY;
            "Adjusted Amt. (LCY)" := AdjExchRateBuffer.AdjAmount;
            INSERT;
            //soft,sn
            CASE "Account Type" OF
                1:
                    CustAdjusted := TRUE;
                2:
                    VendAdjusted := TRUE;
            END;
            AccType := "Account Type";
            //soft,en
        END;
    end;

    [Scope('Personalization')]
    procedure InitializeRequest(NewStartDate: Date; NewEndDate: Date; NewPostingDescription: Text[50]; NewPostingDate: Date)
    begin
        StartDate := NewStartDate;
        EndDate := NewEndDate;
        PostingDescription := NewPostingDescription;
        PostingDate := NewPostingDate;
        IF EndDate = 0D THEN
            EndDateReq := DMY2DATE(31, 12, 9999)
        ELSE
            EndDateReq := EndDate;
    end;

    [Scope('Personalization')]
    procedure InitializeRequest2(NewStartDate: Date; NewEndDate: Date; NewPostingDescription: Text[50]; NewPostingDate: Date; NewPostingDocNo: Code[20]; NewAdjCustVendBank: Boolean; NewAdjGLAcc: Boolean)
    begin
        InitializeRequest(NewStartDate, NewEndDate, NewPostingDescription, NewPostingDate);
        PostingDocNo := NewPostingDocNo;
        AdjCustVendBank := NewAdjCustVendBank;
        AdjGLAcc := NewAdjGLAcc;
    end;

    local procedure AdjExchRateBufferUpdate(CurrencyCode2: Code[10]; PostingGroup2: Code[20]; AdjBase2: Decimal; AdjBaseLCY2: Decimal; AdjAmount2: Decimal; GainsAmount2: Decimal; LossesAmount2: Decimal; DimEntryNo: Integer; Postingdate2: Date; ICCode: Code[20]; AccNo: Code[20]; EntNo: Code[20]): Integer
    begin
        AdjExchRateBuffer.INIT;

        //soft,o OK := AdjExchRateBuffer.GET(CurrencyCode2,PostingGroup2,DimEntryNo,Postingdate2,ICCode);
        OK := AdjExchRateBuffer.GET(CurrencyCode2, PostingGroup2, DimEntryNo, Postingdate2, ICCode, EntNo, AccNo); //soft,n


        AdjExchRateBuffer.AdjBase := AdjExchRateBuffer.AdjBase + AdjBase2;
        AdjExchRateBuffer.AdjBaseLCY := AdjExchRateBuffer.AdjBaseLCY + AdjBaseLCY2;
        AdjExchRateBuffer.AdjAmount := AdjExchRateBuffer.AdjAmount + AdjAmount2;
        AdjExchRateBuffer.TotalGainsAmount := AdjExchRateBuffer.TotalGainsAmount + GainsAmount2;
        AdjExchRateBuffer.TotalLossesAmount := AdjExchRateBuffer.TotalLossesAmount + LossesAmount2;

        IF NOT OK THEN BEGIN
            AdjExchRateBuffer."Currency Code" := CurrencyCode2;
            AdjExchRateBuffer."Posting Group" := PostingGroup2;
            //soft,sn
            AdjExchRateBuffer."PTSS Account No." := AccNo;
            AdjExchRateBuffer."PTSS No." := EntNo;
            //soft,en
            AdjExchRateBuffer."Dimension Entry No." := DimEntryNo;
            AdjExchRateBuffer."Posting Date" := Postingdate2;
            AdjExchRateBuffer."IC Partner Code" := ICCode;
            MaxAdjExchRateBufIndex += 1;
            AdjExchRateBuffer.Index := MaxAdjExchRateBufIndex;
            AdjExchRateBuffer.INSERT;
        END ELSE
            AdjExchRateBuffer.MODIFY;

        EXIT(AdjExchRateBuffer.Index);
    end;

    local procedure HandlePostAdjmt(AdjustAccType: Integer)
    var
        GLEntry: Record "G/L Entry";
        TempDtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer" temporary;
    begin
        IF AdjExchRateBuffer.FIND('-') THEN BEGIN
            // Summarize per currency and dimension combination
            REPEAT
                AdjExchRateBuffer2.INIT;
                OK :=
                  AdjExchRateBuffer2.GET(
                    AdjExchRateBuffer."Currency Code",
                    '',
                    AdjExchRateBuffer."Dimension Entry No.",
                    AdjExchRateBuffer."Posting Date",
                    AdjExchRateBuffer."IC Partner Code");
                AdjExchRateBuffer2.AdjBase := AdjExchRateBuffer2.AdjBase + AdjExchRateBuffer.AdjBase;
                AdjExchRateBuffer2.TotalGainsAmount := AdjExchRateBuffer2.TotalGainsAmount + AdjExchRateBuffer.TotalGainsAmount;
                AdjExchRateBuffer2.TotalLossesAmount := AdjExchRateBuffer2.TotalLossesAmount + AdjExchRateBuffer.TotalLossesAmount;
                IF NOT OK THEN BEGIN
                    AdjExchRateBuffer2."Currency Code" := AdjExchRateBuffer."Currency Code";
                    AdjExchRateBuffer2."Dimension Entry No." := AdjExchRateBuffer."Dimension Entry No.";
                    AdjExchRateBuffer2."Posting Date" := AdjExchRateBuffer."Posting Date";
                    AdjExchRateBuffer2."IC Partner Code" := AdjExchRateBuffer."IC Partner Code";
                    AdjExchRateBuffer2.INSERT;
                END ELSE
                    AdjExchRateBuffer2.MODIFY;
            UNTIL AdjExchRateBuffer.NEXT = 0;

            // Post per posting group and per currency
            IF AdjExchRateBuffer2.FIND('-') THEN
                REPEAT
                    WITH AdjExchRateBuffer DO BEGIN
                        SETRANGE("Currency Code", AdjExchRateBuffer2."Currency Code");
                        SETRANGE("Dimension Entry No.", AdjExchRateBuffer2."Dimension Entry No.");
                        SETRANGE("Posting Date", AdjExchRateBuffer2."Posting Date");
                        SETRANGE("IC Partner Code", AdjExchRateBuffer2."IC Partner Code");
                        TempDimBuf.RESET;
                        TempDimBuf.DELETEALL;
                        TempDimSetEntry.RESET;
                        TempDimSetEntry.DELETEALL;
                        FIND('-');
                        DimBufMgt.GetDimensions("Dimension Entry No.", TempDimBuf);
                        DimMgt.CopyDimBufToDimSetEntry(TempDimBuf, TempDimSetEntry);
                        REPEAT
                            TempDtldCVLedgEntryBuf.INIT;
                            TempDtldCVLedgEntryBuf."Entry No." := Index;
                            IF AdjAmount <> 0 THEN
                                CASE AdjustAccType OF
                                    1: // Customer
                                        BEGIN
                                            CustPostingGr.GET("Posting Group");
                                            TempDtldCVLedgEntryBuf."Transaction No." :=
                                            //soft,so
                                            //  PostAdjmt(
                                            //    CustPostingGr.GetReceivablesAccount,AdjAmount,AdjBase,"Currency Code",TempDimSetEntry,
                                            //    AdjExchRateBuffer2."Posting Date","IC Partner Code");
                                            //soft,eo
                                            //soft,sn
                                            PostAdjmt(
                                              "PTSS Account No.", AdjAmount, AdjBase, "Currency Code", TempDimSetEntry,
                                              AdjExchRateBuffer2."Posting Date", "IC Partner Code");
                                            //soft,en
                                            IF TempDtldCVLedgEntryBuf.INSERT THEN;
                                            InsertExchRateAdjmtReg(1, "Posting Group", "Currency Code");
                                            TotalCustomersAdjusted += 1;
                                        END;
                                    2: // Vendor
                                        BEGIN
                                            //soft,so
                                            VendPostingGr.GET("Posting Group");
                                            TempDtldCVLedgEntryBuf."Transaction No." :=
                                             //soft,so
                                             //PostAdjmt(
                                             //  VendPostingGr.GetPayablesAccount,AdjAmount,AdjBase,"Currency Code",TempDimSetEntry,
                                             //  AdjExchRateBuffer2."Posting Date","IC Partner Code");
                                             //soft,eo
                                             //soft,sn
                                             PostAdjmt(
                                               "PTSS Account No.", AdjAmount, AdjBase, "Currency Code", TempDimSetEntry,
                                                AdjExchRateBuffer2."Posting Date", AdjExchRateBuffer."IC Partner Code");
                                            //soft,en
                                            IF TempDtldCVLedgEntryBuf.INSERT THEN;
                                            InsertExchRateAdjmtReg(2, "Posting Group", "Currency Code");
                                            TotalVendorsAdjusted += 1;
                                        END;
                                END;
                        UNTIL NEXT = 0;
                    END;

                    WITH AdjExchRateBuffer2 DO BEGIN
                        Currency2.GET("Currency Code");
                        IF TotalGainsAmount <> 0 THEN
                            PostAdjmt(
                              Currency2.GetUnrealizedGainsAccount, -TotalGainsAmount, AdjBase, "Currency Code", TempDimSetEntry,
                              //soft,o"Posting Date","IC Partner Code");
                              AdjExchRateBuffer2."Posting Date", "IC Partner Code"); //soft,n
                        IF TotalLossesAmount <> 0 THEN
                            PostAdjmt(
                              Currency2.GetUnrealizedLossesAccount, -TotalLossesAmount, AdjBase, "Currency Code", TempDimSetEntry,
                              //soft,o "Posting Date","IC Partner Code");
                              AdjExchRateBuffer2."Posting Date", "IC Partner Code"); //soft,n
                    END;
                UNTIL AdjExchRateBuffer2.NEXT = 0;

            GLEntry.FINDLAST;
            CASE AdjustAccType OF
                1: // Customer
                    IF TempDtldCustLedgEntry.FIND('-') THEN
                        REPEAT
                            IF TempDtldCVLedgEntryBuf.GET(TempDtldCustLedgEntry."Transaction No.") THEN
                                TempDtldCustLedgEntry."Transaction No." := TempDtldCVLedgEntryBuf."Transaction No."
                            ELSE
                                TempDtldCustLedgEntry."Transaction No." := GLEntry."Transaction No.";
                            DtldCustLedgEntry := TempDtldCustLedgEntry;
                            DtldCustLedgEntry.INSERT(TRUE);
                        UNTIL TempDtldCustLedgEntry.NEXT = 0;
                2: // Vendor
                    IF TempDtldVendLedgEntry.FIND('-') THEN
                        REPEAT
                            IF TempDtldCVLedgEntryBuf.GET(TempDtldVendLedgEntry."Transaction No.") THEN
                                TempDtldVendLedgEntry."Transaction No." := TempDtldCVLedgEntryBuf."Transaction No."
                            ELSE
                                TempDtldVendLedgEntry."Transaction No." := GLEntry."Transaction No.";
                            DtldVendLedgEntry := TempDtldVendLedgEntry;
                            DtldVendLedgEntry.INSERT(TRUE);
                        UNTIL TempDtldVendLedgEntry.NEXT = 0;
            END;

            AdjExchRateBuffer.RESET;
            AdjExchRateBuffer.DELETEALL;
            AdjExchRateBuffer2.RESET;
            AdjExchRateBuffer2.DELETEALL;
            TempDtldCustLedgEntry.RESET;
            TempDtldCustLedgEntry.DELETEALL;
            TempDtldVendLedgEntry.RESET;
            TempDtldVendLedgEntry.DELETEALL;
        END;
    end;

    local procedure AdjustVATEntries(VATType: Integer; UseTax: Boolean)
    begin
        CLEAR(VATEntry2);
        WITH VATEntry DO BEGIN
            SETRANGE(Type, VATType);
            SETRANGE("Use Tax", UseTax);
            IF FIND('-') THEN
                REPEAT
                    Accumulate(VATEntry2.Base, Base);
                    Accumulate(VATEntry2.Amount, Amount);
                    Accumulate(VATEntry2."Unrealized Amount", "Unrealized Amount");
                    Accumulate(VATEntry2."Unrealized Base", "Unrealized Base");
                    Accumulate(VATEntry2."Remaining Unrealized Amount", "Remaining Unrealized Amount");
                    Accumulate(VATEntry2."Remaining Unrealized Base", "Remaining Unrealized Base");
                    Accumulate(VATEntry2."Additional-Currency Amount", "Additional-Currency Amount");
                    Accumulate(VATEntry2."Additional-Currency Base", "Additional-Currency Base");
                    Accumulate(VATEntry2."Add.-Currency Unrealized Amt.", "Add.-Currency Unrealized Amt.");
                    Accumulate(VATEntry2."Add.-Currency Unrealized Base", "Add.-Currency Unrealized Base");
                    Accumulate(VATEntry2."Add.-Curr. Rem. Unreal. Amount", "Add.-Curr. Rem. Unreal. Amount");
                    Accumulate(VATEntry2."Add.-Curr. Rem. Unreal. Base", "Add.-Curr. Rem. Unreal. Base");

                    Accumulate(VATEntryTotalBase.Base, Base);
                    Accumulate(VATEntryTotalBase.Amount, Amount);
                    Accumulate(VATEntryTotalBase."Unrealized Amount", "Unrealized Amount");
                    Accumulate(VATEntryTotalBase."Unrealized Base", "Unrealized Base");
                    Accumulate(VATEntryTotalBase."Remaining Unrealized Amount", "Remaining Unrealized Amount");
                    Accumulate(VATEntryTotalBase."Remaining Unrealized Base", "Remaining Unrealized Base");
                    Accumulate(VATEntryTotalBase."Additional-Currency Amount", "Additional-Currency Amount");
                    Accumulate(VATEntryTotalBase."Additional-Currency Base", "Additional-Currency Base");
                    Accumulate(VATEntryTotalBase."Add.-Currency Unrealized Amt.", "Add.-Currency Unrealized Amt.");
                    Accumulate(VATEntryTotalBase."Add.-Currency Unrealized Base", "Add.-Currency Unrealized Base");
                    Accumulate(
                      VATEntryTotalBase."Add.-Curr. Rem. Unreal. Amount", "Add.-Curr. Rem. Unreal. Amount");
                    Accumulate(VATEntryTotalBase."Add.-Curr. Rem. Unreal. Base", "Add.-Curr. Rem. Unreal. Base");

                    AdjustVATAmount(Base, "Additional-Currency Base");
                    AdjustVATAmount(Amount, "Additional-Currency Amount");
                    AdjustVATAmount("Unrealized Amount", "Add.-Currency Unrealized Amt.");
                    AdjustVATAmount("Unrealized Base", "Add.-Currency Unrealized Base");
                    AdjustVATAmount("Remaining Unrealized Amount", "Add.-Curr. Rem. Unreal. Amount");
                    AdjustVATAmount("Remaining Unrealized Base", "Add.-Curr. Rem. Unreal. Base");
                    MODIFY;

                    Accumulate(VATEntry2.Base, -Base);
                    Accumulate(VATEntry2.Amount, -Amount);
                    Accumulate(VATEntry2."Unrealized Amount", -"Unrealized Amount");
                    Accumulate(VATEntry2."Unrealized Base", -"Unrealized Base");
                    Accumulate(VATEntry2."Remaining Unrealized Amount", -"Remaining Unrealized Amount");
                    Accumulate(VATEntry2."Remaining Unrealized Base", -"Remaining Unrealized Base");
                    Accumulate(VATEntry2."Additional-Currency Amount", -"Additional-Currency Amount");
                    Accumulate(VATEntry2."Additional-Currency Base", -"Additional-Currency Base");
                    Accumulate(VATEntry2."Add.-Currency Unrealized Amt.", -"Add.-Currency Unrealized Amt.");
                    Accumulate(VATEntry2."Add.-Currency Unrealized Base", -"Add.-Currency Unrealized Base");
                    Accumulate(VATEntry2."Add.-Curr. Rem. Unreal. Amount", -"Add.-Curr. Rem. Unreal. Amount");
                    Accumulate(VATEntry2."Add.-Curr. Rem. Unreal. Base", -"Add.-Curr. Rem. Unreal. Base");
                UNTIL NEXT = 0;
        END;
    end;

    local procedure AdjustVATAmount(var AmountLCY: Decimal; var AmountAddCurr: Decimal)
    begin
        CASE GLSetup."VAT Exchange Rate Adjustment" OF
            GLSetup."VAT Exchange Rate Adjustment"::"Adjust Amount":
                AmountLCY :=
                  ROUND(
                    CurrExchRate2.ExchangeAmtFCYToLCYAdjmt(
                      PostingDate, GLSetup."Additional Reporting Currency",
                      AmountAddCurr, AddCurrCurrencyFactor));
            GLSetup."VAT Exchange Rate Adjustment"::"Adjust Additional-Currency Amount":
                AmountAddCurr :=
                  ROUND(
                    CurrExchRate2.ExchangeAmtLCYToFCY(
                      PostingDate, GLSetup."Additional Reporting Currency",
                      AmountLCY, AddCurrCurrencyFactor));
        END;
    end;

    local procedure AdjustVATAccount(AccNo: Code[20]; AmountLCY: Decimal; AmountAddCurr: Decimal; BaseLCY: Decimal; BaseAddCurr: Decimal)
    begin
        "G/L Account".GET(AccNo);
        "G/L Account".SETRANGE("Date Filter", StartDate, EndDate);
        CASE GLSetup."VAT Exchange Rate Adjustment" OF
            GLSetup."VAT Exchange Rate Adjustment"::"Adjust Amount":
                PostGLAccAdjmt(
                  AccNo, GLSetup."VAT Exchange Rate Adjustment"::"Adjust Amount",
                  -AmountLCY, BaseLCY, BaseAddCurr);
            GLSetup."VAT Exchange Rate Adjustment"::"Adjust Additional-Currency Amount":
                PostGLAccAdjmt(
                  AccNo, GLSetup."VAT Exchange Rate Adjustment"::"Adjust Additional-Currency Amount",
                  -AmountAddCurr, BaseLCY, BaseAddCurr);
        END;
    end;

    local procedure AdjustPurchTax(UseTax: Boolean)
    begin
        IF (VATEntry2.Amount <> 0) OR (VATEntry2."Additional-Currency Amount" <> 0) THEN BEGIN
            TaxJurisdiction.TESTFIELD("Tax Account (Purchases)");
            AdjustVATAccount(
              TaxJurisdiction."Tax Account (Purchases)",
              VATEntry2.Amount, VATEntry2."Additional-Currency Amount",
              VATEntryTotalBase.Amount, VATEntryTotalBase."Additional-Currency Amount");
            IF UseTax THEN BEGIN
                TaxJurisdiction.TESTFIELD("Reverse Charge (Purchases)");
                AdjustVATAccount(
                  TaxJurisdiction."Reverse Charge (Purchases)",
                  -VATEntry2.Amount, -VATEntry2."Additional-Currency Amount",
                  -VATEntryTotalBase.Amount, -VATEntryTotalBase."Additional-Currency Amount");
            END;
        END;
        IF (VATEntry2."Remaining Unrealized Amount" <> 0) OR
           (VATEntry2."Add.-Curr. Rem. Unreal. Amount" <> 0)
        THEN BEGIN
            TaxJurisdiction.TESTFIELD("Unrealized VAT Type");
            TaxJurisdiction.TESTFIELD("Unreal. Tax Acc. (Purchases)");
            AdjustVATAccount(
              TaxJurisdiction."Unreal. Tax Acc. (Purchases)",
              VATEntry2."Remaining Unrealized Amount", VATEntry2."Add.-Curr. Rem. Unreal. Amount",
              VATEntryTotalBase."Remaining Unrealized Amount", VATEntry2."Add.-Curr. Rem. Unreal. Amount");

            IF UseTax THEN BEGIN
                TaxJurisdiction.TESTFIELD("Unreal. Rev. Charge (Purch.)");
                AdjustVATAccount(
                  TaxJurisdiction."Unreal. Rev. Charge (Purch.)",
                  -VATEntry2."Remaining Unrealized Amount",
                  -VATEntry2."Add.-Curr. Rem. Unreal. Amount",
                  -VATEntryTotalBase."Remaining Unrealized Amount",
                  -VATEntryTotalBase."Add.-Curr. Rem. Unreal. Amount");
            END;
        END;
    end;

    local procedure AdjustSalesTax()
    begin
        TaxJurisdiction.TESTFIELD("Tax Account (Sales)");
        AdjustVATAccount(
          TaxJurisdiction."Tax Account (Sales)",
          VATEntry2.Amount, VATEntry2."Additional-Currency Amount",
          VATEntryTotalBase.Amount, VATEntryTotalBase."Additional-Currency Amount");
        IF (VATEntry2."Remaining Unrealized Amount" <> 0) OR
           (VATEntry2."Add.-Curr. Rem. Unreal. Amount" <> 0)
        THEN BEGIN
            TaxJurisdiction.TESTFIELD("Unrealized VAT Type");
            TaxJurisdiction.TESTFIELD("Unreal. Tax Acc. (Sales)");
            AdjustVATAccount(
              TaxJurisdiction."Unreal. Tax Acc. (Sales)",
              VATEntry2."Remaining Unrealized Amount",
              VATEntry2."Add.-Curr. Rem. Unreal. Amount",
              VATEntryTotalBase."Remaining Unrealized Amount",
              VATEntryTotalBase."Add.-Curr. Rem. Unreal. Amount");
        END;
    end;

    local procedure Accumulate(var TotalAmount: Decimal; AmountToAdd: Decimal)
    begin
        TotalAmount := TotalAmount + AmountToAdd;
    end;

    local procedure PostGLAccAdjmt(GLAccNo: Code[20]; ExchRateAdjmt: Integer; Amount: Decimal; NetChange: Decimal; AddCurrNetChange: Decimal)
    begin
        GenJnlLine.INIT;
        CASE ExchRateAdjmt OF
            "G/L Account"."Exchange Rate Adjustment"::"Adjust Amount":
                BEGIN
                    GenJnlLine."Additional-Currency Posting" := GenJnlLine."Additional-Currency Posting"::"Amount Only";
                    GenJnlLine."Currency Code" := '';
                    GenJnlLine.Amount := Amount;
                    GenJnlLine."Amount (LCY)" := GenJnlLine.Amount;
                    GLAmtTotal := GLAmtTotal + GenJnlLine.Amount;
                    GLAddCurrNetChangeTotal := GLAddCurrNetChangeTotal + AddCurrNetChange;
                    GLNetChangeBase := GLNetChangeBase + NetChange;
                END;
            "G/L Account"."Exchange Rate Adjustment"::"Adjust Additional-Currency Amount":
                BEGIN
                    GenJnlLine."Additional-Currency Posting" := GenJnlLine."Additional-Currency Posting"::"Additional-Currency Amount Only";
                    GenJnlLine."Currency Code" := GLSetup."Additional Reporting Currency";
                    GenJnlLine.Amount := Amount;
                    GenJnlLine."Amount (LCY)" := 0;
                    GLAddCurrAmtTotal := GLAddCurrAmtTotal + GenJnlLine.Amount;
                    GLNetChangeTotal := GLNetChangeTotal + NetChange;
                    GLAddCurrNetChangeBase := GLAddCurrNetChangeBase + AddCurrNetChange;
                END;
        END;
        IF GenJnlLine.Amount <> 0 THEN BEGIN
            GenJnlLine."Document No." := PostingDocNo;
            GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
            GenJnlLine."Account No." := GLAccNo;
            GenJnlLine."Posting Date" := PostingDate;
            CASE GenJnlLine."Additional-Currency Posting" OF
                GenJnlLine."Additional-Currency Posting"::"Amount Only":
                    GenJnlLine.Description :=
                      STRSUBSTNO(
                        PostingDescription,
                        GLSetup."Additional Reporting Currency",
                        AddCurrNetChange);
                GenJnlLine."Additional-Currency Posting"::"Additional-Currency Amount Only":
                    GenJnlLine.Description :=
                      STRSUBSTNO(
                        PostingDescription,
                        '',
                        NetChange);
            END;
            GenJnlLine."System-Created Entry" := TRUE;
            GenJnlLine."Source Code" := SourceCodeSetup."Exchange Rate Adjmt.";
            GetJnlLineDefDim(GenJnlLine, TempDimSetEntry);
            PostGenJnlLine(GenJnlLine, TempDimSetEntry);
        END;
    end;

    local procedure CheckExchRateAdjustment(AccNo: Code[20]; SetupTableName: Text[100]; SetupFieldName: Text[100])
    var
        GLAcc: Record "G/L Account";
        GLSetup: Record "General Ledger Setup";
    begin
        IF AccNo = '' THEN
            EXIT;
        GLAcc.GET(AccNo);
        IF GLAcc."Exchange Rate Adjustment" <> GLAcc."Exchange Rate Adjustment"::"No Adjustment" THEN BEGIN
            GLAcc."Exchange Rate Adjustment" := GLAcc."Exchange Rate Adjustment"::"No Adjustment";
            ERROR(
              Text017,
              GLAcc.FIELDCAPTION("Exchange Rate Adjustment"), GLAcc.TABLECAPTION,
              GLAcc."No.", GLAcc."Exchange Rate Adjustment",
              SetupTableName, GLSetup.FIELDCAPTION("VAT Exchange Rate Adjustment"),
              GLSetup.TABLECAPTION, SetupFieldName);
        END;
    end;

    local procedure HandleCustDebitCredit(Amount: Decimal; AmountLCY: Decimal; Correction: Boolean; AdjAmount: Decimal)
    begin
        IF ((Amount > 0) OR (AmountLCY > 0)) AND (NOT Correction) OR
           ((Amount < 0) OR (AmountLCY < 0)) AND Correction
        THEN BEGIN
            TempDtldCustLedgEntry."Debit Amount (LCY)" := AdjAmount;
            TempDtldCustLedgEntry."Credit Amount (LCY)" := 0;
        END ELSE BEGIN
            TempDtldCustLedgEntry."Debit Amount (LCY)" := 0;
            TempDtldCustLedgEntry."Credit Amount (LCY)" := -AdjAmount;
        END;
    end;

    local procedure HandleVendDebitCredit(Amount: Decimal; AmountLCY: Decimal; Correction: Boolean; AdjAmount: Decimal)
    begin
        IF ((Amount > 0) OR (AmountLCY > 0)) AND (NOT Correction) OR
           ((Amount < 0) OR (AmountLCY < 0)) AND Correction
        THEN BEGIN
            TempDtldVendLedgEntry."Debit Amount (LCY)" := AdjAmount;
            TempDtldVendLedgEntry."Credit Amount (LCY)" := 0;
        END ELSE BEGIN
            TempDtldVendLedgEntry."Debit Amount (LCY)" := 0;
            TempDtldVendLedgEntry."Credit Amount (LCY)" := -AdjAmount;
        END;
    end;

    local procedure GetJnlLineDefDim(var GenJnlLine: Record "Gen. Journal Line"; var DimSetEntry: Record "Dimension Set Entry")
    var
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin
        WITH GenJnlLine DO BEGIN
            CASE "Account Type" OF
                "Account Type"::"G/L Account":
                    TableID[1] := DATABASE::"G/L Account";
                "Account Type"::"Bank Account":
                    TableID[1] := DATABASE::"Bank Account";
            END;
            No[1] := "Account No.";
            DimMgt.GetDefaultDimID(TableID, No, "Source Code", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Dimension Set ID", 0);
        END;
        DimMgt.GetDimSetEntryDefaultDim(DimSetEntry);
    end;

    local procedure CopyDimSetEntryToDimBuf(var DimSetEntry: Record "Dimension Set Entry"; var DimBuf: Record "Dimension Buffer")
    begin
        IF DimSetEntry.FIND('-') THEN
            REPEAT
                DimBuf."Table ID" := DATABASE::"Dimension Buffer";
                DimBuf."Entry No." := 0;
                DimBuf."Dimension Code" := DimSetEntry."Dimension Code";
                DimBuf."Dimension Value Code" := DimSetEntry."Dimension Value Code";
                DimBuf.INSERT;
            UNTIL DimSetEntry.NEXT = 0;
    end;

    local procedure GetDimCombID(var DimBuf: Record "Dimension Buffer"): Integer
    var
        DimEntryNo: Integer;
    begin
        DimEntryNo := DimBufMgt.FindDimensions(DimBuf);
        IF DimEntryNo = 0 THEN
            DimEntryNo := DimBufMgt.InsertDimensions(DimBuf);
        EXIT(DimEntryNo);
    end;

    local procedure PostGenJnlLine(var GenJnlLine: Record "Gen. Journal Line"; var DimSetEntry: Record "Dimension Set Entry"): Integer
    begin
        GenJnlLine."Shortcut Dimension 1 Code" := GetGlobalDimVal(GLSetup."Global Dimension 1 Code", DimSetEntry);
        GenJnlLine."Shortcut Dimension 2 Code" := GetGlobalDimVal(GLSetup."Global Dimension 2 Code", DimSetEntry);
        GenJnlLine."Dimension Set ID" := DimMgt.GetDimensionSetID(TempDimSetEntry);
        GenJnlPostLine.RUN(GenJnlLine);
        EXIT(GenJnlPostLine.GetNextTransactionNo);
    end;

    local procedure GetGlobalDimVal(GlobalDimCode: Code[20]; var DimSetEntry: Record "Dimension Set Entry"): Code[20]
    var
        DimVal: Code[20];
    begin
        IF GlobalDimCode = '' THEN
            DimVal := ''
        ELSE BEGIN
            DimSetEntry.SETRANGE("Dimension Code", GlobalDimCode);
            IF DimSetEntry.FIND('-') THEN
                DimVal := DimSetEntry."Dimension Value Code"
            ELSE
                DimVal := '';
            DimSetEntry.SETRANGE("Dimension Code");
        END;
        EXIT(DimVal);
    end;

    [Scope('Personalization')]
    procedure CheckPostingDate()
    begin
        IF PostingDate < StartDate THEN
            ERROR(Text018);
        IF PostingDate > EndDateReq THEN
            ERROR(Text018);
    end;

    [Scope('Personalization')]
    procedure AdjustCustomerLedgerEntry(CusLedgerEntry: Record "Cust. Ledger Entry"; PostingDate2: Date)
    var
        DimSetEntry: Record "Dimension Set Entry";
        DimEntryNo: Integer;
        OldAdjAmount: Decimal;
        Adjust: Boolean;
        AdjExchRateBufIndex: Integer;
    begin
        WITH CusLedgerEntry DO BEGIN
            SETRANGE("Date Filter", 0D, PostingDate2);
            Currency2.GET("Currency Code");
            GainsAmount := 0;
            LossesAmount := 0;
            OldAdjAmount := 0;
            Adjust := FALSE;
            CustAdjusted := FALSE; //soft,n

            TempDimSetEntry.RESET;
            TempDimSetEntry.DELETEALL;
            TempDimBuf.RESET;
            TempDimBuf.DELETEALL;
            DimSetEntry.SETRANGE("Dimension Set ID", "Dimension Set ID");
            CopyDimSetEntryToDimBuf(DimSetEntry, TempDimBuf);
            DimEntryNo := GetDimCombID(TempDimBuf);

            CALCFIELDS(
              Amount, "Amount (LCY)", "Remaining Amount", "Remaining Amt. (LCY)", "Original Amt. (LCY)",
              "Debit Amount", "Credit Amount", "Debit Amount (LCY)", "Credit Amount (LCY)");

            // Calculate Old Unrealized Gains and Losses
            SetUnrealizedGainLossFilterCust(DtldCustLedgEntry, "Entry No.");
            DtldCustLedgEntry.CALCSUMS("Amount (LCY)");

            SetUnrealizedGainLossFilterCust(TempDtldCustLedgEntrySums, "Entry No.");
            TempDtldCustLedgEntrySums.CALCSUMS("Amount (LCY)");
            OldAdjAmount := DtldCustLedgEntry."Amount (LCY)" + TempDtldCustLedgEntrySums."Amount (LCY)";
            "Remaining Amt. (LCY)" := "Remaining Amt. (LCY)" + TempDtldCustLedgEntrySums."Amount (LCY)";
            "Debit Amount (LCY)" := "Debit Amount (LCY)" + TempDtldCustLedgEntrySums."Amount (LCY)";
            "Credit Amount (LCY)" := "Credit Amount (LCY)" + TempDtldCustLedgEntrySums."Amount (LCY)";
            TempDtldCustLedgEntrySums.RESET;

            // Modify Currency factor on Customer Ledger Entry
            IF "Adjusted Currency Factor" <> Currency2."Currency Factor" THEN BEGIN
                "Adjusted Currency Factor" := Currency2."Currency Factor";
                MODIFY;
            END;

            // Calculate New Unrealized Gains and Losses
            AdjAmount :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCYAdjmt(
                  PostingDate2, Currency2.Code, "Remaining Amount", Currency2."Currency Factor")) -
              "Remaining Amt. (LCY)";

            IF AdjAmount <> 0 THEN BEGIN
                InitDtldCustLedgEntry(CusLedgerEntry, TempDtldCustLedgEntry);
                TempDtldCustLedgEntry."Entry No." := NewEntryNo;
                TempDtldCustLedgEntry."Posting Date" := PostingDate2;
                TempDtldCustLedgEntry."Document No." := PostingDocNo;

                //soft,sn
                CustAdjusted := TRUE;

                DtldCustLedgEntry2.COPYFILTERS(DtldCustLedgEntry);
                DtldCustLedgEntry2.SETRANGE("Entry Type", DtldCustLedgEntry2."Entry Type"::"Initial Entry");
                IF DtldCustLedgEntry2.FINDFIRST THEN
                    TempDtldCustLedgEntry."PTSS Initial BP Statistic Code" := DtldCustLedgEntry2."PTSS Initial BP Statistic Code";
                //soft,en

                Correction :=
                  ("Debit Amount" < 0) OR
                  ("Credit Amount" < 0) OR
                  ("Debit Amount (LCY)" < 0) OR
                  ("Credit Amount (LCY)" < 0);

                IF OldAdjAmount > 0 THEN
                    CASE TRUE OF
                        (AdjAmount > 0):
                            BEGIN
                                TempDtldCustLedgEntry."Amount (LCY)" := AdjAmount;
                                TempDtldCustLedgEntry."Entry Type" := TempDtldCustLedgEntry."Entry Type"::"Unrealized Gain";
                                HandleCustDebitCredit(
                                  Amount, "Amount (LCY)", Correction, TempDtldCustLedgEntry."Amount (LCY)");
                                InsertTempDtldCustomerLedgerEntry;
                                NewEntryNo := NewEntryNo + 1;
                                GainsAmount := AdjAmount;
                                Adjust := TRUE;
                            END;
                        (AdjAmount < 0):
                            IF -AdjAmount <= OldAdjAmount THEN BEGIN
                                TempDtldCustLedgEntry."Amount (LCY)" := AdjAmount;
                                TempDtldCustLedgEntry."Entry Type" := TempDtldCustLedgEntry."Entry Type"::"Unrealized Loss";
                                HandleCustDebitCredit(
                                  Amount, "Amount (LCY)", Correction, TempDtldCustLedgEntry."Amount (LCY)");
                                InsertTempDtldCustomerLedgerEntry;
                                NewEntryNo := NewEntryNo + 1;
                                LossesAmount := AdjAmount;
                                Adjust := TRUE;
                            END ELSE BEGIN
                                AdjAmount := AdjAmount + OldAdjAmount;
                                TempDtldCustLedgEntry."Amount (LCY)" := -OldAdjAmount;
                                TempDtldCustLedgEntry."Entry Type" := TempDtldCustLedgEntry."Entry Type"::"Unrealized Gain";
                                HandleCustDebitCredit(
                                  Amount, "Amount (LCY)", Correction, TempDtldCustLedgEntry."Amount (LCY)");
                                InsertTempDtldCustomerLedgerEntry;
                                NewEntryNo := NewEntryNo + 1;
                                AdjExchRateBufIndex :=
                                  AdjExchRateBufferUpdate(
                                    "Currency Code", Customer."Customer Posting Group",
                                    //soft,o 0,0,-OldAdjAmount,-OldAdjAmount,0,DimEntryNo,PostingDate2,Customer."IC Partner Code");
                                    //soft,sn
                                    0, 0, -OldAdjAmount, -OldAdjAmount, 0, DimEntryNo, PostingDate2, Customer."IC Partner Code",
                                    GetCustPostingGrAcc(CusLedgerEntry), Customer."No.");
                                //soft,en
                                TempDtldCustLedgEntry."Transaction No." := AdjExchRateBufIndex;
                                ModifyTempDtldCustomerLedgerEntry;
                                Adjust := FALSE;
                            END;
                    END;
                IF OldAdjAmount < 0 THEN
                    CASE TRUE OF
                        (AdjAmount < 0):
                            BEGIN
                                TempDtldCustLedgEntry."Amount (LCY)" := AdjAmount;
                                TempDtldCustLedgEntry."Entry Type" := TempDtldCustLedgEntry."Entry Type"::"Unrealized Loss";
                                HandleCustDebitCredit(
                                  Amount, "Amount (LCY)", Correction, TempDtldCustLedgEntry."Amount (LCY)");
                                InsertTempDtldCustomerLedgerEntry;
                                NewEntryNo := NewEntryNo + 1;
                                LossesAmount := AdjAmount;
                                Adjust := TRUE;
                            END;
                        (AdjAmount > 0):
                            IF AdjAmount <= -OldAdjAmount THEN BEGIN
                                TempDtldCustLedgEntry."Amount (LCY)" := AdjAmount;
                                TempDtldCustLedgEntry."Entry Type" := TempDtldCustLedgEntry."Entry Type"::"Unrealized Gain";
                                HandleCustDebitCredit(
                                  Amount, "Amount (LCY)", Correction, TempDtldCustLedgEntry."Amount (LCY)");
                                InsertTempDtldCustomerLedgerEntry;
                                NewEntryNo := NewEntryNo + 1;
                                GainsAmount := AdjAmount;
                                Adjust := TRUE;
                            END ELSE BEGIN
                                AdjAmount := OldAdjAmount + AdjAmount;
                                TempDtldCustLedgEntry."Amount (LCY)" := -OldAdjAmount;
                                TempDtldCustLedgEntry."Entry Type" := TempDtldCustLedgEntry."Entry Type"::"Unrealized Loss";
                                HandleCustDebitCredit(
                                  Amount, "Amount (LCY)", Correction, TempDtldCustLedgEntry."Amount (LCY)");
                                InsertTempDtldCustomerLedgerEntry;
                                NewEntryNo := NewEntryNo + 1;
                                AdjExchRateBufIndex :=
                                  AdjExchRateBufferUpdate(
                                    "Currency Code", Customer."Customer Posting Group",
                                    //soft,o 0,0,-OldAdjAmount,0,-OldAdjAmount,DimEntryNo,PostingDate2,Customer."IC Partner Code");
                                    //soft,sn
                                    0, 0, -OldAdjAmount, 0, -OldAdjAmount, DimEntryNo, PostingDate2, Customer."IC Partner Code",
                                    GetCustPostingGrAcc(CusLedgerEntry), Customer."No.");
                                //soft,en
                                TempDtldCustLedgEntry."Transaction No." := AdjExchRateBufIndex;
                                ModifyTempDtldCustomerLedgerEntry;
                                Adjust := FALSE;
                            END;
                    END;
                //XXX,begin
                //soft,sn
                // CusLedgerEntry.CALCFIELDS(
                //   Amount, "Amount (LCY)", "Remaining Amount", "Remaining Amt. (LCY)", "Original Amt. (LCY)",
                //   "Debit Amount", "Credit Amount", "Debit Amount (LCY)", "Credit Amount (LCY)");
                // IF (("Bill No." <> '') AND (CarteraManagement.AccessToCartera)) THEN
                //     CASE "Document Situation" OF
                //         "Document Situation"::Cartera:
                //             IF Doc.GET(Doc.Type::Receivable, "Entry No.") THEN BEGIN
                //                 Doc."Remaining Amt. (LCY)" := "Remaining Amt. (LCY)";
                //                 Doc.MODIFY;
                //             END;
                //         "Document Situation"::"Posted BG/PO":
                //             IF PostedDoc.GET(PostedDoc.Type::Receivable, "Entry No.") THEN BEGIN
                //                 PostedDoc."Remaining Amt. (LCY)" := "Remaining Amt. (LCY)";
                //                 PostedDoc.MODIFY;
                //             END;
                //         "Document Situation"::"Closed BG/PO", "Document Situation"::"Closed Documents":
                //             IF ClosedDoc.GET(ClosedDoc.Type::Receivable, "Entry No.") THEN BEGIN
                //                 ClosedDoc."Remaining Amt. (LCY)" := "Remaining Amt. (LCY)";
                //                 ClosedDoc.MODIFY;
                //             END;
                //     END;
                //soft,en
                //XXX,end

                IF NOT Adjust THEN BEGIN
                    TempDtldCustLedgEntry."Amount (LCY)" := AdjAmount;
                    HandleCustDebitCredit(Amount, "Amount (LCY)", Correction, TempDtldCustLedgEntry."Amount (LCY)");
                    TempDtldCustLedgEntry."Entry No." := NewEntryNo;
                    IF AdjAmount < 0 THEN BEGIN
                        TempDtldCustLedgEntry."Entry Type" := TempDtldCustLedgEntry."Entry Type"::"Unrealized Loss";
                        GainsAmount := 0;
                        LossesAmount := AdjAmount;
                    END ELSE
                        IF AdjAmount > 0 THEN BEGIN
                            TempDtldCustLedgEntry."Entry Type" := TempDtldCustLedgEntry."Entry Type"::"Unrealized Gain";
                            GainsAmount := AdjAmount;
                            LossesAmount := 0;
                        END;
                    //soft,o TempDtldCustLedgEntry.INSERT;
                    InsertTempDtldCustomerLedgerEntry; //soft,n
                    NewEntryNo := NewEntryNo + 1;
                END;

                TotalAdjAmount := TotalAdjAmount + AdjAmount;
                Window.UPDATE(4, TotalAdjAmount);
                AdjExchRateBufIndex :=
                  AdjExchRateBufferUpdate(
                    "Currency Code", Customer."Customer Posting Group",
                    "Remaining Amount", "Remaining Amt. (LCY)", TempDtldCustLedgEntry."Amount (LCY)",
                    //soft,o GainsAmount,LossesAmount,DimEntryNo,PostingDate2,Customer."IC Partner Code");
                    //soft,sn
                    GainsAmount, LossesAmount, DimEntryNo, PostingDate2, Customer."IC Partner Code",
                    GetCustPostingGrAcc(CusLedgerEntry), Customer."No.");
                //soft,en
                TempDtldCustLedgEntry."Transaction No." := AdjExchRateBufIndex;
                ModifyTempDtldCustomerLedgerEntry;
                //soft,sn
                IF Customer.GET("Customer No.") THEN
                    AccountName := Customer.Name;
                IF NOT Detail THEN //soft,n
                    GetAdjustmentValues("Remaining Amount", "Remaining Amt. (LCY)", TempDtldCustLedgEntry."Amount (LCY)", 1,
                        AccountName, "Document No.", "Customer No.", PostingDate2, "Currency Code");
                //soft,en
            END;
        END;
        //soft,sn
        IF NOT CustAdjusted THEN
            CurrReport.SKIP;
        //soft,en
    end;

    [Scope('Personalization')]
    procedure AdjustVendorLedgerEntry(VendLedgerEntry: Record "Vendor Ledger Entry"; PostingDate2: Date)
    var
        DimSetEntry: Record "Dimension Set Entry";
        DimEntryNo: Integer;
        OldAdjAmount: Decimal;
        Adjust: Boolean;
        AdjExchRateBufIndex: Integer;
    begin
        WITH VendLedgerEntry DO BEGIN
            SETRANGE("Date Filter", 0D, PostingDate2);
            Currency2.GET("Currency Code");
            GainsAmount := 0;
            LossesAmount := 0;
            OldAdjAmount := 0;
            Adjust := FALSE;
            VendAdjusted := FALSE; //soft,n

            TempDimBuf.RESET;
            TempDimBuf.DELETEALL;
            DimSetEntry.SETRANGE("Dimension Set ID", "Dimension Set ID");
            CopyDimSetEntryToDimBuf(DimSetEntry, TempDimBuf);
            DimEntryNo := GetDimCombID(TempDimBuf);

            CALCFIELDS(
              Amount, "Amount (LCY)", "Remaining Amount", "Remaining Amt. (LCY)", "Original Amt. (LCY)",
              "Debit Amount", "Credit Amount", "Debit Amount (LCY)", "Credit Amount (LCY)");

            // Calculate Old Unrealized GainLoss
            SetUnrealizedGainLossFilterVend(DtldVendLedgEntry, "Entry No.");
            DtldVendLedgEntry.CALCSUMS("Amount (LCY)");

            SetUnrealizedGainLossFilterVend(TempDtldVendLedgEntrySums, "Entry No.");
            TempDtldVendLedgEntrySums.CALCSUMS("Amount (LCY)");
            OldAdjAmount := DtldVendLedgEntry."Amount (LCY)" + TempDtldVendLedgEntrySums."Amount (LCY)";
            "Remaining Amt. (LCY)" := "Remaining Amt. (LCY)" + TempDtldVendLedgEntrySums."Amount (LCY)";
            "Debit Amount (LCY)" := "Debit Amount (LCY)" + TempDtldVendLedgEntrySums."Amount (LCY)";
            "Credit Amount (LCY)" := "Credit Amount (LCY)" + TempDtldVendLedgEntrySums."Amount (LCY)";
            TempDtldVendLedgEntrySums.RESET;

            // Modify Currency factor on Vendor Ledger Entry
            IF "Adjusted Currency Factor" <> Currency2."Currency Factor" THEN BEGIN
                "Adjusted Currency Factor" := Currency2."Currency Factor";
                MODIFY;
            END;

            // Calculate New Unrealized Gains and Losses
            AdjAmount :=
              ROUND(
                CurrExchRate.ExchangeAmtFCYToLCYAdjmt(
                  PostingDate2, Currency2.Code, "Remaining Amount", Currency2."Currency Factor")) -
              "Remaining Amt. (LCY)";

            IF AdjAmount <> 0 THEN BEGIN
                InitDtldVendLedgEntry(VendLedgerEntry, TempDtldVendLedgEntry);
                TempDtldVendLedgEntry."Entry No." := NewEntryNo;
                TempDtldVendLedgEntry."Posting Date" := PostingDate2;
                TempDtldVendLedgEntry."Document No." := PostingDocNo;
                //soft,sn
                VendAdjusted := TRUE;

                DtldVendLedgEntry2.COPYFILTERS(DtldVendLedgEntry);
                DtldVendLedgEntry2.SETRANGE("Entry Type", DtldVendLedgEntry2."Entry Type"::"Initial Entry");
                IF DtldVendLedgEntry2.FINDFIRST THEN
                    TempDtldVendLedgEntry."PTSS Initial BP Statistic Code" := DtldVendLedgEntry2."PTSS Initial BP Statistic Code";
                //soft,en

                Correction :=
                  ("Debit Amount" < 0) OR
                  ("Credit Amount" < 0) OR
                  ("Debit Amount (LCY)" < 0) OR
                  ("Credit Amount (LCY)" < 0);

                IF OldAdjAmount > 0 THEN
                    CASE TRUE OF
                        (AdjAmount > 0):
                            BEGIN
                                TempDtldVendLedgEntry."Amount (LCY)" := AdjAmount;
                                TempDtldVendLedgEntry."Entry Type" := TempDtldVendLedgEntry."Entry Type"::"Unrealized Gain";
                                HandleVendDebitCredit(Amount, "Amount (LCY)", Correction, TempDtldVendLedgEntry."Amount (LCY)");
                                InsertTempDtldVendorLedgerEntry;
                                NewEntryNo := NewEntryNo + 1;
                                GainsAmount := AdjAmount;
                                Adjust := TRUE;
                            END;
                        (AdjAmount < 0):
                            IF -AdjAmount <= OldAdjAmount THEN BEGIN
                                TempDtldVendLedgEntry."Amount (LCY)" := AdjAmount;
                                TempDtldVendLedgEntry."Entry Type" := TempDtldVendLedgEntry."Entry Type"::"Unrealized Loss";
                                HandleVendDebitCredit(
                                  Amount, "Amount (LCY)", Correction, TempDtldVendLedgEntry."Amount (LCY)");
                                InsertTempDtldVendorLedgerEntry;
                                NewEntryNo := NewEntryNo + 1;
                                LossesAmount := AdjAmount;
                                Adjust := TRUE;
                            END ELSE BEGIN
                                AdjAmount := AdjAmount + OldAdjAmount;
                                TempDtldVendLedgEntry."Amount (LCY)" := -OldAdjAmount;
                                TempDtldVendLedgEntry."Entry Type" := TempDtldVendLedgEntry."Entry Type"::"Unrealized Gain";
                                HandleVendDebitCredit(
                                  Amount, "Amount (LCY)", Correction, TempDtldVendLedgEntry."Amount (LCY)");
                                InsertTempDtldVendorLedgerEntry;
                                NewEntryNo := NewEntryNo + 1;
                                AdjExchRateBufIndex :=
                                  AdjExchRateBufferUpdate(
                                    "Currency Code", Vendor."Vendor Posting Group",
                                    //soft,o 0,0,-OldAdjAmount,-OldAdjAmount,0,DimEntryNo,PostingDate2,Vendor."IC Partner Code");
                                    //soft,sn
                                    0, 0, -OldAdjAmount, -OldAdjAmount, 0, DimEntryNo, PostingDate2, Vendor."IC Partner Code",
                                    GetVendPostingGrAcc(VendLedgerEntry), Vendor."No.");
                                //soft,en
                                TempDtldVendLedgEntry."Transaction No." := AdjExchRateBufIndex;
                                ModifyTempDtldVendorLedgerEntry;
                                Adjust := FALSE;
                            END;
                    END;
                IF OldAdjAmount < 0 THEN
                    CASE TRUE OF
                        (AdjAmount < 0):
                            BEGIN
                                TempDtldVendLedgEntry."Amount (LCY)" := AdjAmount;
                                TempDtldVendLedgEntry."Entry Type" := TempDtldVendLedgEntry."Entry Type"::"Unrealized Loss";
                                HandleVendDebitCredit(Amount, "Amount (LCY)", Correction, TempDtldVendLedgEntry."Amount (LCY)");
                                InsertTempDtldVendorLedgerEntry;
                                NewEntryNo := NewEntryNo + 1;
                                LossesAmount := AdjAmount;
                                Adjust := TRUE;
                            END;
                        (AdjAmount > 0):
                            IF AdjAmount <= -OldAdjAmount THEN BEGIN
                                TempDtldVendLedgEntry."Amount (LCY)" := AdjAmount;
                                TempDtldVendLedgEntry."Entry Type" := TempDtldVendLedgEntry."Entry Type"::"Unrealized Gain";
                                HandleVendDebitCredit(
                                  Amount, "Amount (LCY)", Correction, TempDtldVendLedgEntry."Amount (LCY)");
                                InsertTempDtldVendorLedgerEntry;
                                NewEntryNo := NewEntryNo + 1;
                                GainsAmount := AdjAmount;
                                Adjust := TRUE;
                            END ELSE BEGIN
                                AdjAmount := OldAdjAmount + AdjAmount;
                                TempDtldVendLedgEntry."Amount (LCY)" := -OldAdjAmount;
                                TempDtldVendLedgEntry."Entry Type" := TempDtldVendLedgEntry."Entry Type"::"Unrealized Loss";
                                HandleVendDebitCredit(
                                  Amount, "Amount (LCY)", Correction, TempDtldVendLedgEntry."Amount (LCY)");
                                InsertTempDtldVendorLedgerEntry;
                                NewEntryNo := NewEntryNo + 1;
                                AdjExchRateBufIndex :=
                                  AdjExchRateBufferUpdate(
                                    "Currency Code", Vendor."Vendor Posting Group",
                                 //soft,o 0,0,-OldAdjAmount,0,-OldAdjAmount,DimEntryNo,PostingDate2,Vendor."IC Partner Code");
                                 //soft,sn
                                 0, 0, -OldAdjAmount, 0, -OldAdjAmount, DimEntryNo, PostingDate2, Vendor."IC Partner Code",
                                 GetVendPostingGrAcc(VendLedgerEntry), Vendor."No.");
                                //soft,en
                                TempDtldVendLedgEntry."Transaction No." := AdjExchRateBufIndex;
                                ModifyTempDtldVendorLedgerEntry;
                                Adjust := FALSE;
                            END;
                    END;
                //XXX,begin    
                //soft,sn
                // VendLedgerEntry.CALCFIELDS(
                // Amount, "Amount (LCY)", "Remaining Amount", "Remaining Amt. (LCY)", "Original Amt. (LCY)",
                // "Debit Amount", "Credit Amount", "Debit Amount (LCY)", "Credit Amount (LCY)");
                // IF "Bill No." <> '' THEN
                //     CASE "Document Situation" OF
                //         "Document Situation"::Cartera:
                //             IF Doc.GET(Doc.Type::Payable, "Entry No.") THEN BEGIN
                //                 Doc."Remaining Amt. (LCY)" := "Remaining Amt. (LCY)";
                //                 Doc.MODIFY;
                //             END;
                //         "Document Situation"::"Posted BG/PO":
                //             IF PostedDoc.GET(PostedDoc.Type::Payable, "Entry No.") THEN BEGIN
                //                 PostedDoc."Remaining Amt. (LCY)" := "Remaining Amt. (LCY)";
                //                 PostedDoc.MODIFY;
                //             END;
                //         "Document Situation"::"Closed BG/PO", "Document Situation"::"Closed Documents":
                //             IF ClosedDoc.GET(ClosedDoc.Type::Payable, "Entry No.") THEN BEGIN
                //                 ClosedDoc."Remaining Amt. (LCY)" := "Remaining Amt. (LCY)";
                //                 ClosedDoc.MODIFY;
                //             END;
                //     END;
                // //soft,en
                //XXX,end

                IF NOT Adjust THEN BEGIN
                    TempDtldVendLedgEntry."Amount (LCY)" := AdjAmount;
                    HandleVendDebitCredit(Amount, "Amount (LCY)", Correction, TempDtldVendLedgEntry."Amount (LCY)");
                    TempDtldVendLedgEntry."Entry No." := NewEntryNo;
                    IF AdjAmount < 0 THEN BEGIN
                        TempDtldVendLedgEntry."Entry Type" := TempDtldVendLedgEntry."Entry Type"::"Unrealized Loss";
                        GainsAmount := 0;
                        LossesAmount := AdjAmount;
                    END ELSE
                        IF AdjAmount > 0 THEN BEGIN
                            TempDtldVendLedgEntry."Entry Type" := TempDtldVendLedgEntry."Entry Type"::"Unrealized Gain";
                            GainsAmount := AdjAmount;
                            LossesAmount := 0;
                        END;
                    InsertTempDtldVendorLedgerEntry;
                    NewEntryNo := NewEntryNo + 1;
                END;

                TotalAdjAmount := TotalAdjAmount + AdjAmount;
                Window.UPDATE(4, TotalAdjAmount);
                AdjExchRateBufIndex :=
                  AdjExchRateBufferUpdate(
                    "Currency Code", Vendor."Vendor Posting Group",
                    "Remaining Amount", "Remaining Amt. (LCY)",
                  //soft,o TempDtldVendLedgEntry."Amount (LCY)",GainsAmount,LossesAmount,DimEntryNo,PostingDate2,Vendor."IC Partner Code");
                  //soft,sn
                  TempDtldVendLedgEntry."Amount (LCY)", GainsAmount, LossesAmount, DimEntryNo, PostingDate2, Vendor."IC Partner Code",
                     GetVendPostingGrAcc(VendLedgerEntry), Vendor."No.");
                //soft,en
                TempDtldVendLedgEntry."Transaction No." := AdjExchRateBufIndex;
                ModifyTempDtldVendorLedgerEntry;
                //soft,sn
                IF Vendor.GET("Vendor No.") THEN
                    AccountName := Vendor.Name;
                IF NOT Detail THEN //soft,n
                    GetAdjustmentValues("Remaining Amount", "Remaining Amt. (LCY)", TempDtldVendLedgEntry."Amount (LCY)", 2,
                      AccountName, "Document No.", "Vendor No.", PostingDate2, "Currency Code");
                //soft,en
            END;
        END;
        //soft,sn
        IF NOT VendAdjusted THEN
            CurrReport.SKIP;
        //soft,en
    end;

    local procedure InitDtldCustLedgEntry(CustLedgEntry: Record "Cust. Ledger Entry"; var DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry")
    begin
        WITH CustLedgEntry DO BEGIN
            DtldCustLedgEntry.INIT;
            DtldCustLedgEntry."Cust. Ledger Entry No." := "Entry No.";
            DtldCustLedgEntry.Amount := 0;
            DtldCustLedgEntry."Customer No." := "Customer No.";
            DtldCustLedgEntry."Currency Code" := "Currency Code";
            DtldCustLedgEntry."User ID" := USERID;
            DtldCustLedgEntry."Source Code" := SourceCodeSetup."Exchange Rate Adjmt.";
            DtldCustLedgEntry."Journal Batch Name" := "Journal Batch Name";
            DtldCustLedgEntry."Reason Code" := "Reason Code";
            DtldCustLedgEntry."Initial Entry Due Date" := "Due Date";
            DtldCustLedgEntry."Initial Entry Global Dim. 1" := "Global Dimension 1 Code";
            DtldCustLedgEntry."Initial Entry Global Dim. 2" := "Global Dimension 2 Code";
            DtldCustLedgEntry."Initial Document Type" := "Document Type";
            //XXX DtldCustLedgEntry."Customer Posting Group" := "Customer Posting Group"//soft,n
        END;
    end;

    local procedure InitDtldVendLedgEntry(VendLedgEntry: Record "Vendor Ledger Entry"; var DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry")
    begin
        WITH VendLedgEntry DO BEGIN
            DtldVendLedgEntry.INIT;
            DtldVendLedgEntry."Vendor Ledger Entry No." := "Entry No.";
            DtldVendLedgEntry.Amount := 0;
            DtldVendLedgEntry."Vendor No." := "Vendor No.";
            DtldVendLedgEntry."Currency Code" := "Currency Code";
            DtldVendLedgEntry."User ID" := USERID;
            DtldVendLedgEntry."Source Code" := SourceCodeSetup."Exchange Rate Adjmt.";
            DtldVendLedgEntry."Journal Batch Name" := "Journal Batch Name";
            DtldVendLedgEntry."Reason Code" := "Reason Code";
            DtldVendLedgEntry."Initial Entry Due Date" := "Due Date";
            DtldVendLedgEntry."Initial Entry Global Dim. 1" := "Global Dimension 1 Code";
            DtldVendLedgEntry."Initial Entry Global Dim. 2" := "Global Dimension 2 Code";
            DtldVendLedgEntry."Initial Document Type" := "Document Type";
            //XXX DtldVendLedgEntry."Vendor Posting Group" := "Vendor Posting Group"//soft,n
        END;
    end;

    local procedure SetUnrealizedGainLossFilterCust(var DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry"; EntryNo: Integer)
    begin
        WITH DtldCustLedgEntry DO BEGIN
            RESET;
            SETCURRENTKEY("Cust. Ledger Entry No.", "Entry Type");
            SETRANGE("Cust. Ledger Entry No.", EntryNo);
            SETRANGE("Entry Type", "Entry Type"::"Unrealized Loss", "Entry Type"::"Unrealized Gain");
        END;
    end;

    local procedure SetUnrealizedGainLossFilterVend(var DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry"; EntryNo: Integer)
    begin
        WITH DtldVendLedgEntry DO BEGIN
            RESET;
            SETCURRENTKEY("Vendor Ledger Entry No.", "Entry Type");
            SETRANGE("Vendor Ledger Entry No.", EntryNo);
            SETRANGE("Entry Type", "Entry Type"::"Unrealized Loss", "Entry Type"::"Unrealized Gain");
        END;
    end;

    local procedure InsertTempDtldCustomerLedgerEntry()
    begin
        TempDtldCustLedgEntry.INSERT;
        TempDtldCustLedgEntrySums := TempDtldCustLedgEntry;
        TempDtldCustLedgEntrySums.INSERT;
    end;

    local procedure InsertTempDtldVendorLedgerEntry()
    begin
        TempDtldVendLedgEntry.INSERT;
        TempDtldVendLedgEntrySums := TempDtldVendLedgEntry;
        TempDtldVendLedgEntrySums.INSERT;
    end;

    local procedure ModifyTempDtldCustomerLedgerEntry()
    begin
        TempDtldCustLedgEntry.MODIFY;
        TempDtldCustLedgEntrySums := TempDtldCustLedgEntry;
        TempDtldCustLedgEntrySums.MODIFY;
    end;

    local procedure ModifyTempDtldVendorLedgerEntry()
    begin
        TempDtldVendLedgEntry.MODIFY;
        TempDtldVendLedgEntrySums := TempDtldVendLedgEntry;
        TempDtldVendLedgEntrySums.MODIFY;
    end;

    [IntegrationEvent(TRUE, TRUE)]
    local procedure OnBeforeOnInitReport(var IsHandled: Boolean)
    begin
    end;

    procedure GetCustPostingGrAcc(CustLedgEntry: Record "Cust. Ledger Entry"): Code[20]
    var
        CustPostingGr: Record "Customer Posting Group";
        //XXX PostedDoc: Record "31022936";
    begin
        //XXX,begin
        //soft,sn
        // CLEAR(PostedDoc);
        // WITH CustLedgEntry DO BEGIN
        //     TESTFIELD("Customer Posting Group");
        //     CustPostingGr.GET("Customer Posting Group");
        //     CASE TRUE OF
        //         ("Document Type" = "Document Type"::Invoice) AND
        //         ("Document Status" = "Document Status"::" ") AND
        //         ("Document Situation" = "Document Situation"::" "):
        //             BEGIN
        //                 CustPostingGr.TESTFIELD("Receivables Account");
        //                 EXIT(CustPostingGr."Receivables Account");
        //             END;
        //         ("Document Type" = "Document Type"::Invoice) AND
        //         ("Document Status" = "Document Status"::Rejected) AND
        //         ("Document Situation" IN ["Document Situation"::"Posted BG/PO", "Document Situation"::"Closed BG/PO"]):
        //             BEGIN
        //                 CustPostingGr.TESTFIELD("Rejected Factoring Acc.");
        //                 EXIT(CustPostingGr."Rejected Factoring Acc.");
        //             END;
        //         ("Document Type" = "Document Type"::Invoice) AND
        //         ("Document Status" = "Document Status"::Open) AND
        //         ("Document Situation" = "Document Situation"::"Posted BG/PO"):
        //             BEGIN
        //                 PostedDoc.GET(PostedDoc.Type::Receivable, CustLedgEntry."Entry No.");
        //                 IF PostedDoc."Dealing Type" = PostedDoc."Dealing Type"::Discount THEN BEGIN
        //                     CustPostingGr.TESTFIELD("Factoring for Discount Acc.");
        //                     EXIT(CustPostingGr."Factoring for Discount Acc.");
        //                 END ELSE BEGIN
        //                     CustPostingGr.TESTFIELD("Factoring for Collection Acc.");
        //                     EXIT(CustPostingGr."Factoring for Collection Acc.");
        //                 END;
        //             END;
        //         ("Document Type" = "Document Type"::"7") AND
        //         ("Document Status" = "Document Status"::Open) AND
        //         ("Document Situation" IN ["Document Situation"::Cartera, "Document Situation"::"BG/PO"]):
        //             BEGIN
        //                 CustPostingGr.TESTFIELD("Bills Account");
        //                 EXIT(CustPostingGr."Bills Account");
        //             END;
        //         ("Document Type" = "Document Type"::"7") AND
        //         ("Document Status" = "Document Status"::Rejected) AND
        //         ("Document Situation" IN ["Document Situation"::"Posted BG/PO", "Document Situation"::"Closed BG/PO",
        //                                   "Document Situation"::"Closed Documents"]):
        //             BEGIN
        //                 CustPostingGr.TESTFIELD("Rejected Bills Acc.");
        //                 EXIT(CustPostingGr."Rejected Bills Acc.");
        //             END;
        //         ("Document Type" = "Document Type"::"7") AND
        //         ("Document Status" = "Document Status"::Open) AND
        //         ("Document Situation" = "Document Situation"::"Posted BG/PO"):
        //             BEGIN
        //                 PostedDoc.GET(PostedDoc.Type::Receivable, CustLedgEntry."Entry No.");
        //                 IF PostedDoc."Dealing Type" = PostedDoc."Dealing Type"::Discount THEN BEGIN
        //                     CustPostingGr.TESTFIELD("Discounted Bills Acc.");
        //                     EXIT(CustPostingGr."Discounted Bills Acc.");
        //                 END ELSE BEGIN
        //                     CustPostingGr.TESTFIELD("Bills on Collection Acc.");
        //                     EXIT(CustPostingGr."Bills on Collection Acc.");
        //                 END;
        //             END;
        //         ELSE BEGIN
        //                 CustPostingGr.TESTFIELD("Receivables Account");
        //                 EXIT(CustPostingGr."Receivables Account");
        //             END;
        //     END;
        // END;
        // //soft,en
        //XXX,end
    end;

    procedure GetVendPostingGrAcc(VendLedgEntry: Record "Vendor Ledger Entry"): Code[20]
    var
        VendPostingGr: Record "Vendor Posting Group";
    begin
        //XXX,begin
        //soft,sn
        // CLEAR(PostedDoc);
        // WITH VendLedgEntry DO BEGIN
        //     TESTFIELD("Vendor Posting Group");
        //     VendPostingGr.GET("Vendor Posting Group");
        //     CASE TRUE OF
        //         ("Document Type" = "Document Type"::Invoice) AND
        //         ("Document Status" = "Document Status"::" ") AND
        //         ("Document Situation" = "Document Situation"::" "):
        //             BEGIN

        //                 VendPostingGr.TESTFIELD("Payables Account");
        //                 EXIT(VendPostingGr."Payables Account");
        //             END;
        //         ("Document Type" = "Document Type"::Invoice) AND
        //         ("Document Status" = "Document Status"::Open) AND
        //         ("Document Situation" = "Document Situation"::"Posted BG/PO"):
        //             BEGIN

        //                 VendPostingGr.TESTFIELD("Invoices in Pmt. Order Acc.");
        //                 EXIT(VendPostingGr."Invoices in Pmt. Order Acc.");
        //             END;
        //         ("Document Type" = "Document Type"::"12") AND
        //         ("Document Status" = "Document Status"::Open) AND
        //         ("Document Situation" IN ["Document Situation"::Cartera, "Document Situation"::"BG/PO"]):
        //             BEGIN

        //                 VendPostingGr.TESTFIELD("Bills Account");
        //                 EXIT(VendPostingGr."Bills Account");
        //             END;
        //         ("Document Type" = "Document Type"::"12") AND
        //         ("Document Status" = "Document Status"::Open) AND
        //         ("Document Situation" = "Document Situation"::"Posted BG/PO"):
        //             BEGIN

        //                 VendPostingGr.TESTFIELD("Bills in Pmt. Order Acc.");
        //                 EXIT(VendPostingGr."Bills in Pmt. Order Acc.");
        //             END;
        //         ELSE BEGIN

        //                 VendPostingGr.TESTFIELD("Payables Account");
        //                 EXIT(VendPostingGr."Payables Account");
        //             END;
        //     END;
        // END;
        //soft,en
        //XXX,end
    end;

    procedure GetBankAccNo(BankAccPostingGrCode: Code[20]): Code[20]
    var
        BankAccPostingGr: Record "Bank Account Posting Group";
    begin
        //soft,sn
        BankAccPostingGr.GET(BankAccPostingGrCode);
        BankAccPostingGr.TESTFIELD("G/L Bank Account No.");
        EXIT(BankAccPostingGr."G/L Bank Account No.");
        //soft,en
    end;

    procedure GetAdjustmentValues(AdjustedBase: Decimal; AdjustedBaseLCY: Decimal; AdjAmtLCY: Decimal; AccountType: Option "G/L Account",Customer,Vendor,"Bank Account"; AccName: Text[50]; DocumentNo: Code[20]; AccountNo: Code[20]; PostingDate: Date; Currency: Code[10])
    begin
        //soft,sn
        AdjustBase := AdjustedBase;
        AdjustBaseLCY := AdjustedBaseLCY;
        NewBaseLCY := AdjustedBaseLCY + AdjAmtLCY;
        AdjustedAmtLCY := AdjAmtLCY;
        AccType := AccountType;
        AccountName := AccName;
        DocNo := DocumentNo;
        AccNo := AccountNo;
        CurrCode := Currency;
        CurrencyFactor := CurrExchRate.ExchangeRateAdjmt(PostingDate, CurrCode);
        //soft,en
    end;

    procedure FillBankAccPostingBuffer(BankAccLedgEntry: Record "Bank Account Ledger Entry")
    begin
        //XXX,begin
        //soft,sn
        // //Agrupar por código de fluxo de caixa

        // WITH BankAccLedgEntry DO BEGIN
        //     CLEAR(BankAccPostingBuffer[1]);
        //     BankAccPostingBuffer[1]."Bank Account" := "Bank Account No.";
        //     BankAccPostingBuffer[1]."Cash Flow Code" := "Cash-Flow Code";
        //     BankAccPostingBuffer[1].Amount := Amount;
        //     BankAccPostingBuffer[1]."Amount (LCY)" := "Amount (LCY)";

        //     UpdateBankAccPostingBuffer;
        // END;
        // //soft,en
        //XXX,end
    end;

    procedure UpdateBankAccPostingBuffer()
    var
        TempDimBuf: Record "Dimension Buffer" temporary;
        EntryNo: Integer;
    begin
        //XXX,begin
        //soft,sn
        // BankAccPostingBuffer[2] := BankAccPostingBuffer[1];
        // IF BankAccPostingBuffer[2].FIND THEN BEGIN
        //     BankAccPostingBuffer[2].Amount :=
        //       BankAccPostingBuffer[2].Amount + BankAccPostingBuffer[1].Amount;
        //     BankAccPostingBuffer[2]."Amount (LCY)" :=
        //       BankAccPostingBuffer[2]."Amount (LCY)" + BankAccPostingBuffer[1]."Amount (LCY)";
        //     BankAccPostingBuffer[2].MODIFY;
        // END ELSE
        //     BankAccPostingBuffer[1].INSERT;
        //soft,en
        //XXX,end
    end;
}

