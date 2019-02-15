report 31023104 "PTSS Intrastat Export"
{
    //Intrastat

    Caption = 'Intrastat - Make Disk Tax Auth';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Intrastat Jnl. Batch"; "Intrastat Jnl. Batch")
        {
            DataItemTableView = SORTING ("Journal Template Name", Name);
            RequestFilterFields = "Journal Template Name", Name;
            dataitem("Intrastat Jnl. Line"; "Intrastat Jnl. Line")
            {
                DataItemLink = "Journal Template Name" = FIELD ("Journal Template Name"),
                               "Journal Batch Name" = FIELD (Name);
                RequestFilterFields = Type;

                trigger OnAfterGetRecord()
                begin

                    JournalBatch.GET("Journal Template Name", "Journal Batch Name");
                    JournalBatch.TESTFIELD(JournalBatch.Reported, FALSE);

                    IF ("Tariff No." = '') AND
                       ("Country/Region Code" = '') AND
                       ("Transaction Type" = '') AND
                       ("Transport Method" = '') AND
                       ("Total Weight" = 0)
                    THEN
                        CurrReport.SKIP;

                    TESTFIELD("Tariff No.");
                    TESTFIELD("Country/Region Code");
                    TESTFIELD("Transaction Type");
                    TESTFIELD("Total Weight");
                    IF "Supplementary Units" THEN
                        TESTFIELD(Quantity);

                    CompanyInfo.GET;
                    CLEAR(Fluxo);
                    CLEAR(POrigem);
                    CLEAR(CountryCode);
                    CLEAR(CountryOfOriginCode);
                    CLEAR(AdqNIF);

                    IF Country.GET("Country/Region Code") THEN
                        CountryCode := Country."EU Country/Region Code";

                    IF Country.GET("Country/Region of Origin Code") THEN
                        CountryOfOriginCode := Country."EU Country/Region Code";

                    NrAd := NrAd + 1;

                    IF "Intrastat Jnl. Line".Type = "Intrastat Jnl. Line".Type::Receipt THEN
                        Fluxo := 'INTRA-CH'
                    ELSE BEGIN
                        Fluxo := 'INTRA-EX';
                        ItemLedgEntry.GET("Intrastat Jnl. Line"."Source Entry No.");
                        IF (Amount < 0) AND (ItemLedgEntry."Source Type" = ItemLedgEntry."Source Type"::Vendor) THEN BEGIN
                            IF Vendor.GET(ItemLedgEntry."Source No.") THEN
                                AdqNIF := CountryCode + Vendor."VAT Registration No.";
                        END ELSE
                            IF Customer.GET(ItemLedgEntry."Source No.") THEN
                                AdqNIF := CountryCode + Customer."VAT Registration No.";
                    END;

                    IF "PTSS Source Type" = "PTSS Source Type"::"FA Entry" THEN
                        POrigem := "Country/Region of Origin Code"
                    ELSE BEGIN
                        Item.GET("Intrastat Jnl. Line"."Item No.");
                        POrigem := Item."Country/Region of Origin Code";
                    END;

                    IF NOT "Supplementary Units" THEN
                        Quantity := 0;

                    IF Quantity = 0 THEN
                        TxtQuantity := ''
                    ELSE BEGIN
                        EVALUATE(Qty, DecimalNumeralZeroFormat(Quantity, 10));
                        UnsupQty := "Intrastat Jnl. Line"."Net Weight";
                        TotalUnsup := Qty * UnsupQty;
                        EVALUATE(TotalUnsup, DecimalNumeralZeroFormat(TotalUnsup, 12));
                        TxtQuantity := FORMAT(TotalUnsup);
                    END;

                    OutputStream.WriteText();
                    OutputStream.WriteText(
                                  Fluxo + ';' +
                                  "Intrastat Jnl. Batch"."Statistics Period" + ';' +
                                  CompanyInfo."VAT Registration No." + ';' +
                                  DecimalNumeralZeroFormat(NrAd, 5) + ';' +
                                  PADSTR(DELCHR("Tariff No."), 9) + ';' +
                                  PADSTR(CountryCode, 2) + ';' +
                                  POrigem + ';' +
                                  COPYSTR(Area, 1, 2) + ';' +
                                  COPYSTR("Shpt. Method Code", 1, 3) + ';' +
                                  COPYSTR("Transaction Type", 1, 2) + ';' +
                                  COPYSTR("Transport Method", 1, 1) + ';' +
                                  COPYSTR("Entry/Exit Point", 1, 3) + ';' +
                                  DecimalNumeralZeroFormat("Total Weight", 12) + ';' +
                                  TxtQuantity + ';' +
                                  DecimalNumeralZeroFormat(Amount, 9) + ';' +
                                  DecimalNumeralZeroFormat("Statistical Value", 9) + ';' +
                                  AdqNIF);

                end;

                trigger OnPostDataItem()
                var
                    ToFile: Text[1024];
                begin
                    "Intrastat Jnl. Batch".Reported := TRUE;
                    "Intrastat Jnl. Batch".MODIFY;
                    tmpBlob.Blob.CreateInStream(InputStream);
                    DownloadFromStream(Inputstream, '', '', '', FileName);
                end;

                trigger OnPreDataItem()
                begin
                    NrAd := 0;
                end;
            }
            dataitem(IntrastatJnlLine2; "Intrastat Jnl. Line")
            {
                DataItemTableView = SORTING ("Internal Ref. No.");

                trigger OnAfterGetRecord()
                begin
                    CurrReport.SKIP;

                    IF ("Tariff No." = '') AND
                       ("Country/Region Code" = '') AND
                       ("Transaction Type" = '') AND
                       ("Transport Method" = '') AND
                       ("Total Weight" = 0)
                    THEN
                        CurrReport.SKIP;
                    "Tariff No." := DELCHR("Tariff No.");

                    TotalWeightAmt += "Total Weight";
                    QuantityAmt += Quantity;
                    StatisticalValueAmt += "Statistical Value";

                    IntrastatJnlLine5.COPY(IntrastatJnlLine2);
                    IF IntrastatJnlLine5.NEXT = 1 THEN BEGIN
                        IF (DELCHR(IntrastatJnlLine5."Tariff No.") = "Tariff No.") AND
                           (IntrastatJnlLine5."Country/Region Code" = "Country/Region Code") AND
                           (IntrastatJnlLine5."Transaction Type" = "Transaction Type") AND
                           (IntrastatJnlLine5."Transport Method" = "Transport Method")
                        THEN
                            GroupTotal := FALSE
                        ELSE
                            GroupTotal := TRUE;
                    END ELSE
                        GroupTotal := TRUE;

                    IF GroupTotal THEN BEGIN
                        WriteGrTotalsToFile(TotalWeightAmt, QuantityAmt, StatisticalValueAmt);
                        StatisticalValueTotalAmt += StatisticalValueAmt;
                        TotalWeightAmt := 0;
                        QuantityAmt := 0;
                        StatisticalValueAmt := 0;
                    END;
                end;

                trigger OnPostDataItem()
                begin
                    CurrReport.SKIP;
                    IF NOT Receipt THEN
                        OutputStream.WriteText(FORMAT('02000' + FORMAT(IntraReferenceNo, 4) + '100000' + FORMAT(VATRegNo, 8) + '1' + FORMAT(IntraReferenceNo, 4), 80));

                    IF NOT Shipment THEN
                        OutputStream.WriteText(FORMAT('02000' + FORMAT(IntraReferenceNo, 4) + '200000' + FORMAT(VATRegNo, 8) + '2' + FORMAT(IntraReferenceNo, 4), 80));
                    OutputStream.WriteText(FORMAT('10' + DecimalNumeralZeroFormat(StatisticalValueTotalAmt, 16), 80));


                    "Intrastat Jnl. Batch".Reported := TRUE;
                    "Intrastat Jnl. Batch".MODIFY;
                    tmpBlob.Blob.CreateInStream(InputStream);
                    DownloadFromStream(Inputstream, '', '', '', FileName);

                end;

                trigger OnPreDataItem()
                begin
                    CurrReport.SKIP; //soft,n
                    CompanyInfo.GET;
                    VATRegNo := CONVERTSTR(CompanyInfo."VAT Registration No.", Text001, '    ');
                    OutputStream.WriteText(FORMAT('00' + FORMAT(VATRegNo, 8) + Text002, 80));
                    OutputStream.WriteText(FORMAT('0100004', 80));
                    SETRANGE("Internal Ref. No.", COPYSTR(IntraReferenceNo, 1, 4), COPYSTR(IntraReferenceNo, 1, 4) + '9');
                    CurrReport.CREATETOTALS(Quantity, "Statistical Value", "Total Weight");
                    IntrastatJnlLine3.SETCURRENTKEY("Internal Ref. No.");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                TESTFIELD(Reported, FALSE);

                IntraReferenceNo := "Statistics Period" + '0000';
            end;

            trigger OnPreDataItem()
            begin
                IntrastatJnlLine4.COPYFILTER("Journal Template Name", "Journal Template Name");
                IntrastatJnlLine4.COPYFILTER("Journal Batch Name", Name);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
        }

        actions
        {
        }

        trigger OnOpenPage()
        var
            IntrastatSetup: Record "Intrastat Setup";
        begin
            IF NOT IntrastatSetup.GET THEN
                EXIT;

            IF IntrastatSetup."Report Receipts" AND IntrastatSetup."Report Shipments" THEN
                EXIT;

            IF IntrastatSetup."Report Receipts" THEN
                "Intrastat Jnl. Line".SETRANGE(Type, "Intrastat Jnl. Line".Type::Receipt)
            ELSE
                IF IntrastatSetup."Report Shipments" THEN
                    "Intrastat Jnl. Line".SETRANGE(Type, "Intrastat Jnl. Line".Type::Shipment)
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    var
        ToFile: Text[1024];
    begin
    end;

    trigger OnPreReport()
    begin
        FileName := DefaultFilenameTxt;
        IntrastatJnlLine4.COPYFILTERS("Intrastat Jnl. Line");

        tmpBlob.Blob.CreateOutStream(OutputStream);
        OutputStream.WriteText(TextFLUXO + ';' + TextPERIODO + ';' + TextNIF + ';' + TextREF + ';' + TextNC + ';' + TextPAIS + ';' + TextPORIGEM + ';' + TextREGIAO + ';' + TextCODENT + ';' +
            TextNATTRA + ';' + TextMODTRA + ';' + TextAERPOR + ';' + TextMASSA + ';' + TextUNSUP + ';' + TextVALFAC + ';' + TextVALEST + ';' + TextADQNIF);
    end;

    var
        Text001: Label 'WwWw';
        Text002: Label 'INTRASTAT';
        Text003: Label 'It is not possible to display %1 in a field with a length of %2.';
        IntrastatJnlLine3: Record "Intrastat Jnl. Line";
        IntrastatJnlLine4: Record "Intrastat Jnl. Line";
        IntrastatJnlLine5: Record "Intrastat Jnl. Line";
        CompanyInfo: Record "Company Information";
        Country: Record "Country/Region";
        IntraFile: File;
        QuantityAmt: Decimal;
        StatisticalValueAmt: Decimal;
        StatisticalValueTotalAmt: Decimal;
        TotalWeightAmt: Decimal;
        FileName: Text;
        IntraReferenceNo: Text[10];
        ServerFileName: Text;
        NoOfEntries: Text[3];
        Receipt: Boolean;
        Shipment: Boolean;
        VATRegNo: Code[20];
        ImportExport: Code[1];
        OK: Boolean;
        DefaultFilenameTxt: Label 'Intrastat.txt';
        GroupTotal: Boolean;
        JournalBatch: Record "Intrastat Jnl. Batch";
        Item: Record item;
        ItemLedgEntry: Record "Item Ledger Entry";
        CountryCode: Code[3];
        CountryOfOriginCode: Code[3];
        NrAd: Integer;
        Fluxo: Text[8];
        POrigem: Text[2];
        TxtQuantity: Text;
        Customer: Record Customer;
        Vendor: Record Vendor;
        AdqNIF: Code[15];
        TextFLUXO: Label 'FLUXO';
        TextPERIODO: Label 'PERIODO';
        TextNIF: Label 'NIF';
        TextREF: Label 'REF';
        TextNC: Label 'NC';
        TextPAIS: Label 'PAIS';
        TextPORIGEM: Label 'PORIGEM';
        TextREGIAO: Label 'REGIAO';
        TextCODENT: Label 'CODENT';
        TextNATTRA: Label 'NATTRA';
        TextMODTRA: Label 'MODTRA';
        TextAERPOR: Label 'AERPOR';
        TextMASSA: Label 'MASSA';
        TextUNSUP: Label 'UNSUP';
        TextVALFAC: Label 'VALFAC';
        TextVALEST: Label 'VALEST';
        TextADQNIF: Label 'ADQNIF';
        OutputStream: OutStream;
        tmpBlob: Record TempBlob;
        InputStream: InStream;
        TotalUnsup: Decimal;
        UnsupQty: Decimal;
        Qty: Decimal;


    local procedure DecimalNumeralZeroFormat(DecimalNumeral: Decimal; Length: Integer): Text[250]
    begin
        EXIT(TextZeroFormat(DELCHR(FORMAT(ROUND(ABS(DecimalNumeral), 1, '<'), 0, 1)), Length));
    end;

    local procedure TextZeroFormat(Text: Text[250]; Length: Integer): Text[250]
    begin
        IF STRLEN(Text) > Length THEN
            ERROR(Text003, Text, Length);
        EXIT(Text);
    end;

    // [Scope('Internal')]
    procedure WriteGrTotalsToFile(TotalWeightAmt: Decimal; QuantityAmt: Decimal; StatisticalValueAmt: Decimal)
    begin
        WITH IntrastatJnlLine2 DO BEGIN
            OK := COPYSTR("Internal Ref. No.", 8, 3) = '001';
            IF OK THEN BEGIN
                IntrastatJnlLine3.SETRANGE(
                  "Internal Ref. No.",
                  COPYSTR("Internal Ref. No.", 1, 7) + '000',
                  COPYSTR("Internal Ref. No.", 1, 7) + '999');
                IntrastatJnlLine3.FINDLAST;
                NoOfEntries := COPYSTR(IntrastatJnlLine3."Internal Ref. No.", 8, 3);
            END;
            ImportExport := INCSTR(FORMAT(Type, 1, 2));

            IF Type = Type::Receipt THEN
                Receipt := TRUE
            ELSE
                Shipment := TRUE;
            Country.GET("Country/Region Code");
            Country.TESTFIELD("Intrastat Code");

            IF OK THEN
                OutputStream.WriteText(
                  FORMAT(
                    '02' +
                    TextZeroFormat(DELCHR(NoOfEntries), 3) +
                    FORMAT(COPYSTR(IntrastatJnlLine3."Internal Ref. No.", 1, 7) + '000', 10) +
                    FORMAT(VATRegNo, 8) + FORMAT(ImportExport, 1) + FORMAT(IntraReferenceNo, 4),
                    80));

            OutputStream.WriteText(
              FORMAT(
                '03' +
                TextZeroFormat(COPYSTR("Internal Ref. No.", 8, 3), 3) +
                FORMAT("Internal Ref. No.", 10) + FORMAT(Country."Intrastat Code", 3) + FORMAT("Transaction Type", 2) +
                '0' + FORMAT("Transport Method", 1) + PADSTR("Tariff No.", 9, '0') +
                DecimalNumeralZeroFormat(ROUND(TotalWeightAmt, 1, '>'), 15) +
                DecimalNumeralZeroFormat(QuantityAmt, 10) +
                DecimalNumeralZeroFormat(StatisticalValueAmt, 15),
                80));
        END;
    end;
}

