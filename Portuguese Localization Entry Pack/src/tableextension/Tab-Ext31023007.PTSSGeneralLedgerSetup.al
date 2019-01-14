tableextension 31023007 "PTSS General Ledger Setup" extends "General Ledger Setup"
{
    //Check Chart of Accounts
    //Check (PT)
    fields
    {
        field(31022897; "PTSS Check Chart of Accounts"; boolean)
        {
            //Check Chart of Accounts
            Caption = 'Check Chart of Accounts';
            DataClassification = CustomerContent;
        }
        field(31022890; "PTSS Curr. Decimal Unit Text"; Text[30])
        {
            //Check (PT)
            Caption = 'Currency Decimal Unit Text';
            DataClassification = CustomerContent;
        }
        field(31022891; "PTSS Cur. Dec. Unit Dec. Place"; Integer)
        {
            //Check (PT)
            Caption = 'Curr. Dec. Unit Decimal Places';
            DataClassification = CustomerContent;
        }
        field(31022898; "PTSS Currency Text"; Text[30])
        {
            //Check (PT)
            Caption = 'Currency Text';
            DataClassification = CustomerContent;
        }
    }
}