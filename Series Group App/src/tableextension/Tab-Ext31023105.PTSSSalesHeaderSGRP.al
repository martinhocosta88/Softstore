tableextension 31023105 "PTSS Sales Header SGRP" extends "Sales Header"
{
    //Series Groups
    fields
    {
        field(31022919; "PTSS Series Group SGRP"; Code[10])
        {
            Caption = 'Series Group';
            DataClassification = CustomerContent;
            TableRelation = "PTSS Series Groups SGRP".Code;
        }

    }

    procedure SetSeriesGroups(PostingDoc: Integer)
    var
        NoSeries: Record "No. Series";
        SeriesGroups: Record "PTSS Series Groups SGRP";
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        IF NoSeries.GET("No. Series") THEN
            "PTSS Series Group SGRP" := NoSeries."PTSS Series Group SGRP";

        IF NoSeries."PTSS Series Group SGRP" <> '' THEN
            SeriesGroups.GET(NoSeries."PTSS Series Group SGRP");

        IF InSeriesGroup(PostingDoc) THEN BEGIN

            CASE PostingDoc OF
                1:
                    NoSeriesMgt.SetDefaultSeries("Posting No. Series", SeriesGroups."Posted Invoice");
                2:
                    NoSeriesMgt.SetDefaultSeries("Shipping No. Series", SeriesGroups."Shipment/Receipts");
                3:
                    NoSeriesMgt.SetDefaultSeries("Posting No. Series", SeriesGroups."Posted Credit Memo");
                4:
                    NoSeriesMgt.SetDefaultSeries("Return Receipt No. Series", SeriesGroups."Posted Ret. Receipts/Ship.");
                5:
                    NoSeriesMgt.SetDefaultSeries("Prepayment No. Series", SeriesGroups."Posted Prepmt. Inv. Nos.");
                6:
                    NoSeriesMgt.SetDefaultSeries("Prepmt. Cr. Memo No. Series", SeriesGroups."Posted Prepmt. Cr. Memo Nos.");
            END;

        END;
    end;

    local procedure InSeriesGroup(PostingDoc: Integer): Boolean
    var
        UserSetup: Record "User Setup";
        NoSeries: Record "No. Series";
        SeriesGroups: Record "PTSS Series Groups SGRP";
    begin
        IF UserSetup.GET(USERID) THEN
            IF UserSetup."PTSS Sales Series Group SGRP" <> '' THEN BEGIN
                SeriesGroups.GET(UserSetup."PTSS Sales Series Group SGRP");
                EXIT(TestPostingDocType(PostingDoc, SeriesGroups));
            END;

        IF ("No. Series" <> '') AND (NoSeries.GET("No. Series")) AND (NoSeries."PTSS Series Group SGRP" <> '') THEN BEGIN
            SeriesGroups.GET(NoSeries."PTSS Series Group SGRP");
            IF SeriesGroups.Type = SeriesGroups.Type::Sales THEN
                EXIT(TestPostingDocType(PostingDoc, SeriesGroups));
        END;
        EXIT(FALSE);
    end;

    local procedure TestPostingDocType(PostingDoc: Integer; SeriesGroups: Record "PTSS Series Groups SGRP"): Boolean
    begin
        CASE PostingDoc OF
            1:
                IF SeriesGroups."Posted Invoice" <> '' THEN
                    EXIT(TRUE);
            2:
                IF SeriesGroups."Shipment/Receipts" <> '' THEN
                    EXIT(TRUE);
            3:
                IF SeriesGroups."Posted Credit Memo" <> '' THEN
                    EXIT(TRUE);
            4:
                IF SeriesGroups."Posted Ret. Receipts/Ship." <> '' THEN
                    EXIT(TRUE);
            5:
                IF SeriesGroups."Posted Prepmt. Inv. Nos." <> '' THEN
                    EXIT(TRUE);
            6:
                IF SeriesGroups."Posted Prepmt. Cr. Memo Nos." <> '' THEN
                    EXIT(TRUE);
        END;
    end;

    procedure GetNoSeriesPT(Var NoSeriesCode: Code[20])
    var
        UserSetup: Record "User Setup";
        SeriesGroups: Record "PTSS Series Groups SGRP";
        SeriesGroupIsEmpty: Boolean;
    begin
        SeriesGroupIsEmpty := TRUE;
        IF ("PTSS Series Group SGRP" <> '') THEN BEGIN
            SeriesGroups.GET("PTSS Series Group SGRP");
            SeriesGroupIsEmpty := FALSE;
        END;
        IF UserSetup.GET(USERID) AND (UserSetup."PTSS Sales Series Group SGRP" <> '') THEN BEGIN
            SeriesGroups.GET(UserSetup."PTSS Sales Series Group SGRP");
            SeriesGroupIsEmpty := FALSE;
        END;
        IF NOT SeriesGroupIsEmpty THEN BEGIN
            CASE "Document Type" OF
                "Document Type"::Quote:
                    IF SeriesGroups.Quote <> '' THEN
                        NoSeriesCode := SeriesGroups.Quote;
                "Document Type"::Order:
                    IF SeriesGroups.Order <> '' THEN
                        NoSeriesCode := SeriesGroups.Order;
                "Document Type"::Invoice:
                    BEGIN
                        //Debit Memo DEV
                        // IF "Debit Memo" THEN BEGIN
                        //     IF SeriesGroups."Debit Memo" <> '' THEN
                        //         NoSeriesCode := SeriesGroups."Debit Memo";
                        // END ELSE
                        IF SeriesGroups.Invoice <> '' THEN
                            NoSeriesCode := SeriesGroups.Invoice;
                    END;
                "Document Type"::"Return Order":
                    IF SeriesGroups.Return <> '' THEN
                        NoSeriesCode := SeriesGroups.Return;
                "Document Type"::"Credit Memo":
                    IF SeriesGroups."Credit Memo" <> '' THEN
                        NoSeriesCode := SeriesGroups."Credit Memo";
                "Document Type"::"Blanket Order":
                    IF SeriesGroups."Blanket Order" <> '' THEN
                        NoSeriesCode := SeriesGroups."Blanket Order";
            END;
        END;
    end;

    procedure GetPostingNoSeriesCodePT(SalesHeader: Record "Sales Header"; Var PostingNos: Code[20])
    var
        UserSetup: Record "User Setup";
        SeriesGroups: Record "PTSS Series Groups SGRP";
        NoSeries: Record "No. Series";
    begin
        IF UserSetup.GET(USERID) AND (UserSetup."PTSS Sales Series Group SGRP" <> '') THEN BEGIN
            SeriesGroups.GET(UserSetup."PTSS Sales Series Group SGRP");
            IF (SeriesGroups."Posted Credit Memo" <> '') AND ("Document Type" IN ["Document Type"::"Return Order", "Document Type"::"Credit Memo"]) THEN
                PostingNos := SeriesGroups."Posted Credit Memo"
            ELSE
                IF (SeriesGroups."Posted Invoice" <> '') AND NOT ("Document Type" IN ["Document Type"::"Return Order", "Document Type"::"Credit Memo"]) THEN
                    PostingNos := SeriesGroups."Posted Invoice";
        END;
        IF (NoSeries.GET("No. Series")) AND (NoSeries."PTSS Series Group SGRP" <> '') THEN BEGIN
            SeriesGroups.GET(NoSeries."PTSS Series Group SGRP");
            IF (SeriesGroups."Posted Credit Memo" <> '') AND ("Document Type" IN ["Document Type"::"Return Order", "Document Type"::"Credit Memo"]) THEN
                PostingNos := SeriesGroups."Posted Credit Memo"
            ELSE
                IF (SeriesGroups."Posted Invoice" <> '') AND NOT ("Document Type" IN ["Document Type"::"Return Order", "Document Type"::"Credit Memo"]) THEN
                    PostingNos := SeriesGroups."Posted Invoice";
        END;
    end;

}