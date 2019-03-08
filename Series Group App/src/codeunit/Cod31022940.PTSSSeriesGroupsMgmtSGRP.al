codeunit 31022940 "PTSS SeriesGroupsMgmt SGRP"
{
    [EventSubscriber(ObjectType::Table, 36, 'OnAfterInitRecord', '', true, true)]
    local procedure InitRecordSalesPT(var SalesHeader: Record "Sales Header")
    var
        NoSeries: Record "No. Series";
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        With SalesHeader do begin
            IF NoSeries.GET("No. Series") THEN
                "PTSS Series Group SGRP" := NoSeries."PTSS Series Group SGRP";

            SalesSetup.GET();
            CASE "Document Type" OF
                "Document Type"::Quote, "Document Type"::Order:
                    BEGIN
                        SalesHeader.SetSeriesGroups(1);
                        SalesHeader.SetSeriesGroups(2);
                        IF "Document Type" = "Document Type"::Order THEN BEGIN
                            SalesHeader.SetSeriesGroups(5);
                            SalesHeader.SetSeriesGroups(6);
                        END;
                    END;
                "Document Type"::Invoice:
                    BEGIN
                        IF NOT ("No. Series" <> '') OR NOT (SalesSetup."Invoice Nos." = SalesSetup."Posted Invoice Nos.") THEN
                            SalesHeader.SetSeriesGroups(1);
                        IF SalesSetup."Shipment on Invoice" THEN
                            SalesHeader.SetSeriesGroups(2);
                    END;
                "Document Type"::"Return Order":
                    BEGIN

                        SalesHeader.SetSeriesGroups(3);
                        SalesHeader.SetSeriesGroups(4);
                    END;
                "Document Type"::"Credit Memo":
                    BEGIN
                        IF NOT ("No. Series" <> '') OR NOT (SalesSetup."Credit Memo Nos." = SalesSetup."Posted Credit Memo Nos.") THEN
                            SalesHeader.SetSeriesGroups(3);
                        IF SalesSetup."Return Receipt on Credit Memo" THEN
                            SalesHeader.SetSeriesGroups(4);
                    END;
            END;
        End;
    end;

    [EventSubscriber(ObjectType::Table, 38, 'OnAfterInitRecord', '', true, true)]
    local procedure InitRecordPurchPT(var PurchHeader: Record "Purchase Header")
    var
        NoSeries: Record "No. Series";
    begin
        With PurchHeader do begin
            IF NoSeries.GET("No. Series") THEN
                "PTSS Series Group SGRP" := NoSeries."PTSS Series Group SGRP";
        End;
    end;

    [EventSubscriber(ObjectType::Table, 5900, 'OnAfterInitRecord', '', true, true)]
    local procedure InitRecordServPT(var ServiceHeader: Record "Service Header")
    var
        NoSeries: Record "No. Series";
    begin
        with ServiceHeader Do begin
            IF NoSeries.GET("No. Series") THEN
                "PTSS Series Group SGRP" := NoSeries."PTSS Series Group SGRP";
        end;
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterGetNoSeriesCode', '', true, true)]
    local procedure MyProcedure()
    begin

    end;
}