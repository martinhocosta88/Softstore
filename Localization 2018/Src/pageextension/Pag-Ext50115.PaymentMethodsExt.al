pageextension 50115 "Payment Methods Ext" extends "Payment Methods"
{
    layout
    {
        addafter("Bal. Account No.")
        {
            field("Sales Cash-flow code"; "Sales Cash-flow code")
            {
                ToolTip='Specifies the Sales Cash-flow code';
            }
            field("Purch. Cash-flow code"; "Purch. Cash-flow code")
            {
                ToolTip='Specifies the Sales Cash-flow code';
            }
        }
    }    
}