tableextension 50116 "Sales Cr.Memo Line Ext" extends "Sales Cr.Memo Line"
{
    fields
    {
        field(31022970; "Withholding Tax Code"; Code[20])
        {
            caption = 'Withholding Tax Code';
            TableRelation = "Withholding Tax Codes";
            DataClassification = ToBeClassified;
        }
        field(31022971; "Withholding Tax %"; Decimal)
        {
            caption='Witholding Tax %';

            DataClassification = ToBeClassified;
        }
        field(31022972; "Withholding Tax Account"; Code[20])
        {
            caption='Witholding Tax Account';
            
            DataClassification = ToBeClassified;
        }
        field(31022973; "Withholding Tax Amount"; Decimal)
        {
            caption='Witholding Tax Amount';

            DataClassification = ToBeClassified;
        }
        field(31022974; "Orig. Withholding Tax Amount"; Decimal)
        {
            caption='Orig. Witholding Tax Amount';

            DataClassification = ToBeClassified;
        }
        field(31022975; "Max. Correction Amount"; Decimal)
        {
            caption='Max. Correction Amount';
            MinValue = 0;
            DataClassification = ToBeClassified;
        }
    }
    var
}