pageextension 31023116 "Sales Invoice" extends "Sales Invoice"
{
    //Cash-Flow
    layout
    {
        
        addlast("Invoice Details")
        {
            field("Cash-flow code"; "Cash-flow code")
            {
                ApplicationArea=All;
                ToolTip='Specifies the Cash-flow code.';
            }
        }
    }
}