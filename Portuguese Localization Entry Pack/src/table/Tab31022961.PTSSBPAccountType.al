table 31022961 "PTSS BP Account Type"
{
    //COPE

    Caption = 'BP Account Type';
    DrillDownPageID = 31023037;
    LookupPageID = 31023037;
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[1])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; "Description"; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }
}

