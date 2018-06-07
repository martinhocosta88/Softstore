table 31022975 "Withholding Tax Codes"
{
    Caption ='Withholding Tax Codes';
    DrillDownPageID = 31023084;
    LookupPageID = 31023084;
    fields
    {
        field(1;"Code";Code[20])
        {
            Caption = 'Code';
        }
        field(2;Description;Text[60])
        {
            Caption = 'Description';
        }
        field(3;"Tax %";Decimal)
        {
            Caption = 'Withholding %';
        }
        field(4;"Account No.";Code[20])
        {
            Caption ='Account No.';
            TableRelation = "G/L Account";
        }
        field(5;"IRC Code";Boolean)
        {
            Caption ='IRC Code';
        }
        field(6;"Max. Correction Amount";Decimal)
        {
            Caption ='Max. Correction Amount';
            MinValue = 0;
        }
    }

    keys
    {
        key(Key1;"Code")
        {
        }
    }

    fieldgroups
    {
    }
}

