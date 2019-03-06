pageextension 31023201 "PTSS Vend. Ldg. Entries FCTR" extends "Vendor Ledger Entries" //MyTargetPageId
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