tableextension 31023042 "PTSS Service Invoice Header" extends "Service Invoice Header" //MyTargetTableId
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