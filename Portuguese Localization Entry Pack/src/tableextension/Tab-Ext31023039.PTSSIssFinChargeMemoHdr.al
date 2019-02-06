tableextension 31023039 "PTSS Iss. Fin. Charge Memo Hdr" extends "Issued Fin. Charge Memo Header" //MyTargetTableId
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