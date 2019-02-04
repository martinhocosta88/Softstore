codeunit 31022931 "PTSS CreditInvoiceMgmt"
{
    //Notas de Crédito de Acordo com a Fatura
    [EventSubscriber(ObjectType::Table, 37, 'OnValidateNoOnCopyFromTempSalesLine', '', true, true)]
    local procedure CheckNoSeriesCreditInvoice(var SalesLine: Record "Sales Line"; var TempSalesLine: Record "Sales Line")
    var
        SalesHeader: Record "Sales Header";
    begin
        IF (SalesLine."Document Type" <> SalesHeader."Document Type") OR (SalesLine."Document No." <> SalesHeader."No.") THEN
            SalesHeader.GET(SalesLine."Document Type", SalesLine."Document No.");

        SalesLine.NoSeriesCreditInvoice(TempSalesLine."PTSS Credit-to Doc. No.", TempSalesLine."PTSS Credit-to Doc. Line No.", SalesHeader."No. Series");
    end;

    [EventSubscriber(ObjectType::Codeunit, 6620, 'OnBeforeRecalculateSalesLine', '', true, true)]
    local procedure RecalculateSalesLinePT(var ToSalesHeader: Record "Sales Header"; var ToSalesLine: Record "Sales Line"; var FromSalesHeader: Record "Sales Header"; var FromSalesLine: Record "Sales Line"; var CopyThisLine: Boolean)
    begin
        ToSalesLine.NoSeriesCreditInvoice(FromSalesLine."PTSS Credit-to Doc. No.", FromSalesLine."PTSS Credit-to Doc. Line No.", ToSalesHeader."No. Series");
    end;

    //Faltam eventos pedidos no GIT


}