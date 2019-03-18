tableextension 31023116 "PTSS Transfer Shpt. Hdr. SGRP" extends "Transfer Shipment Header" //MyTargetTableId
{
    fields
    {
        field(31022898; "PTSS Series Group SGRP"; Code[10])
        {
            Caption = 'Series Group';
            DataClassification = CustomerContent;
            TableRelation = "PTSS Series Groups SGRP".Code;
        }

    }

}