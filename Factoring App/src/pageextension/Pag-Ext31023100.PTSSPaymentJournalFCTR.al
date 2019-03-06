pageextension 31023100 "PTSS Payment Journal FCTR" extends "Payment Journal" //MyTargetPageId
{
    //Factoring
    layout
    {
        addlast(Control1)
        {
            field("PTSS Factoring to Vendor No."; "PTSS Factoring to Vendor No.")
            {
                ToolTip = 'Specifies the Factoring to Vendor No.';
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}