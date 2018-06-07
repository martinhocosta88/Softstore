pageextension 50113 "Sales Invoice Subform Ext" extends "Sales Invoice Subform"
{
    layout
    {
        addlast(Control1)
        {
            field("Withholding Tax Code"; "Withholding Tax Code")
            {
                ToolTip = 'Specficies the Withholding Tax Code';
                ApplicationArea = Basic,Suite;
            }
            field("Withholding Tax %"; "Withholding Tax %")
            {
                ToolTip = 'Specifies the Witholding Tax Percentage';
                ApplicationArea = Basic,Suite;
            }
            field("Withholding Tax Amount"; "Withholding Tax Amount")
            {
                ToolTip = 'Specifies the Withholding Tax Amount';
                ApplicationArea = Basic,Suite;
            }
        }
    }
    
    actions
    {

    }
    
    var

}