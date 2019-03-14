tableextension 31023109 "PTSS Service Header SGRP" extends "Service Header"
{
    //Series Group
    fields
    {
        field(31022918; "PTSS Series Group SGRP"; Code[10])
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
            END;
        END;
    end;

    local procedure InSeriesGroup(PostingDoc: Integer): Boolean
    var
        UserSetup: Record "User Setup";
        SeriesGroups: Record "PTSS Series Groups SGRP";
        NoSeries: Record "No. Series";
    begin
        IF UserSetup.GET(USERID) AND (UserSetup."PTSS Service Series Group SGRP" <> '') THEN BEGIN
            SeriesGroups.GET(UserSetup."PTSS Service Series Group SGRP");
            EXIT(TestPostingDocType(PostingDoc, SeriesGroups));
        END;
        IF ("No. Series" <> '') AND (NoSeries.GET("No. Series")) AND (NoSeries."PTSS Series Group SGRP" <> '') THEN BEGIN
            SeriesGroups.GET(NoSeries."PTSS Series Group SGRP");
            IF SeriesGroups.Type = SeriesGroups.Type::Services THEN
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
        END;
    end;

    procedure GetNoSeriesPT(Var NoSeriesCode: Code[20])
    var
        SeriesGroupIsEmpty: Boolean;
        SeriesGroups: Record "PTSS Series Groups SGRP";
        UserSetup: Record "User Setup";
    begin
        SeriesGroupIsEmpty := TRUE;
        IF ("PTSS Series Group SGRP" <> '') THEN BEGIN
            SeriesGroups.GET("PTSS Series Group SGRP");
            SeriesGroupIsEmpty := FALSE;
        END;
        IF UserSetup.GET(USERID) AND (UserSetup."PTSS Service Series Group SGRP" <> '') THEN BEGIN
            SeriesGroups.GET(UserSetup."PTSS Service Series Group SGRP");
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
                    IF SeriesGroups.Invoice <> '' THEN
                        NoSeriesCode := SeriesGroups.Invoice;
                "Document Type"::"Credit Memo":
                    IF SeriesGroups."Credit Memo" <> '' THEN
                        NoSeriesCode := SeriesGroups."Credit Memo";
            END;
        END;
    end;


    procedure GetPostingNoSeriesCodePT(ServHeader: Record "Service Header"; var PostingNos: Code[20])
    var
        UserSetup: Record "User Setup";
        SeriesGroups: Record "PTSS Series Groups SGRP";
        NoSeries: Record "No. Series";
    begin
        IF UserSetup.GET(USERID) AND (UserSetup."PTSS Service Series Group SGRP" <> '') THEN BEGIN
            SeriesGroups.GET(UserSetup."PTSS Service Series Group SGRP");
            IF (SeriesGroups."Posted Credit Memo" <> '') AND ("Document Type" = "Document Type"::"Credit Memo") THEN
                PostingNos := SeriesGroups."Posted Credit Memo"
            ELSE
                IF (SeriesGroups."Posted Invoice" <> '') AND NOT ("Document Type" = "Document Type"::"Credit Memo") THEN
                    PostingNos := SeriesGroups."Posted Invoice";
        END;
        IF (NoSeries.GET("No. Series")) AND (NoSeries."PTSS Series Group SGRP" <> '') THEN BEGIN
            SeriesGroups.GET(NoSeries."PTSS Series Group SGRP");
            IF (SeriesGroups."Posted Credit Memo" <> '') AND ("Document Type" = "Document Type"::"Credit Memo") THEN
                PostingNos := SeriesGroups."Posted Credit Memo"
            ELSE
                IF (SeriesGroups."Posted Invoice" <> '') AND NOT ("Document Type" = "Document Type"::"Credit Memo") THEN
                    PostingNos := SeriesGroups."Posted Invoice";
        END;
    end;

}