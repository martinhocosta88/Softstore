page 31023052 "PTSS AT Com. Inventory Log"
{
    //AT Inventory Communication

    Caption = 'AT Communication Inventory Log';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    UsageCategory = History;
    ApplicationArea = Basic, Suite;
    SourceTable = "PTSS AT Inventory Comm. Log";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Date/Time"; "Date/Time")
                {
                    ApplicationArea = All;
                }
                field("Fiscal Year"; "Fiscal Year")
                {
                    ApplicationArea = All;
                }
                field("Ending Date"; "Ending Date")
                {
                    ApplicationArea = All;
                }
                field("Last Item Ledger Entry No."; "Last Item Ledger Entry No.")
                {
                    ApplicationArea = All;
                }
                field("User ID"; "User ID")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

