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
    [EventSubscriber(ObjectType::Table, 5900, 'OnBeforeGetNoSeries', '', true, true)]
    local procedure GetNoSeriesCodeServ(var ServiceHeader: Record "Service Header"; var NoSeriesCode: Code[20]; var IsHandled: Boolean)
    begin
        ServiceHeader.GetNoSeriesPT(NoSeriesCode);
        IF NoSeriesCode <> '' then
            exit;
    end;

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

    [EventSubscriber(ObjectType::Report, 5753, 'OnAfterCreateShptHeader', '', true, true)]
    local procedure CreateShptHeader(var WarehouseShipmentHeader: Record "Warehouse Shipment Header"; WarehouseRequest: Record "Warehouse Request"; SalesLine: Record "Sales Line")
    begin
        SetNoSeries(SeriesGroupCode, true);
        WarehouseShipmentHeader."No. Series" := WhseShptHeaderTemp."No. Series";
        WarehouseShipmentHeader."PTSS Series Group SGRP" := WhseShptHeaderTemp."PTSS Series Group SGRP";
        WarehouseShipmentHeader.Modify();
    end;

    [EventSubscriber(ObjectType::Report, 5753, 'OnAfterCreateRcptHeader', '', true, true)]
    local procedure CreateReceiptHeader(var WarehouseReceiptHeader: Record "Warehouse Receipt Header"; WarehouseRequest: Record "Warehouse Request"; PurchaseLine: Record "Purchase Line")
    begin
        SetNoSeries(SeriesGroupCode, true);
        WarehouseReceiptHeader."No. Series" := WhseReceiptHeaderTemp."No. Series";
        WarehouseReceiptHeader."PTSS Series Group SGRP" := WhseReceiptHeaderTemp."PTSS Series Group SGRP";
        
    end;

    local procedure SetNoSeries(VAR Code: Code[10]; IsShipment: Boolean)
    var
        NoSeries: Record "No. Series";
        SeriesGroups: Record "PTSS Series Groups SGRP";
    begin
        IF SeriesGroups.GET(Code) THEN BEGIN
            IF IsShipment THEN BEGIN
                WhseShptHeaderTemp.INIT;
                WhseShptHeaderTemp."No. Series" := SeriesGroups.Shipment;
                WhseShptHeaderTemp."PTSS Series Group SGRP" := SeriesGroups.Code;
                WhseShptHeaderTemp.INSERT;
            END ELSE BEGIN
                WhseReceiptHeaderTemp.INIT;
                WhseReceiptHeaderTemp."No. Series" := SeriesGroups.Receipt;
                WhseReceiptHeaderTemp."PTSS Series Group SGRP" := SeriesGroups.Code;
                WhseReceiptHeaderTemp.INSERT;
            END;
        END;
    end;
    //Habilitar evento quando disponível
    // [EventSubscriber(ObjectType::Codeunit, 5751, 'OnAfterFindWarehouseRequestForPurchaseOrder', '', true, true)]
    // local procedure FillSeriesGroupCodePurch(var WhseRqst:Record "Warehouse Request";PurchHeader:Record "Purchase Header")
    // begin
    //     SeriesGroupCode := PurchHeader."PTSS Series Group SGRP";
    // end;

    //Habilitar evento quando disponível
    // [EventSubscriber(ObjectType::Codeunit, 5751, 'OnAfterFindWarehouseRequestForSalesReturnOrder', '', true, true)]
    // local procedure FillSeriesGroupCodeSales(var WhseRqst:Record "Warehouse Request";SalesHeader:Record "Sales Header")
    // begin
    //     SeriesGroupCode := SalesHeader."PTSS Series Group SGRP";
    // end;

    //Habilitar evento quando disponível
    // [EventSubscriber(ObjectType::Codeunit, 5751, 'OnAfterFindWarehouseRequestForInbndTransferOrder', '', true, true)]
    // local procedure FillSeriesGroupCodeTransfer(var WhseRqst:Record "Warehouse Request";TransHeader:Record "Transfer Header")
    // begin
    //     SeriesGroupCode := TransHeader."PTSS Series Group SGRP";
    // end;

    //Habilitar evento quando disponível
    // [EventSubscriber(ObjectType::Codeunit, 5752, 'OnAfterFindWarehouseRequestForSalesOrder', '', true, true)]
    // local procedure FillSeriesGroupCodeSalesOut(var WhseRqst:Record "Warehouse Request";SalesHeader:Record "Sales Header")
    // begin
    //     SeriesGroupCode := SalesHeader."PTSS Series Group SGRP";
    // end;

    //Habilitar evento quando disponível
    // [EventSubscriber(ObjectType::Codeunit, 5752, 'OnAfterFindWarehouseRequestForPurchReturnOrder', '', true, true)]
    // local procedure FillSeriesGroupCodePurchOut(var WhseRqst: Record "Warehouse Request"; PurchHeader: Record "Purchase Header")
    // begin
    //     SeriesGroupCode := PurchHeader."PTSS Series Group SGRP";
    // end;

    //Habilitar evento quando disponível
    // [EventSubscriber(ObjectType::Codeunit, 5752, 'OnAfterFindWarehouseRequestForOutbndTransferOrder', '', true, true)]
    // local procedure FillSeriesGroupCodeTransferOut(var WhseRqst: Record "Warehouse Request"; TransHeader: Record "Transfer Header")
    // begin
    //     SeriesGroupCode := TransHeader."PTSS Series Group SGRP";
    // end;

    //Habilitar evento quando disponível
    // [EventSubscriber(ObjectType::Codeunit, 5752, 'OnAfterFindWarehouseRequestForServiceOrder', '', true, true)]
    // local procedure FillSeriesGroupCodeServiceOut(var WhseRqst: Record "Warehouse Request"; ServiceHeader: Record "Service Header")
    // begin
    //     SeriesGroupCode := ServiceHeader."PTSS Series Group SGRP";
    // end;

    [EventSubscriber(ObjectType::Codeunit, 5704, 'OnBeforeInsertTransShptHeader', '', true, true)]
    local procedure InsertTransferShptHeaderPT(VAR TransShptHeader: Record "Transfer Shipment Header"; TransHeader: Record "Transfer Header"; CommitIsSuppressed: Boolean)
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        UserSetup: Record "User Setup";
        NoSeriesRec: Record "No. Series";
        SeriesGroups: Record "PTSS Series Groups SGRP";
        InvtSetup: Record "Inventory Setup";
    begin
        TransShptHeader."PTSS Series Group SGRP" := TransHeader."PTSS Series Group SGRP";
        IF UserSetup.GET(USERID) THEN BEGIN
            IF UserSetup."PTSS Sales Series Group SGRP" <> '' THEN BEGIN
                SeriesGroups.GET(UserSetup."PTSS Sales Series Group SGRP");
                TransShptHeader."No. Series" := SeriesGroups."Ship. Transfer";
                TransShptHeader."No." :=
                  NoSeriesMgt.GetNextNo(
                    SeriesGroups."Ship. Transfer", TransHeader."Posting Date", TRUE);
            END ELSE
                IF NoSeriesRec.GET(TransHeader."No. Series") THEN
                    IF NoSeriesRec."PTSS Series Group SGRP" <> '' THEN BEGIN
                        SeriesGroups.GET(NoSeriesRec."PTSS Series Group SGRP");
                        TransShptHeader."No. Series" := SeriesGroups."Ship. Transfer";
                        TransShptHeader."No." :=
                          NoSeriesMgt.GetNextNo(SeriesGroups."Ship. Transfer", TransHeader."Posting Date", TRUE);
                        //Código Séries Sequêncial
                        // END ELSE BEGIN
                        //     TransShptHeader."No. Series" := InvtSetup."Posted Transfer Shpt. Nos.";
                        //     NoSeriesMgt.SetPreservePostingSequence(TRUE);
                        //     TransShptHeader."No." :=
                        //       NoSeriesMgt.GetNextNo(
                        //         InvtSetup."Posted Transfer Shpt. Nos.", TransHeader."Posting Date", TRUE);
                        //     NoSeriesMgt.SetPreservePostingSequence(FALSE);
                        // END;
                        // END ELSE BEGIN
                        //NoSeriesMgt.SetPreservePostingSequence(TRUE);
                        //soft,en
                    End;
        End;
    end;

    [EventSubscriber(ObjectType::Codeunit, 5705, 'OnBeforeTransRcptHeaderInsert', '', true, true)]
    local procedure InsertTransRcptHeaderPT(var TransferReceiptHeader: Record "Transfer Receipt Header"; TransferHeader: Record "Transfer Header")
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Handled: Boolean;
        UserSetup: Record "User Setup";
        SeriesGroups: Record "PTSS Series Groups SGRP";
        DeleteOne: Boolean;
        NoSeriesRec: Record "No. Series";
        InvtSetup: Record "Inventory Setup";

    begin
        TransferReceiptHeader."PTSS Series Group SGRP" := TransferHeader."PTSS Series Group SGRP";
        IF UserSetup.GET(USERID) THEN BEGIN
            IF UserSetup."PTSS Sales Series Group SGRP" <> '' THEN BEGIN
                SeriesGroups.GET(UserSetup."PTSS Sales Series Group SGRP");
                TransferReceiptHeader."No. Series" := SeriesGroups."Receipt Transfer";
                TransferReceiptHeader."No." :=
                  NoSeriesMgt.GetNextNo(
                    SeriesGroups."Receipt Transfer", TransferHeader."Posting Date", TRUE);
            END ELSE
                IF NoSeriesRec.GET(TransferHeader."No. Series") THEN
                    IF NoSeriesRec."PTSS Series Group SGRP" <> '' THEN BEGIN
                        SeriesGroups.GET(NoSeriesRec."PTSS Series Group SGRP");
                        TransferReceiptHeader."No. Series" := SeriesGroups."Receipt Transfer";
                        TransferReceiptHeader."No." :=
                          NoSeriesMgt.GetNextNo(
                            SeriesGroups."Receipt Transfer", TransferHeader."Posting Date", TRUE);
                    END ELSE BEGIN
                        TransferReceiptHeader."No. Series" := InvtSetup."Posted Transfer Rcpt. Nos.";
                        TransferReceiptHeader."No." :=
                          NoSeriesMgt.GetNextNo(
                            InvtSetup."Posted Transfer Rcpt. Nos.", TransferHeader."Posting Date", TRUE);
                    END;
        END
    end;



    var
        WhseReceiptHeaderTemp: Record "Warehouse Receipt Header" temporary;
        WhseShptHeaderTemp: Record "Warehouse Shipment Header" temporary;
        SeriesGroupCode: Code[10];

}