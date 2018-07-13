pageextension 31023117 "Purchase Invoice" extends "Purchase Invoice"
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