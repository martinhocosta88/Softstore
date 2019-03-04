codeunit 31022936 "PTSS InitRecordsPT"
{
    //Comunicacao AT

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterInitRecord', '', true, true)]
    local procedure InitRecordPTSales(var SalesHeader: Record "Sales Header")
    begin
        SalesHeader.InitRecordPT(SalesHeader);
    end;

    [EventSubscriber(ObjectType::Table, 38, 'OnAfterInitRecord', '', true, true)]
    local procedure InitRecordPTPurch(var PurchHeader: Record "Purchase Header")
    begin
        PurchHeader.InitRecordPT(PurchHeader);
    end;

    [EventSubscriber(ObjectType::Table, 5900, 'OnAfterInitRecord', '', true, true)]
    local procedure InitRecordPTService(var ServiceHeader: Record "Service Header")
    begin
        ServiceHeader.InitRecordPT(ServiceHeader);
    end;

    [EventSubscriber(ObjectType::Table, 115, 'OnAfterInitFromSalesLine', '', true, true)]
    local procedure InitFromSalesCRMemoLinePT(var SalesCRMemoLine: Record "Sales Cr.Memo Line"; SalesCrMemoHeader: Record "Sales Cr.Memo Header"; SalesLine: Record "Sales Line")
    begin
        SalesCRMemoLine."Shipment Date" := SalesCrMemoHeader."Shipment Date";
    end;

    [EventSubscriber(ObjectType::Table, 113, 'OnAfterInitFromSalesLine', '', true, true)]
    local procedure InitFromSalesInvLinePT(var SalesInvLine: Record "Sales Invoice Line"; SalesInvHeader: Record "Sales Invoice Header"; SalesLine: Record "Sales Line")
    begin
        SalesInvLine."Shipment Date" := SalesInvHeader."Shipment Date";
    end;

    [EventSubscriber(ObjectType::Table, 111, 'OnAfterInitFromSalesLine', '', true, true)]
    local procedure InitFromSalesShipLinePT(SalesShptHeader: Record "Sales Shipment Header"; SalesLine: Record "Sales Line"; var SalesShptLine: Record "Sales Shipment Line")
    begin
        SalesShptLine."Shipment Date" := SalesShptHeader."Shipment Date";
    end;
}