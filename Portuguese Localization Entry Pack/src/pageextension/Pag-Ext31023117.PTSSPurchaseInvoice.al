pageextension 31023117 "PTSS Purchase Invoice" extends "Purchase Invoice"
{
    //Cash-Flow
    layout
    {

        addlast("Invoice Details")
        {
            field("PTSS Cash-flow code"; "PTSS Cash-flow code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Cash-flow code.';
            }
        }
    }
}