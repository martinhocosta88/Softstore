pageextension 50117 "Purchase Invoice Ext" extends "Purchase Invoice"
{
    layout
    {
        addlast("Invoice Details")
        {
            field("Cash-flow code"; "Cash-flow code")
            {
                ApplicationArea=basic,suite;
                ToolTip='Specifies the Cash-flow code.';
            }
        }
    }
}