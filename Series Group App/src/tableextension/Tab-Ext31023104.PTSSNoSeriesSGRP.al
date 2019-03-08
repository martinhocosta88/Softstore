tableextension 31023104 "PTSS No. Series SGRP" extends "No. Series"
{
    // Series Group
    fields
    {
        field(31022894; "PTSS Series Group SGRP"; Code[10])
        {
            Caption = 'Series Group';
            DataClassification = CustomerContent;
            TableRelation = "PTSS Series Groups SGRP";
        }
    }

}