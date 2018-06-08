tableextension 50101 AccScheduleLineExt extends "Acc. Schedule Line"
{
    fields
    {
        // Add changes to table fields here
        field(31022890;"Column Value"; Option)
        {
            //OptionCaption =  "1st Value","2nd Value","3rd Value";
            caption = 'Column Value';
            OptionMembers = "1st Value","2nd Value","3rd Value";
            OptionCaption = '1st Value,2nd Value,3rd Value';
            DataClassification = CustomerContent;
        }
        field(31022891; "Positive Only"; boolean)
        {
            caption = 'Positive Only';
            DataClassification = CustomerContent;
        }
        field(31022892; "Positive Only 2"; boolean)
        {
            caption = 'Positive Only 2';
            DataClassification = CustomerContent;
        }
        field(31022893; "Reverse Sign"; boolean)
        {
            caption = 'Reverse Sign';
            DataClassification = CustomerContent;
        }
        field(31022894; "Reverse Sign 2"; boolean)
        {
            caption = 'Reverse Sign 2';
            DataClassification = CustomerContent;
        }
        field(31022895; "Totaling 2"; Text[250])
        {
            caption = 'Totaling 2';
            DataClassification = CustomerContent;
        }
        field(31022896;"Type"; Option)
        {
            caption = 'Type';
            OptionMembers =  "","Debit","Credit","Assets","Liabilities";
            OptionCaption = ' ,Debit,Credit,Assets,Liabilities';
            DataClassification = CustomerContent;
        }
    }
    
    var
        myInt: Integer;
}