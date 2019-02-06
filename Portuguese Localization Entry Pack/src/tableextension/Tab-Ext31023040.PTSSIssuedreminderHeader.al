tableextension 31023040 "PTSS Issued reminder Header" extends "Issued Reminder Header" //MyTargetTableId
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