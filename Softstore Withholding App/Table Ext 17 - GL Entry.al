tableextension 50119 "GL Entry Ext" extends "G/L Entry"
{
    fields
    {
        field(31022970; "Withholding Tax Code"; Code[20])
        {
            caption = 'Withholding Tax Code';
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
        field(31022973; "Witholding Tax Autom. Entry"; Boolean)
        {
            caption='Witholding Tax Autom. Entry';
            DataClassification = ToBeClassified;
        }
        field(31022974; "Calc. IRC Withholding Tax"; Boolean)
        {
            caption='Calc. IRC Withholding Tax';
            DataClassification = ToBeClassified;
        }

    }
    var
}