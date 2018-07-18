pageextension 31023121 "Vendor Card Ext" extends "Vendor Card"
{
    layout
    {
        addbefore("Posting Details")
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