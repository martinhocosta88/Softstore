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


    [EventSubscriber(ObjectType::Codeunit, 6620, 'OnCopySalesLinesToBufferTransferFields', '', true, true)]
    local procedure CopySalesLinesToBufferTransferFieldsPT(SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; var TempSalesLineBuf: Record "Sales Line")
    begin
        TempSalesLineBuf.NoSeriesCreditInvoice(SalesLine."Document No.", SalesLine."Line No.", salesheader."No. Series");
    end;

    [EventSubscriber(ObjectType::Codeunit, 6620, 'OnSplitPstdSalesLinesPerILETransferFields', '', true, true)]
    local procedure SplitPstdSalesLinesPerILETransferFieldsPT(var FromSalesHeader: Record "Sales Header"; var FromSalesLine: Record "Sales Line"; var TempSalesLineBuf: Record "Sales Line"; var ToSalesHeader: Record "Sales Header")
    begin
        TempSalesLineBuf.NoSeriesCreditInvoice(TempSalesLineBuf."Document No.", TempSalesLineBuf."Line No.", ToSalesHeader."No. Series");
    end;

    [EventSubscriber(ObjectType::Table, 5902, 'OnAfterClearFields', '', true, true)]
    local procedure ClearFieldsPT(var ServiceLine: Record "Service Line"; xServiceLine: Record "Service Line"; TempServiceLine: Record "Service Line"; CallingFieldNo: Integer)
    var
        ServHeader: Record "Service Header";
    begin
        with ServiceLine Do begin
            GetServHeader;
            ServHeader.GET("Document Type", "Document No.");
            NoSeriesCreditInvoice(TempServiceLine."PTSS Credit-to Doc. No.", TempServiceLine."PTSS Credit-to Doc. Line No.", ServHeader."No. Series");
        end;
    end;


}