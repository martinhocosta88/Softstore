pageextension 31023123 "PTSS Small Business Owner RC" extends "Small Business Owner RC" //MyTargetPageId
{
    //Ajuste Divisas

    actions
    {
        modify("Adjust E&xchange Rates")
        {
            Visible = false;
        }
        addafter("Adjust E&xchange Rates")
        {
            action("PTSS Adjust E&xchange Rates PT")
            {
                Caption = 'Adjust Exchange Rates';
                ToolTip = 'Adjust general ledger, customer, vendor, and bank account entries to reflect a more updated balance if the exchange rate has changed since the entries were posted.';
                Ellipsis = True;
                ApplicationArea = All;
                PromotedCategory = Process;
                Promoted = true;
                Image = AdjustExchangeRates;
                RunObject = report "PTSS Adjust Exchange Rates";
            }
        }
    }
}