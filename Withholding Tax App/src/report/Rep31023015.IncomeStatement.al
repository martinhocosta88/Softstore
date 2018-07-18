report 31023015 "Income Statement"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Income Statement.rdl';
    Caption = 'Income Statement';
    UseRequestPage = true;
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem(Vendor;Vendor)
        {
            DataItemTableView = SORTING("No.")
                                WHERE("Subject to Withholding Tax"=FILTER(true));
            RequestFilterFields = "No.";
            column(Vendor_No;"No.")
            {
            }
            column(CompanyInfo_Picture;CompanyInfo.Picture)
            {
            }
            dataitem(CopyLoop;Integer)
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop;Integer)
                {
                    DataItemTableView = SORTING(Number)
                                        WHERE(Number=CONST(1));
                    column(Vendor_Name_Vendor_Name_2;Vendor.Name+' '+Vendor."Name 2")
                    {
                    }
                    column(CompanyAddr_1;CompanyAddr[1])
                    {
                    }
                    column(CompanyAddr_2;CompanyAddr[2])
                    {
                    }
                    column(CompanyAddr_3;CompanyAddr[3])
                    {
                    }
                    column(CompanyAddr_4;CompanyAddr[4])
                    {
                    }
                    column(Vendor_Address;Vendor.Address)
                    {
                    }
                    column(Vendor_Address_2;Vendor."Address 2")
                    {
                    }
                    column(Vendor_Post_Code_Vendor_City;Vendor."Post Code"+' '+Vendor.City)
                    {
                    }
                    column(FORMAT_WORKDATE_0_Day_de_Month_Text_Year4;FORMAT(WORKDATE,0,'<Day> de <Month Text> <Year4>'))
                    {
                    }
                    column(PageLoop_Number;Number)
                    {
                    }
                    dataitem(Text;Integer)
                    {
                        DataItemLinkReference = Vendor;
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number=FILTER(1));
                        column(IncomeYear;IncomeYear)
                        {
                        }
                        column(STRSUBSTNO_TextDescription_Vendor_Name_Vendor_Name_2_Vendor_VAT_Registration_No;STRSUBSTNO(TextDescription,Vendor.Name+' '+Vendor."Name 2",Vendor."VAT Registration No."))
                        {
                        }
                        column(Amount1;Amount1)
                        {
                        }
                        column(Amount2;Amount2)
                        {
                        }
                        column(Amount3;Amount3)
                        {
                        }
                        column(CurrencyString;CurrencyString)
                        {
                        }
                        column(IncomesType_Description;IncomeType.Description)
                        {
                        }
                        column(Income_StatementCaption;Income_StatementCaptionLbl)
                        {
                        }
                        column(YearCaption;YearCaptionLbl)
                        {
                        }
                        column(Remuneration_WorkingCaption;Remuneration_WorkingCaptionLbl)
                        {
                        }
                        column(Without_RetentionCaption;Without_RetentionCaptionLbl)
                        {
                        }
                        column(With_RetentionCaption;With_RetentionCaptionLbl)
                        {
                        }
                        column(Having_been_made_the_following_deduction_Caption;Having_been_made_the_following_deduction_CaptionLbl)
                        {
                        }
                        column(I_R_S_Caption;I_R_S_CaptionLbl)
                        {
                        }
                        column(Text_Number;Number)
                        {
                        }
                    }
                }

                trigger OnPreDataItem();
                begin
                    NoOfLoops := ABS(NoOfCopies) + 1;
                    SETRANGE(Number,1,NoOfLoops);
                end;
            }

            trigger OnAfterGetRecord();
            begin
                FormatAddr.Company(CompanyAddr,CompanyInfo);

                WithTaxLedgEntry.RESET;
                WithTaxLedgEntry.SETCURRENTKEY("Has Withholding Tax","Entity Type","Entry No.","Document Date");
                WithTaxLedgEntry.SETRANGE("Entity Type",WithTaxLedgEntry."Entity Type"::Vendor);
                WithTaxLedgEntry.SETRANGE("Entity No.","No.");
                WithTaxLedgEntry.SETRANGE("Document Date",Startdate,Enddate);
                WithTaxLedgEntry.SETRANGE("Has Withholding Tax",TRUE);
                IF NOT  WithTaxLedgEntry.ISEMPTY THEN BEGIN
                  WithTaxLedgEntry.CALCSUMS("Income Amount","Withholding Tax Amount");
                  Amount1 := WithTaxLedgEntry."Income Amount";
                  Amount3 := WithTaxLedgEntry."Withholding Tax Amount";
                END;
                WithTaxLedgEntry.RESET;
                WithTaxLedgEntry.SETCURRENTKEY("Has Withholding Tax","Entity Type","Entity No.","Document Date");
                WithTaxLedgEntry.SETRANGE("Entity No.","No.");
                WithTaxLedgEntry.SETRANGE("Document Date",Startdate,Enddate);
                WithTaxLedgEntry.SETRANGE("Has Withholding Tax",FALSE);
                IF NOT  WithTaxLedgEntry.ISEMPTY THEN BEGIN 
                  WithTaxLedgEntry.CALCSUMS("Income Amount");
                  Amount2 := WithTaxLedgEntry."Income Amount";
                END; 
                IF IncomeType.GET("Income Type") THEN;
            end;

            trigger OnPreDataItem();
            begin
                Startdate := DMY2DATE(1,1,IncomeYear);
                Enddate := DMY2DATE(31,12,IncomeYear);
            end;
        }
        dataitem(Customer;Customer)
        {
            DataItemTableView = SORTING("No.")
                                WHERE("Subject to Withholding Tax"=FILTER(true));
            RequestFilterFields = "No.";
            column(Customer_No;"No.")
            {
            }
            column(CompanyInfo_Picture_C;CompanyInfo.Picture)
            {
            }
            dataitem(CopyLoop_C;Integer)
            {
                DataItemTableView = SORTING(Number);
                dataitem(PageLoop_C;Integer)
                {
                    DataItemTableView = SORTING(Number)
                                        WHERE(Number=CONST(1));
                    column(Customer_Name_Customer_Name_2;Customer.Name+' '+Customer."Name 2")
                    {
                    }
                    column(CompanyAddr_1_C;CompanyAddr[1])
                    {
                    }
                    column(CompanyAddr_2_C;CompanyAddr[2])
                    {
                    }
                    column(CompanyAddr_3_C;CompanyAddr[3])
                    {
                    }
                    column(CompanyAddr_4_C;CompanyAddr[4])
                    {
                    }
                    column(Customer_Address;Customer.Address)
                    {
                    }
                    column(Customer_Address_2;Customer."Address 2")
                    {
                    }
                    column(Customer_Post_Code_Customer_City;Customer."Post Code"+' '+Customer.City)
                    {
                    }
                    column(FORMAT_WORKDATE_0_Day_de_Month_Text_Year4_C;FORMAT(WORKDATE,0,'<Day> de <Month Text> <Year4>'))
                    {
                    }
                    column(PageLoop_Number_C;Number)
                    {
                    }
                    dataitem(Text_C;Integer)
                    {
                        DataItemLinkReference = Vendor;
                        DataItemTableView = SORTING(Number)
                                            WHERE(Number=FILTER(1));
                        column(IncomeYear_C;IncomeYear)
                        {
                        }
                        column(STRSUBSTNO_TextDescription_Customer_Name_Customer_Name_2_Customer_VAT_Registration_No;STRSUBSTNO(TextDescription,Customer.Name+' '+Customer."Name 2",Customer."VAT Registration No."))
                        {
                        }
                        column(Amount1_C;ABS(Amount1))
                        {
                        }
                        column(Amount2_C;ABS(Amount2))
                        {
                        }
                        column(Amount3_C;ABS(Amount3))
                        {
                        }
                        column(CurrencyString_C;CurrencyString)
                        {
                        }
                        column(IncomesType_Description_C;IncomeType.Description)
                        {
                        }
                        column(Income_StatementCaption_C;Income_StatementCaptionLbl)
                        {
                        }
                        column(YearCaption_C;YearCaptionLbl)
                        {
                        }
                        column(Remuneration_WorkingCaption_C;Remuneration_WorkingCaptionLbl)
                        {
                        }
                        column(Without_RetentionCaption_C;Without_RetentionCaptionLbl)
                        {
                        }
                        column(With_RetentionCaption_C;With_RetentionCaptionLbl)
                        {
                        }
                        column(Having_been_made_the_following_deduction_Caption_C;Having_been_made_the_following_deduction_CaptionLbl)
                        {
                        }
                        column(I_R_S_Caption_C;I_R_S_CaptionLbl)
                        {
                        }
                        column(Text_Number_C;Number)
                        {
                        }
                    }
                }

                trigger OnPreDataItem();
                begin
                    NoOfLoops := ABS(NoOfCopies) + 1;
                    SETRANGE(Number,1,NoOfLoops);
                end;
            }

            trigger OnAfterGetRecord();
            begin
                FormatAddr.Company(CompanyAddr,CompanyInfo);

                WithTaxLedgEntry.RESET;
                WithTaxLedgEntry.SETCURRENTKEY("Has Withholding Tax","Entity Type","Entry No.","Document Date");
                WithTaxLedgEntry.SETRANGE("Entity Type",WithTaxLedgEntry."Entity Type"::Customer);
                WithTaxLedgEntry.SETRANGE("Entity No.","No.");
                WithTaxLedgEntry.SETRANGE("Document Date",Startdate,Enddate);
                WithTaxLedgEntry.SETRANGE("Has Withholding Tax",TRUE);
                IF NOT  WithTaxLedgEntry.ISEMPTY THEN BEGIN  //V10.00#00001,n
                  WithTaxLedgEntry.CALCSUMS("Income Amount","Withholding Tax Amount");
                  Amount1 := WithTaxLedgEntry."Income Amount";
                  Amount3 := WithTaxLedgEntry."Withholding Tax Amount";
                END; //V10.00#00001,n
                WithTaxLedgEntry.RESET;
                WithTaxLedgEntry.SETCURRENTKEY("Has Withholding Tax","Entity Type","Entity No.","Document Date");
                WithTaxLedgEntry.SETRANGE("Entity No.","No.");
                WithTaxLedgEntry.SETRANGE("Document Date",Startdate,Enddate);
                WithTaxLedgEntry.SETRANGE("Has Withholding Tax",FALSE);
                IF NOT  WithTaxLedgEntry.ISEMPTY THEN BEGIN //V10.00#00001,n
                  WithTaxLedgEntry.CALCSUMS("Income Amount");
                  Amount2 := WithTaxLedgEntry."Income Amount";
                END; //V10.00#00001,n
                IF IncomeType.GET("Income Type") THEN;
            end;

            trigger OnPreDataItem();
            begin
                Startdate := DMY2DATE(1,1,IncomeYear);
                Enddate := DMY2DATE(31,12,IncomeYear);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group("Income Statement")
                {
                    field(Year;IncomeYear)
                    {
                        CaptionML = ENU='Year',
                                    PTG='Ano';
                    }
                    field(NoOfCopies;NoOfCopies)
                    {
                        CaptionML = ENU='No. Of Copies',
                                    PTG='Nº de Cópias';
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
    }

    trigger OnInitReport();
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
        IncomeYear := DATE2DMY(TODAY, 3)-1;
    end;

    var
        CompanyInfo : Record "Company Information";
        FormatAddr : Codeunit "Format Address";
        NoOfCopies : Integer;
        NoOfLoops : Integer;
        CopyText : Text[30];
        CompanyAddr : array [8] of Text[50];
        IncomeYear : Integer;
        TextDescription : Label 'Para efeitos do disposto na alínea b) do nº 1 do Artigo 119º do Código do I.R.S., se declara que %1, Contribuinte Nº %2, auferiu nesta empresa durante o ano indicado, as seguintes remunerações:';
        Amount1 : Decimal;
        Amount2 : Decimal;
        Amount3 : Decimal;
        WithTaxLedgEntry : Record "Withholding Tax Ledger Entry";
        Startdate : Date;
        Enddate : Date;
        IncomeType : Record "Income Type";
        Income_StatementCaptionLbl : TextConst ENU='Income Statement',PTG='Declaração de Rendimentos';
        YearCaptionLbl : TextConst ENU='Year',PTG='Ano';
        Remuneration_WorkingCaptionLbl : TextConst ENU='- Remuneration Working',PTG='- Remunerações de';
        Without_RetentionCaptionLbl : TextConst ENU='- Without Retention',PTG='- Sem Retenção';
        With_RetentionCaptionLbl : TextConst ENU='- With Retention',PTG='- Com Retenção';
        Having_been_made_the_following_deduction_CaptionLbl : TextConst ENU='Having been made the following deduction:',PTG='Tendo-lhe sido efectuada a seguinte dedução:';
        I_R_S_CaptionLbl : TextConst ENU='- I.R.S.',PTG='IRS';
        CurrencyString : TextConst ENU='  Eur',PTG='  Eur';

    procedure InitLogInteraction();
    begin
    end;
}

