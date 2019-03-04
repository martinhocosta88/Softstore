codeunit 31022932 "PTSS CheckMasterDataSales"
{
    //Notas de Crédito de Acordo com a Fatura
    [EventSubscriber(ObjectType::Codeunit, 80, 'OnAfterCheckSalesDoc', '', true, true)]
    local procedure CheckAndUpdatePT(var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; WhseShip: Boolean; WhseReceive: Boolean)
    begin
        CheckMasterDataSales(SalesHeader, SalesHeader.IsCreditDocType);
    end;

    local procedure CheckMasterDataSales(SalesHeader: Record "Sales Header"; IsCreditDocType: Boolean)
    var
        Cust: Record Customer;
        CompanyInformation: Record "Company Information";
        ReservationEntry: Record "Reservation Entry";
        SalesLine: Record "Sales Line";
        Item: Record Item;
        GLSetup: Record "General Ledger Setup";
        Text31022895: Label 'Document amount cannot be negative.';
        Text31022901: Label 'Appl.-to Item Entry must have a value in Item Tracking Lines. It cannot be zero or empty.';
    begin
        Cust.GET(SalesHeader."Bill-to Customer No.");
        Cust.TESTFIELD(Name);
        Cust.TESTFIELD(Address);
        Cust.TESTFIELD(City);
        Cust.TESTFIELD("Country/Region Code");
        Cust.TESTFIELD("Post Code");
        Cust.TESTFIELD("VAT Registration No.");

        CompanyInformation.GET;
        CompanyInformation.TESTFIELD(Name);
        CompanyInformation.TESTFIELD(Address);
        CompanyInformation.TESTFIELD(City);
        CompanyInformation.TESTFIELD("Post Code");
        CompanyInformation.TESTFIELD("Country/Region Code");

        //Desenvolvimento Pendente - Series Manuais
        // IF SalesHeader.Invoice AND SalesHeader."Manual Document" THEN BEGIN
        // SalesHeader.TESTFIELD("Manual Doc. Series");
        // SalesHeader.TESTFIELD("Manual Doc. No.");
        // END;

        //Desenvolvimneto Pendente - Descontos
        // IF ((SalesHeader.Ship OR SalesHeader.Invoice) AND NOT IsCreditDocType) AND (GLSetup."Payment Discount Type" = GLSetup."Payment Discount Type"::"Calc. Pmt. Disc. on Lines") THEN BEGIN
        //     SalesHeader.TESTFIELD("Payment Method Code");
        //     SalesHeader.TESTFIELD("Payment Terms Code");
        // END;

        IF SalesHeader."Document Type" IN [SalesHeader."Document Type"::"Credit Memo", SalesHeader."Document Type"::"Return Order"] THEN BEGIN
            IF SalesLine.TestNoSeries(SalesHeader."No. Series") THEN BEGIN
                SalesLine.RESET;
                SalesLine.SETRANGE("Document Type", SalesHeader."Document Type");
                SalesLine.SETRANGE("Document No.", SalesHeader."No.");
                SalesLine.CALCSUMS(Amount);
                IF SalesLine.Amount < 0 THEN
                    ERROR(Text31022895);
                SalesLine.SETFILTER(Type, '>%1', 0);
                SalesLine.FINDSET;
                REPEAT
                    SalesLine.TESTFIELD("PTSS Credit-to Doc. No.");
                    SalesLine.TESTFIELD("PTSS Credit-to Doc. Line No.");
                    IF (SalesLine."Return Receipt No." = '') AND (SalesLine.Type = SalesLine.Type::Item) THEN BEGIN
                        Item.GET(SalesLine."No.");
                        IF Item.Type = Item.Type::Inventory THEN
                            IF Item."Item Tracking Code" <> '' THEN BEGIN
                                ReservationEntry.SETFILTER("Item No.", Item."No.");
                                ReservationEntry.SETFILTER("Source ID", SalesHeader."No.");
                                ReservationEntry.SETRANGE("Appl.-from Item Entry", 0);
                                IF NOT ReservationEntry.ISEMPTY THEN
                                    ERROR(Text31022901);
                            END ELSE
                                SalesLine.TESTFIELD("Appl.-from Item Entry");
                    END;
                    SalesLine.CheckQty;
                    SalesLine.CheckAmt;
                    SalesLine.CheckLineAmt;
                UNTIL SalesLine.NEXT = 0;
            END;
        END;
    end;
}