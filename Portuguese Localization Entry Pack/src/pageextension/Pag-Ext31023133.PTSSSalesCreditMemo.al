pageextension 31023133 "PTSS Sales Credit Memo" extends "Sales Credit Memo" //MyTargetPageId
{
    //Notas de Crédito de Acordo com a Fatura
    //Comunicacao AT
    layout
    {
        addafter("Shipment Date")
        {
            field("PTSS Shipment Start Time"; "PTSS Shipment Start Time")
            {
                Importance = promoted;
                ApplicationArea = All;
                ToolTip = 'Specifies the Shipmnet Start Time.';
            }
        }
    }

    actions
    {
    }
    trigger OnAfterGetRecord()
    begin
        CurrPage.SalesLines.Page.ControlCreditInvoice("No. Series");
    end;
}