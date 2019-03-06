tableextension 31023002 "PTSS Vend. Ldg. Entry FCTR" extends "Vendor Ledger Entry" //MyTargetTableId
{
    //Factoring
    fields
    {
        field(50100; "PTSS Factoring to Vendor No."; Code[20])
        {
            Caption = 'Factoring to Vendor No.';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = Vendor."No.";
        }


    }

}