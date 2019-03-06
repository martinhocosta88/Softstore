tableextension 31023001 "PTSS Vendor FCTR" extends Vendor //MyTargetTableId
{
    //Factoring
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