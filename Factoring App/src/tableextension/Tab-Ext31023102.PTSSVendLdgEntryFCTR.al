tableextension 31023102 "PTSS Vend. Ldg. Entry FCTR" extends "Vendor Ledger Entry" //MyTargetTableId
{
    //Factoring
    fields
    {
        field(31022960; "PTSS Factoring to Vendor No."; Code[20])
        {
            Caption = 'Factoring to Vendor No.';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = Vendor."No.";
        }
    }
}