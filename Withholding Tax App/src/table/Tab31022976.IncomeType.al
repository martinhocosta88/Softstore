table 31022976 "Income Type"
{

    Caption ='Income Type';
    DrillDownPageID = "Income Type List";
    LookupPageID = "Income Type List";

    fields
    {
        field(1;"Code";Code[20])
        {
            Caption='Code';
            DataClassification = CustomerContent; 
        }
        field(2;Description;Text[60])
        {
            Caption='Description';
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

