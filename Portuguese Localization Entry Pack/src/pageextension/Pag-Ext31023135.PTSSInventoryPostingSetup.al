pageextension 31023135 "PTSS Inventory Posting Setup" extends "Inventory Posting Setup" //MyTargetPageId
{
    //Registo Inventário Físico
    layout
    {
        addafter("Mfg. Overhead Variance Account")
        {
            field("PTSS Gains in Inventory"; "PTSS Gains in Inventory")
            {
                ToolTip = 'Specifies the Gains in Inventory.';
                ApplicationArea = All;
            }
            field("PTSS Losses in Inventory"; "PTSS Losses in Inventory")
            {
                ToolTip = 'Specifies the Losses in Inventory.';
                ApplicationArea = All;
            }
        }
    }
}