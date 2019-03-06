pageextension 31023202 "PTSS Vendor FCTR" extends "Vendor Card" //MyTargetPageId
{
    //Factoring
    layout
    {
        addlast(Payments)
        {
            field("PTSS Factoring to Vendor No."; "PTSS Factoring to Vendor No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Factoring to Vendor No.';
            }
        }
    }
    actions
    {
    }
}