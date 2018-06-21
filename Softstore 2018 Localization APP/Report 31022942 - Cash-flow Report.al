report 31022942 "Cash-flow Report"
{


    DefaultLayout = RDLC;
    RDLCLayout = '.Layouts/Cash-flow Report.rdlc';
    Caption = 'Cash-flow Report';

    dataset
    {
        dataitem(DataItem1170000000;"Cash-Flow Plan")
        {
            DataItemTableView = SORTING("No.");
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(USERID;USERID)
            {
            }
            column(ReportFilter;ReportFilterTxt)
            {
            }
            column(No;"Cash-Flow Plan"."No.")
            {
            }
            column(Description;PADSTR('',Indentation * 2)+Description)
            {
            }
            column(Strong;("Cash-Flow Plan".Type=1))
            {
            }
            column(SecondColumnCaption;FORMAT(StartingDate2) + ' ' + ToText + ' ' + FORMAT(EndingDate2))
            {
            }
            column(FirstColumnCaption;FORMAT(StartingDate) + ' ' + ToText + ' ' + FORMAT(EndingDate))
            {
            }
            column(SecondValue;NetChange2)
            {
            }
            column(FirstValue;"Net Change")
            {
            }
            column(TotPeriod;TotPeriod)
            {
            }
            column(TotPeriod2;TotPeriod2)
            {
            }
            column(TotBefPeriod;TotBefPeriod)
            {
            }
            column(TotBefPeriod2;TotBefPeriod2)
            {
            }
            column(TotFinal;TotBefPeriod+TotPeriod)
            {
            }
            column(TotFinal2;TotBefPeriod2+TotPeriod2)
            {
            }
            column(NetChangeText;NetChangeText)
            {
            }
            column(OpeningText;OpeningText)
            {
            }
            column(EndingText;EndingText)
            {
            }

            trigger OnAfterGetRecord();
            begin
                CALCFIELDS("Net Change");
                CashFlow2.GET("No.");
                CashFlow2.CALCFIELDS("Net Change");
                NetChange2 := CashFlow2."Net Change";
                IF "Cash-Flow Plan".Type = "Cash-Flow Plan".Type::Posting THEN BEGIN
                  TotPeriod += "Net Change";
                  TotPeriod2 += NetChange2;
                END;
            end;

            trigger OnPreDataItem();
            begin
                SETFILTER("Date filter",'%1..%2',StartingDate,EndingDate);
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
                field(StartingDate;StartingDate)
                {
                    CaptionML = ENU='Starting Date',
                                PTG='Data Inicial';
                }
                field(PeriodFormula;PeriodFormula)
                {
                    CaptionML = ENU='Period Formula',
                                PTG='Fórmula Período';
                }
                field(ComparingMethod;ComparingMethod)
                {
                    CaptionML = ENU='Comparing Method',
                                PTG='Metodo Comparativo';
                    OptionCaptionML = ENU='Homologous Period,Previous Period',
                                      PTG='Período Homólogo,Período Anterior';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        label(TitleReport_Caption;ENU='Cash-Flow Report',
                                  PTG='Demonstração de Fluxos de Caixa')
        label(Page_Caption;ENU='Page',
                           PTG='Página')
        label(No_Caption;ENU='No.',
                         PTG='Nº')
        label(Description_Caption;ENU='Description',
                                  PTG='Descrição')
    }

    trigger OnInitReport();
    var
        AccountingPeriod : Record "50";
    begin
        AccountingPeriod.RESET;
        AccountingPeriod.SETRANGE("New Fiscal Year",TRUE);
        AccountingPeriod.SETFILTER("Starting Date",'>=%1',WORKDATE);
        IF AccountingPeriod.FINDFIRST THEN
          StartingDate := AccountingPeriod."Starting Date";
        EVALUATE(PeriodFormula,'<1Y>');
        EndingDate := CALCDATE(PeriodFormula,StartingDate);
    end;

    trigger OnPreReport();
    begin
        ReportFilterTxt := STRSUBSTNO(FilterText,StartingDate,EndingDate);
        EndingDate := CALCDATE(PeriodFormula,StartingDate) -1;
        IF EndingDate < StartingDate THEN
          ERROR(ErrorDates1);
        EVALUATE(PeriodFormula2,STRSUBSTNO('-%1',PeriodFormula));

        IF ComparingMethod = ComparingMethod::"Homologous Period" THEN BEGIN
          StartingDate2 := CALCDATE('<-1Y>',StartingDate);
          EndingDate2 := CALCDATE(PeriodFormula,StartingDate2) - 1;
        END ELSE BEGIN
          StartingDate2 := CALCDATE(PeriodFormula2,StartingDate);
          EndingDate2 := StartingDate - 1;
        END;

        CalcOpeningValues;
        CashFlow2.SETFILTER("Date filter",'%1..%2',StartingDate2,EndingDate2);
    end;

    var
        CashFlow2 : Record "Cash-Flow Plan";
        StartingDate : Date;
        PeriodFormula : DateFormula;
        EndingDate : Date;
        ComparingMethod : Option "Homologous Period","Previous Period";
        ToText : TextConst ENU='to',PTG='a';
        StartingDate2 : Date;
        EndingDate2 : Date;
        PeriodFormula2 : DateFormula;
        NetChange2 : Decimal;
        ReportFilterTxt : Text;
        FilterText : TextConst ENU='Report Period: %1 to %2',PTG='Período do Mapa: %1 a %2';
        ErrorDates1 : TextConst ENU='Ending Date should be greater or equal to Starting Date',PTG='Data Final deve ser igual ou superior à Data Inicial';
        TotPeriod : Decimal;
        TotPeriod2 : Decimal;
        TotBefPeriod : Decimal;
        TotBefPeriod2 : Decimal;
        NetChangeText : TextConst ENU='Period Net Change:',PTG='Saldo Período:';
        OpeningText : TextConst ENU='Balance at period begining:',PTG='Saldo inicial do período:';
        EndingText : TextConst ENU='Balance at the period ending:',PTG='Saldo na data final do período:';

    procedure CalcOpeningValues();
    begin
        CashFlow2.RESET;
        CashFlow2.SETFILTER("Date filter",'..%1',StartingDate -1);
        IF CashFlow2.FINDFIRST THEN
          REPEAT
            CashFlow2.CALCFIELDS("Net Change");
            IF CashFlow2.Type = CashFlow2.Type::Posting THEN
              TotBefPeriod += CashFlow2."Net Change";
          UNTIL CashFlow2.NEXT = 0;


        CashFlow2.RESET;
        CashFlow2.SETFILTER("Date filter",'..%1',StartingDate2 -1);
        IF CashFlow2.FINDFIRST THEN
          REPEAT
            CashFlow2.CALCFIELDS("Net Change");
            IF CashFlow2.Type = CashFlow2.Type::Posting THEN
              TotBefPeriod2 += CashFlow2."Net Change";
          UNTIL CashFlow2.NEXT = 0;

        CashFlow2.RESET;
    end;
}

