tableextension 31023007 "General Ledger Setup" extends "General Ledger Setup"
{
    //Check Chart of Accounts
    //Check (PT)
    fields
    {
        field(31022897; "Check Chart of Accounts"; boolean)
        {
            //Check Chart of Accounts
            Caption = 'Check Chart of Accounts';
            DataClassification = CustomerContent;
        }
        field(31022890; "Currency Decimal Unit Text"; Text[30])
        {
            //Check (PT)
            Caption = 'Currency Decimal Unit Text';            
            DataClassification = CustomerContent;
        }
        field(31022891; "Curr. Dec. Unit Decimal Places"; Integer)
        {
            //Check (PT)
            Caption = 'Curr. Dec. Unit Decimal Places';
            DataClassification = CustomerContent;
        }
        field(31022898; "Currency Text"; Text[30])
        {
            //Check (PT)
            Caption = 'Currency Text';
            DataClassification = CustomerContent;
        }
    }
}