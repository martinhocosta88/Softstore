tableextension 31023106 "PTSS Purchase Header SGRP" extends "Purchase Header"
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