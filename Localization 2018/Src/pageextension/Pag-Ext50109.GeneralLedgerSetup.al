pageextension 50109 "General Ledger Setup" extends "General Ledger Setup"
{
    //Check Chart of Accounts
    layout
    {
        addlast(General)
        {
            field("Check Chart of Accounts"; "Check Chart of Accounts")
            {
                ApplicationArea=All;
                ToolTip = 'Specifies if checks chart of accounts.';
            }
        }
    }
}