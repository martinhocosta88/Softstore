tableextension 31023101 "PTSS Vendor FCTR" extends Vendor //MyTargetTableId
{
    //Factoring
    fields
    {
        field(31022960; "PTSS Factoring to Vendor No."; Code[20])
        {
            TableRelation = Vendor."No.";
            Caption = 'Factoring to Vendor No.';
            DataClassification = CustomerContent;
        }
    }

}