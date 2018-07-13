pageextension 50118 "Currencies" extends Currencies
{
    //Check (PT)
    layout
    {
        
        addafter(Description)
        {
            field("Currency Decimal Unit Text";"Currency Decimal Unit Text")
            {
                ApplicationArea = All;
                ToolTip='Specifies the Currency Decimal Unit Text';
            }
            field("Curr. Dec. Unit Decimal Places";"Curr. Dec. Unit Decimal Places")
            {
                ApplicationArea = All;
                ToolTip='Specifies the Curr. Dec. Unit Decimal Places';
            }
        }
    }
}