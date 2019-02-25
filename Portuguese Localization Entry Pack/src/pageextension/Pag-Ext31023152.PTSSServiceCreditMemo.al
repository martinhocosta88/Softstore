pageextension 31023152 "PTSS Service Credit Memo" extends "Service Credit Memo" //MyTargetPageId
{
    //Nota de Credito de acordo com a Fatura
    layout
    {

    }

    actions
    {
    }
    trigger OnAfterGetRecord()
    begin
        CurrPage.ServLines.PAGE.ControlCreditInvoice("No. Series");
    end;
}