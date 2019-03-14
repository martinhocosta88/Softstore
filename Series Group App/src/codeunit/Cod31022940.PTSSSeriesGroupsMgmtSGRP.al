codeunit 31022940 "PTSS SeriesGroupsMgmt SGRP"
{
    //Series Groups
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

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterGetNoSeriesCode', '', true, true)]
    local procedure GetNoSeriesCodeSales(Var SalesHeader: Record "Sales Header"; SalesReceivablesSetup: record "Sales & Receivables Setup"; Var NoSeriesCode: Code[20])
    begin
        SalesHeader.GetNoSeriesPT(NoSeriesCode);
    end;

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterGetPostingNoSeriesCode', '', true, true)]
    local procedure GetPostingNoSeriesCodeSalesPT(SalesHeader: Record "Sales Header"; Var PostingNos: Code[20])
    begin
        SalesHeader.GetPostingNoSeriesCodePT(SalesHeader, PostingNos);
    end;


    [EventSubscriber(ObjectType::Table, 38, 'OnAfterInitRecord', '', true, true)]
    local procedure InitRecordPurchPT(var PurchHeader: Record "Purchase Header")
    var
        NoSeries: Record "No. Series";
        PurchSetup: Record "Purchases & Payables Setup";

    begin
        With PurchHeader do begin
            IF NoSeries.GET("No. Series") THEN
                "PTSS Series Group SGRP" := NoSeries."PTSS Series Group SGRP";

            PurchSetup.get();
            CASE "Document Type" OF
                "Document Type"::Quote, "Document Type"::Order:
                    BEGIN
                        SetSeriesGroups(1);
                        SetSeriesGroups(2);
                        IF "Document Type" = "Document Type"::Order THEN BEGIN
                            SetSeriesGroups(5);
                            SetSeriesGroups(6);
                        END;
                    END;
                "Document Type"::Invoice:
                    BEGIN
                        //debit memo
                        //IF NOT SetDebitMemoSeries THEN
                        IF NOT ("No. Series" <> '') OR NOT (PurchSetup."Invoice Nos." = PurchSetup."Posted Invoice Nos.") THEN
                            SetSeriesGroups(1);
                        IF PurchSetup."Receipt on Invoice" THEN
                            SetSeriesGroups(2);
                    END;
                "Document Type"::"Return Order":
                    BEGIN
                        SetSeriesGroups(3);
                        SetSeriesGroups(4);
                    END;
                "Document Type"::"Credit Memo":
                    BEGIN
                        IF NOT ("No. Series" <> '') OR NOT (PurchSetup."Credit Memo Nos." = PurchSetup."Posted Credit Memo Nos.") THEN
                            SetSeriesGroups(3);
                        IF PurchSetup."Return Shipment on Credit Memo" THEN
                            SetSeriesGroups(4);
                    END;
            END;
        End;
    end;

    [EventSubscriber(ObjectType::Table, 38, 'OnAfterGetNoSeriesCode', '', true, true)]
    local procedure GetNoSeriesCodePurch(Var PurchHeader: Record "Purchase Header"; PurchSetup: Record "Purchases & Payables Setup"; var NoSeriesCode: Code[20])
    begin
        PurchHeader.GetNoSeriesPT(NoSeriesCode);
    end;

    [EventSubscriber(ObjectType::Table, 38, 'OnAfterGetPostingNoSeriesCode', '', true, true)]
    local procedure GetPostingNoSeriesCodePurchPT(PurchaseHeader: Record "Purchase Header"; var PostingNos: Code[20])
    begin
        PurchaseHeader.GetPostingNoSeriesCodePT(PurchaseHeader, PostingNos);
    end;

    [EventSubscriber(ObjectType::Table, 5900, 'OnAfterInitRecord', '', true, true)]
    local procedure InitRecordServPT(var ServiceHeader: Record "Service Header")
    var
        NoSeries: Record "No. Series";
        ServSetup: Record "Service Mgt. Setup";
    begin
        with ServiceHeader Do begin
            IF NoSeries.GET("No. Series") THEN
                "PTSS Series Group SGRP" := NoSeries."PTSS Series Group SGRP";

            ServSetup.get();
            CASE "Document Type" OF
                "Document Type"::Quote, "Document Type"::Order:
                    BEGIN
                        SetSeriesGroups(1);
                        SetSeriesGroups(2);
                    END;
                "Document Type"::Invoice:
                    BEGIN
                        IF NOT ("No. Series" <> '') OR NOT (ServSetup."Service Invoice Nos." = ServSetup."Posted Service Invoice Nos.") THEN
                            SetSeriesGroups(1);
                        IF ServSetup."Shipment on Invoice" THEN
                            SetSeriesGroups(2);
                    END;
                "Document Type"::"Credit Memo":
                    BEGIN
                        IF NOT ("No. Series" <> '') OR NOT (ServSetup."Service Credit Memo Nos." = ServSetup."Posted Serv. Credit Memo Nos.") THEN
                            SetSeriesGroups(3);
                    END;
            END;
        end;
    end;

    //Espera de Evento
    // [EventSubscriber(ObjectType::Table, 5900,'OnAfterGetNoSeriesCode', '', true, true)]
    // local procedure GetNoSeriesCodeServ()
    // begin
    //     ServHeader.GetNoSeriesPT(NoSeriesCode);
    // end;

    //Espera de Evento
    // [EventSubscriber(ObjectType::Table, 5900, 'OnAfterGetPostingNoSeriesCode', '', true, true)]
    // local procedure GetPostingNoSeriesCodeServPT(ServHeader: Record "Service Header"; var PostingNos: Code[20])
    // begin
    //     ServHeader.GetPostingNoSeriesCodePT(ServHeader, PostingNos);
    // end;

    //Espera de Evento Transfer Header
    // [EventSubscriber(ObjectType::Table, 5740, 'OnAfterGetNoSeriesCode', '', true, true)]
    // local procedure GetNoSeriesCodeTransfPT()
    // var
    // TransferHeader:Record "Transfer Header";
    // begin
    //     TransferHeader.GetNoSeriesCodePT();
    // end;

    //Espera de Evento Whse. Activity Header
    // [EventSubscriber(ObjectType::Table, 5766, 'OnAfterGetNoSeriesCode', '', true, true)]
    // local procedure GetNoSeriesCode()
    // var
    //     WhseActivityHeader: Record "Warehouse Activity Header";
    // begin
    //     WhseActivityHeader.GetNoSeriesPT()
    // end;

    //Espera de Evento Service Contract Header
    // [EventSubscriber(ObjectType::Table, 5965, 'OnAfterAssistEdit', '', true, true)]
    // local procedure AssistEditPTServContract(OldServContract)
    // var
    // ServContractHeader:Record "Service Contract Header";
    // begin
    //     ServContractHeader.AssistEditPT(OldServContact);
    // end;

    //Espera de Evento Warehouse Receipt Header
    // [EventSubscriber(ObjectType::Table, 7316, 'OnAfterAssistEdit', '', true, true)]
    // local procedure AssistEditPTWhseRcptHdr(OldWhseRcptHeader)
    // var
    // WhseReceiptHeader:Record "Warehouse Receipt Header";
    // begin
    //     WhseReceiptHeader.AssistEditPT(OldWhseRcptHeader);
    // end;

    //Espera de Evento Warehouse Shipment Header
    // [EventSubscriber(ObjectType::Table, 7320, 'OnAfterAssistEdit', '', true, true)]
    // local procedure AssistEditPTWhseShptHdr(OldWhseRcptHeader)
    // var
    // WhseShipmentHeader:Record "Warehouse Shipment Header";
    // begin
    //     WhseShipmentHeader.AssitEditPT(OldWhseRcptHeader);
    // end;



}