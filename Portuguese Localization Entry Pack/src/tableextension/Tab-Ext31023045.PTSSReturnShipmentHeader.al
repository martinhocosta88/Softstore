tableextension 31023045 "PTSS Return Shipment Header" extends "Return Shipment Header" //MyTargetTableId
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