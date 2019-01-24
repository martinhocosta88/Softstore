report 31022897 "PTSS Trial Balance - 7/4 Col."
{
    //Balancetes

    DefaultLayout = RDLC;
    RDLCLayout = './Trial Balance - 74 Columns.rdlc';
    Caption = 'Trial Balance - 7/4 Columns';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(DataItem6710; "G/L Account")
        {
            RequestFilterFields = "No.", "Account Type", "Date Filter";
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(USERID; USERID)
            {
            }
            // column(CurrReport_PAGENO; CurrReport.PAGENO)
            // {
            // }
            column(FORMATTODAY04; FORMAT(TODAY, 0, 4))
            {
            }
            column(TextHeader1; TextHeader[1])
            {
            }
            column(TextHeader2; TextHeader[2])
            {
            }
            column(TextHeader3; TextHeader[3])
            {
            }
            column(TitleReport; TitleReport)
            {
            }
            column(TextHeader4; TextHeader[4])
            {
            }
            column(HeaderText; HeaderText)
            {
            }
            column(GLAccountNo; "No.")
            {
            }
            column(Typeequaltypeperiod; Type = Type::Period)
            {
            }
            dataitem(BlankLinesNumber; Integer)
            {
                DataItemTableView = SORTING (Number);
                column(BlankLineNo; "No. of Blank Lines")
                {
                }

                trigger OnPreDataItem()
                begin
                    SETRANGE(Number, 1, "No. of Blank Lines");
                end;
            }
            dataitem(DataItem5444; Integer)
            {
                DataItemTableView = SORTING (Number)
                                    WHERE (Number = CONST (1));
                column(DebitPeriod; DebitPeriod)
                {
                }
                column(CreditPeriod; CreditPeriod)
                {
                }
                column(DebitBalance; DebitBalance)
                {
                }
                column(CreditBalance; CreditBalance)
                {
                }
                column(PADSTRGLAccountIndentation2GLAccountName; PADSTR('', Indentation * 2) + Name)
                {
                }
                column(GLAccountNumber; "No.")
                {
                }
                column(BeforeDebitAmtOpenDebitAmt; BeforeDebitAmt + OpenDebitAmt)
                {
                }
                column(BeforeCreditAmtOpenCreditAmt; BeforeCreditAmt + OpenCreditAmt)
                {
                }
                column(DebitPeriod_BeforeDebitAmtOpenDebitAmt; DebitPeriod + BeforeDebitAmt + OpenDebitAmt)
                {
                }
                column(CreditPeriod_BeforeCreditAmtOpenCreditAmt; CreditPeriod + BeforeCreditAmt + OpenCreditAmt)
                {
                }
                column(TotDebitPeriod; TotDebitPeriod)
                {
                }
                column(TotCreditPeriod; TotCreditPeriod)
                {
                }
                column(TotDebitBeforePeriodTotOpenDebit; TotDebitBeforePeriod + TotOpenDebit)
                {
                }
                column(TotCreditBeforePeriodTotOpenCredit; TotCreditBeforePeriod + TotOpenCredit)
                {
                }
                column(TotDebitPeriodTotDebitBeforePeriodTotOpenDebit; TotDebitPeriod + TotDebitBeforePeriod + TotOpenDebit)
                {
                }
                column(TotCreditPeriodTotCreditBeforePeriodTotOpenCredit; TotCreditPeriod + TotCreditBeforePeriod + TotOpenCredit)
                {
                }
                column(TotDebitBalance; TotDebitBalance)
                {
                }
                column(TotCreditBalance; TotCreditBalance)
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                CALCFIELDS("Debit Amount", "Credit Amount", "Balance at Date", "Add.-Currency Debit Amount",
                           "Add.-Currency Credit Amount", "Add.-Currency Balance at Date");

                OpenCreditAmt := 0;
                OpenDebitAmt := 0;
                BeforeDebitAmt := 0;
                BeforeCreditAmt := 0;

                I := I + 1;
                IF I = 1 THEN
                    FixedLevel := STRLEN("No.");
                IF (COPYSTR("No.", 1, 1) <> PrevAccount) AND (STRLEN("No.") >= FixedLevel) THEN BEGIN
                    Accumulate := TRUE;
                    FirstLevel := STRLEN("No.");
                END ELSE
                    IF (STRLEN("No.") <= PreviousLevel) AND (STRLEN("No.") <= FirstLevel) AND (STRLEN("No.") >= FixedLevel) THEN
                        Accumulate := TRUE
                    ELSE
                        Accumulate := FALSE;

                IF NOT PrintValuesAddCurr THEN BEGIN
                    DebitPeriod := "Debit Amount";
                    CreditPeriod := "Credit Amount";
                END ELSE BEGIN
                    DebitPeriod := "Add.-Currency Debit Amount";
                    CreditPeriod := "Add.-Currency Credit Amount";
                END;

                IF OpeningFilter <> '' THEN
                    CalcOpenEntries(Rec);

                IF (PeriodFilter <> '') AND (BeforeFilter <> '') THEN
                    CalcBeforePeriod(Rec);

                CreditBalance := 0;
                DebitBalance := 0;

                IF "Account Type" = "Account Type"::Total THEN BEGIN
                    CreditBalance := ABS(GetBalance(FALSE, Totaling, 0D, EndDate, PrintValuesAddCurr));
                    DebitBalance := GetBalance(TRUE, Totaling, 0D, EndDate, PrintValuesAddCurr);
                END ELSE BEGIN
                    IF NOT PrintValuesAddCurr THEN
                        IF "Balance at Date" > 0 THEN
                            DebitBalance := "Balance at Date"
                        ELSE
                            CreditBalance := ABS("Balance at Date")
                    ELSE
                        IF "Add.-Currency Balance at Date" > 0 THEN
                            DebitBalance := "Add.-Currency Balance at Date"
                        ELSE
                            CreditBalance := ABS("Add.-Currency Balance at Date");
                END;

                IF Accumulate THEN BEGIN
                    TotDebitPeriod := TotDebitPeriod + DebitPeriod;
                    TotCreditPeriod := TotCreditPeriod + CreditPeriod;
                    TotDebitBalance := TotDebitBalance + DebitBalance;
                    TotCreditBalance := TotCreditBalance + CreditBalance;
                END;

                IF (STRLEN("No.") >= FixedLevel) THEN BEGIN
                    PreviousLevel := STRLEN("No.");
                    PrevAccount := COPYSTR("No.", 1, 1);
                END;

                IF PrintWithBalance AND
                   ((OpenDebitAmt + OpenCreditAmt) = 0) AND
                   ((BeforeCreditAmt + BeforeDebitAmt) = 0) AND
                   ((CreditPeriod + DebitPeriod) = 0) AND
                   ((DebitBalance + CreditBalance) = 0) THEN
                    CurrReport.SKIP;
            end;

            trigger OnPostDataItem()
            var
                GLAcc: Record "G/L Account" temporary;
            begin
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CREATETOTALS(DebitPeriod, CreditPeriod, OpenDebitAmt, OpenCreditAmt, CreditBalance, DebitBalance,
                                        OpenDebitAmt, OpenCreditAmt);

                TotDebitPeriod := 0;
                TotCreditPeriod := 0;
                TotDebitBalance := 0;
                TotCreditBalance := 0;
                TotDebitBeforePeriod := 0;
                TotCreditBeforePeriod := 0;
                TotOpenDebit := 0;
                TotOpenCredit := 0;
            end;
        }
    }

    requestpage
    {
        SourceTable = "G/L Account";

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(Type; Type)
                    {
                        OptionCaption = 'Period/Accumulated,Period';

                        trigger OnValidate()
                        begin
                            IF Type = Type::Period THEN
                                PeriodTypeOnValidate;
                            IF Type = Type::"Period/Accumulated" THEN
                                PeriodAccumulatTypeOnValidate;
                        end;
                    }
                    field(PrintWithBalance; PrintWithBalance)
                    {
                        Caption = 'Only Accounts with values';
                    }
                    field(PrintValuesAddCurr; PrintValuesAddCurr)
                    {
                        Caption = 'Show Amounts in Add. Currency';
                    }
                    field(Abertura; OpenEntries)
                    {
                        Caption = 'With openning values';
                        Enabled = AberturaEnable;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            AberturaEnable := TRUE;
        end;

        trigger OnOpenPage()
        begin
            PrintWithBalance := TRUE;
        end;
    }

    labels
    {
        CurrReportPAGENO = 'Page';
        Period = 'Period';
        Name = 'Name';
        Debit = 'Debit';
        AccumPeriodDate = 'Accum. PeriodDate';
        Credit = 'Credit';
        TrialBalance = 'Trial Balance';
        Balance = 'Balance';
        Acc = 'Acc.';
        Accumulated = 'Accumulated';
        AccumBeforePeriod = 'Accum. Before Period';
        AccumatEndofPeriodl = 'Accum. at End of Period';
        Total = 'Total';
    }

    trigger OnPreReport()
    begin
        PeriodFilter := GLAcc.GETFILTER("Date Filter");
        StartDate := GLAcc.GETRANGEMIN("Date Filter");
        EndDate := GLAcc.GETRANGEMAX("Date Filter");
        IF StartPeriod(NORMALDATE(GLAcc.GETRANGEMIN("Date Filter"))) <> NORMALDATE(GLAcc.GETRANGEMIN("Date Filter")) THEN
            BeforeFilter := FORMAT(StartPeriod(StartDate), 0, 1) + Text31022898 +
                            FORMAT(StartDate - 1, 0, 1);
        IF OpenEntries THEN
            OpeningFilter := Text31022890 + FORMAT(StartPeriod(StartDate) - 1, 0, 1);
        TextHeader[1] := Text31022891 + GLAcc.GETFILTERS();
        IF PrintWithBalance THEN
            TextHeader[2] := Text31022892
        ELSE
            TextHeader[2] := Text31022893;
        IF OpenEntries THEN TextHeader[4] := Text31022894;

        TitleReport := Text31022895;

        CalcAccountFilter(GLAcc);


        GLSetup.GET;
        IF PrintValuesAddCurr THEN BEGIN
            GLSetup.TESTFIELD("Additional Reporting Currency");
            HeaderText := STRSUBSTNO(Text31022899, GLSetup."Additional Reporting Currency")
        END ELSE BEGIN
            GLSetup.TESTFIELD("LCY Code");
            HeaderText := STRSUBSTNO(Text31022899, GLSetup."LCY Code");
        END;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        GLAcc: Record "G/L Account";
        Periods: Record "Accounting Period";
        OpeningFilter: Text[30];
        BeforeFilter: Text[30];
        PeriodFilter: Text[30];
        AccFilter: Text[30];
        TitleReport: Text[40];
        TextHeader: array[4] of Text[150];
        StartDate: Date;
        EndDate: Date;
        OpenCreditAmt: Decimal;
        OpenDebitAmt: Decimal;
        BeforeDebitAmt: Decimal;
        BeforeCreditAmt: Decimal;
        CreditBalance: Decimal;
        DebitBalance: Decimal;
        DebitPeriod: Decimal;
        CreditPeriod: Decimal;
        TotDebitBalance: Decimal;
        TotCreditBalance: Decimal;
        PrintWithBalance: Boolean;
        PrintValuesAddCurr: Boolean;
        PrintHeader: Boolean;
        OpenEntries: Boolean;
        Type: Option "Period/Accumulated",Period;
        Text31022890: Label '..C';
        Text31022891: Label 'Account Filter:';
        Text31022892: Label 'Only Accounts with values';
        Text31022893: Label 'Also accounts with no values';
        Text31022894: Label 'With openning values';
        Text31022895: Label 'Trial Balance ';
        Text31022896: Label 'Fiscal period do not Exist!';
        Text31022897: Label '<= %1';
        Text31022898: Label '..';
        AccountFilter: Text[250];
        Text31022899: Label 'All Amounts in %1';
        HeaderText: Text[30];
        [InDataSet]
        AberturaEnable: Boolean;
        TotDebitPeriod: Decimal;
        TotCreditPeriod: Decimal;
        TotDebitBeforePeriod: Decimal;
        TotCreditBeforePeriod: Decimal;
        TotOpenDebit: Decimal;
        TotOpenCredit: Decimal;
        PrevAccount: Text[20];
        Accumulate: Boolean;
        FirstLevel: Integer;
        PreviousLevel: Integer;
        FixedLevel: Integer;
        I: Integer;

    procedure StartPeriod(Date: Date): Date
    var
        PerContco: Record "Accounting Period";
    begin
        PerContco.SETRANGE("New Fiscal Year", TRUE);
        PerContco.SETFILTER("Starting Date", Text31022897, Date);
        IF PerContco.FIND('+') THEN
            EXIT(PerContco."Starting Date")
        ELSE
            ERROR(Text31022896);
    end;

    procedure CalcOpenEntries(GLAccParam: Record "G/L Account")
    var
        GLAccOE: Record "G/L Account";
    begin
        GLAccOE := GLAccParam;
        GLAccOE.SETFILTER("Date Filter", OpeningFilter);
        GLAccOE.CALCFIELDS("Debit Amount", "Credit Amount", "Net Change", "Add.-Currency Debit Amount",
                   "Add.-Currency Credit Amount", "Additional-Currency Net Change");

        IF GLAccOE."Account Type" = GLAccOE."Account Type"::Total THEN BEGIN
            OpenCreditAmt := ABS(GLAccOE.GetBalance(FALSE, GLAccOE.Totaling, 0D,
                                                    GLAccOE.GETRANGEMAX(GLAccOE."Date Filter"), PrintValuesAddCurr));
            OpenDebitAmt := GLAccOE.GetBalance(TRUE, GLAccOE.Totaling, 0D,
                                                GLAccOE.GETRANGEMAX(GLAccOE."Date Filter"), PrintValuesAddCurr);
        END ELSE BEGIN
            IF GLAccOE."Net Change" > 0 THEN
                IF NOT PrintValuesAddCurr THEN
                    OpenDebitAmt := GLAccOE."Net Change"
                ELSE
                    OpenDebitAmt := GLAccOE."Additional-Currency Net Change"
            ELSE
                IF NOT PrintValuesAddCurr THEN
                    OpenCreditAmt := ABS(GLAccOE."Net Change")
                ELSE
                    OpenCreditAmt := ABS(GLAccOE."Additional-Currency Net Change");

            TotOpenDebit := TotOpenDebit + OpenDebitAmt;
            TotOpenCredit := TotOpenCredit + OpenCreditAmt;
        END;
    end;

    procedure CalcBeforePeriod(GLAccParam: Record "G/L Account")
    var
        GLAccOE: Record "G/L Account";
    begin
        GLAccOE := GLAccParam;
        GLAccOE.SETFILTER("Date Filter", BeforeFilter);
        GLAccOE.CALCFIELDS("Debit Amount", "Credit Amount", "Add.-Currency Debit Amount", "Add.-Currency Credit Amount");
        IF NOT PrintValuesAddCurr THEN BEGIN
            BeforeDebitAmt := GLAccOE."Debit Amount";
            BeforeCreditAmt := GLAccOE."Credit Amount";
        END ELSE BEGIN
            BeforeDebitAmt := GLAccOE."Add.-Currency Debit Amount";
            BeforeCreditAmt := GLAccOE."Add.-Currency Credit Amount";
        END;

        IF GLAccParam."Account Type" = GLAccParam."Account Type"::Posting THEN BEGIN
            TotDebitBeforePeriod := TotDebitBeforePeriod + BeforeDebitAmt;
            TotCreditBeforePeriod := TotCreditBeforePeriod + BeforeCreditAmt;
        END;
    end;

    procedure CalcAccountFilter(GLAccParam: Record "G/L Account")
    var
        xFilter: Text[250];
        xCount: Integer;
    begin
        AccountFilter := '';
        xFilter := GLAccParam.GETFILTER("No.");
        FOR xCount := 1 TO STRLEN(xFilter) DO
            IF COPYSTR(xFilter, xCount, 1) = '|' THEN
                AccountFilter := AccountFilter + '*|'
            ELSE
                AccountFilter := AccountFilter + COPYSTR(xFilter, xCount, 1);
        IF xFilter <> AccountFilter THEN
            AccountFilter := AccountFilter + '*';
    end;

    local procedure PeriodAccumulatTypeOnPush()
    begin
        AberturaEnable := TRUE;
    end;

    local procedure PeriodTypeOnPush()
    begin
        AberturaEnable := FALSE;
        OpenEntries := FALSE;
    end;

    local procedure PeriodAccumulatTypeOnValidate()
    begin
        PeriodAccumulatTypeOnPush;
    end;

    local procedure PeriodTypeOnValidate()
    begin
        PeriodTypeOnPush;
    end;
}

