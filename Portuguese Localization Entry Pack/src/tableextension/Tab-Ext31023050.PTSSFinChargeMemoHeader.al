tableextension 31023050 "PTSS Fin. Charge Memo Header" extends "Finance Charge Memo Header" //MyTargetTableId
{
    //Certificacao Documentos
    fields
    {
        field(31022892; "PTSS Sign on Issuing"; Boolean)
        {
            Caption = 'Sign on Issuing';
            DataClassification = CustomerContent;
        }
        modify("Fin. Charge Terms Code")
        {
            trigger OnBeforeValidate()
            begin
                IF "Fin. Charge Terms Code" <> '' THEN begin
                    FinChrgTerms.GET("Fin. Charge Terms Code");
                    "PTSS Sign on Issuing" := FinChrgTerms."PTSS Sign on Issuing";
                END;
            end;
        }
    }
    var
        FinChrgTerms: Record "Finance Charge Terms";

}