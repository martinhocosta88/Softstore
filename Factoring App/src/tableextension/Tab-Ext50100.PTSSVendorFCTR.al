tableextension 50100 "PTSS Vendor FCTR" extends Vendor //MyTargetTableId
{
    fields
    {
        field(50101; "PTSS Factoring to Vendor No."; Code[20])
        {
            TableRelation = Vendor."No.";
            Caption = 'PTSS Factoring to Vendor No.';
            DataClassification = CustomerContent;
        }
    }

}