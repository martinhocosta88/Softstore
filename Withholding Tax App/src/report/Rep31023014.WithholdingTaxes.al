report 31023014 "Withholding Taxes"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Withholding Taxes.rdl';
    Caption = 'Withholding Taxes';
    UsageCategory = ReportsAndAnalysis;
    dataset
    {
        dataitem("Withholding Tax Ledger Entry";"Withholding Tax Ledger Entry")
        {
            DataItemTableView = SORTING("Entity Type","Entity No.","Withholding Tax Code","Document Type");
            RequestFilterFields = "Entity Type","Document No.";
            column(PageConst_________FORMAT_CurrReport_PAGENO_;PageConst + ' ' + FORMAT(CurrReport.PAGENO))
            {
            }
            column(FORMAT_TODAY_0_4_;FORMAT(TODAY,0,4))
            {
            }
            column(CompanyAddr_1_;CompanyAddr[1])
            {
            }
            column(CompanyAddr_2_;CompanyAddr[2])
            {
            }
            column(CompanyAddr_3_;CompanyAddr[3])
            {
            }
            column(CompanyAddr_4_;CompanyAddr[4])
            {
            }
            column(CompanyInfo_Picture;CompanyInfo.Picture)
            {
            }
            column(GETFILTERS;GETFILTERS)
            {
            }
            column(IRS_IRC_Retentions__VAT_No__;"VAT Registration No.")
            {
            }
            column(Entity_No;"Withholding Tax Ledger Entry"."Entity No.")
            {
            }
            column(Source_Type;"Withholding Tax Ledger Entry"."Entity Type")
            {
            }
            column(recVendor_Name_____recVendor__Name_2_;recVendor.Name+' '+recVendor."Name 2")
            {
            }
            column(IRS_IRC_Retentions__Retention_Code_;"Withholding Tax Code")
            {
            }
            column(recretCode_Description;recretCode.Description)
            {
            }
            column(IRS_IRC_Retentions__Document_No__;"Document No.")
            {
            }
            column(IRS_IRC_Retentions__Income_Value_;ABS("Income Amount"))
            {
            }
            column(IRS_IRC_Retentions__Retention_Value_;ABS("Withholding Tax Amount"))
            {
            }
            column(IRS_IRC_Retentions__Document_Date_;"Document Date")
            {
            }
            column(TotalFor____Retention_Code_;TextTotalFor + "Withholding Tax Code")
            {
            }
            column(IRS_IRC_Retentions__Income_Value__Control1000000024;"Income Amount")
            {
            }
            column(IRS_IRC_Retentions__Retention_Value__Control1000000011;"Withholding Tax Amount")
            {
            }
            column(TotalFor____VAT_No__;TextTotalFor + "VAT Registration No.")
            {
            }
            column(IRS_IRC_Retentions__Income_Value__Control1000000026;"Income Amount")
            {
            }
            column(IRS_IRC_Retentions__Retention_Value__Control1000000012;"Withholding Tax Amount")
            {
            }
            column(IRS_IRC_Retentions__Retention_Value__Control1000000010;"Withholding Tax Amount")
            {
            }
            column(IRS_IRC_Retentions__Income_Value__Control1000000013;"Income Amount")
            {
            }
            column(TextTotal;TextTotal)
            {
            }
            column(IRS_IRC_RetentionCaption;IRS_IRC_RetentionCaptionLbl)
            {
            }
            column(Document_No_Caption;Document_No_CaptionLbl)
            {
            }
            column(IncomeCaption;IncomeCaptionLbl)
            {
            }
            column(RetentionsCaption;RetentionsCaptionLbl)
            {
            }
            column(VAT_Registration_No_Caption;VAT_Registration_No_CaptionLbl)
            {
            }
            column(Retention_CodeCaption;Retention_CodeCaptionLbl)
            {
            }
            column(Doc__DateCaption;Doc__DateCaptionLbl)
            {
            }
            column(Filters_Caption;Filters_CaptionLbl)
            {
            }
            column(IRS_IRC_Retentions_Entry_No_;"Entry No.")
            {
            }

            trigger OnPreDataItem();
            begin
                LastFieldNo := FIELDNO("Withholding Tax Code");
                FormatAddr.Company(CompanyAddr,CompanyInfo);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
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
    end;

    var
        PageConst : Label 'Página';
        LastFieldNo : Integer;
        FooterPrinted : Boolean;
        TextTotalFor : Label '"Total de "';
        nextpage : Boolean;
        showpage : Boolean;
        breakpage : Boolean;
        TextTotal : Label 'Total';
        recVendor : Record Vendor;
        recretCode : Record "Withholding Tax Codes";
        CompanyInfo : Record "Company Information";
        CompanyAddr : array [8] of Text[50];
        FormatAddr : Codeunit 365;
        IRS_IRC_RetentionCaptionLbl : TextConst ENU='Income and Withholding Summary Report ',PTG='Mapa Resumo de Rendimentos e Retenções';
        Document_No_CaptionLbl : TextConst ENU='Document No.',PTG='Nº Documento';
        IncomeCaptionLbl : TextConst ENU='Income',PTG='Rendimentos';
        RetentionsCaptionLbl : TextConst ENU='Withholding Taxes',PTG='Retenções na Fonte';
        VAT_Registration_No_CaptionLbl : TextConst ENU='VAT Registration No.',PTG='Nº Contribuinte';
        Retention_CodeCaptionLbl : TextConst ENU='Withholding Tax Code',PTG='Código Retenção na Fonte';
        Doc__DateCaptionLbl : TextConst ENU='Doc. Date',PTG='Data Doc.';
        Filters_CaptionLbl : TextConst ENU='Filters:',PTG='Filtros:';
}

