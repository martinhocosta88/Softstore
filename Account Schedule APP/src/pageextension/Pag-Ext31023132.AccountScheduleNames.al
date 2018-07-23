pageextension 31023132 "Account Schedule Names" extends "Account Schedule Names" //MyTargetPageId
{
    layout
    {
        addafter("Default Column Layout")
        {
            field(Standardized;Standardized)
            {
                ToolTip='Specifies if it is Standardized.';
                ApplicationArea = Basic,Suite;
            }
            
        }
    }
    
    actions
    {
    }
}