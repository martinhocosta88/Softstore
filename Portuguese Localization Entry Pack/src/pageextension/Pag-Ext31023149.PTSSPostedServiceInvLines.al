pageextension 31023149 "PTSS Posted Service Inv. Lines" extends "Posted Service Invoice Lines" 
{
    //Notas de Crédito de acordo com Fatura
    layout
    {

    }

    actions
    {
    }
    procedure GetServInvLines(VAR ServInvLine: Record "Service Invoice Line")
    begin
        ServInvLine := Rec;
    end;
}