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
        NoSeriesMgt.SetDefaultSeries("Receiving No. Series", GetNoSeriesCodePost);
    end;

    local procedure GetNoSeriesCode(): Code[10]
    begin
        WhseSetup.GET;
        IF ("PTSS Series Group SGRP" <> '') AND SeriesGroups.GET("PTSS Series Group SGRP") THEN
            EXIT(SeriesGroups.Receipt);

        IF UserSetup.GET(USERID) AND (UserSetup."PTSS Purchase Series Group SGRP" <> '') THEN BEGIN
            SeriesGroups.GET(UserSetup."PTSS Purchase Series Group SGRP");
            EXIT(SeriesGroups.Receipt);
        END;
        IF NoSeries.GET("No. Series") AND (NoSeries."PTSS Series Group SGRP" <> '') THEN BEGIN
            SeriesGroups.GET(NoSeries."PTSS Series Group SGRP");
            EXIT(SeriesGroups.Receipt);
        END;
        EXIT(WhseSetup."Whse. Receipt Nos.");
    end;

    local procedure GetNoSeriesCodePost(): Code[10]
    begin
        WhseSetup.GET;
        IF ("PTSS Series Group SGRP" <> '') AND SeriesGroups.GET("PTSS Series Group SGRP") THEN
            EXIT(SeriesGroups."Posted Receipt");

        IF UserSetup.GET(USERID) AND (UserSetup."PTSS Purchase Series Group SGRP" <> '') THEN BEGIN
            SeriesGroups.GET(UserSetup."PTSS Purchase Series Group SGRP");
            EXIT(SeriesGroups."Posted Receipt");
        END;
        IF NoSeries.GET("No. Series") AND (NoSeries."PTSS Series Group SGRP" <> '') THEN BEGIN
            SeriesGroups.GET(NoSeries."PTSS Series Group SGRP");
            EXIT(SeriesGroups."Posted Receipt");
        END;
        EXIT(WhseSetup."Posted Whse. Receipt Nos.");
    end;

    local procedure AssistEditPT(OldWhseRcptHeader: Record "Warehouse Receipt Header"): Boolean
    var
        WhseRcptHeader: Record "Warehouse Receipt Header";
    begin
        WITH WhseRcptHeader DO BEGIN
            WhseRcptHeader := Rec;
            IF NoSeriesMgt.SelectSeries(GetNoSeriesCode, OldWhseRcptHeader."No. Series", "No. Series")
            THEN BEGIN
                NoSeriesMgt.SetSeries("No.");
                Rec := WhseRcptHeader;
                EXIT(TRUE);
            END;
        END;

    end;

    var
        WhseSetup: Record "Warehouse Setup";
        SeriesGroups: Record "PTSS Series Groups SGRP";
        UserSetup: Record "User Setup";
        NoSeries: Record "No. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;




}