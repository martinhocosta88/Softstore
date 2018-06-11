table 50131 "Income Type"
{

    Caption ='Income Type';
    DrillDownPageID = "Income Type List";
    LookupPageID = "Income Type List";

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

