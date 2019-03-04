tableextension 50101 "PTSS Vend. Ldg. Entry FCTR" extends "Vendor Ledger Entry" //MyTargetTableId
{
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