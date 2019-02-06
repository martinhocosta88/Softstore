tableextension 31023044 "PTSS Transfer Shipment Header" extends "Transfer Shipment Header" //MyTargetTableId
{
    // Certificação Documentos
    fields
    {

    }
    trigger OnBeforeDelete()
    var
        Text31022890: Label 'It is not possible to delete Certified Documents.';
    begin
        Error(Text31022890);
    end;

}