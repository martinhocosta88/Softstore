tableextension 31023052 "PTSS Finance Charge Terms" extends "Finance Charge Terms"
{
    //Certificação de Documentos
    fields
    {
        field(31022890; "PTSS Sign on Issuing"; Boolean)
        {
            Caption = 'Sign on Issuing';
            DataClassification = CustomerContent;
        }
    }

    trigger OnAfterModify()
    begin
        "PTSS Sign on Issuing" := FALSE;
        IF "Post Additional Fee" OR "Post Interest" THEN
            "PTSS Sign on Issuing" := TRUE;
    end;
}