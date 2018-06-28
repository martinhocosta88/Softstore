pageextension 50117 "Purchase Invoice Ext" extends "Purchase Invoice"
{
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