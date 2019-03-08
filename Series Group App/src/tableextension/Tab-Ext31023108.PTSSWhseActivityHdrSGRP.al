tableextension 31023108 "PTSS Whse. Activity Hdr. SGRP" extends "Warehouse Activity Header"
{
    //Series Group
    fields
    {
        field(31022919; "PTSS Series Group SGRP"; Code[10])
        {
            Caption = 'Series Group';
            DataClassification = CustomerContent;
            TableRelation = "PTSS Series Groups SGRP".Code;
        }
    }

}