tableextension 31023012 "PTSS Currency" extends Currency
{
    //Check (PT)
    fields
    {
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
    }
}