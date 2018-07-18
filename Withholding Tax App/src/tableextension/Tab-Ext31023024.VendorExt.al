tableextension 31023024 "Vendor Ext" extends Vendor
{
    fields
    {
        field(31022970; "Subject to Withholding Tax"; Boolean)
        {
            Caption = 'Subject to Withholding Tax';
            DataClassification = CustomerContent;
        }
        field(31022971; "Income Type"; Code[10])
        {
            Caption = 'Income Type';
            DataClassification = CustomerContent;
            TableRelation = "Income Type";
        }
    }
    
    var  
}