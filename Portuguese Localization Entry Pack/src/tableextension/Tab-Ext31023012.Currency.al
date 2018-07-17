tableextension 31023012 "Currency" extends Currency
{
    //Check (PT)
    fields
    {
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
    }
}