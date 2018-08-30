report 31022942 "Cash-Flow Report"
{
    //Cash-FLow
    DefaultLayout = RDLC;
    RDLCLayout = './Cash-Flow Report Layout.rdl';
    Caption = 'Cash-Flow Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = Basic, Suite;
    dataset
    {
        dataitem(DataItem1170000000; "Cash-Flow Plan")
        {
            DataItemTableView = SORTING ("No.");
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(USERID; USERID)
            {
            }
            column(ReportFilter; ReportFilterTxt)
            {
            }
            column(No; "No.")
            {
            }
            column(Description; PADSTR('', Indentation * 2) + Description)
            {
            }
            column(Strong; (Type = 1))
            {
            }
            column(SecondColumnCaption; FORMAT(StartingDate2) + ' ' + ToText + ' ' + FORMAT(EndingDate2))
            {
            }
            column(FirstColumnCaption; FORMAT(StartingDate) + ' ' + ToText + ' ' + FORMAT(EndingDate))
            {
            }
            column(SecondValue; NetChange2)
            {
            }
            column(FirstValue; "Net Change")
            {
            }
            column(TotPeriod; TotPeriod)
            {
            }
            column(TotPeriod2; TotPeriod2)
            {
            }
            column(TotBefPeriod; TotBefPeriod)
            {
            }
            column(TotBefPeriod2; TotBefPeriod2)
            {
            }
            column(TotFinal; TotBefPeriod + TotPeriod)
            {
            }
            column(TotFinal2; TotBefPeriod2 + TotPeriod2)
            {
            }
            column(NetChangeText; NetChangeText)
            {
            }
            column(OpeningText; OpeningText)
            {
            }
            column(EndingText; EndingText)
            {
            }

            trigger OnAfterGetRecord();
            begin
                CALCFIELDS("Net Change");
                CashFlow2.GET("No.");
                CashFlow2.CALCFIELDS("Net Change");
                NetChange2 := CashFlow2."Net Change";
                IF Type = Type::Posting THEN BEGIN
                    TotPeriod += "Net Change";
                    TotPeriod2 += NetChange2;
                END;
            end;

            trigger OnPreDataItem();
            begin
                SETFILTER("Date filter", '%1..%2', StartingDate, EndingDate);
                CALCFIELDS("Net Change");
            end;
        }
    }
    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    field(StartingDate; StartingDate)
                    {
                        Caption = 'Starting Date';
                        ApplicationArea = Basic, Suite;
                    }
                    field(PeriodFormula; PeriodFormula)
                    {
                        Caption = 'Period Formula';
                        ApplicationArea = Basic, Suite;
                    }
                    field(ComparingMethod; ComparingMethod)
                    {
                        Caption = 'Comparing Method';
                        OptionCaption = 'Homologous Period,Previous Period';
                        ApplicationArea = Basic, Suite;
                    }
                }
            }
        }

        actions
        {
        }
    }
    labels
    {
        TitleReport_caption = 'Cash-Flow Report';
        Page_Caption = 'Page';
        No_Caption = 'No.';
        Description_Caption = 'Description';
    }
    trigger OnInitReport();
    var
        AccountingPeriod: Record "Accounting Period";
    begin
        // AccountingPeriod.RESET;
        // AccountingPeriod.SETRANGE("New Fiscal Year", TRUE);
        // AccountingPeriod.SETFILTER("Starting Date", '>=%1', WORKDATE);
        // IF AccountingPeriod.FINDFIRST THEN
        //     StartingDate := AccountingPeriod."Starting Date";
        // EVALUATE(PeriodFormula, '<1Y>');
        // EndingDate := CALCDATE(PeriodFormula, StartingDate);
    end;

    trigger OnPreReport();
    var
        AccountingPeriod: Record "Accounting Period"; //MSC ############
    begin
        //MSC ############
        AccountingPeriod.RESET;
        AccountingPeriod.SETRANGE("New Fiscal Year", TRUE);
        AccountingPeriod.SETFILTER("Starting Date", '>=%1', WORKDATE);
        IF AccountingPeriod.FINDFIRST THEN
            StartingDate := AccountingPeriod."Starting Date";
        EVALUATE(PeriodFormula, '<1Y>');
        EndingDate := CALCDATE(PeriodFormula, StartingDate);
        //MSC ############

        ReportFilterTxt := STRSUBSTNO(FilterText, StartingDate, EndingDate);
        EndingDate := CALCDATE(PeriodFormula, StartingDate) - 1;
        IF EndingDate < StartingDate THEN
            ERROR(ErrorDates1);
        EVALUATE(PeriodFormula2, STRSUBSTNO('-%1', PeriodFormula));

        IF ComparingMethod = ComparingMethod::"Homologous Period" THEN BEGIN
            StartingDate2 := CALCDATE('<-1Y>', StartingDate);
            EndingDate2 := CALCDATE(PeriodFormula, StartingDate2) - 1;
        END ELSE BEGIN
            StartingDate2 := CALCDATE(PeriodFormula2, StartingDate);
            EndingDate2 := StartingDate - 1;
        END;

        CalcOpeningValues;
        CashFlow2.SETFILTER("Date filter", '%1..%2', StartingDate2, EndingDate2);
    end;

    var
        CashFlow2: Record "Cash-Flow Plan";
        StartingDate: Date;
        PeriodFormula: DateFormula;
        EndingDate: Date;
        ComparingMethod: Option "Homologous Period","Previous Period";
        ToText: label 'to';
        StartingDate2: Date;
        EndingDate2: Date;
        PeriodFormula2: DateFormula;
        NetChange2: Decimal;
        ReportFilterTxt: Text;
        FilterText: label 'Report Period: %1 to %2';
        ErrorDates1: label 'Ending Date should be greater or equal to Starting Date';
        TotPeriod: Decimal;
        TotPeriod2: Decimal;
        TotBefPeriod: Decimal;
        TotBefPeriod2: Decimal;
        NetChangeText: label 'Period Net Change:';
        OpeningText: label 'Balance at period begining:';
        EndingText: label 'Balance at the period ending:';

    procedure CalcOpeningValues();
    begin
        CashFlow2.RESET;
        CashFlow2.SETFILTER("Date filter", '..%1', StartingDate - 1);
        IF CashFlow2.FINDFIRST THEN
            REPEAT
                CashFlow2.CALCFIELDS("Net Change");
                IF CashFlow2.Type = CashFlow2.Type::Posting THEN
                    TotBefPeriod += CashFlow2."Net Change";
            UNTIL CashFlow2.NEXT = 0;


        CashFlow2.RESET;
        CashFlow2.SETFILTER("Date filter", '..%1', StartingDate2 - 1);
        IF CashFlow2.FINDFIRST THEN
            REPEAT
                CashFlow2.CALCFIELDS("Net Change");
                IF CashFlow2.Type = CashFlow2.Type::Posting THEN
                    TotBefPeriod2 += CashFlow2."Net Change";
            UNTIL CashFlow2.NEXT = 0;

        CashFlow2.RESET;
    end;
}
