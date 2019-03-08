tableextension 31023110 "PTSS Service Contr. Hdr. SGRP" extends "Service Contract Header"
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

    trigger OnInsert()
    begin
        IF NoSeries.GET("No. Series") THEN
            "PTSS Series Group SGRP" := NoSeries."PTSS Series Group SGRP";
    end;

    var
        NoSeries: Record "No. Series";
}