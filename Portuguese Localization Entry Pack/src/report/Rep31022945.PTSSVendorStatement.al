report 31022945 "PTSS Vendor Statement"
{
    //Extrato Fornecedor

    DefaultLayout = RDLC;
    RDLCLayout = './Vendor Statement.rdlc';
    Caption = 'Vendor Statement';
    PreviewMode = Normal;
    UseSystemPrinter = false;

    dataset
    {
        dataitem(DataItem6836; Vendor)
        {
            DataItemTableView = SORTING ("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Name", "Currency Filter", "Date Filter", "PTSS Vendor Post. Group Filter";
            column(NoVend; "No.")
            {
            }
            dataitem(DataItem5444; Integer)
            {
                DataItemTableView = SORTING (Number)
                                    WHERE (Number = CONST (1));
                PrintOnlyIfDetail = true;
                column(CompanyInfo1Picture; CompanyInfo1.Picture)
                {
                }
                column(VendAddr1; VendAddr[1])
                {
                }
                column(CompanyAddr1; CompanyAddr[1])
                {
                }
                column(VendAddr2; VendAddr[2])
                {
                }
                column(CompanyAddr2; CompanyAddr[2])
                {
                }
                column(VendAddr3; VendAddr[3])
                {
                }
                column(CompanyAddr3; CompanyAddr[3])
                {
                }
                column(VendAddr4; VendAddr[4])
                {
                }
                column(CompanyAddr4; CompanyAddr[4])
                {
                }
                column(VendAddr5; VendAddr[5])
                {
                }
                column(PhoneNoCompanyInfo; CompanyInfo."Phone No.")
                {
                }
                column(VendAddr6; VendAddr[6])
                {
                }
                column(CompanyInfoEmail; CompanyInfo."E-Mail")
                {
                }
                column(CompanyInfoHomePage; CompanyInfo."Home Page")
                {
                }
                column(VATRegNoCompanyInfo; CompanyInfo."VAT Registration No.")
                {
                }
                column(BankNameCompanyInfo; CompanyInfo."Bank Name")
                {
                }
                column(BankAccNoCompanyInfo; CompanyInfo."Bank Account No.")
                {
                }
                column(No1Vend; Vendor."No.")
                {
                }
                column(TodayFormatted; FORMAT(TODAY))
                {
                }
                column(StartDate; FORMAT(StartDate))
                {
                }
                column(EndDate; FORMAT(EndDate))
                {
                }
                column(VendAddr7; VendAddr[7])
                {
                }
                column(VendAddr8; VendAddr[8])
                {
                }
                column(CompanyAddr7; CompanyAddr[7])
                {
                }
                column(CompanyAddr8; CompanyAddr[8])
                {
                }
                column(DocNoDtldVendLedgEntriesCaption; DtldVendLedgEntries.FIELDCAPTION("Document No."))
                {
                }
                column(DescVendLedgEntry2Caption; VendLedgEntry2.FIELDCAPTION(Description))
                {
                }
                column(RemainAmtVendLedgEntry2Caption; VendLedgEntry2.FIELDCAPTION("Remaining Amount"))
                {
                }
                column(OriginalAmtVendLedgEntry2Caption; VendLedgEntry2.FIELDCAPTION("Original Amount"))
                {
                }
                dataitem(CurrencyLoop; Integer)
                {
                    DataItemTableView = SORTING (Number)
                                        WHERE (Number = FILTER (1 ..));
                    PrintOnlyIfDetail = true;
                    dataitem(VendLedgEntryHdr; Integer)
                    {
                        DataItemTableView = SORTING (Number)
                                            WHERE (Number = CONST (1));
                        column(Currency2CodeVendLedgEntryHdr; STRSUBSTNO(Text001, CurrencyCode3))
                        {
                        }
                        column(StartBalance; StartBalance)
                        {
                            AutoFormatExpression = Currency2.Code;
                            AutoFormatType = 1;
                        }
                        column(CurrencyCode3; CurrencyCode3)
                        {
                        }
                        column(VendBalanceVendLedgEntryHdr; VendBalance)
                        {
                        }
                        column(PrintLine; PrintLine)
                        {
                        }
                        column(DtldVendLedgEntryType; FORMAT(DtldVendLedgEntries."Entry Type", 0, 2))
                        {
                        }
                        column(EntriesExists; EntriesExists)
                        {
                        }
                        column(IsNewVendCurrencyGroup; IsNewVendCurrencyGroup)
                        {
                        }
                        dataitem(DtldVendLedgEntries; "Detailed Vendor Ledg. Entry")
                        {
                            DataItemTableView = SORTING ("Vendor No.", "Posting Date", "Entry Type", "Currency Code");
                            column(PostDateDtldVendLedgEntries; FORMAT("Posting Date"))
                            {
                            }
                            column(DocNoDtldVendLedgEntries; "Document No.")
                            {
                            }
                            column(Description; Description)
                            {
                            }
                            column(DueDateDtldVendLedgEntries; FORMAT(DueDate))
                            {
                            }
                            column(CurrCodeDtldVendLedgEntries; "Currency Code")
                            {
                            }
                            column(AmtDtldVendLedgEntries; Amount)
                            {
                                AutoFormatExpression = "Currency Code";
                                AutoFormatType = 1;
                            }
                            column(RemainAmtDtldVendLedgEntries; RemainingAmount)
                            {
                                AutoFormatExpression = "Currency Code";
                                AutoFormatType = 1;
                            }
                            column(VendBalance; VendBalance)
                            {
                                AutoFormatExpression = "Currency Code";
                                AutoFormatType = 1;
                            }
                            column(Currency2Code; Currency2.Code)
                            {
                            }

                            trigger OnAfterGetRecord()
                            var
                                VendLedgerEntry: Record "Vendor Ledger Entry";
                            begin
                                IF SkipReversedUnapplied(DtldVendLedgEntries) OR (Amount = 0) THEN
                                    CurrReport.SKIP;
                                RemainingAmount := 0;
                                PrintLine := TRUE;
                                CASE "Entry Type" OF
                                    "Entry Type"::"Initial Entry":
                                        BEGIN
                                            VendLedgerEntry.GET("Vendor Ledger Entry No.");
                                            Description := VendLedgerEntry.Description;
                                            DueDate := VendLedgerEntry."Due Date";
                                            VendLedgerEntry.SETRANGE("Date Filter", 0D, EndDate);
                                            VendLedgerEntry.CALCFIELDS("Remaining Amount");
                                            RemainingAmount := VendLedgerEntry."Remaining Amount";
                                            VendLedgerEntry.SETRANGE("Date Filter");
                                        END;
                                    "Entry Type"::Application:
                                        BEGIN
                                            DtldVendLedgEntries2.SETCURRENTKEY("Vendor No.", "Posting Date", "Entry Type");
                                            DtldVendLedgEntries2.SETRANGE("Vendor No.", "Vendor No.");
                                            DtldVendLedgEntries2.SETRANGE("Posting Date", "Posting Date");
                                            DtldVendLedgEntries2.SETRANGE("Entry Type", "Entry Type"::Application);
                                            DtldVendLedgEntries2.SETRANGE("Transaction No.", "Transaction No.");
                                            DtldVendLedgEntries2.SETFILTER("Currency Code", '<>%1', "Currency Code");
                                            DtldVendLedgEntries2.SETFILTER("PTSS Vendor Posting Group", VendPostingGroupFilter);
                                            IF NOT DtldVendLedgEntries2.ISEMPTY THEN BEGIN
                                                Description := Text005;
                                                DueDate := 0D;
                                            END ELSE
                                                PrintLine := FALSE;
                                        END;
                                    "Entry Type"::"Payment Discount",
                                    "Entry Type"::"Payment Discount (VAT Excl.)",
                                    "Entry Type"::"Payment Discount (VAT Adjustment)",
                                    "Entry Type"::"Payment Discount Tolerance",
                                    "Entry Type"::"Payment Discount Tolerance (VAT Excl.)",
                                    "Entry Type"::"Payment Discount Tolerance (VAT Adjustment)":
                                        BEGIN
                                            Description := Text006;
                                            DueDate := 0D;
                                        END;
                                    "Entry Type"::"Payment Tolerance",
                                    "Entry Type"::"Payment Tolerance (VAT Excl.)",
                                    "Entry Type"::"Payment Tolerance (VAT Adjustment)":
                                        BEGIN
                                            Description := Text014;
                                            DueDate := 0D;
                                        END;
                                    "Entry Type"::"Appln. Rounding",
                                    "Entry Type"::"Correction of Remaining Amount":
                                        BEGIN
                                            Description := Text007;
                                            DueDate := 0D;
                                        END;
                                END;

                                IF PrintLine THEN BEGIN
                                    VendBalance := VendBalance + Amount;
                                    IsNewVendCurrencyGroup := IsFirstPrintLine;
                                    IsFirstPrintLine := FALSE;
                                    ClearCompanyPicture;
                                END;
                            end;

                            trigger OnPreDataItem()
                            begin
                                SETRANGE("Vendor No.", Vendor."No.");
                                SETRANGE("Posting Date", StartDate, EndDate);
                                SETRANGE("Currency Code", Currency2.Code);
                                SETFILTER("PTSS Vendor Posting Group", VendPostingGroupFilter);
                                IF Currency2.Code = '' THEN BEGIN
                                    GLSetup.TESTFIELD("LCY Code");
                                    CurrencyCode3 := GLSetup."LCY Code"
                                END ELSE
                                    CurrencyCode3 := Currency2.Code;

                                IsFirstPrintLine := TRUE;
                            end;
                        }
                    }
                    dataitem(VendLedgEntryFooter; Integer)
                    {
                        DataItemTableView = SORTING (Number)
                                            WHERE (Number = CONST (1));
                        column(CurrencyCode3VendLedgEntryFooter; CurrencyCode3)
                        {
                        }
                        column(VendBalanceVendLedgEntryHdrFooter; VendBalance)
                        {
                            AutoFormatExpression = Currency2.Code;
                            AutoFormatType = 1;
                        }
                        column(EntriesExistslVendLedgEntryFooterCaption; EntriesExists)
                        {
                        }
                    }
                    dataitem(VendLedgEntry2; "Vendor Ledger Entry")
                    {
                        DataItemLink = "Vendor No." = FIELD ("No.");
                        DataItemLinkReference = DataItem6836;
                        DataItemTableView = SORTING ("Vendor No.", Open, Positive, "Due Date");
                        column(OverDueEntries; STRSUBSTNO(Text002, Currency2.Code))
                        {
                        }
                        column(RemainAmtVendLedgEntry2; "Remaining Amount")
                        {
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PostDateVendLedgEntry2; FORMAT("Posting Date"))
                        {
                        }
                        column(DocNoVendLedgEntry2; "Document No.")
                        {
                        }
                        column(DescVendLedgEntry2; Description)
                        {
                        }
                        column(DueDateVendLedgEntry2; FORMAT("Due Date"))
                        {
                        }
                        column(OriginalAmtVendLedgEntry2; "Original Amount")
                        {
                            AutoFormatExpression = "Currency Code";
                        }
                        column(CurrCodeVendLedgEntry2; "Currency Code")
                        {
                        }
                        column(PrintEntriesDue; PrintEntriesDue)
                        {
                        }
                        column(Currency2CodeVendLedgEntry2; Currency2.Code)
                        {
                        }
                        column(CurrencyCode3VendLedgEntry2; CurrencyCode3)
                        {
                        }
                        column(VendNoVendLedgEntry2; "Vendor No.")
                        {
                        }

                        trigger OnAfterGetRecord()
                        var
                            VendLedgerEntry: Record "Vendor Ledger Entry";
                        begin
                            IF IncludeAgingBand THEN
                                IF ("Posting Date" > EndDate) AND ("Due Date" >= EndDate) THEN
                                    CurrReport.SKIP;
                            VendLedgerEntry := VendLedgEntry2;
                            VendLedgerEntry.SETRANGE("Date Filter", 0D, EndDate);
                            VendLedgerEntry.SETFILTER("Vendor Posting Group", VendPostingGroupFilter);
                            VendLedgerEntry.CALCFIELDS("Remaining Amount");
                            "Remaining Amount" := VendLedgerEntry."Remaining Amount";
                            IF VendLedgerEntry."Remaining Amount" = 0 THEN
                                CurrReport.SKIP;

                            IF IncludeAgingBand AND ("Posting Date" <= EndDate) THEN
                                UpdateBuffer(Currency2.Code, GetDate("Posting Date", "Due Date"), "Remaining Amount");
                            IF "Due Date" >= EndDate THEN
                                CurrReport.SKIP;
                        end;

                        trigger OnPreDataItem()
                        begin
                            CurrReport.CREATETOTALS("Remaining Amount");
                            IF NOT IncludeAgingBand THEN
                                SETRANGE("Due Date", 0D, EndDate - 1);
                            SETRANGE("Currency Code", Currency2.Code);
                            IF (NOT PrintEntriesDue) AND (NOT IncludeAgingBand) THEN
                                CurrReport.BREAK;
                        end;
                    }

                    trigger OnAfterGetRecord()
                    var
                        VendLedgerEntry: Record "Vendor Ledger Entry";
                    begin
                        IF Number = 1 THEN
                            Currency2.FINDFIRST;

                        REPEAT
                            IF NOT IsFirstLoop THEN
                                IsFirstLoop := TRUE
                            ELSE
                                IF Currency2.NEXT = 0 THEN
                                    CurrReport.BREAK;
                            VendLedgerEntry.SETRANGE("Vendor No.", Vendor."No.");
                            VendLedgerEntry.SETRANGE("Posting Date", 0D, EndDate);
                            VendLedgerEntry.SETRANGE("Currency Code", Currency2.Code);
                            VendLedgerEntry.SETFILTER("Vendor Posting Group", VendPostingGroupFilter);
                            EntriesExists := NOT VendLedgerEntry.ISEMPTY;
                        UNTIL EntriesExists;
                        Vend2 := Vendor;
                        Vend2.SETRANGE("Date Filter", 0D, StartDate - 1);
                        Vend2.SETRANGE("Currency Filter", Currency2.Code);
                        Vend2.SETFILTER("Vendor Posting Group", VendPostingGroupFilter);
                        Vend2.CALCFIELDS("Net Change");
                        StartBalance := -Vend2."Net Change";
                        VendBalance := -Vend2."Net Change";
                    end;

                    trigger OnPreDataItem()
                    begin
                        Vendor.COPYFILTER("Currency Filter", Currency2.Code);
                    end;
                }
                dataitem(AgingBandLoop; Integer)
                {
                    DataItemTableView = SORTING (Number)
                                        WHERE (Number = FILTER (1 ..));
                    column(AgingDate1; FORMAT(AgingDate[1] + 1))
                    {
                    }
                    column(AgingDate2; FORMAT(AgingDate[2]))
                    {
                    }
                    column(AgingDate21; FORMAT(AgingDate[2] + 1))
                    {
                    }
                    column(AgingDate3; FORMAT(AgingDate[3]))
                    {
                    }
                    column(AgingDate31; FORMAT(AgingDate[3] + 1))
                    {
                    }
                    column(AgingDate4; FORMAT(AgingDate[4]))
                    {
                    }
                    column(AgingBandEndingDate; STRSUBSTNO(Text011, AgingBandEndingDate, PeriodLength, SELECTSTR(DateChoice + 1, Text013)))
                    {
                    }
                    column(AgingDate41; FORMAT(AgingDate[4] + 1))
                    {
                    }
                    column(AgingDate5; FORMAT(AgingDate[5]))
                    {
                    }
                    column(AgingBandBufCol1Amt; AgingBandBuf."Column 1 Amt.")
                    {
                        AutoFormatExpression = AgingBandBuf."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(AgingBandBufCol2Amt; AgingBandBuf."Column 2 Amt.")
                    {
                        AutoFormatExpression = AgingBandBuf."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(AgingBandBufCol3Amt; AgingBandBuf."Column 3 Amt.")
                    {
                        AutoFormatExpression = AgingBandBuf."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(AgingBandBufCol4Amt; AgingBandBuf."Column 4 Amt.")
                    {
                        AutoFormatExpression = AgingBandBuf."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(AgingBandBufCol5Amt; AgingBandBuf."Column 5 Amt.")
                    {
                        AutoFormatExpression = AgingBandBuf."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(AgingBandCurrencyCode; AgingBandCurrencyCode)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        IF Number = 1 THEN BEGIN
                            ClearCompanyPicture;
                            IF NOT AgingBandBuf.FIND('-') THEN
                                CurrReport.BREAK;
                        END ELSE
                            IF AgingBandBuf.NEXT = 0 THEN
                                CurrReport.BREAK;
                        AgingBandCurrencyCode := AgingBandBuf."Currency Code";
                        IF AgingBandCurrencyCode = '' THEN
                            AgingBandCurrencyCode := GLSetup."LCY Code";
                    end;

                    trigger OnPreDataItem()
                    begin
                        IF NOT IncludeAgingBand THEN
                            CurrReport.BREAK;
                    end;
                }
            }

            trigger OnAfterGetRecord()
            var
                VendLedgerEntry: Record "Vendor Ledger Entry";
                language: Record Language;
            begin
                SETFILTER("PTSS Vendor Post. Group Filter", VendPostingGroupFilter);
                IF FirstVendorPrinted THEN BEGIN
                    CLEAR(CompanyInfo1.Picture);
                END;
                FirstVendorPrinted := TRUE;
                AgingBandBuf.DELETEALL;
                //Foi removida a Funcao GetLanguageID de BC online
                //CurrReport.LANGUAGE := Language.GetLanguageID("Language Code");
                PrintLine := FALSE;
                Vend2 := Vendor;
                COPYFILTER("Currency Filter", Currency2.Code);
                IF PrintAllHavingBal THEN BEGIN
                    IF Currency2.FINDSET THEN
                        REPEAT
                            Vend2.SETRANGE("Date Filter", 0D, EndDate);
                            Vend2.SETRANGE("Currency Filter", Currency2.Code);
                            Vend2.SETFILTER("PTSS Vendor Post. Group Filter", VendPostingGroupFilter);
                            Vend2.CALCFIELDS("Net Change");
                            PrintLine := Vend2."Net Change" <> 0;
                        UNTIL (Currency2.NEXT = 0) OR PrintLine;
                END;
                IF NOT PrintLine AND PrintAllHavingEntry THEN BEGIN
                    VendLedgerEntry.SETRANGE("Vendor No.", "No.");
                    VendLedgerEntry.SETRANGE("Posting Date", StartDate, EndDate);
                    VendLedgerEntry.SETFILTER("Vendor Posting Group", VendPostingGroupFilter);
                    COPYFILTER("Currency Filter", VendLedgerEntry."Currency Code");
                    PrintLine := NOT VendLedgerEntry.ISEMPTY;
                END;
                IF NOT PrintLine THEN
                    CurrReport.SKIP;

                // If we have any line that's flagged for printing, set output flag
                OutputGenerated := TRUE;

                FormatAddr.Vendor(VendAddr, Vendor);
                CurrReport.PAGENO := 1;

                IsFirstLoop := FALSE;
            end;

            trigger OnPreDataItem()
            begin
                VerifyDates;
                AgingBandEndingDate := EndDate;
                CalcAgingBandDates;

                CompanyInfo.GET;
                FormatAddr.Company(CompanyAddr, CompanyInfo);

                Currency2.Code := '';
                Currency2.INSERT;
                COPYFILTER("Currency Filter", Currency.Code);
                IF Currency.FINDSET THEN
                    REPEAT
                        Currency2 := Currency;
                        Currency2.INSERT;
                    UNTIL Currency.NEXT = 0;
                VendPostingGroupFilter := GETFILTER("PTSS Vendor Post. Group Filter");
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
                    field("Start Date"; StartDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Start Date';
                        ToolTip = 'Specifies the date from which the report or batch job processes information.';
                    }
                    field("End Date"; EndDate)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'End Date';
                        ToolTip = 'Specifies the date to which the report or batch job processes information.';
                    }
                    field(ShowOverdueEntries; PrintEntriesDue)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show Overdue Entries';
                        ToolTip = 'Specifies if you want overdue entries to be shown separately for each currency.';
                    }
                    group(Include)
                    {
                        Caption = 'Include';
                        field(IncludeAllVendorswithLE; PrintAllHavingEntry)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Include All Vendors with Ledger Entries';
                            MultiLine = true;
                            ToolTip = 'Specifies if you want entries displayed for vendors that have ledger entries at the end of the selected period.';

                            trigger OnValidate()
                            begin
                                IF NOT PrintAllHavingEntry THEN
                                    PrintAllHavingBal := TRUE;
                            end;
                        }
                        field(IncludeAllVendorswithBalance; PrintAllHavingBal)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Include All Vendors with a Balance';
                            MultiLine = true;
                            ToolTip = 'Specifies if you want entries displayed for vendors that have a balance at the end of the selected period.';

                            trigger OnValidate()
                            begin
                                IF NOT PrintAllHavingBal THEN
                                    PrintAllHavingEntry := TRUE;
                            end;
                        }
                        field(IncludeReversedEntries; PrintReversedEntries)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Include Reversed Entries';
                            ToolTip = 'Specifies if you want to include reversed entries in the report.';
                        }
                        field(IncludeUnappliedEntries; PrintUnappliedEntries)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Include Unapplied Entries';
                            ToolTip = 'Specifies if you want to include unapplied entries in the report.';
                        }
                    }
                    group("Aging Band")
                    {
                        Caption = 'Aging Band';
                        field(IncludeAgingBand; IncludeAgingBand)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Include Aging Band';
                            ToolTip = 'Specifies if you want an aging band to be included in the document. If you place a check mark here, you must also fill in the Aging Band Period Length and Aging Band by fields.';
                        }
                        field(AgingBandPeriodLengt; PeriodLength)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Aging Band Period Length';
                            ToolTip = 'Specifies the length of each of the four periods in the aging band, for example, enter "1M" for one month. The most recent period will end on the last day of the period in the Date Filter field.';
                        }
                        field(AgingBandby; DateChoice)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Aging Band by';
                            OptionCaption = 'Due Date,Posting Date';
                            ToolTip = 'Specifies if the aging band will be calculated from the due date or from the posting date.';
                        }
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Specifies that interactions with the contact are logged.';
                    }
                }
                group("Output Options")
                {
                    Caption = 'Output Options';
                    field(ReportOutput; SupportedOutputMethod)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Report Output';
                        OptionCaption = 'Print,Preview,PDF,Email,Excel,XML';
                        ToolTip = 'Specifies the output of the scheduled report, such as PDF or Word.';

                        trigger OnValidate()
                        var
                            CustomLayoutReporting: Codeunit "Custom Layout Reporting";
                        begin
                            ShowPrintRemaining := (SupportedOutputMethod = SupportedOutputMethod::Email);

                            CASE SupportedOutputMethod OF
                                SupportedOutputMethod::Print:
                                    ChosenOutputMethod := CustomLayoutReporting.GetPrintOption;
                                SupportedOutputMethod::Preview:
                                    ChosenOutputMethod := CustomLayoutReporting.GetPreviewOption;
                                SupportedOutputMethod::PDF:
                                    ChosenOutputMethod := CustomLayoutReporting.GetPDFOption;
                                SupportedOutputMethod::Email:
                                    ChosenOutputMethod := CustomLayoutReporting.GetEmailOption;
                                SupportedOutputMethod::Excel:
                                    ChosenOutputMethod := CustomLayoutReporting.GetExcelOption;
                                SupportedOutputMethod::XML:
                                    ChosenOutputMethod := CustomLayoutReporting.GetXMLOption;
                            END;
                        end;
                    }
                    field(ChosenOutput; ChosenOutputMethod)
                    {
                        Caption = 'Chosen Output';
                        Visible = false;
                    }
                    group(EmailOptions)
                    {
                        Caption = 'Email Options';
                        Visible = ShowPrintRemaining;
                        field(PrintMissingAddresses; PrintRemaining)
                        {
                            Caption = 'Print remaining statements';
                        }
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            InitRequestPageDataInternal;
        end;
    }

    labels
    {
        Statement = 'Statement';
        PhoneNo = 'Phone No.';
        VATRegNo = 'VAT Registration No.';
        BankName = 'Bank';
        BankAccNo = 'Account No';
        No1Vendor = 'Vendor No';
        StartDateInit = 'Starting Date';
        EndDateInit = 'Ending Date';
        PostingDateDtldVendLedgEntries = 'Posting Date';
        DueDateVendorLedgEntry2 = 'Due Date';
        VendorBalance = 'Balance';
        before = '..before';
        CompanyHomepage = 'Home Page';
        CompanyEmail = 'E-Mail';
        DocDate = 'Document Date';
        Total = 'Total';
        CurrReportPageNo = 'Page';
    }

    trigger OnInitReport()
    begin
        GLSetup.GET;
        PurchSetup.GET;

        CompanyInfo1.GET;
        CompanyInfo1.CALCFIELDS(Picture);

        OutputGenerated := FALSE;
        LogInteractionEnable := TRUE;
    end;

    trigger OnPostReport()
    begin
        IF NOT OutputGenerated THEN
            ERROR(NoOutputErr);
    end;

    trigger OnPreReport()
    begin
        InitRequestPageDataInternal;
    end;

    var

        Text001: Label 'Entries %1';
        Text002: Label 'Overdue Entries %1';
        Text003: Label 'Statement ';
        Vendor: Record Vendor;
        GLSetup: Record "General Ledger Setup";
        PurchSetup: Record "Purchases & Payables Setup";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        Vend2: Record Vendor;
        Currency: Record Currency;
        Currency2: Record Currency temporary;
        Language: Record Language;
        DtldVendLedgEntries2: Record "Detailed Vendor Ledg. Entry";
        AgingBandBuf: Record "Aging Band Buffer" temporary;
        FormatAddr: Codeunit "Format Address";
        SegManagement: Codeunit SegManagement;
        PrintAllHavingEntry: Boolean;
        PrintAllHavingBal: Boolean;
        PrintEntriesDue: Boolean;
        PrintUnappliedEntries: Boolean;
        PrintReversedEntries: Boolean;
        PrintLine: Boolean;
        LogInteraction: Boolean;
        EntriesExists: Boolean;
        StartDate: Date;
        EndDate: Date;
        DueDate: Date;
        VendAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        Description: Text[50];
        StartBalance: Decimal;
        VendBalance: Decimal;
        RemainingAmount: Decimal;
        CurrencyCode3: Code[10];
        Text005: Label 'Multicurrency Application';
        Text006: Label 'Payment Discount';
        Text007: Label 'Rounding';
        PeriodLength: DateFormula;
        PeriodLength2: DateFormula;
        DateChoice: Option "Due Date","Posting Date";
        AgingDate: array[5] of Date;
        Text008: Label 'You must specify the Aging Band Period Length.';
        AgingBandEndingDate: Date;
        Text010: Label 'You must specify Aging Band Ending Date.';
        Text011: Label 'Aged Summary by %1 (%2 by %3)';
        IncludeAgingBand: Boolean;
        Text012: Label 'Period Length is out of range.';
        AgingBandCurrencyCode: Code[20];
        Text013: Label 'Due Date,Posting Date';
        Text014: Label 'Application Writeoffs';
        [InDataSet]
        LogInteractionEnable: Boolean;
        Text036: Label '-%1', Comment = 'Negating the period length: %1 is the period length';
        isInitialized: Boolean;
        IsFirstLoop: Boolean;
        IsFirstPrintLine: Boolean;
        IsNewVendCurrencyGroup: Boolean;
        SupportedOutputMethod: Option Print,Preview,PDF,Email,Excel,XML;
        ChosenOutputMethod: Integer;
        PrintRemaining: Boolean;
        [InDataSet]
        ShowPrintRemaining: Boolean;
        FirstVendorPrinted: Boolean;
        OutputGenerated: Boolean;
        VendPostingGroupFilter: Text[250];
        BlankStartDateErr: Label 'Start Date must have a value.';
        BlankEndDateErr: Label 'End Date must have a value.';
        StartDateLaterTheEndDateErr: Label 'Start date must be earlier than End date.';
        NoOutputErr: Label 'No data was returned for the report using the selected data filters.';

    local procedure GetDate(PostingDate: Date; DueDate: Date): Date
    begin
        IF DateChoice = DateChoice::"Posting Date" THEN
            EXIT(PostingDate);

        EXIT(DueDate);
    end;

    local procedure CalcAgingBandDates()
    begin
        IF NOT IncludeAgingBand THEN
            EXIT;
        IF AgingBandEndingDate = 0D THEN
            ERROR(Text010);
        IF FORMAT(PeriodLength) = '' THEN
            ERROR(Text008);
        EVALUATE(PeriodLength2, STRSUBSTNO(Text036, PeriodLength));
        AgingDate[5] := AgingBandEndingDate;
        AgingDate[4] := CALCDATE(PeriodLength2, AgingDate[5]);
        AgingDate[3] := CALCDATE(PeriodLength2, AgingDate[4]);
        AgingDate[2] := CALCDATE(PeriodLength2, AgingDate[3]);
        AgingDate[1] := CALCDATE(PeriodLength2, AgingDate[2]);
        IF AgingDate[2] <= AgingDate[1] THEN
            ERROR(Text012);
    end;

    local procedure UpdateBuffer(CurrencyCode: Code[10]; Date: Date; Amount: Decimal)
    var
        I: Integer;
        GoOn: Boolean;
    begin
        AgingBandBuf.INIT;
        AgingBandBuf."Currency Code" := CurrencyCode;
        IF NOT AgingBandBuf.FIND THEN
            AgingBandBuf.INSERT;
        I := 1;
        GoOn := TRUE;
        WHILE (I <= 5) AND GoOn DO BEGIN
            IF Date <= AgingDate[I] THEN
                IF I = 1 THEN BEGIN
                    AgingBandBuf."Column 1 Amt." := AgingBandBuf."Column 1 Amt." + Amount;
                    GoOn := FALSE;
                END;
            IF Date <= AgingDate[I] THEN
                IF I = 2 THEN BEGIN
                    AgingBandBuf."Column 2 Amt." := AgingBandBuf."Column 2 Amt." + Amount;
                    GoOn := FALSE;
                END;
            IF Date <= AgingDate[I] THEN
                IF I = 3 THEN BEGIN
                    AgingBandBuf."Column 3 Amt." := AgingBandBuf."Column 3 Amt." + Amount;
                    GoOn := FALSE;
                END;
            IF Date <= AgingDate[I] THEN
                IF I = 4 THEN BEGIN
                    AgingBandBuf."Column 4 Amt." := AgingBandBuf."Column 4 Amt." + Amount;
                    GoOn := FALSE;
                END;
            IF Date <= AgingDate[I] THEN
                IF I = 5 THEN BEGIN
                    AgingBandBuf."Column 5 Amt." := AgingBandBuf."Column 5 Amt." + Amount;
                    GoOn := FALSE;
                END;
            I := I + 1;
        END;
        AgingBandBuf.MODIFY;
    end;

    procedure SkipReversedUnapplied(var DtldVendLedgEntries: Record "Detailed Vendor Ledg. Entry"): Boolean
    var
        VendLedgerEntry: Record "Vendor Ledger Entry";
    begin
        IF PrintReversedEntries AND PrintUnappliedEntries THEN
            EXIT(FALSE);
        IF NOT PrintUnappliedEntries THEN
            IF DtldVendLedgEntries.Unapplied THEN
                EXIT(TRUE);
        IF NOT PrintReversedEntries THEN BEGIN
            VendLedgerEntry.GET(DtldVendLedgEntries."Vendor Ledger Entry No.");
            IF VendLedgerEntry.Reversed THEN
                EXIT(TRUE);
        END;
        EXIT(FALSE);
    end;

    procedure InitializeRequest(NewPrintEntriesDue: Boolean; NewPrintAllHavingEntry: Boolean; NewPrintAllHavingBal: Boolean; NewPrintReversedEntries: Boolean; NewPrintUnappliedEntries: Boolean; NewIncludeAgingBand: Boolean; NewPeriodLength: Text[30]; NewDateChoice: Option; NewLogInteraction: Boolean; NewStartDate: Date; NewEndDate: Date)
    begin
        InitRequestPageDataInternal;

        PrintEntriesDue := NewPrintEntriesDue;
        PrintAllHavingEntry := NewPrintAllHavingEntry;
        PrintAllHavingBal := NewPrintAllHavingBal;
        PrintReversedEntries := NewPrintReversedEntries;
        PrintUnappliedEntries := NewPrintUnappliedEntries;
        IncludeAgingBand := NewIncludeAgingBand;
        EVALUATE(PeriodLength, NewPeriodLength);
        DateChoice := NewDateChoice;
        LogInteraction := NewLogInteraction;
        StartDate := NewStartDate;
        EndDate := NewEndDate;
    end;

    procedure InitRequestPageDataInternal()
    begin
        IF isInitialized THEN
            EXIT;

        isInitialized := TRUE;

        IF (NOT PrintAllHavingEntry) AND (NOT PrintAllHavingBal) THEN
            PrintAllHavingBal := TRUE;

        LogInteraction := SegManagement.FindInteractTmplCode(7) <> '';
        LogInteractionEnable := LogInteraction;

        IF FORMAT(PeriodLength) = '' THEN
            EVALUATE(PeriodLength, '<1M+CM>');

        ShowPrintRemaining := SupportedOutputMethod = SupportedOutputMethod::Email;
    end;

    local procedure VerifyDates()
    begin
        IF StartDate = 0D THEN
            ERROR(BlankStartDateErr);
        IF EndDate = 0D THEN
            ERROR(BlankEndDateErr);
        IF StartDate > EndDate THEN
            ERROR(StartDateLaterTheEndDateErr);
    end;

    local procedure ClearCompanyPicture()
    begin
        IF FirstVendorPrinted THEN BEGIN
            CLEAR(CompanyInfo1.Picture);
        END;
        FirstVendorPrinted := TRUE;
    end;
}

