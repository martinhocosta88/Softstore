tableextension 31023026 "Sales Cr.Memo Line Ext" extends "Sales Cr.Memo Line"
{
    fields
    {
        field(31022970; "Withholding Tax Code"; Code[20])
        {
            caption = 'Withholding Tax Code';
            TableRelation = "Withholding Tax Codes";
            DataClassification = CustomerContent;
        }
        field(31022971; "Withholding Tax %"; Decimal)
        {
            caption='Withholding Tax %';

            DataClassification = CustomerContent;
        }
        field(31022972; "Withholding Tax Account"; Code[20])
        {
            caption='Withholding Tax Account';
            
            DataClassification = CustomerContent;
        }
        field(31022973; "Withholding Tax Amount"; Decimal)
        {
            caption='Withholding Tax Amount';

            DataClassification = CustomerContent;
        }
        field(31022974; "Orig. Withholding Tax Amount"; Decimal)
        {
            caption='Orig. Withholding Tax Amount';

            DataClassification = CustomerContent;
        }
        field(31022975; "Max. Correction Amount"; Decimal)
        {
            caption='Max. Correction Amount';
            MinValue = 0;
            DataClassification = CustomerContent;
        }
    }
    var
}