pageextension 31023102 "PTSS Currencies" extends Currencies
{
    //Check (PT)
    layout
    {
        addafter(Description)
        {
            field("PTSS Currency Decimal Unit Text"; "PTSS Curr. Decimal Unit Text")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Currency Decimal Unit Text';
            }
            field("PTSS Curr. Dec. Unit Decimal Places"; "PTSS Cur. Dec. Unit Dec. Place")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Curr. Dec. Unit Decimal Places';
            }
        }
    }
}