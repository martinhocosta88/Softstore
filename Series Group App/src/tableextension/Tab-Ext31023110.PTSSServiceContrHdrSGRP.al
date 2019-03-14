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
        modify("Contract No.")
        {
            trigger OnAfterValidate()
            begin
                IF "Contract No." <> xRec."Contract No." THEN BEGIN
                    ServMgtSetup.GET;
                    NoSeriesMgt.TestManual(GetNoSeriesCode);
                    "No. Series" := '';
                END;
            end;
        }
    }

    trigger OnAfterInsert()
    begin
        IF "Contract No." = '' THEN
            NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", 0D, "Contract No.", "No. Series");

        IF NoSeries.GET("No. Series") THEN
            "PTSS Series Group SGRP" := NoSeries."PTSS Series Group SGRP";
    end;

    local procedure GetNoSeriesCode(): Code[10]
    begin
        ServMgtSetup.GET;
        IF UserSetup.GET(USERID) AND (UserSetup."PTSS Service Series Group SGRP" <> '') THEN BEGIN
            SeriesGroups.GET(UserSetup."PTSS Service Series Group SGRP");
            IF SeriesGroups.Contract <> '' THEN
                EXIT(SeriesGroups.Contract);
        END;
        IF NoSeries.GET("No. Series") AND (NoSeries."PTSS Series Group SGRP" <> '') THEN BEGIN
            SeriesGroups.GET(NoSeries."PTSS Series Group SGRP");
            EXIT(SeriesGroups.Contract);
        END;
        EXIT(ServMgtSetup."Service Contract Nos.");
    end;

    procedure AssistEditPT(OldServContract: Record "Service Contract Header"): Boolean
    var
        ServContractHeader: Record "Service Contract Header";
    begin
        WITH ServContractHeader DO BEGIN
            ServContractHeader := Rec;
            IF NoSeriesMgt.SelectSeries(GetNoSeriesCode, OldServContract."No. Series", "No. Series") THEN BEGIN
                NoSeriesMgt.SetSeries("Contract No.");
                Rec := ServContractHeader;
                EXIT(TRUE);
            END;
        END;
    end;

    var
        NoSeries: Record "No. Series";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ServMgtSetup: Record "Service Mgt. Setup";
        UserSetup: Record "User Setup";
        SeriesGroups: Record "PTSS Series Groups SGRP";
}