pageextension 31023102 "PTSS Vendor FCTR" extends "Vendor Card" //MyTargetPageId
{
    //Factoring
    layout
    {
        addlast(Payments)
        {
            field("PTSS Factoring to Vendor No."; "PTSS Factoring to Vendor No.")
            {
                Caption = 'Factoring to Vendor No.';
                ApplicationArea = All;
                ToolTip = 'Specifies the Factoriong to Vendor No.';
            }
        }
    }

    actions
    {
    }
}