tableextension 31023060 "PTSS VAT Posting Setup" extends "VAT Posting Setup" //MyTargetTableId
{
    //Configuracao SAFT
    fields
    {
        field(31022893; "PTSS SAF-T PT VAT Code"; Option)
        {
            OptionMembers = " ","Intermediate tax rate","Normal tax rate","Reduced tax rate","No tax rate","Others","Stamp Duty","Exempt from IVA or Stamp Duty";
            OptionCaption = ' ,Intermediate tax rate,Normal tax rate,Reduced tax rate,No tax rate,Others,Stamp Duty,Exempt from IVA or Stamp Duty';
            Caption = 'SAF-T PT VAT Code';
            DataClassification = CustomerContent;
        }
        field(31022894; "PTSS SAF-T PT VAT Type Description"; Option)
        {
            OptionMembers = " ","VAT Portugal Mainland","VAT Madeira","VAT Azores","VAT European Union","VAT Exportation";
            OptionCaption = ' ,VAT Portugal Mainland,VAT Madeira,VAT Azores,VAT European Union,VAT Exportation';
            caption = 'SAF-T PT VAT Type Description';
            DataClassification = CustomerContent;
        }
    }
}