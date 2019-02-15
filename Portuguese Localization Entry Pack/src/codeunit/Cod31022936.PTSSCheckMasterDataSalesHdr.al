codeunit 31022936 "PTSS CheckMasterDataSalesHdr"
{
    //Comunicacao AT

    [EventSubscriber(ObjectType::Table, 36, 'OnAfterInitRecord', '', true, true)]
    local procedure InitRecordPT()
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.InitRecordPT();
    end;

}