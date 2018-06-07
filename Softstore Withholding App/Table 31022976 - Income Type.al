table 31022976 "Income Type"
{

    Caption ='Income Type';
    DrillDownPageID = 31023085;
    LookupPageID = 31023085;

    fields
    {
        field(1;"Code";Code[20])
        {
            Caption='Code';
        }
        field(2;Description;Text[60])
        {
            Caption='Description';
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

