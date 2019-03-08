tableextension 31023113 "PTSS User Setup SGRP" extends "User Setup"
{
    //Series Group
    fields
    {
        field(31022913; "PTSS Sales Series Group SGRP"; Code[10])
        {
            Caption = 'Sales Series Group';
            DataClassification = CustomerContent;
            TableRelation = "PTSS Series Groups SGRP" WHERE (Type = CONST (Sales));
        }
        field(31022914; "PTSS Purchase Series Group SGRP"; Code[10])
        {
            Caption = 'Purchase Series Group';
            DataClassification = CustomerContent;
            TableRelation = "PTSS Series Groups SGRP" WHERE (Type = CONST (Purchase));
        }
        field(31022915; "PTSS Service Series Group SGRP"; Code[10])
        {
            Caption = 'Service Series Group';
            DataClassification = CustomerContent;
            TableRelation = "PTSS Series Groups SGRP" WHERE (Type = CONST (Services));
        }

    }

}