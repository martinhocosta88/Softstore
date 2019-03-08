tableextension 31023112 "PTSS Whse Ship. Hdr. SGRP" extends "Warehouse Shipment Header"
{
    //Series Group
    fields
    {
        field(31022900; "PTSS Series Group SGRP"; Code[10])
        {
            Caption = 'Series Group';
            DataClassification = CustomerContent;
            TableRelation = "PTSS Series Groups SGRP".Code;
        }
    }

    trigger OnAfterInsert()
    begin
        IF NoSeries.GET("No. Series") THEN
            "PTSS Series Group SGRP" := NoSeries."PTSS Series Group SGRP";
    end;

    var
        NoSeries: Record "No. Series";

}