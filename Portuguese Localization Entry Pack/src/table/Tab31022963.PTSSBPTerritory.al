table 31022963 "PTSS BP Territory"
{
    //COPE

    Caption = 'BP Territory';
    DrillDownPageID = 31023039;
    LookupPageID = 31023039;
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[3])
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

