tableextension 31023108 "PTSS Whse. Activity Hdr. SGRP" extends "Warehouse Activity Header"
{
    //Series Group
    fields
    {
        field(31022919; "PTSS Series Group SGRP"; Code[10])
        {
            Caption = 'Series Group';
            DataClassification = CustomerContent;
            TableRelation = "PTSS Series Groups SGRP".Code;
        }
    }

    procedure GetNoSeriesPT(): Code[20]
    begin
        CASE Type OF
            Type::"Put-away":
                BEGIN
                    WhseSetup.GET;
                    IF GetNoSeriesGroups(Type) THEN
                        EXIT(NoSeriesCode);
                    EXIT(WhseSetup."Whse. Put-away Nos.");
                END;
            Type::Pick:
                BEGIN
                    WhseSetup.GET;
                    IF GetNoSeriesGroups(Type) THEN
                        EXIT(NoSeriesCode);
                    EXIT(WhseSetup."Whse. Pick Nos.");
                END;
            Type::Movement:
                BEGIN
                    WhseSetup.GET;
                    EXIT(WhseSetup."Whse. Movement Nos.");
                END;
            Type::"Invt. Put-away":
                BEGIN
                    InvtSetup.GET;
                    IF GetNoSeriesGroups(Type) THEN
                        EXIT(NoSeriesCode);
                    EXIT(InvtSetup."Inventory Put-away Nos.");
                END;
            Type::"Invt. Pick":
                BEGIN
                    InvtSetup.GET;
                    IF GetNoSeriesGroups(Type) THEN
                        EXIT(NoSeriesCode);
                    EXIT(InvtSetup."Inventory Pick Nos.");
                END;
            Type::"Invt. Movement":
                BEGIN
                    InvtSetup.GET;
                    EXIT(InvtSetup."Inventory Movement Nos.");
                END;
        END;
    end;

    local procedure GetNoSeriesGroups(Type: Option " ","Put-away","Pick","Movement","Invt. Put-away","Invt. Pick","Invt. Movement"): Boolean
    var
        UserSetup: Record "User Setup";
        NoSeries: Record "No. Series";
        SeriesGroups: Record "PTSS Series Groups SGRP";
    begin
        UserSetup.GET(USERID);
        CASE Type OF
            Type::"Put-away":
                BEGIN
                    IF UserSetup."PTSS Purch. Series Group SGRP" <> '' THEN BEGIN
                        SeriesGroups.GET(UserSetup."PTSS Purch. Series Group SGRP");
                        NoSeriesCode := SeriesGroups."Put-away";
                        Exit(true);
                    END;

                    IF NoSeries.GET("No. Series") AND (NoSeries."PTSS Series Group SGRP" <> '') THEN BEGIN
                        SeriesGroups.GET(NoSeries."PTSS Series Group SGRP");
                        NoSeriesCode := SeriesGroups."Put-away";
                        Exit(true);
                    END;
                END;

            Type::Pick, Type::"Invt. Pick":
                BEGIN
                    IF UserSetup."PTSS Sales Series Group SGRP" <> '' THEN BEGIN
                        SeriesGroups.GET(UserSetup."PTSS Sales Series Group SGRP");
                        NoSeriesCode := SeriesGroups.Pick;
                        Exit(true);
                    END;

                    IF NoSeries.GET("No. Series") AND (NoSeries."PTSS Series Group SGRP" <> '') THEN BEGIN
                        SeriesGroups.GET(NoSeries."PTSS Series Group SGRP");
                        NoSeriesCode := SeriesGroups.Pick;
                        Exit(true);
                    END;
                END;

            Type::"Invt. Put-away":
                BEGIN
                    IF UserSetup."PTSS Sales Series Group SGRP" <> '' THEN BEGIN
                        SeriesGroups.GET(UserSetup."PTSS Sales Series Group SGRP");
                        NoSeriesCode := SeriesGroups."Put-away";
                        Exit(true);
                    END;

                    IF NoSeries.GET("No. Series") AND (NoSeries."PTSS Series Group SGRP" <> '') THEN BEGIN
                        SeriesGroups.GET(NoSeries."PTSS Series Group SGRP");
                        NoSeriesCode := SeriesGroups."Put-away";
                        Exit(true);
                    END;
                END;
        END;
        Exit(false);
    end;

    local procedure GetPostNoSeriesGroups(Type: Option " ","Put-away","Pick","Movement","Invt. Put-away","Invt. Pick","Invt. Movement")
    var
        UserSetup: Record "User Setup";
        NoSeries: Record "No. Series";
        SeriesGroups: Record "PTSS Series Groups SGRP";
    begin
        UserSetup.GET(USERID);
        CASE Type OF
            Type::"Put-away":
                BEGIN
                    IF UserSetup."PTSS Purch. Series Group SGRP" <> '' THEN BEGIN
                        SeriesGroups.GET(UserSetup."PTSS Purch. Series Group SGRP");
                        PostNoSeriesCode := SeriesGroups."Register Put-away";
                    END;
                    IF NoSeries.GET("No. Series") AND ("PTSS Series Group SGRP" <> '') THEN BEGIN
                        SeriesGroups.GET("PTSS Series Group SGRP");
                        PostNoSeriesCode := SeriesGroups."Register Put-away";
                    END;
                END;
            Type::Pick:
                BEGIN
                    IF UserSetup."PTSS Sales Series Group SGRP" <> '' THEN BEGIN
                        SeriesGroups.GET(UserSetup."PTSS Sales Series Group SGRP");
                        PostNoSeriesCode := SeriesGroups."Register Pick";
                    END;
                    IF NoSeries.GET("No. Series") AND (NoSeries."PTSS Series Group SGRP" <> '') THEN BEGIN
                        SeriesGroups.GET(NoSeries."PTSS Series Group SGRP");
                        PostNoSeriesCode := SeriesGroups."Register Pick";
                    END;
                END;
        END;
    end;

    var
        NoSeriesCode: Code[10];
        PostNoSeriesCode: Code[10];
        WhseSetup: Record "Warehouse Setup";
        InvtSetup: Record "Inventory Setup";

}