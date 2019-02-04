pageextension 31023130 "PTSS Item Category Card" extends "Item Category Card" //MyTargetPageId
{
    //AT Inventory Comm.
    layout
    {
        addafter("Parent Category")
        {
            field("PTSS AT Item Category"; "PTSS AT Item Category")
            {
                ToolTip = 'Specifies the AT Item Category.';
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}