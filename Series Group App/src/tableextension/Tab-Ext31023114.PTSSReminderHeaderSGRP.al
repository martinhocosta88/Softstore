tableextension 31023114 "PTSS Reminder Header SGRP" extends "Reminder Header"
{
    //Series Groups
    fields
    {


    }
    trigger OnAfterInsert()
    begin
        SalesSetup.Get();

        If "No." = '' then
            GetReminderNoSeries();

        IF Not ("No. Series" <> '') or not (SalesSetup."Reminder Nos." = SalesSetup."Issued Reminder Nos.") THEN
            GetIssuedReminderNoSeries();

        SetPostingNoSeries();
    end;

    local procedure GetReminderNoSeries()
    begin
        IF UserSetup.GET(USERID) AND (UserSetup."PTSS Sales Series Group SGRP" <> '') THEN BEGIN
            SeriesGroups.GET(UserSetup."PTSS Sales Series Group SGRP");
            IF SeriesGroups.Reminder <> '' THEN BEGIN
                NoSeriesMgt.InitSeries(SeriesGroups.Reminder, xRec."No. Series", "Posting Date", "No.", "No. Series");
            END;
        END;
    end;

    local procedure GetIssuedReminderNoSeries()
    begin
        IF UserSetup.GET(USERID) AND (UserSetup."PTSS Sales Series Group SGRP" <> '') THEN BEGIN
            SeriesGroups.GET(UserSetup."PTSS Sales Series Group SGRP");
            IF SeriesGroups."Issued Reminder" <> '' THEN BEGIN
                NoSeriesMgt.SetDefaultSeries("Issuing No. Series", SeriesGroups."Issued Reminder");
            END;
        END;
        NoSeries.GET("No. Series");
        IF NoSeries."PTSS Series Group SGRP" <> '' THEN BEGIN
            SeriesGroups.GET(NoSeries."PTSS Series Group SGRP");
            IF SeriesGroups."Issued Reminder" <> '' THEN BEGIN
                NoSeriesMgt.SetDefaultSeries("Issuing No. Series", SeriesGroups."Issued Reminder");
            END;
        END;
    end;

    local procedure GetPostedReminderNoSeries()
    begin
        //Habilitar código em On-Premise

        // IF UserSetup.GET(USERID) AND (UserSetup."PTSS Sales Series Group SGRP" <> '') THEN BEGIN
        //     SeriesGroups.GET(UserSetup."PTSS Sales Series Group SGRP");
        //     IF SeriesGroups."Posted Reminder" <> '' THEN BEGIN
        //         NoSeriesMgt.SetDefaultSeries("Posting No. Series", SeriesGroups."Posted Reminder");
        //     END;
        // END;
        // NoSeries.GET("No. Series");
        // IF NoSeries."PTSS Series Group SGRP" <> '' THEN BEGIN
        //     SeriesGroups.GET(NoSeries."PTSS Series Group SGRP");
        //     IF SeriesGroups."Posted Reminder" <> '' THEN BEGIN
        //         NoSeriesMgt.SetDefaultSeries("Posting No. Series", SeriesGroups."Posted Reminder");
        //     END;
        // END;
    end;

    local procedure SetPostingNoSeries()
    begin
        //Habilitar código em On-Premise

        //IF "Sign on Issuing" THEN BEGIN
        // IF ("No. Series" <> '') AND (SalesSetup."Reminder Nos." = SalesSetup."Posted Reminder Nos.") THEN
        //     "Posting No. Series" := "No. Series"
        // ELSE begin
        //     NoSeriesMgt.SetDefaultSeries("Posting No. Series", SalesSetup."Posted Reminder Nos.");
        //     GetPostedReminderNoSeries();
        // END;
        //END;
    end;

    var
        UserSetup: Record "User Setup";
        SeriesGroups: Record "PTSS Series Groups SGRP";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeries: Record "No. Series";
        SalesSetup: Record "Sales & Receivables Setup";

}