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
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    NoSeriesMgt.TestManual(GetNoSeriesCode);
                    "No. Series" := '';
                END;
            end;
        }
    }

    trigger OnAfterInsert()
    begin
        NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", TODAY, "No.", "No. Series");
        NoSeriesMgt.SetDefaultSeries("Shipping No. Series", GetNoSeriesCodePost);

        IF NoSeries.GET("No. Series") THEN
            "PTSS Series Group SGRP" := NoSeries."PTSS Series Group SGRP";
    end;

    local procedure GetNoSeriesCode(): Code[10]
    begin
        WhseSetup.GET;
        IF UserSetup.GET(USERID) AND (UserSetup."PTSS Sales Series Group SGRP" <> '') THEN BEGIN
            SeriesGroups.GET(UserSetup."PTSS Sales Series Group SGRP");
            EXIT(SeriesGroups.Shipment);
        END;
        IF NoSeries.GET("No. Series") AND (NoSeries."PTSS Series Group SGRP" <> '') THEN BEGIN
            SeriesGroups.GET(NoSeries."PTSS Series Group SGRP");
            EXIT(SeriesGroups.Shipment);
        END;
        EXIT(WhseSetup."Whse. Ship Nos.");
    end;

    local procedure GetNoSeriesCodePost(): Code[10]
    begin
        WhseSetup.GET;
        IF UserSetup.GET(USERID) AND (UserSetup."PTSS Sales Series Group SGRP" <> '') THEN BEGIN
            SeriesGroups.GET(UserSetup."PTSS Sales Series Group SGRP");
            EXIT(SeriesGroups."Posted Shipment");
        END;
        IF NoSeries.GET("No. Series") AND (NoSeries."PTSS Series Group SGRP" <> '') THEN BEGIN
            SeriesGroups.GET(NoSeries."PTSS Series Group SGRP");
            EXIT(SeriesGroups."Posted Shipment");
        END;
        EXIT(WhseSetup."Posted Whse. Shipment Nos.");
    end;

    procedure AssitEditPT(OldWhseShptHeader: Record "Warehouse Shipment Header"): Boolean
    var
        WhseShptHeader: Record "Warehouse Shipment Header";
    begin
        WITH WhseShptHeader DO BEGIN
            WhseShptHeader := Rec;
            WhseSetup.TESTFIELD("Whse. Ship Nos.");
            IF NoSeriesMgt.SelectSeries(GetNoSeriesCode, OldWhseShptHeader."No. Series", "No. Series") THEN BEGIN
                NoSeriesMgt.SetSeries("No.");
                Rec := WhseShptHeader;
                EXIT(TRUE);
            END;
        END;
    end;


    var
        NoSeries: Record "No. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        WhseSetup: Record "Warehouse Setup";
        UserSetup: Record "User Setup";
        SeriesGroups: Record "PTSS Series Groups SGRP";

}