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

}