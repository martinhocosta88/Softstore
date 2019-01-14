table 31022973 "PTSS AT Inventory Comm. Log"
{
    //AT Inventory Communication

    Caption = 'AT Inventory Comm. Log';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
        }
        field(2; "Date/Time"; DateTime)
        {
            Caption = 'Date/Time';
            Editable = false;
        }
        field(3; "User ID"; Code[50])
        {
            Caption = 'User ID';
            Editable = false;
        }
        field(4; "Fiscal Year"; Integer)
        {
            Caption = 'Fiscal Year';
            Editable = false;
        }
        field(5; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
            Editable = false;
        }
        field(6; "Last Item Ledger Entry No."; Integer)
        {
            Caption = 'Last Item Ledger Entry No.';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
        key(Key2; "Ending Date")
        {
        }
    }

    fieldgroups
    {
    }
}

