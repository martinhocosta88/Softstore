pageextension 50109 "General Ledger Setup Ext" extends "General Ledger Setup"
{
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