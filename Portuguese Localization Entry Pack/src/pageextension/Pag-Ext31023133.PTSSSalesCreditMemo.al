pageextension 31023133 "PTSS Sales Credit Memo" extends "Sales Credit Memo" //MyTargetPageId
{
    //Notas de Crédito de Acordo com a Fatura
    layout
    {

    }

    actions
    {
    }
    trigger OnAfterGetRecord()
    begin
        CurrPage.SalesLines.Page.ControlCreditInvoice("No. Series");
    end;
}