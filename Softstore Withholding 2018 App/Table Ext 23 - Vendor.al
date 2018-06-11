tableextension 50114 "Vendor Ext" extends Vendor
{
    fields
    {
        field(31022970; "Subject to Withholding Tax"; Boolean)
        {
            Caption = 'Subject to Withholding Tax';
            DataClassification = ToBeClassified;
        }
        field(31022971; "Income Type"; Code[10])
        {
            Caption = 'Income Type';
            DataClassification = ToBeClassified;
            TableRelation = "Income Type";
        }
    }
    
    var
     
}