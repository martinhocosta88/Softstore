codeunit 31022935 "PTSS TransferHeaderManagement"
{
    //Comunicação AT
    [EventSubscriber(ObjectType::Table, 5744, 'OnAfterCopyFromTransferHeader', '', true, true)]
    local procedure CopyFromTransferHeaderPT(var TransferShipmentHeader: Record "Transfer Shipment Header"; TransferHeader: Record "Transfer Header")
    begin
        TransferShipmentHeader."PTSS Shipment Start Time" := TransferHeader."PTSS Shipment Start Time";
        TransferShipmentHeader."PTSS Transfer-to VAT Reg. No." := TransferHeader."PTSS Transfer-to VAT Reg. No.";
        TransferShipmentHeader."PTSS Location Type" := TransferHeader."PTSS Location Type";
        TransferShipmentHeader."PTSS External Entity No." := TransferHeader."PTSS External Entity No.";
        TransferShipmentHeader."PTSS Ship-to Code" := TransferHeader."PTSS Ship-to Code";
    end;
}