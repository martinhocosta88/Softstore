tableextension 31023029 "GL Entry Ext" extends "G/L Entry"
{
    fields
    {
        field(31022970; "Withholding Tax Code"; Code[20])
        {
            caption = 'Withholding Tax Code';
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
        field(31022973; "Withholding Tax Autom. Entry"; Boolean)
        {
            caption='Withholding Tax Autom. Entry';
            DataClassification = CustomerContent;
        }
        field(31022974; "Calc. IRC Withholding Tax"; Boolean)
        {
            caption='Calc. IRC Withholding Tax';
            DataClassification = CustomerContent;
        }
    }
    var
}