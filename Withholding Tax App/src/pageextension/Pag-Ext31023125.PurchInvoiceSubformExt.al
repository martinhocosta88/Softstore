pageextension 31023125 "Purch. Invoice Subform Ext" extends "Purch. Invoice Subform"
{
    layout
    {
        addbefore(Control39)
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