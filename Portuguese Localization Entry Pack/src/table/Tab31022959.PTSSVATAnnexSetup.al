table 31022959 "PTSS VAT Annex Setup"
{
    // IRC Modelo 22

    Caption = 'VAT Annex Setup';
    DrillDownPageID = "PTSS VAT Annex Setup";
    LookupPageID = "PTSS VAT Annex Setup";

    fields
    {
        field(1; "Annex"; Option)
        {
            Caption = 'Annex';
            OptionCaption = '40,41';
            OptionMembers = "40","41";
        }
        field(2; "Record Type"; Text[2])
        {
            Caption = 'Record Type';
        }
        field(3; "Frame"; Option)
        {
            Caption = 'Frame';
            OptionCaption = '1,1-A,1-B,1-C,1-D,1-E,1-F,1-G,2,3';
            OptionMembers = "1","1-A","1-B","1-C","1-D","1-E","1-F","1-G","2","3";
        }
        field(4; "Article"; Option)
        {
            Caption = 'Article';
            OptionCaption = '78.º,78.º-A,78.º-B,78.º-C,78.º-D';
            OptionMembers = "78.º","78.º-A","78.º-B","78.º-C","78.º-D";
        }
        field(5; "No."; Text[2])
        {
            Caption = 'No.';
        }
        field(6; "SubSection"; Text[1])
        {
            Caption = 'SubSection';
        }
        field(7; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            NotBlank = true;
            TableRelation = "Reason Code".Code;
        }
        field(8; "Tax Authority Code"; Text[2])
        {
            Caption = 'Tax Authority Code';
            Numeric = true;
        }
        field(9; "Group By Doc. No."; Boolean)
        {
            Caption = 'Group By Doc. No.';

            trigger OnValidate()
            begin
                IF "Group By Doc. No." THEN
                    "Group by Reason Code" := FALSE;
            end;
        }
        field(10; "Group by Reason Code"; Boolean)
        {
            Caption = 'Group by Reason Code';

            trigger OnValidate()
            begin
                IF "Group by Reason Code" THEN
                    "Group By Doc. No." := FALSE;
            end;
        }
    }

    keys
    {
        key(Key1; Annex, "Record Type", Frame, Article, "No.", SubSection)
        {
        }
    }

    fieldgroups
    {
    }
}

