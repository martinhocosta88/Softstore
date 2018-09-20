pageextension 31023116 "PTSS Sales Invoice" extends "Sales Invoice"
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