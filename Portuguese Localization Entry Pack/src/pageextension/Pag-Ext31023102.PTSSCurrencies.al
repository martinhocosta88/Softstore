pageextension 31023102 "PTSS Currencies" extends Currencies
{
    //Check (PT)
    //Ajust Divisas
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
    actions
    {
        modify("Adjust Exchange Rate")
        {
            Visible = false;
        }
        addafter("Adjust Exchange Rate")
        {
            action("PTSS Adjust Exchange Rate PT")
            {
                Caption = 'Adjust Exchange Rate';
                ToolTip = 'Adjust general ledger, customer, vendor, and bank account entries to reflect a more updated balance if the exchange rate has changed since the entries were posted.';
                ApplicationArea = All;
                PromotedCategory = Process;
                Promoted = true;
                Image = AdjustExchangeRates;
                RunObject = report "PTSS Adjust Exchange Rates";
            }
        }
    }
}