pageextension 50116 "Sales Invoice Ext" extends "Sales Invoice"
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