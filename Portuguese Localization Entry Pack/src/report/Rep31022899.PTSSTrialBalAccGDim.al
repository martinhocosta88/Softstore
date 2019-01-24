report 31022899 "PTSS Trial Bal. Acc./G. Dim."
{
    //Balancetes

    DefaultLayout = RDLC;
    RDLCLayout = './Trial Balance AccountG. Dim. Layout.rdl';
    Caption = 'Trial Balance Account/G. Dim.';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(DataItem7069; "G/L Entry")
        {
            DataItemTableView = SORTING ("G/L Account No.", "Business Unit Code", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date");
            RequestFilterFields = "G/L Account No.", "Business Unit Code", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date";
            column(USERID; USERID)
            {
            }
            column(HeaderText0; HeaderText0)
            {
            }
            // column(CurrReportPAGENO; CurrReport.PAGENO)
            // {
            // }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(FORMATTODAY04; FORMAT(TODAY, 0, 4))
            {
            }
            column(HeaderText; HeaderText)
            {
            }
            column(GLEntryGLAccountNo; "G/L Account No.")
            {
            }
            column(GLAccName; GLAcc.Name)
            {
            }
            column(GLEntryGlobalDimension1Code; "Global Dimension 1 Code")
            {
            }
            column(GLEntryGlobalDimension2Code; "Global Dimension 2 Code")
            {
            }
            column(GLEntryDebitAmount; GLacc2."Debit Amount")
            {
            }
            column(GLEntryCreditAmount; GLacc2."Credit Amount")
            {
            }
            column(DebitAmountCredit_Amount; GLacc2."Debit Amount" - GLacc2."Credit Amount")
            {
            }
            column(GLAccDebitAmount; GLAcc."Debit Amount")
            {
            }
            column(GLAccCreditAmount; GLAcc."Credit Amount")
            {
            }
            column(GLAccNetChange; GLAcc."Net Change")
            {
            }
            column(GLAcc1DebitAmount; DebitAmountGroup)
            {
            }
            column(GLAcc1CreditAmount; CreditAmountGroup)
            {
            }
            column(GLAcc1NetChange; BalanceAtDateGroup)
            {
            }
            column(TrialBalanceAccountDepartmentProjectCaption; Trial_Balance_Departament_Project_AccountCaption)
            {
            }
            column(GLEntryEntryNo; "Entry No.")
            {
            }
            column(GLEntryBusinessUnitCode; "Business Unit Code")
            {
            }
            column(PrintAllHavingBal; PrintAllHavingBal)
            {
            }
            column(BalanceAtDate; GLAcc."Balance at Date")
            {
            }
            column(BalanceAtDateFooter; BalanceAtDateFooter)
            {
            }

            trigger OnAfterGetRecord()
            begin
                IF (LastGLAccNo <> "G/L Account No.") THEN BEGIN
                    BalanceAtDateFooter := 0;
                END;
                RecordNo := RecordNo + 1;

                Window.UPDATE(1, "Global Dimension 1 Code");
                Window.UPDATE(2, "Global Dimension 2 Code");
                Window.UPDATE(3, "G/L Account No.");
                Window.UPDATE(4, ((RecordNo / NoOfRecords) * 10000) DIV 1);


                IF (LastGLAccNo <> "G/L Account No.") OR (LastGlobalDim1Code <> "Global Dimension 1 Code") OR (LastGlobalDim2Code <> "Global Dimension 2 Code") THEN BEGIN
                    GLAcc.GET("G/L Account No.");
                    GLAcc.SETRANGE("Date Filter", StartingPeriod(FromDate), ToDate);
                    GLAcc.SETRANGE("Global Dimension 1 Filter", "Global Dimension 1 Code");
                    GLAcc.SETRANGE("Global Dimension 2 Filter", "Global Dimension 2 Code");
                    GLAcc.CALCFIELDS("Debit Amount", "Credit Amount", "Net Change", "Balance at Date");

                    IF LastGLAccNo <> "G/L Account No." THEN BEGIN
                        CLEAR(DebitAmountGroup);
                        CLEAR(CreditAmountGroup);
                        CLEAR(BalanceAtDateGroup);
                    END;

                    DebitAmountGroup += GLAcc."Debit Amount";
                    CreditAmountGroup += GLAcc."Credit Amount";
                    BalanceAtDateGroup += GLAcc."Net Change";
                    BalanceAtDateFooter += GLAcc."Balance at Date";
                    GLacc2.GET("G/L Account No.");
                    GLacc2.SETRANGE("Date Filter", FromDate, ToDate);
                    GLacc2.SETRANGE("Global Dimension 1 Filter", "Global Dimension 1 Code");
                    GLacc2.SETRANGE("Global Dimension 2 Filter", "Global Dimension 2 Code");
                    GLacc2.CALCFIELDS("Debit Amount", "Credit Amount");
                END;

                LastGLAccNo := "G/L Account No.";
                LastGlobalDim1Code := "Global Dimension 1 Code";
                LastGlobalDim2Code := "Global Dimension 2 Code";

                IF GenLedgSetup.FIND('-') THEN
                    Trial_Balance_Departament_Project_AccountCaption := STRSUBSTNO(Trial_Balance_Account__Department_ProjectCaptionLbl, GenLedgSetup."Global Dimension 1 Code", GenLedgSetup."Global Dimension 2 Code");
            end;

            trigger OnPreDataItem()
            begin
                FromDate := 0D;
                IF GETFILTER("Posting Date") = '' THEN
                    ToDate := 99991231D
                ELSE BEGIN
                    FromDate := GETRANGEMIN("Posting Date");
                    ToDate := GETRANGEMAX("Posting Date");
                    SETRANGE("Posting Date", StartingPeriod(FromDate), ToDate);
                END;

                LastFieldNo := FIELDNO("G/L Account No.");
                NoOfRecords := COUNT;
                Window.OPEN(Text31022891 +
                            Text31022892 + '#1#################\' +
                            Text31022893 + '#2#################\' +
                            Text31022894 + '#3#################\' +
                            '@4@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\')
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
                    Caption = 'Options';
                    field(PrintAllHavingBal; PrintAllHavingBal)
                    {
                        Caption = 'Only G/L accounts with Balance at Date';
                        MultiLine = true;
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
        Total = 'Total of';
        PAGENO = 'Page';
        AllamountsareinLocalCurrency = 'All amounts are in Local Currency';
        OnlyGLaccountswithBalanceatDate = 'Only G/L accounts with Balance at Date';
        Project = 'Project';
        Department = 'Department';
        AccYearatDate = 'Acc. Year at Date';
        BalatDate = 'Balance at Date';
        Credit = 'Credit';
        Debit = 'Debit';
        AccinPeriod = 'Acc. in Period';
        PeriodBalance = 'Period Balance';
    }

    trigger OnPreReport()
    begin
        HeaderText0 := GLEntry.GETFILTER("Posting Date");
        HeaderText := GLEntry.GETFILTERS();
        IF HeaderText <> '' THEN
            HeaderText := Text31022890 + HeaderText;
    end;

    var
        GLEntry: Record "G/L Entry";
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        NoOfRecords: Integer;
        RecordNo: Integer;
        Window: Dialog;
        GLAcc: Record "G/L Account";
        GLAcc1: Record "G/L Account";
        FromDate: Date;
        ToDate: Date;
        PrintAllHavingBal: Boolean;
        HeaderText: Text[250];
        HeaderText0: Text[250];
        Text31022890: Label 'Report Filters: ';
        Trial_Balance_Account__Department_ProjectCaptionLbl: Label 'Trial Balance Account/ %1 - %2';
        LastGLAccNo: Text[20];
        LastGlobalDim1Code: Code[20];
        LastGlobalDim2Code: Code[20];
        DebitAmountGroup: Decimal;
        CreditAmountGroup: Decimal;
        BalanceAtDateGroup: Decimal;
        GenLedgSetup: Record "General Ledger Setup";
        Trial_Balance_Departament_Project_AccountCaption: Text;
        Text31022891: Label 'Verifying entries...             \';
        Text31022892: Label 'Department';
        Text31022893: Label 'Project       ';
        Text31022894: Label 'G/L Account   ';
        GLacc2: Record "G/L Account";
        BalanceAtDateFooter: Decimal;

    procedure StartingPeriod(Date: Date): Date
    var
        AccPeriod: Record "Accounting Period";
        t_message1: Label 'Fiscal Year do not exist!';
    begin
        AccPeriod.SETRANGE("New Fiscal Year", TRUE);
        AccPeriod.SETFILTER("Starting Date", '<= %1', Date);
        IF AccPeriod.FINDLAST THEN
            EXIT(AccPeriod."Starting Date")
        ELSE
            ERROR(t_message1);
    end;
}

