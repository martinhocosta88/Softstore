table 31022907 "PTSS Inc. Stmt. Clos. Buffer"
{
    //Lancamento Regularizacao

    Caption = 'Inc. Stmt. Clos. Buffer';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Account No."; Text[20])
        {
            Caption = 'Account No.';
        }
        field(3; "Amount"; Decimal)
        {
            Caption = 'Amount';
        }
        field(4; "Additional-Currency Amount"; Decimal)
        {
            Caption = 'Additional-Currency Amount';
        }
        field(5; "Closing Account?"; Boolean)
        {
            Caption = 'Closing Account?';
        }
        field(6; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (1));
        }
        field(7; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (2));
        }
        field(8; "Business Unit Code"; Code[10])
        {
            Caption = 'Business Unit Code';
            TableRelation = "Business Unit";
        }
    }

    keys
    {
        key(Key1; "Entry No.", "Account No.")
        {
        }
    }

    fieldgroups
    {
    }
}

