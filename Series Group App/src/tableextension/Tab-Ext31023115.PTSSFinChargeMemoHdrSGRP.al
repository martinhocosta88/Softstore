tableextension 31023115 "PTSS Fin. Charge Memo Hdr SGRP" extends "Finance Charge Memo Header" //MyTargetTableId
{
    //Series Groups
    fields
    {

    }
    trigger OnAfterInsert()
    begin
        SalesSetup.get();

        If "No." = '' then
            GetFinCMemoNoSeries();

        IF Not ("No. Series" <> '') Or Not (SalesSetup."Fin. Chrg. Memo Nos." = SalesSetup."Issued Fin. Chrg. M. Nos.") then
            GetIssuedFinCMemoCMNoSeries();

        SetPostingNoSeries();
    end;

    local procedure GetFinCMemoNoSeries()
    begin
        IF UserSetup.GET(USERID) AND (UserSetup."PTSS Sales Series Group SGRP" <> '') THEN BEGIN
            SeriesGroups.GET(UserSetup."PTSS Sales Series Group SGRP");
            IF SeriesGroups."Finance Charge Memo" <> '' THEN BEGIN
                NoSeriesMgt.InitSeries(SeriesGroups."Finance Charge Memo", xRec."No. Series", "Posting Date", "No.", "No. Series");
            END;
        END;
    end;

    local procedure GetIssuedFinCMemoCMNoSeries()
    begin
        IF UserSetup.GET(USERID) AND (UserSetup."PTSS Sales Series Group SGRP" <> '') THEN BEGIN
            SeriesGroups.GET(UserSetup."PTSS Sales Series Group SGRP");
            IF SeriesGroups."Issued F. Charge Memo" <> '' THEN BEGIN
                NoSeriesMgt.SetDefaultSeries("Issuing No. Series", SeriesGroups."Issued F. Charge Memo");
            END;
        END;
        NoSeries.GET("No. Series");
        IF NoSeries."PTSS Series Group SGRP" <> '' THEN BEGIN
            SeriesGroups.GET(NoSeries."PTSS Series Group SGRP");
            IF SeriesGroups."Issued F. Charge Memo" <> '' THEN BEGIN
                NoSeriesMgt.SetDefaultSeries("Issuing No. Series", SeriesGroups."Issued F. Charge Memo");
            END;
        END;
    end;

    local procedure GetPostedFinCMemoNoSeries()
    begin
        //Habilitar código em On-Premise

        // IF UserSetup.GET(USERID) AND (UserSetup."PTSS Sales Series Group SGRP" <> '') THEN BEGIN
        //     SeriesGroups.GET(UserSetup."PTSS Sales Series Group SGRP");
        //     IF SeriesGroups."Posted F. Charge Memo" <> '' THEN BEGIN
        //         NoSeriesMgt.SetDefaultSeries("Posting No. Series", SeriesGroups."Posted F. Charge Memo");
        //     END;
        // END;
        // NoSeries.GET("No. Series");
        // IF NoSeries."PTSS Series Group SGRP" <> '' THEN BEGIN
        //     SeriesGroups.GET(NoSeries."PTSS Series Group SGRP");
        //     IF SeriesGroups."Posted F. Charge Memo" <> '' THEN BEGIN
        //         NoSeriesMgt.SetDefaultSeries("Posting No. Series", SeriesGroups."Posted F. Charge Memo");
        //     END;
        // END;
    end;

    local procedure SetPostingNoSeries()
    begin
        //Habilitar código em On-Premise

        // IF "Sign on Issuing" THEN BEGIN
        //     IF ("No. Series" <> '') AND (SalesSetup."Fin. Chrg. Memo Nos." = SalesSetup."Posted Fin. Chrg. M. Nos.") THEN
        //         "Posting No. Series" := "No. Series"
        //     ELSE begin
        //         NoSeriesMgt.SetDefaultSeries("Posting No. Series", SalesSetup."Posted Fin. Chrg. M. Nos.");
        //         GetPostedFinCMemoNoSeries();
        //     END;
        // END;
    end;

    var
        UserSetup: Record "User Setup";
        SeriesGroups: Record "PTSS Series Groups SGRP";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeries: Record "No. Series";
        SalesSetup: Record "Sales & Receivables Setup";

}