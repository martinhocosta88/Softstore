pageextension 31023150 "PTSS Posted Service Invoices" extends "Posted Service Invoices" //MyTargetPageId
{
    //Nota de Crédito de acordo com a Fatura
    layout
    {

    }

    actions
    {
    }
    procedure GetServiceInvoice(var ServInvHeader: Record "Service Invoice Header")
    begin
        ServInvHeader := Rec;
    end;
}