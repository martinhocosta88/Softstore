pageextension 50101 "PTSS Vend. Ldg. Entries FCTR" extends "Vendor Ledger Entries" //MyTargetPageId
{
    layout
    {
        addlast(Control1)
        {
            field("PTSS Factoring to Vendor No."; "PTSS Factoring to Vendor No.")
            {
                ToolTip = 'Specifies the Fatoring to Vendor No.';
                ApplicationArea = All;
            }

        }

    }

    actions
    {
    }
}