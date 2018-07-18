pageextension 31023120 "Customer Card Ext" extends "Customer Card"
{
    layout
    {
        addbefore(PostingDetails)
        {
            field("Subject to Withholding Tax"; "Subject to Withholding Tax")
            {
                ToolTip='Specifies if the Customer is Subject to Withholding Tax';
                ApplicationArea = Basic,Suite;
            }
            field("Income Type"; "Income Type")
            {
                ToolTip='Specifies the Income Type of the Customer';
                ApplicationArea = Basic,Suite;
            }
        }
    }
    actions
    {

    }
    
    var
       
}