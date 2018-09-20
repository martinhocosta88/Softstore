pageextension 31023109 "PTSS General Ledger Setup" extends "General Ledger Setup"
{
    //Check Chart of Accounts
    layout
    {
        addlast(General)
        {

            field("PTSS Check Chart of Accounts"; "PTSS Check Chart of Accounts")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies if checks chart of accounts.';
            }
            field("PTSS Currency Decimal Unit Text"; "PTSS Currency Decimal Unit Text")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Currency Decimal Unit Text.';
            }
            field("PTSS Curr. Dec. Unit Decimal Places"; "PTSS Curr. Dec. Unit Decimal Places")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Curr. Dec. Unit Decimal Places.';
            }
            field("PTSS Currency Text"; "PTSS Currency Text")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies Currency Text.';
            }
        }
    }
}