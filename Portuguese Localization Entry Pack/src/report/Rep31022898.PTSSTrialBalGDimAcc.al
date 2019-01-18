report 31022898 "PTSS Trial Bal. G. Dim./Acc."
{
    //Balancetes

    DefaultLayout = RDLC;
    RDLCLayout = './Trial Balance G. Dim.Account Layout.rdl';
    Caption = 'Trial Balance G. Dim./Account';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(DataItem7069; "G/L Entry")
        {
            DataItemTableView = SORTING ("Global Dimension 1 Code", "Global Dimension 2 Code", "G/L Account No.", "Posting Date");
            RequestFilterFields = "Global Dimension 1 Code", "Global Dimension 2 Code", "G/L Account No.", "Posting Date";
            column(USERID; USERID)
            {
            }
            column(CurrReportPAGENO; CurrReport.PAGENO)
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(FORMATTODAY04; FORMAT(TODAY, 0, 4))
            {
            }
            column(HeaderText0; HeaderText0)
            {
            }
            column(HeaderText; HeaderText)
            {
            }
            column(GLEntryGlobalDimension2Code; "Global Dimension 2 Code")
            {
            }
            column(GLEntryGlobalDimension1Code; "Global Dimension 1 Code")
            {
            }
            column(GLAccDebitAmount; GLAcc."Debit Amount")
            {
            }
            column(GLAccCreditAmount; GLAcc."Credit Amount")
            {
            }
            column(GLEntryGLAccountNo; "G/L Account No.")
            {
            }
            column(GLAccBalanceatDate; GLAcc."Balance at Date")
            {
            }
            column(GLAcc2DebitAmount; GLacc2."Debit Amount")
            {
            }
            column(GLAcc2CreditAmount; GLacc2."Credit Amount")
            {
            }
            column(GLAcc2DebitAmountCreditAmount; GLacc2."Debit Amount" - GLacc2."Credit Amount")
            {
            }
            column(CreditValueGroup; CreditValueGroup)
            {
            }
            column(DebitValueGroup; DebitValueGroup)
            {
            }
            column(DebitValueGroupCreditValueGroup; DebitValueGroup - CreditValueGroup)
            {
            }
            column(Debit_AmountCreditAmount; "Debit Amount" - "Credit Amount")
            {
            }
            column(DebitValueFooter; DebitValueFooter)
            {
            }
            column(CreditValueFooter; CreditValueFooter)
            {
            }
            column(DebitValueFooterCreditValueFooter; DebitValueFooter - CreditValueFooter)
            {
            }
            column(Trial_Balance_Departament_ProjectAccountCaption; Trial_Balance_Departament_Project_AccountCaption)
            {
            }
            column(GLEntryGlobalDimension1CodeCaption; FIELDCAPTION("Global Dimension 1 Code"))
            {
            }
            column(GLEntryGlobalDimension2CodeCaption; FIELDCAPTION("Global Dimension 2 Code"))
            {
            }
            column(GLEntryEntryNo; "Entry No.")
            {
            }
            column(PrintAllHavingBal; PrintAllHavingBal)
            {
            }
            column(GLAccNetChange; GLAcc."Net Change")
            {
            }
            column(BalanceAtDateFooter; BalanceAtDateFooter)
            {
            }
            column(DebitValuePeriod; DebitValuePeriod)
            {
            }
            column(CreditValuePeriod; CreditValuePeriod)
            {
            }
            column(DebitValuePeriodCreditValuePeriod; DebitValuePeriod - CreditValuePeriod)
            {
            }
            column(BalanceAtDateFooterGroup; BalanceAtDateFooterGroup)
            {
            }

            trigger OnAfterGetRecord()
            begin
                IF (LastGlobalDim1Code <> "Global Dimension 1 Code") OR (LastGlobalDim2Code <> "Global Dimension 2 Code") THEN BEGIN
                    DebitValuePeriod := 0;
                    CreditValuePeriod := 0;
                    BalanceAtDateFooter := 0;
                END;

                RecordNo := RecordNo + 1;


                Window.UPDATE(1, "Global Dimension 1 Code");
                Window.UPDATE(2, "Global Dimension 2 Code");
                Window.UPDATE(3, "G/L Account No.");
                Window.UPDATE(4, ((RecordNo / NoOfRecords) * 10000) DIV 1);

                IF (LastGLAccNo = "G/L Account No.") AND ((LastGlobalDim1Code = "Global Dimension 1 Code") OR (LastGlobalDim2Code = "Global Dimension 2 Code")) THEN BEGIN
                    GLAcc."Debit Amount" := 0;
                    GLAcc."Credit Amount" := 0;
                END;

                IF (LastGLAccNo <> "G/L Account No.") OR (LastGlobalDim1Code <> "Global Dimension 1 Code") OR (LastGlobalDim2Code <> "Global Dimension 2 Code") THEN BEGIN
                    GLAcc.GET("G/L Account No.");
                    GLAcc.SETRANGE("Date Filter", StartingPeriod(FromDate), ToDate);
                    GLAcc.SETRANGE("Global Dimension 1 Filter", "Global Dimension 1 Code");
                    GLAcc.SETRANGE("Global Dimension 2 Filter", "Global Dimension 2 Code");
                    GLAcc.CALCFIELDS("Debit Amount", "Credit Amount", "Balance at Date");
                    IF EntryNo <> "Entry No." THEN BEGIN
                        DebitValueFooter += GLAcc."Debit Amount";
                        CreditValueFooter += GLAcc."Credit Amount";
                        BalanceAtDateFooter += GLAcc."Balance at Date";
                        DebitValueGroup_CreditValueGroup := GLAcc."Balance at Date";
                        BalanceAtDateFooterGroup += DebitValueGroup_CreditValueGroup;
                    END;

                    GLacc2.GET("G/L Account No.");
                    GLacc2.SETRANGE("Date Filter", FromDate, ToDate);
                    GLacc2.SETRANGE("Global Dimension 1 Filter", "Global Dimension 1 Code");
                    GLacc2.SETRANGE("Global Dimension 2 Filter", "Global Dimension 2 Code");
                    GLacc2.CALCFIELDS("Debit Amount", "Credit Amount", "Net Change");
                    IF EntryNo <> "Entry No." THEN BEGIN
                        DebitValuePeriod += GLacc2."Debit Amount";
                        CreditValuePeriod += GLacc2."Credit Amount";
                        DebitValueGroup += GLacc2."Debit Amount";
                        CreditValueGroup += GLacc2."Credit Amount";
                    END;

                    EntryNo := "Entry No.";
                END;

                LastGlobalDim1Code := "Global Dimension 1 Code";
                LastGlobalDim2Code := "Global Dimension 2 Code";
                LastGLAccNo := "G/L Account No.";

                GenLedgSetup.GET;
                Trial_Balance_Departament_Project_AccountCaption := STRSUBSTNO(Trial_Balance_Departament_Project___AccountCaptionLbl, GenLedgSetup."Global Dimension 1 Code", GenLedgSetup."Global Dimension 2 Code");
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
                Window.OPEN(Text31022892 +
                            Text31022893 + '#1#################\' +
                            Text31022894 + '#2#################\' +
                            Text31022895 + '#3#################\' +
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
        TotalFor = 'Total of ';
        PAGENO = 'Page';
        AllamountsareinLCY = 'All amounts are in LCY';
        OnlyGLaccountswithBalanceatDate = 'Only G/L accounts with Balance at Date';
        AccYearatDate = 'Acc. Year at Date';
        AccinPeriod = 'Acc. in Period';
        Credit = 'Credit';
        Debit = 'Debit';
        BalanceatDate = 'Balance at Date';
        Account = 'Account';
        PeriodBalance = 'Period Balance';
    }

    trigger OnPreReport()
    begin
        HeaderText0 := Text31022890 + GLEntry.GETFILTER("Posting Date");
        HeaderText := GLEntry.GETFILTERS();
        IF HeaderText <> '' THEN
            HeaderText := Text31022891 + HeaderText;
    end;

    var
        GLEntry: Record "G/L Entry";
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        NoOfRecords: Integer;
        RecordNo: Integer;
        Window: Dialog;
        GLAcc: Record "G/L Account";
        DebitValue: Decimal;
        CreditValue: Decimal;
        DebitValueGroup: Decimal;
        CreditValueGroup: Decimal;
        DebitValuePeriod: Decimal;
        CreditValuePeriod: Decimal;
        DebitValueFooter: Decimal;
        CreditValueFooter: Decimal;
        LastGlobalDim1Code: Code[20];
        LastGlobalDim2Code: Code[20];
        EntryNo: Integer;
        ProjectCode: Code[20];
        DepartmentCode: Code[20];
        FromDate: Date;
        ToDate: Date;
        PrintAllHavingBal: Boolean;
        HeaderText: Text[250];
        HeaderText0: Text[250];
        Text31022890: Label 'Period: ';
        Text31022891: Label 'Report Filters: ';
        LastGLAccNo: Text[20];
        GenLedgSetup: Record "General Ledger Setup";
        Trial_Balance_Departament_Project_AccountCaption: Text;
        Text31022892: Label 'Verifying entries...             \';
        Text31022893: Label 'Department    ';
        Text31022894: Label 'Project       ';
        Text31022895: Label 'G/L Account   ';
        Text31022896: Label 'Fiscal Year does not exist.';
        GLacc2: Record "G/L Account";
        BalanceAtDateFooter: Decimal;
        DebitValueGroup_CreditValueGroup: Decimal;
        BalanceAtDateFooterGroup: Decimal;
        BalanceAtDateFooterPeriod: Decimal;
        Trial_Balance_Departament_Project___AccountCaptionLbl: Label 'Trial Balance %1 - %2 / Account';

    procedure StartingPeriod(Date: Date): Date
    var
        AccPeriod: Record "Accounting Period";
    begin
        AccPeriod.SETRANGE("New Fiscal Year", TRUE);
        AccPeriod.SETFILTER("Starting Date", '<= %1', Date);
        IF AccPeriod.FINDLAST THEN
            EXIT(AccPeriod."Starting Date")
        ELSE
            ERROR(Text31022896);
    end;
}

