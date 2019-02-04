report 31022896 "PTSS Trial Bal. - Legal Books"
{
    // Balancetes

    DefaultLayout = RDLC;
    RDLCLayout = './Trial Balance - Legal Books Layout.rdl';
    Caption = 'Trial Balance - Legal Books';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(DataItem6710; "G/L Account")
        {
            //  DataItemTableView = SORTING ("No.")
            //                      WHERE ("No." = FILTER (??));
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(USERID; USERID)
            {
            }
            // column(CurrReport_PAGENO;CurrReport.PAGENO)
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
            column(CreditPeriod; CreditPeriod)
            {
            }
            column(DebitPeriod; DebitPeriod)
            {
            }
            column(BeforeDebitAmtOpenDebitAmtDebitPeriod; BeforeDebitAmt + OpenDebitAmt + DebitPeriod)
            {
            }
            column(BeforeCreditAmtOpenCreditAmtCreditPeriod; BeforeCreditAmt + OpenCreditAmt + CreditPeriod)
            {
            }
            column(DebitBalance; DebitBalance)
            {
            }
            column(CreditBalance; CreditBalance)
            {
            }
            column(BeforeDebitAmtOpenDebitAmt; BeforeDebitAmt + OpenDebitAmt)
            {
            }
            column(BeforeCreditAmtOpenCreditAmt; BeforeCreditAmt + OpenCreditAmt)
            {
            }
            column(GLAccountNo; "No.")
            {
            }
            dataitem(BlankLinesNumber; Integer)
            {
                DataItemTableView = SORTING (Number);

                trigger OnPreDataItem()
                begin
                    SETRANGE(Number, 1, RecGLAcc."No. of Blank Lines");
                end;
            }
            dataitem(DataItem5444; Integer)
            {
                DataItemTableView = SORTING (Number)
                                    WHERE (Number = CONST (1));
                column(DebitPeriodControl3; DebitPeriod)
                {
                }
                column(CreditPeriodControl4; CreditPeriod)
                {
                }
                column(BeforeDebitAmtOpenDebitAmtControl5; BeforeDebitAmt + OpenDebitAmt)
                {
                }
                column(BeforeCreditAmtOpenCreditAmtControl6; BeforeCreditAmt + OpenCreditAmt)
                {
                }
                column(CreditPeriod_BeforeCreditAmtOpenCreditAmt; CreditPeriod + BeforeCreditAmt + OpenCreditAmt)
                {
                }
                column(DebitPeriod_BeforeDebitAmtOpenDebitAmt; DebitPeriod + BeforeDebitAmt + OpenDebitAmt)
                {
                }
                column(DebitBalanceControl1; DebitBalance)
                {
                }
                column(CreditBalanceControl2; CreditBalance)
                {
                }
                column(PADSTRGLAccountIndentation2GLAccountName; PADSTR('', RecGLAcc.Indentation * 2) + RecGLAcc.Name)
                {
                }
                column(GLAccountNumber; RecGLAcc."No.")
                {
                }
                column(IntegerNumber; Number)
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

                IF NOT PrintValuesAddCurr THEN BEGIN
                    DebitPeriod := "Debit Amount";
                    CreditPeriod := "Credit Amount";
                END ELSE BEGIN
                    DebitPeriod := "Add.-Currency Debit Amount";
                    CreditPeriod := "Add.-Currency Credit Amount";
                END;

                IF OpeningFilter <> '' THEN
                    CalcOpenEntries;

                IF (PeriodFilter <> '') AND (BeforeFilter <> '') THEN
                    CalcBeforePeriod;

                IF Opcao = 0 THEN BEGIN
                    DebitPeriod := OpenDebitAmt;
                    CreditPeriod := OpenCreditAmt;
                    OpenCreditAmt := 0;
                    OpenDebitAmt := 0;
                END;

                CreditBalance := 0;
                DebitBalance := 0;

                IF "Account Type" = "Account Type"::Total THEN BEGIN
                    CreditBalance := ABS(GetBalance(FALSE, Totaling, 0D, EndDate, PrintValuesAddCurr));
                    DebitBalance := GetBalance(TRUE, Totaling, 0D, EndDate, PrintValuesAddCurr);
                END ELSE BEGIN
                    IF "Balance at Date" > 0 THEN
                        IF NOT PrintValuesAddCurr THEN
                            DebitBalance := "Balance at Date"
                        ELSE
                            DebitBalance := "Add.-Currency Balance at Date"
                    ELSE
                        IF NOT PrintValuesAddCurr THEN
                            CreditBalance := ABS("Balance at Date")
                        ELSE
                            CreditBalance := ABS("Add.-Currency Balance at Date");
                    ;
                END;

                IF Opcao = 0 THEN BEGIN
                    CreditBalance := CreditPeriod;
                    DebitBalance := DebitPeriod;
                END;

                IF PrintWithBalance AND
                   (OpenDebitAmt + OpenCreditAmt +
                    BeforeCreditAmt + BeforeDebitAmt +
                    CreditPeriod + DebitPeriod +
                    CreditBalance + DebitBalance = 0) THEN
                    CurrReport.SKIP;
            end;

            trigger OnPreDataItem()
            begin
                RecGLAcc.SETFILTER("No.", AccFilter);
                RecGLAcc.SETFILTER("Date Filter", PeriodFilter);

                CurrReport.CREATETOTALS(DebitPeriod, CreditPeriod, OpenDebitAmt, OpenCreditAmt, CreditBalance, DebitBalance,
                                        BeforeDebitAmt, BeforeCreditAmt);
            end;
        }
    }

    requestpage
    {
        SourceTable = "G/L Account";
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(Opcao; Opcao)
                    {
                        OptionCaption = 'Opening Values,Closing Values,Accounting Period';
                        trigger OnValidate()
                        begin
                            IF Opcao = Opcao::PeriodDate THEN
                                PeriodDateOpcaoOnValidate();
                            IF Opcao = Opcao::Opening then
                                ClosingOpcaoOnValidate();
                            IF Opcao = Opcao::Opening then
                                OpeningOpcaoOnValidate();
                        end;
                    }
                    field(PrintWithBalance; PrintWithBalance)
                    {
                        Caption = 'Only accounts with values';
                        MultiLine = true;
                    }
                    field(PrintValuesAddCurr; PrintValuesAddCurr)
                    {
                        Caption = 'Show values in add. currency';
                    }
                    field(PrintHeader; PrintHeader)
                    {
                        Caption = 'Print Header';
                    }
                    field(AccFilter; AccFilter)
                    {
                        Caption = 'Account Filter';
                        TableRelation = "G/L Account"."No.";
                    }
                    field(OpeningPeriod; OpeningPeriod)
                    {
                        Caption = 'Opening Period';
                        Enabled = OpeningPeriodEnable;
                        TableRelation = "Accounting Period" where ("New Fiscal Year" = filter (true));
                    }
                    field(ClosingPeriod; ClosingPeriod)
                    {
                        caption = 'Closing Period';
                        Enabled = ClosingPeriodEnable;
                        TableRelation = "Accounting Period" where ("New Fiscal Year" = Filter (true));
                    }

                    field(PeriodDate; PeriodDate)
                    {
                        Caption = 'Period Date';
                        Enabled = PeriodDateEnable;
                        TableRelation = "Accounting Period";
                    }
                }
            }
        }
    }

    labels
    {
        CurrReportPAGENO = 'Page';
        TrialBalanceLegalBooks = 'Trial Balance - Legal Books';
        Period = 'Period';
        Accumulated = 'Accumulated';
        Acc = 'Acc.';
        Name = 'Name';
        Debit = 'Debit';
        Credit = 'Credit';
        AccumBeforePeriod = 'Accum. Before Period';
        AccumatEnd = 'Accum. at End of Period';
        AccumPeriodDate = 'Accum. PeriodDate';
        TrialBalance = 'Trial Balance';
        Balance = 'Balance';
        Total = 'Total. . . . . . . . ';
    }

    trigger OnPreReport()
    begin
        CASE Opcao OF
            0:
                BEGIN
                    OpeningFilter := Text31022890 + FORMAT(OpeningPeriod - 1, 0, 1);
                    PeriodFilter := '';
                    BeforeFilter := '';
                    EndDate := CLOSINGDATE(OpeningPeriod - 1);
                    TextHeader[1] := Text31022898 + FORMAT(DATE2DMY(OpeningPeriod, 3), 0, 1);
                END;
            1:
                BEGIN
                    Periods.SETFILTER(Periods."New Fiscal Year", '%1', TRUE);
                    Periods.GET(ClosingPeriod);
                    Periods.NEXT;
                    OpeningFilter := Text31022890 + FORMAT(ClosingPeriod - 1, 0, 1);
                    PeriodFilter := Text31022891 + FORMAT(Periods."Starting Date" - 1, 0, 1);
                    BeforeFilter := FORMAT(ClosingPeriod, 0, 1) + Text31022892 + FORMAT(Periods."Starting Date" - 1, 0, 1);
                    EndDate := CLOSINGDATE(Periods."Starting Date" - 1);
                    TextHeader[1] := Text31022900 + FORMAT(DATE2DMY(ClosingPeriod, 3), 0, 1);
                END;
            2:
                BEGIN
                    IF PeriodDate = 0D THEN
                        ERROR(Text31022893);

                    Periods.GET(PeriodDate);
                    Periods.NEXT(1);
                    PeriodFilter := FORMAT(PeriodDate, 0, 1) + Text31022892 + FORMAT(Periods."Starting Date" - 1, 0, 1);
                    OpeningFilter := Text31022890 + FORMAT(StartPeriod(PeriodDate) - 1, 0, 1);
                    IF StartPeriod(PeriodDate) <> PeriodDate THEN
                        BeforeFilter := FORMAT(StartPeriod(PeriodDate), 0, 1) + Text31022892 + FORMAT(PeriodDate - 1, 0, 1);
                    EndDate := Periods."Starting Date" - 1;
                    TextHeader[1] := Text31022899 + PeriodFilter;
                END;
        END;

        IF AccFilter <> '' THEN
            TextHeader[2] := Text31022894 + AccFilter;
        IF PrintWithBalance THEN
            TextHeader[3] := Text31022895
        ELSE
            TextHeader[3] := Text31022896;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        RecGLAcc: Record "G/L Account";
        GLAcc: Record "G/L Account";
        Periods: Record "Accounting Period";
        OpeningFilter: Text[30];
        BeforeFilter: Text[30];
        PeriodFilter: Text[30];
        AccFilter: Text[30];
        TextHeader: array[3] of Text[100];
        Opcao: Option "Opening","Closing","PeriodDate";
        OpeningPeriod: Date;
        PeriodDate: Date;
        ClosingPeriod: Date;
        EndDate: Date;
        OpenCreditAmt: Decimal;
        OpenDebitAmt: Decimal;
        BeforeDebitAmt: Decimal;
        BeforeCreditAmt: Decimal;
        CreditBalance: Decimal;
        DebitBalance: Decimal;
        DebitPeriod: Decimal;
        CreditPeriod: Decimal;
        PrintWithBalance: Boolean;
        PrintValuesAddCurr: Boolean;
        PrintHeader: Boolean;
        Text31022890: Label '..C';
        Text31022891: Label 'C';
        Text31022892: Label '..';
        Text31022893: Label 'Fiscal period do not Exist!';
        Text31022894: Label 'Account Filter:';
        Text31022895: Label 'Only Accounts with values';
        Text31022896: Label 'Also accounts with no values';
        Text31022897: Label '<= %1';
        Text31022898: Label 'Opening - ';
        Text31022899: Label 'Period Date - ';
        Text31022900: Label 'Closing - ';
        [InDataSet]
        OpeningPeriodEnable: Boolean;
        [InDataSet]
        PeriodDateEnable: Boolean;
        [InDataSet]
        ClosingPeriodEnable: Boolean;

    procedure StartPeriod(Date: Date): Date
    var
        PerContco: Record "Accounting Period";
    begin
        PerContco.SETRANGE("New Fiscal Year", TRUE);
        PerContco.SETFILTER("Starting Date", Text31022897, Date);
        IF PerContco.FINDLAST THEN
            EXIT(PerContco."Starting Date")
        ELSE
            ERROR(Text31022893);
    end;

    procedure CalcOpenEntries()
    var
        GLAccOE: Record "G/L Account";
    begin
        GLAccOE := RecGlAcc;
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
        END;
    end;

    procedure CalcBeforePeriod()
    var
        GLAccOE: Record "G/L Account";
    begin
        GLAccOE := RecGLAcc;
        GLAccOE.SETFILTER("Date Filter", BeforeFilter);
        GLAccOE.CALCFIELDS("Debit Amount", "Credit Amount", "Add.-Currency Debit Amount", "Add.-Currency Credit Amount");
        IF NOT PrintValuesAddCurr THEN BEGIN
            BeforeDebitAmt := GLAccOE."Debit Amount";
            BeforeCreditAmt := ABS(GLAccOE."Credit Amount");
        END ELSE BEGIN
            BeforeDebitAmt := GLAccOE."Add.-Currency Debit Amount";
            BeforeCreditAmt := ABS(GLAccOE."Add.-Currency Credit Amount");
        END;
    end;

    local procedure OpeningOpcaoOnActivate()
    begin
        OpeningPeriodEnable := TRUE;
    end;

    local procedure OpeningOpcaoOnPush()
    begin
        PeriodDateEnable := FALSE;
        OpeningPeriodEnable := TRUE;
        ClosingPeriodEnable := FALSE;
        PeriodDate := 0D;
    end;

    local procedure ClosingOpcaoOnPush()
    begin
        PeriodDateEnable := FALSE;
        OpeningPeriodEnable := FALSE;
        ClosingPeriodEnable := TRUE;
        PeriodDate := 0D;
        OpeningPeriod := 0D;
    end;

    local procedure PeriodDateOpcaoOnPush()
    begin
        PeriodDateEnable := TRUE;
        OpeningPeriodEnable := FALSE;
        ClosingPeriodEnable := FALSE;
        OpeningPeriod := 0D;
    end;

    local procedure OpeningOpcaoOnValidate()
    begin
        OpeningOpcaoOnPush;
    end;

    local procedure ClosingOpcaoOnValidate()
    begin
        ClosingOpcaoOnPush;
    end;

    local procedure PeriodDateOpcaoOnValidate()
    begin
        PeriodDateOpcaoOnPush;
    end;
}

