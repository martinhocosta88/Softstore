tableextension 31023117 "PTSS Transfer Rcpt. Hdr. SGRP" extends "Transfer Receipt Header" //MyTargetTableId
{
    fields
    {
        field(31022890; "PTSS Series Group SGRP"; Code[10])
        {
            Caption = 'Series Group';
            DataClassification = CustomerContent;
            TableRelation = "PTSS Series Groups SGRP".Code;
        }

    }

}