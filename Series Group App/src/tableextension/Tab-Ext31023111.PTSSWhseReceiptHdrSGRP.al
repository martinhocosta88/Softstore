tableextension 31023111 "PTSS Whse. Receipt Hdr. SGRP" extends "Warehouse Receipt Header"
{
    //Series Group
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