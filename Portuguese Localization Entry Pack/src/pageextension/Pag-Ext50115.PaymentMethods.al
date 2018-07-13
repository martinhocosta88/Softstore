pageextension 50115 "Payment Methods" extends "Payment Methods"
{
    //Cash-FLow
    layout
    {
        
        addafter("Bal. Account No.")
        {
            field("Sales Cash-flow code"; "Sales Cash-flow code")
            {
                ApplicationArea=All;
                ToolTip='Specifies the Sales Cash-flow code';
            }
            field("Purch. Cash-flow code"; "Purch. Cash-flow code")
            {
                ApplicationArea=All;
                ToolTip='Specifies the Sales Cash-flow code';
            }
        }
    }    
}