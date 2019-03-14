tableextension 31023107 "PTSS Transfer Header SGRP" extends "Transfer Header"
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

    procedure GetNoSeriesCodePT(): Code[20]
    var
        InvtSetup: Record "Inventory Setup";
        UserSetup: Record "User Setup";
        SeriesGroups: Record "PTSS Series Groups SGRP";
        NoSeries: Record "No. Series";
    begin
        InvtSetup.GET;
        IF UserSetup.GET(USERID) THEN
            IF (UserSetup."PTSS Sales Series Group SGRP" <> '') AND SeriesGroups.GET(UserSetup."PTSS Sales Series Group SGRP") THEN
                EXIT(SeriesGroups.Transfer)
            ELSE
                IF NoSeries.GET("No. Series") AND (NoSeries."PTSS Series Group SGRP" <> '') THEN BEGIN
                    SeriesGroups.GET(NoSeries."PTSS Series Group SGRP");
                    EXIT(SeriesGroups.Transfer);
                END;
        EXIT(InvtSetup."Transfer Order Nos.");
    end;

    var
        NoSeries: Record "No. Series";
}