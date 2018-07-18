table 31022975 "Withholding Tax Codes"
{
    Caption ='Withholding Tax Codes';
    DrillDownPageID = "Withholding Tax Codes List";
    LookupPageID = "Withholding Tax Codes List";
    fields
    {
        field(1;"Code";Code[20])
        {
            Caption = 'Code';
            DataClassification = CustomerContent; 
        }
        field(2;Description;Text[60])
        {
            Caption = 'Description';
            DataClassification = CustomerContent; 
        }
        field(3;"Tax %";Decimal)
        {
            Caption = 'Withholding %';
            DataClassification = CustomerContent; 
        }
        field(4;"Account No.";Code[20])
        {
            Caption ='Account No.';
            TableRelation = "G/L Account";
            DataClassification = CustomerContent; 
        }
        field(5;"IRC Code";Boolean)
        {
            Caption ='IRC Code';
            DataClassification = CustomerContent; 
        }
        field(6;"Max. Correction Amount";Decimal)
        {
            Caption ='Max. Correction Amount';
            MinValue = 0;
            DataClassification = CustomerContent; 
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

