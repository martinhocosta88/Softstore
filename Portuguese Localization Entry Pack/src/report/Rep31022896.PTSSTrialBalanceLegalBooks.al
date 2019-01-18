// report 31022896 "PTSS Trial Balance - Legal Books"
// {
//     // version NAVSS93.00

//     DefaultLayout = RDLC;
//     RDLCLayout = './Trial Balance - Legal Books.rdlc';
//     Caption = 'Trial Balance - Legal Books';

//     dataset
//     {
//         dataitem(DataItem6710; Table15)
//         {
//             DataItemTableView = SORTING (No.)
//                                 WHERE (No.=FILTER(??));
//             column(COMPANYNAME;COMPANYNAME)
//             {
//             }
//             column(USERID;USERID)
//             {
//             }
//             column(CurrReport_PAGENO;CurrReport.PAGENO)
//             {
//             }
//             column(FORMATTODAY04;FORMAT(TODAY,0,4))
//             {
//             }
//             column(TextHeader1;TextHeader[1])
//             {
//             }
//             column(TextHeader2;TextHeader[2])
//             {
//             }
//             column(TextHeader3;TextHeader[3])
//             {
//             }
//             column(CreditPeriod;CreditPeriod)
//             {
//             }
//             column(DebitPeriod;DebitPeriod)
//             {
//             }
//             column(BeforeDebitAmtOpenDebitAmtDebitPeriod;BeforeDebitAmt + OpenDebitAmt + DebitPeriod)
//             {
//             }
//             column(BeforeCreditAmtOpenCreditAmtCreditPeriod;BeforeCreditAmt + OpenCreditAmt + CreditPeriod)
//             {
//             }
//             column(DebitBalance;DebitBalance)
//             {
//             }
//             column(CreditBalance;CreditBalance)
//             {
//             }
//             column(BeforeDebitAmtOpenDebitAmt;BeforeDebitAmt + OpenDebitAmt)
//             {
//             }
//             column(BeforeCreditAmtOpenCreditAmt;BeforeCreditAmt + OpenCreditAmt)
//             {
//             }
//             column(GLAccountNo;"No.")
//             {
//             }
//             dataitem(BlankLinesNumber;Table2000000026)
//             {
//                 DataItemTableView = SORTING(Number);

//                 trigger OnPreDataItem()
//                 begin
//                     SETRANGE(Number,1,"G/L Account"."No. of Blank Lines");
//                 end;
//             }
//             dataitem(DataItem5444;Table2000000026)
//             {
//                 DataItemTableView = SORTING(Number)
//                                     WHERE(Number=CONST(1));
//                 column(DebitPeriodControl3;DebitPeriod)
//                 {
//                 }
//                 column(CreditPeriodControl4;CreditPeriod)
//                 {
//                 }
//                 column(BeforeDebitAmtOpenDebitAmtControl5;BeforeDebitAmt + OpenDebitAmt)
//                 {
//                 }
//                 column(BeforeCreditAmtOpenCreditAmtControl6;BeforeCreditAmt + OpenCreditAmt)
//                 {
//                 }
//                 column(CreditPeriod_BeforeCreditAmtOpenCreditAmt;CreditPeriod+BeforeCreditAmt + OpenCreditAmt)
//                 {
//                 }
//                 column(DebitPeriod_BeforeDebitAmtOpenDebitAmt;DebitPeriod+BeforeDebitAmt + OpenDebitAmt)
//                 {
//                 }
//                 column(DebitBalanceControl1;DebitBalance)
//                 {
//                 }
//                 column(CreditBalanceControl2;CreditBalance)
//                 {
//                 }
//                 column(PADSTRGLAccountIndentation2GLAccountName;PADSTR('',"G/L Account".Indentation * 2)+"G/L Account".Name)
//                 {
//                 }
//                 column(GLAccountNumber;"G/L Account"."No.")
//                 {
//                 }
//                 column(IntegerNumber;Number)
//                 {
//                 }
//             }

//             trigger OnAfterGetRecord()
//             begin
//                 CALCFIELDS("Debit Amount","Credit Amount","Balance at Date","Add.-Currency Debit Amount",
//                            "Add.-Currency Credit Amount","Add.-Currency Balance at Date");

//                 OpenCreditAmt := 0;
//                 OpenDebitAmt := 0;
//                 BeforeDebitAmt := 0;
//                 BeforeCreditAmt := 0;

//                 IF NOT PrintValuesAddCurr THEN BEGIN
//                    DebitPeriod := "G/L Account"."Debit Amount";
//                    CreditPeriod := "G/L Account"."Credit Amount";
//                 END ELSE BEGIN
//                    DebitPeriod := "G/L Account"."Add.-Currency Debit Amount";
//                    CreditPeriod := "G/L Account"."Add.-Currency Credit Amount";
//                 END;

//                 IF OpeningFilter <> '' THEN
//                    CalcOpenEntries;

//                 IF (PeriodFilter <> '') AND (BeforeFilter <> '') THEN
//                    CalcBeforePeriod;

//                 IF Opcao = 0 THEN BEGIN
//                    DebitPeriod := OpenDebitAmt;
//                    CreditPeriod := OpenCreditAmt;
//                    OpenCreditAmt := 0;
//                    OpenDebitAmt := 0;
//                 END;

//                 CreditBalance := 0;
//                 DebitBalance := 0;

//                 IF "G/L Account"."Account Type" = "G/L Account"."Account Type"::Total THEN BEGIN
//                     CreditBalance := ABS("G/L Account".GetBalance(FALSE, "G/L Account".Totaling,0D,EndDate,PrintValuesAddCurr));
//                     DebitBalance := "G/L Account".GetBalance(TRUE, "G/L Account".Totaling,0D,EndDate,PrintValuesAddCurr);
//                 END ELSE BEGIN
//                     IF "G/L Account"."Balance at Date" > 0 THEN
//                         IF NOT PrintValuesAddCurr THEN
//                            DebitBalance := "G/L Account"."Balance at Date"
//                         ELSE
//                            DebitBalance := "G/L Account"."Add.-Currency Balance at Date"
//                     ELSE
//                         IF NOT PrintValuesAddCurr THEN
//                            CreditBalance := ABS("G/L Account"."Balance at Date")
//                         ELSE
//                            CreditBalance := ABS("G/L Account"."Add.-Currency Balance at Date");;
//                 END;

//                 IF Opcao = 0 THEN BEGIN
//                    CreditBalance := CreditPeriod;
//                    DebitBalance := DebitPeriod;
//                 END;

//                 IF PrintWithBalance AND
//                    (OpenDebitAmt + OpenCreditAmt +
//                     BeforeCreditAmt + BeforeDebitAmt +
//                     CreditPeriod + DebitPeriod +
//                     CreditBalance + DebitBalance = 0) THEN
//                       CurrReport.SKIP;
//             end;

//             trigger OnPreDataItem()
//             begin
//                 "G/L Account".SETFILTER("No.",AccFilter);
//                 "G/L Account".SETFILTER("Date Filter",PeriodFilter);

//                 CurrReport.CREATETOTALS(DebitPeriod,CreditPeriod,OpenDebitAmt,OpenCreditAmt,CreditBalance,DebitBalance,
//                                         BeforeDebitAmt,BeforeCreditAmt);
//             end;
//         }
//     }

//     requestpage
//     {
//         SourceTable = Table15;

//         layout
//         {
//             area(content)
//             {
//                 group(Options)
//                 {
//                     Caption = 'Options';
//                     field(Opcao;Opcao)
//                     {
//                         OptionCaption = 'Opening Values,Closing Values,Accounting Period';

//                         trigger OnValidate()
//                         begin
//                             IF Opcao = Opcao::PeriodDate THEN
//                               PeriodDateOpcaoOnValidate;
//                             IF Opcao = Opcao::Closing THEN
//                               ClosingOpcaoOnValidate;
//                             IF Opcao = Opcao::Opening THEN
//                               OpeningOpcaoOnValidate;
//                         end;
//                     }
//                     field(PrintWithBalance;PrintWithBalance)
//                     {
//                         Caption = 'Only accounts with values';
//                         MultiLine = true;
//                     }
//                     field(PrintValuesAddCurr;PrintValuesAddCurr)
//                     {
//                         Caption = 'Show values in add. currency';
//                     }
//                     field(PrintHeader;PrintHeader)
//                     {
//                         Caption = 'Print Header';
//                     }
//                     field(AccFilter;AccFilter)
//                     {
//                         Caption = 'Account Filter';
//                         TableRelation = "G/L Account".No.;
//                     }
//                     field(OpeningPeriod;OpeningPeriod)
//                     {
//                         Caption = 'Opening Period';
//                         Enabled = OpeningPeriodEnable;
//                         TableRelation = "Accounting Period" WHERE (New Fiscal Year=FILTER(Yes));
//                     }
//                     field(ClosingPeriod;ClosingPeriod)
//                     {
//                         Caption = 'Closing Period';
//                         Enabled = ClosingPeriodEnable;
//                         TableRelation = "Accounting Period" WHERE (New Fiscal Year=FILTER(Yes));
//                     }
//                     field(PeriodDate;PeriodDate)
//                     {
//                         Caption = 'Period Date';
//                         Enabled = PeriodDateEnable;
//                         TableRelation = "Accounting Period";
//                     }
//                 }
//             }
//         }

//         actions
//         {
//         }

//         trigger OnOpenPage()
//         begin
//             PrintWithBalance := TRUE;
//             OpeningPeriodEnable := TRUE;
//         end;
//     }

//     labels
//     {
//         CurrReportPAGENO = 'Page';
//         TrialBalanceLegalBooks = 'Trial Balance - Legal Books';
//         Period = 'Period';
//         Accumulated = 'Accumulated';
//         Acc = 'Acc.';
//         Name = 'Name';
//         Debit = 'Debit';
//         Credit = 'Credit';
//         AccumBeforePeriod = 'Accum. Before Period';
//         AccumatEnd = 'Accum. at End of Period';
//         AccumPeriodDate = 'Accum. PeriodDate';
//         TrialBalance = 'Trial Balance';
//         Balance = 'Balance';
//         Total = 'Total. . . . . . . . ';
//     }

//     trigger OnPreReport()
//     begin
//         CASE Opcao OF
//            0: BEGIN
//                 OpeningFilter := Text31022890 + FORMAT(OpeningPeriod - 1,0,1);
//                 PeriodFilter := '';
//                 BeforeFilter := '';
//                 EndDate := CLOSINGDATE(OpeningPeriod - 1);
//                 TextHeader[1] := Text31022898 + FORMAT(DATE2DMY(OpeningPeriod,3),0,1);
//               END;
//            1: BEGIN
//                 Periods.SETFILTER(Periods."New Fiscal Year",'%1',TRUE);
//                 Periods.GET(ClosingPeriod);
//                 Periods.NEXT;
//                 OpeningFilter := Text31022890 + FORMAT(ClosingPeriod - 1,0,1);
//                 PeriodFilter := Text31022891 + FORMAT(Periods."Starting Date" - 1,0,1);
//                 BeforeFilter := FORMAT(ClosingPeriod,0,1) + Text31022892 + FORMAT(Periods."Starting Date" - 1,0,1);
//                 EndDate := CLOSINGDATE(Periods."Starting Date" - 1);
//                 TextHeader[1] := Text31022900 + FORMAT(DATE2DMY(ClosingPeriod,3),0,1);
//               END;
//            2: BEGIN
//                 IF PeriodDate = 0D THEN
//                    ERROR(Text31022893);

//                 Periods.GET(PeriodDate);
//                 Periods.NEXT(1);
//                 PeriodFilter := FORMAT(PeriodDate,0,1) + Text31022892 + FORMAT(Periods."Starting Date" - 1,0,1);
//                 OpeningFilter := Text31022890 + FORMAT(StartPeriod(PeriodDate) - 1,0,1);
//                 IF StartPeriod(PeriodDate) <> PeriodDate THEN
//                    BeforeFilter := FORMAT(StartPeriod(PeriodDate),0,1) + Text31022892 + FORMAT(PeriodDate - 1,0,1);
//                 EndDate := Periods."Starting Date" - 1;
//                 TextHeader[1] := Text31022899 + PeriodFilter;
//               END;
//         END;

//         IF AccFilter <> '' THEN
//            TextHeader[2] := Text31022894 + AccFilter;
//         IF PrintWithBalance THEN
//            TextHeader[3] := Text31022895
//         ELSE
//            TextHeader[3] := Text31022896;
//     end;

//     var
//         GLSetup: Record "98";
//         GLAcc: Record "15";
//         Periods: Record "50";
//         OpeningFilter: Text[30];
//         BeforeFilter: Text[30];
//         PeriodFilter: Text[30];
//         AccFilter: Text[30];
//         TextHeader: array [3] of Text[100];
//         Opcao: Option Opening,Closing,PeriodDate;
//         OpeningPeriod: Date;
//         PeriodDate: Date;
//         ClosingPeriod: Date;
//         EndDate: Date;
//         OpenCreditAmt: Decimal;
//         OpenDebitAmt: Decimal;
//         BeforeDebitAmt: Decimal;
//         BeforeCreditAmt: Decimal;
//         CreditBalance: Decimal;
//         DebitBalance: Decimal;
//         DebitPeriod: Decimal;
//         CreditPeriod: Decimal;
//         PrintWithBalance: Boolean;
//         PrintValuesAddCurr: Boolean;
//         PrintHeader: Boolean;
//         Text31022890: Label '..C';
//         Text31022891: Label 'C';
//         Text31022892: Label '..';
//         Text31022893: Label 'Fiscal period do not Exist!';
//         Text31022894: Label 'Account Filter:';
//         Text31022895: Label 'Only Accounts with values';
//         Text31022896: Label 'Also accounts with no values';
//         Text31022897: Label '<= %1';
//         Text31022898: Label 'Opening - ';
//         Text31022899: Label 'Period Date - ';
//         Text31022900: Label 'Closing - ';
//         [InDataSet]
//         OpeningPeriodEnable: Boolean;
//         [InDataSet]
//         PeriodDateEnable: Boolean;
//         [InDataSet]
//         ClosingPeriodEnable: Boolean;

//     procedure StartPeriod(Date: Date): Date
//     var
//         PerContco: Record "50";
//     begin
//         PerContco.SETRANGE("New Fiscal Year",TRUE);
//         PerContco.SETFILTER("Starting Date",Text31022897,Date);
//         IF PerContco.FINDLAST THEN
//           EXIT(PerContco."Starting Date")
//         ELSE
//           ERROR(Text31022893);
//     end;

//     procedure CalcOpenEntries()
//     var
//         GLAccOE: Record "15";
//     begin
//         GLAccOE := "G/L Account";
//         GLAccOE.SETFILTER("Date Filter",OpeningFilter);
//         GLAccOE.CALCFIELDS("Debit Amount","Credit Amount","Net Change","Add.-Currency Debit Amount",
//                    "Add.-Currency Credit Amount","Additional-Currency Net Change");

//         IF GLAccOE."Account Type" = GLAccOE."Account Type"::Total THEN BEGIN
//             OpenCreditAmt := ABS(GLAccOE.GetBalance(FALSE, GLAccOE.Totaling,0D,
//                                                     GLAccOE.GETRANGEMAX(GLAccOE."Date Filter"),PrintValuesAddCurr));
//             OpenDebitAmt := GLAccOE.GetBalance(TRUE, GLAccOE.Totaling,0D,
//                                                 GLAccOE.GETRANGEMAX(GLAccOE."Date Filter"),PrintValuesAddCurr);
//         END ELSE BEGIN
//             IF GLAccOE."Net Change" > 0 THEN
//                 IF NOT PrintValuesAddCurr THEN
//                    OpenDebitAmt := GLAccOE."Net Change"
//                 ELSE
//                    OpenDebitAmt := GLAccOE."Additional-Currency Net Change"
//             ELSE
//                 IF NOT PrintValuesAddCurr THEN
//                    OpenCreditAmt := ABS(GLAccOE."Net Change")
//                 ELSE
//                    OpenCreditAmt := ABS(GLAccOE."Additional-Currency Net Change");
//         END;
//     end;

//     procedure CalcBeforePeriod()
//     var
//         GLAccOE: Record "15";
//     begin
//         GLAccOE := "G/L Account";
//         GLAccOE.SETFILTER("Date Filter",BeforeFilter);
//         GLAccOE.CALCFIELDS("Debit Amount","Credit Amount","Add.-Currency Debit Amount","Add.-Currency Credit Amount");
//         IF NOT PrintValuesAddCurr THEN BEGIN
//               BeforeDebitAmt := GLAccOE."Debit Amount";
//               BeforeCreditAmt := ABS(GLAccOE."Credit Amount");
//         END ELSE BEGIN
//               BeforeDebitAmt := GLAccOE."Add.-Currency Debit Amount";
//               BeforeCreditAmt := ABS(GLAccOE."Add.-Currency Credit Amount");
//         END;
//     end;

//     local procedure OpeningOpcaoOnActivate()
//     begin
//         OpeningPeriodEnable := TRUE;
//     end;

//     local procedure OpeningOpcaoOnPush()
//     begin
//         PeriodDateEnable := FALSE;
//         OpeningPeriodEnable := TRUE;
//         ClosingPeriodEnable := FALSE;
//         PeriodDate:= 0D;
//     end;

//     local procedure ClosingOpcaoOnPush()
//     begin
//         PeriodDateEnable := FALSE;
//         OpeningPeriodEnable := FALSE;
//         ClosingPeriodEnable := TRUE;
//         PeriodDate:= 0D;
//         OpeningPeriod:=0D;
//     end;

//     local procedure PeriodDateOpcaoOnPush()
//     begin
//         PeriodDateEnable := TRUE;
//         OpeningPeriodEnable := FALSE;
//         ClosingPeriodEnable := FALSE;
//         OpeningPeriod:=0D;
//     end;

//     local procedure OpeningOpcaoOnValidate()
//     begin
//         OpeningOpcaoOnPush;
//     end;

//     local procedure ClosingOpcaoOnValidate()
//     begin
//         ClosingOpcaoOnPush;
//     end;

//     local procedure PeriodDateOpcaoOnValidate()
//     begin
//         PeriodDateOpcaoOnPush;
//     end;
// }

