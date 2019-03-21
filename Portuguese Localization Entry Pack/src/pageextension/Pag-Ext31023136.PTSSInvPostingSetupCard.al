pageextension 31023136 "PTSS Inv. Posting Setup Card" extends "Inventory Posting Setup Card" //MyTargetPageId
{
    //Registo Inventário Físico
    layout
    {
        addafter(Manufacturing)
        {
            group("Gains and Losses")
            {
                field("PTSS Gains in Inventory"; "PTSS Gains in Inventory")
                {
                    ToolTip = 'Specifies the Gains in Inventory account.';
                    ApplicationArea = All;
                }
                field("PTSS Losses in Inventory"; "PTSS Losses in Inventory")
                {
                    ToolTip = 'Specifies the Losses in Inventory account';
                    ApplicationArea = All;
                }
            }
        }
    }
}