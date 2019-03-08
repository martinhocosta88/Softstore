tableextension 31023109 "PTSS Service Header SGRP" extends "Service Header"
{
    //Series Group
    fields
    {
        field(31022918; "PTSS Series Group SGRP"; Code[10])
        {
            Caption = 'Series Group';
            DataClassification = CustomerContent;
            TableRelation = "PTSS Series Groups SGRP".Code;
        }
    }

}