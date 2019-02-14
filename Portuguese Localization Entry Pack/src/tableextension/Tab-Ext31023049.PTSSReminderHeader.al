tableextension 31023049 "PTSS Reminder Header" extends "Reminder Header" //MyTargetTableId
{
    //Certificacao de Documentos
    fields
    {
        field(31022892; "PTSS Sign on Issuing"; Boolean)
        {
            Caption = 'Sign on Issuing';
            DataClassification = CustomerContent;
        }
        modify("Reminder Terms Code")
        {
            trigger OnBeforeValidate()
            begin
                IF "Reminder Terms Code" <> '' THEN begin
                    ReminderTerms.GET("Reminder Terms Code");
                    "PTSS Sign on Issuing" := ReminderTerms."PTSS Sign on Issuing";
                END;
            end;
        }
    }
    var
        ReminderTerms: Record "Reminder Terms";


}