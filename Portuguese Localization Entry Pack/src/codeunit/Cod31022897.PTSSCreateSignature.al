codeunit 31022897 "PTSS Create Signature"
{
    // Certificacao Documentos

    Permissions = TableData 110 = imd,
                  TableData 112 = imd,
                  TableData 114 = imd,
                  TableData 120 = imd,
                  TableData 6660 = imd;

    trigger OnRun()
    begin
    end;

    var
        Text31022890: Label 'Processed by Certified Program No.';
        //SigningComponentPTNET: DotNet PTlocalizationSignature;
        PrivateKeyVersion: Integer;
        Signature: Text[172];
        Text31022891: Label 'Error when populating Hash fields. Check No. Series setup.';

    procedure GetHash(SAFTDocType: Code[2]; DocumentDate: Date; DocumentNo: Code[20]; NoSeries: Code[10]; CurrencyCode: Code[10]; CurrencyFactor: Decimal; AmountInclVAT: Decimal; LastHashUsed: Text[172]; SystemEntryDate: Date; SystemEntryTime: Time): Text[172]
    var
        DataForSigning: Text[330];
    begin
        //SigningComponentPTNET := SigningComponentPTNET.PTlocalizationSignature;

        DataForSigning :=
          GetDataForSigning(
            SAFTDocType, DocumentDate, DocumentNo,
            NoSeries, CurrencyCode, CurrencyFactor, ABS(AmountInclVAT), LastHashUsed, SystemEntryDate, SystemEntryTime);

        //Signature := SigningComponentPTNET.GetHash(DataForSigning);
        EXIT(Signature);
    end;

    local procedure GetDataForSigning(SAFTDocType: Code[2]; DocumentDate: Date; DocumentNo: Code[20]; NoSeries: Code[10]; CurrencyCode: Code[10]; CurrencyFactor: Decimal; AmountInclVAT: Decimal; LastHashUsed: Text[200]; SystemEntryDate: Date; SystemEntryTime: Time): Text[330]
    begin
        EXIT(
          FormatDate(DocumentDate) + ';' +
          FormatDateTime(SystemEntryDate, SystemEntryTime) + ';' +
          GetDocumentNo(SAFTDocType, DocumentNo, NoSeries) + ';' +
          FormatAmount(CurrencyCode, CurrencyFactor, AmountInclVAT) + ';' +
          LastHashUsed);
    end;

    local procedure FormatDate(PostingDate: Date): Text[10]
    begin
        EXIT(FORMAT(PostingDate, 0, 9));
    end;

    local procedure FormatDateTime(DateParam: Date; TimeParam: Time): Text[19]
    begin
        EXIT(FORMAT(DateParam, 0, 9) + 'T' + FORMAT(TimeParam, 0, '<Hours24,2><Filler Character,0>:<Minutes,2>:<Seconds,2>'));
    end;

    local procedure GetDocumentNo(SAFTDocType: Code[2]; DocumentNo: Code[20]; NoSeries: Code[10]): Text[35]
    var
        DocumentType: Text[4];
    begin
        EXIT(SAFTDocType + ' ' + NoSeries + '/' + DocumentNo);
    end;

    local procedure FormatAmount(CurrencyCode: Code[10]; CurrencyFactor: Decimal; AmountInclVAT: Decimal): Text[20]
    var
        DocFactor: Decimal;
    begin
        IF CurrencyCode <> '' THEN
            DocFactor := CurrencyFactor
        ELSE
            DocFactor := 1;
        EXIT(FORMAT(ROUND(AmountInclVAT / DocFactor, 0.01), 0, '<Precision,2:2><Standard Format,9>'))
    end;

    procedure GetPrivateKeyVersion(): Text[40]
    begin
        PrivateKeyVersion := 1;
        EXIT(FORMAT(PrivateKeyVersion));
    end;

    procedure GetFourCharFromSignature(Hash: Text[172]): Text[60]
    var
        CompanyInfo: Record "Company Information";
        FourChars: Text[4];
    begin
        CompanyInfo.GET;
        FourChars :=
          COPYSTR(Hash, 1, 1) +
          COPYSTR(Hash, 11, 1) +
          COPYSTR(Hash, 21, 1) +
          COPYSTR(Hash, 31, 1);
        EXIT(FourChars + '-' + Text31022890 + CompanyInfo."PTSS Software Certificate No.");
    end;

    procedure GetInvoiceDocumentTypeBySeriesNo(pCodSeriesNo: Code[10]) outCodDocType: Code[2]
    var
        NoSeries: Record "No. Series";
    begin
        CLEAR(NoSeries);
        NoSeries.GET(pCodSeriesNo);

        CASE NoSeries."PTSS SAF-T Invoice Type" OF
            NoSeries."PTSS SAF-T Invoice Type"::FT:
                EXIT('FT');
            NoSeries."PTSS SAF-T Invoice Type"::FS:
                EXIT('FS');
            NoSeries."PTSS SAF-T Invoice Type"::ND:
                EXIT('ND');
            NoSeries."PTSS SAF-T Invoice Type"::NC:
                EXIT('NC');
            NoSeries."PTSS SAF-T Invoice Type"::TV:
                EXIT('TV');
            NoSeries."PTSS SAF-T Invoice Type"::TD:
                EXIT('TD');
            NoSeries."PTSS SAF-T Invoice Type"::AA:
                EXIT('AA');
            NoSeries."PTSS SAF-T Invoice Type"::DA:
                EXIT('DA');
            NoSeries."PTSS SAF-T Invoice Type"::RP:
                EXIT('RP');
            NoSeries."PTSS SAF-T Invoice Type"::RE:
                EXIT('RE');
            NoSeries."PTSS SAF-T Invoice Type"::CS:
                EXIT('CS');
            NoSeries."PTSS SAF-T Invoice Type"::LD:
                EXIT('LD');
            NoSeries."PTSS SAF-T Invoice Type"::RA:
                EXIT('RA');
            NoSeries."PTSS SAF-T Invoice Type"::FR:
                EXIT('FR');
        END;
    end;

    procedure GetGTATDocumentTypeBySeriesNo(pCodNoSeries: Code[20]) outTxtMovementType: Text[2]
    var
        NoSeries: Record "No. Series";
        ErrWrongValueInNoSeries: Label 'Invalid input.';
    begin
        CLEAR(NoSeries);
        NoSeries.GET(pCodNoSeries);

        CASE NoSeries."PTSS GTAT Document Type" OF
            NoSeries."PTSS GTAT Document Type"::GR:
                outTxtMovementType := 'GR';
            NoSeries."PTSS GTAT Document Type"::GT:
                outTxtMovementType := 'GT';
            NoSeries."PTSS GTAT Document Type"::GA:
                outTxtMovementType := 'GA';
            NoSeries."PTSS GTAT Document Type"::GC:
                outTxtMovementType := 'GC';
            NoSeries."PTSS GTAT Document Type"::GD:
                outTxtMovementType := 'GD';
            ELSE
                NoSeries.FIELDERROR("PTSS GTAT Document Type", ErrWrongValueInNoSeries);
        END;

        CLEAR(NoSeries);
    end;

    procedure UpdateInvoiceSignature(SalesHeader: Record "Sales Header"; var SalesInvHeader: Record "Sales Invoice Header")
    var
        NoSeriesLine: Record "No. Series Line";
        NoSeriesMgt: Codeunit "PTSS NoSeriesManagement";
    begin
        WITH SalesInvHeader DO BEGIN
            NoSeriesMgt.GetAndValidateNoSeriesLine("No. Series", "Posting Date", TRUE, NoSeriesLine, 1);

            "PTSS Hash Doc. Type" := GetInvoiceDocumentTypeBySeriesNo(NoSeriesLine."Series Code");
            "PTSS Hash No. Series" := NoSeriesLine."PTSS SAF-T No. Series";
            "PTSS Hash Doc. No." := COPYSTR("No.", NoSeriesLine."PTSS SAF-T No. Series Del." + 1, STRLEN("No."));
            CalcFields("Amount Including VAT");
            "PTSS Hash Amount Including VAT" := ABS("Amount Including VAT");
            "PTSS Hash Last Hash Used" := NoSeriesLine."PTSS Last Hash Used";

            TESTFIELD("PTSS Hash No. Series");
            TESTFIELD("PTSS Hash Doc. No.");

            IF "PTSS Hash No. Series" + "PTSS Hash Doc. No." <> "No." THEN
                ERROR(Text31022891);

            "PTSS Creation Date" := TODAY;
            "PTSS Creation Time" := TIME;

            "PTSS Hash" := GetHash("PTSS Hash Doc. Type", "Posting Date", "PTSS Hash Doc. No.", "PTSS Hash No. Series", "Currency Code",
                            "Currency Factor", "PTSS Hash Amount Including VAT", "PTSS Hash Last Hash Used", "PTSS Creation Date", "PTSS Creation Time");

            "PTSS Private Key Version" := GetPrivateKeyVersion;
            NoSeriesMgt.UpdateLastHashandNoPosted("No. Series", "Posting Date", "PTSS Hash", "No.");
            MODIFY;
        END;
    end;

    procedure UpdateCrMemoSignature(SalesHeader: Record "Sales Header"; SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    var
        NoSeriesLine: Record "No. Series Line";
        NoSeriesMgt: Codeunit "PTSS NoSeriesManagement";
    begin
        WITH SalesCrMemoHeader DO BEGIN
            NoSeriesMgt.GetAndValidateNoSeriesLine("No. Series", "Posting Date", TRUE, NoSeriesLine, 1);

            "PTSS Hash Doc. Type" := GetInvoiceDocumentTypeBySeriesNo(NoSeriesLine."Series Code");
            "PTSS Hash No. Series" := NoSeriesLine."PTSS SAF-T No. Series";
            "PTSS Hash Doc. No." := COPYSTR("No.", NoSeriesLine."PTSS SAF-T No. Series Del." + 1, STRLEN("No."));
            CalcFields("Amount Including VAT");
            "PTSS Hash Amount Including VAT" := ABS("Amount Including VAT");
            "PTSS Hash Last Hash Used" := NoSeriesLine."PTSS Last Hash Used";

            TESTFIELD("PTSS Hash No. Series");
            TESTFIELD("PTSS Hash Doc. No.");

            IF "PTSS Hash No. Series" + "PTSS Hash Doc. No." <> "No." THEN
                ERROR(Text31022891);

            "PTSS Creation Date" := TODAY;
            "PTSS Creation Time" := TIME;

            "PTSS Hash" := GetHash("PTSS Hash Doc. Type", "Posting Date", "PTSS Hash Doc. No.", "PTSS Hash No. Series", "Currency Code",
                            "Currency Factor", "PTSS Hash Amount Including VAT", "PTSS Hash Last Hash Used", "PTSS Creation Date", "PTSS Creation Time");

            "PTSS Private Key Version" := GetPrivateKeyVersion;
            NoSeriesMgt.UpdateLastHashandNoPosted("No. Series", "Posting Date", "PTSS Hash", "No.");
            MODIFY;
        END;
    end;

    procedure UpdateShipmentSignature(var SalesShipmentHeader: Record "Sales Shipment Header")
    var
        NoSeriesLine: Record "No. Series Line";
        NoSeriesMgt: Codeunit "PTSS NoSeriesManagement";
    begin
        WITH SalesShipmentHeader DO BEGIN
            NoSeriesMgt.GetAndValidateNoSeriesLine("No. Series", "Posting Date", TRUE, NoSeriesLine, 2);

            "PTSS Hash Doc. Type" := GetGTATDocumentTypeBySeriesNo(NoSeriesLine."Series Code");
            "PTSS Hash No. Series" := NoSeriesLine."PTSS SAF-T No. Series";
            "PTSS Hash Doc. No." := COPYSTR("No.", NoSeriesLine."PTSS SAF-T No. Series Del." + 1, STRLEN("No."));
            "PTSS Hash Amount Including VAT" := 0;
            "PTSS Hash Last Hash Used" := NoSeriesLine."PTSS Last Hash Used";

            TESTFIELD("PTSS Hash No. Series");
            TESTFIELD("PTSS Hash Doc. No.");

            IF "PTSS Hash No. Series" + "PTSS Hash Doc. No." <> "No." THEN
                ERROR(Text31022891);

            "PTSS Creation Date" := TODAY;
            "PTSS Creation Time" := TIME;

            "PTSS Hash" := GetHash("PTSS Hash Doc. Type", "Posting Date", "PTSS Hash Doc. No.", "PTSS Hash No. Series", "Currency Code",
                            "Currency Factor", "PTSS Hash Amount Including VAT", "PTSS Hash Last Hash Used", "PTSS Creation Date", "PTSS Creation Time");

            "PTSS Private Key Version" := GetPrivateKeyVersion;

            NoSeriesMgt.UpdateLastHashandNoPosted("No. Series", SalesShipmentHeader."Posting Date", "PTSS Hash", SalesShipmentHeader."No.");
            MODIFY;
        END;
    end;

    procedure UpdateReturnShipSignature(var ReturnShptHeader: Record "Return Shipment Header")
    var
        NoSeriesLine: Record "No. Series Line";
        NoSeriesMgt: Codeunit "PTSS NoSeriesManagement";
    begin
        WITH ReturnShptHeader DO BEGIN
            NoSeriesMgt.GetAndValidateNoSeriesLine("No. Series", "Posting Date", TRUE, NoSeriesLine, 2);

            "PTSS Hash Doc. Type" := GetGTATDocumentTypeBySeriesNo(NoSeriesLine."Series Code");
            "PTSS Hash No. Series" := NoSeriesLine."PTSS SAF-T No. Series";
            "PTSS Hash Doc. No." := COPYSTR(ReturnShptHeader."No.", NoSeriesLine."PTSS SAF-T No. Series Del." + 1, STRLEN("No."));
            "PTSS Hash Amount Including VAT" := 0;
            "PTSS Hash Last Hash Used" := NoSeriesLine."PTSS Last Hash Used";

            TESTFIELD("PTSS Hash No. Series");
            TESTFIELD("PTSS Hash Doc. No.");

            IF "PTSS Hash No. Series" + "PTSS Hash Doc. No." <> "No." THEN
                ERROR(Text31022891);

            "PTSS Creation Date" := TODAY;
            "PTSS Creation Time" := TIME;

            "PTSS Hash" := GetHash("PTSS Hash Doc. Type", "Posting Date", "PTSS Hash Doc. No.", "PTSS Hash No. Series", "Currency Code",
                            "Currency Factor", "PTSS Hash Amount Including VAT", "PTSS Hash Last Hash Used", "PTSS Creation Date", "PTSS Creation Time");

            "PTSS Private Key Version" := GetPrivateKeyVersion;

            NoSeriesMgt.UpdateLastHashandNoPosted("No. Series", "Posting Date", "PTSS Hash", "No.");
            MODIFY;
        END;
    end;

    procedure UpdateTransferShipSignature(var TransShptHeader: Record "Transfer Shipment Header")
    var
        NoSeriesMgt: Codeunit "PTSS NoSeriesManagement";
        NoSeriesLine: Record "No. Series Line";
    begin
        WITH TransShptHeader DO BEGIN
            NoSeriesMgt.GetAndValidateNoSeriesLine("No. Series", "Posting Date", TRUE, NoSeriesLine, 2);

            "PTSS Hash Doc. Type" := GetGTATDocumentTypeBySeriesNo(NoSeriesLine."Series Code");
            "PTSS Hash No. Series" := NoSeriesLine."PTSS SAF-T No. Series";
            "PTSS Hash Doc. No." := COPYSTR("No.", NoSeriesLine."PTSS SAF-T No. Series Del." + 1, STRLEN("No."));
            "PTSS Hash Amount Including VAT" := 0;
            "PTSS Hash Last Hash Used" := NoSeriesLine."PTSS Last Hash Used";

            TESTFIELD("PTSS Hash No. Series");
            TESTFIELD("PTSS Hash Doc. No.");

            IF "PTSS Hash No. Series" + "PTSS Hash Doc. No." <> "No." THEN
                ERROR(Text31022891);

            "PTSS Creation Date" := TODAY;
            "PTSS Creation Time" := TIME;


            "PTSS Hash" := GetHash("PTSS Hash Doc. Type", "Posting Date", "PTSS Hash Doc. No.", "PTSS Hash No. Series", '', 0,
                            "PTSS Hash Amount Including VAT", "PTSS Hash Last Hash Used", "PTSS Creation Date", "PTSS Creation Time");

            "PTSS Private Key Version" := GetPrivateKeyVersion;
            NoSeriesMgt.UpdateLastHashandNoPosted("No. Series", "Posting Date", "PTSS Hash", "No.");
            MODIFY;
        END;
    end;

    procedure UpdateIssueReminderSignature(var IssuedRmdrHeader: Record "Issued Reminder Header")
    var
        NoSeriesLine: Record "No. Series Line";
        NoSeriesMgt: Codeunit "PTSS NoSeriesManagement";
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        WITH IssuedRmdrHeader DO BEGIN
            NoSeriesMgt.GetAndValidateNoSeriesLine("No. Series", "Posting Date", TRUE, NoSeriesLine, 1);

            CALCFIELDS("Interest Amount", "Additional Fee", "VAT Amount");

            "PTSS Hash Doc. Type" := GetInvoiceDocumentTypeBySeriesNo(NoSeriesLine."Series Code");
            "PTSS Hash No. Series" := NoSeriesLine."PTSS SAF-T No. Series";
            "PTSS Hash Doc. No." := COPYSTR("No.", NoSeriesLine."PTSS SAF-T No. Series Del." + 1, STRLEN("No."));
            "PTSS Hash Amount Including VAT" := ABS("Interest Amount" + "Additional Fee" + "VAT Amount");
            "PTSS Hash Last Hash Used" := NoSeriesLine."PTSS Last Hash Used";

            TESTFIELD("PTSS Hash No. Series");
            TESTFIELD("PTSS Hash Doc. No.");

            IF "PTSS Hash No. Series" + "PTSS Hash Doc. No." <> "No." THEN
                ERROR(Text31022891);

            "PTSS Creation Date" := TODAY;
            "PTSS Creation Time" := TIME;

            "PTSS Hash" := GetHash("PTSS Hash Doc. Type", "Posting Date", "PTSS Hash Doc. No.", "PTSS Hash No. Series", "Currency Code", CurrExchRate.ExchangeRate("Posting Date", "Currency Code"),
                            "PTSS Hash Amount Including VAT", "PTSS Hash Last Hash Used", "PTSS Creation Date", "PTSS Creation Time");

            "PTSS Private Key Version" := GetPrivateKeyVersion;
            NoSeriesMgt.UpdateLastHashandNoPosted("No. Series", "Posting Date", "PTSS Hash", "No.");
            MODIFY;
        END;
    end;

    procedure UpdateFinanceChrgSignature(var IssuedFinChargeMemoHeader: Record "Issued Fin. Charge Memo Header")
    var
        NoSeriesLine: Record "No. Series Line";
        NoSeriesMgt: Codeunit "PTSS NoSeriesManagement";
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        WITH IssuedFinChargeMemoHeader DO BEGIN
            NoSeriesMgt.GetAndValidateNoSeriesLine("No. Series", "Posting Date", TRUE, NoSeriesLine, 1);

            CALCFIELDS("Interest Amount", "Additional Fee", "VAT Amount");

            "PTSS Hash Doc. Type" := GetInvoiceDocumentTypeBySeriesNo(NoSeriesLine."Series Code");
            "PTSS Hash No. Series" := NoSeriesLine."PTSS SAF-T No. Series";
            "PTSS Hash Doc. No." := COPYSTR("No.", NoSeriesLine."PTSS SAF-T No. Series Del." + 1, STRLEN("No."));
            "PTSS Hash Amount Including VAT" := ABS("Interest Amount" + "Additional Fee" + "VAT Amount");
            "PTSS Hash Last Hash Used" := NoSeriesLine."PTSS Last Hash Used";

            TESTFIELD("PTSS Hash No. Series");
            TESTFIELD("PTSS Hash Doc. No.");

            IF "PTSS Hash No. Series" + "PTSS Hash Doc. No." <> "No." THEN
                ERROR(Text31022891);

            "PTSS Creation Date" := TODAY;
            "PTSS Creation Time" := TIME;

            "PTSS Hash" := GetHash("PTSS Hash Doc. Type", "Posting Date", "PTSS Hash Doc. No.", "PTSS Hash No. Series", "Currency Code", CurrExchRate.ExchangeRate("Posting Date", "Currency Code"),
                            "PTSS Hash Amount Including VAT", "PTSS Hash Last Hash Used", "PTSS Creation Date", "PTSS Creation Time");

            "PTSS Private Key Version" := GetPrivateKeyVersion;
            NoSeriesMgt.UpdateLastHashandNoPosted("No. Series", "Posting Date", "PTSS Hash", "No.");
            MODIFY;
        END;
    end;

    procedure UpdatePrepmtSalesInvSignature(SalesHeader: Record "Sales Header"; var SalesInvHeader: Record "Sales Invoice Header")
    var
        NoSeriesMgt: Codeunit "PTSS NoSeriesManagement";
        NoSeriesLine: Record "No. Series Line";
    begin
        WITH SalesInvHeader DO BEGIN
            IF NOT ((SalesHeader."Prepayment No." <> '') AND "Prepayment Invoice") THEN
                EXIT;
            CALCFIELDS("Amount Including VAT");
            NoSeriesMgt.GetAndValidateNoSeriesLine("Prepayment No. Series", "Posting Date", TRUE, NoSeriesLine, 1);

            "PTSS Hash Doc. Type" := GetInvoiceDocumentTypeBySeriesNo(NoSeriesLine."Series Code");
            "PTSS Hash No. Series" := NoSeriesLine."PTSS SAF-T No. Series";
            "PTSS Hash Doc. No." := COPYSTR("No.", NoSeriesLine."PTSS SAF-T No. Series Del." + 1, STRLEN("No."));
            "PTSS Hash Amount Including VAT" := ABS("Amount Including VAT");
            "PTSS Hash Last Hash Used" := NoSeriesLine."PTSS Last Hash Used";
            TESTFIELD("PTSS Hash No. Series");
            TESTFIELD("PTSS Hash Doc. No.");
            IF "PTSS Hash No. Series" + "PTSS Hash Doc. No." <> "No." THEN
                ERROR(Text31022890);

            "PTSS Creation Date" := TODAY;
            "PTSS Creation Time" := TIME;
            "PTSS Hash" := GetHash("PTSS Hash Doc. Type", "Posting Date", "PTSS Hash Doc. No.", "PTSS Hash No. Series", "Currency Code", "Currency Factor",
                            "PTSS Hash Amount Including VAT", "PTSS Hash Last Hash Used", "PTSS Creation Date", "PTSS Creation Time");

            "PTSS Private Key Version" := GetPrivateKeyVersion;
            NoSeriesMgt.UpdateLastHashandNoPosted("Prepayment No. Series", "Posting Date", "PTSS Hash", "No.");
            MODIFY;
        END;
    end;

    procedure UpdatePrepmtSalesCrMemoSignature(SalesHeader: Record "Sales Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    var
        NoSeriesMgt: Codeunit "PTSS NoSeriesManagement";
        NoSeriesLine: Record "No. Series Line";
    begin
        WITH SalesCrMemoHeader DO BEGIN
            IF NOT ((SalesHeader."Prepmt. Cr. Memo No." <> '') AND "Prepayment Credit Memo") THEN
                EXIT;
            CALCFIELDS("Amount Including VAT");

            NoSeriesMgt.GetAndValidateNoSeriesLine("Prepmt. Cr. Memo No. Series", "Posting Date", TRUE, NoSeriesLine, 1);

            "PTSS Hash Doc. Type" := GetInvoiceDocumentTypeBySeriesNo(NoSeriesLine."Series Code");
            "PTSS Hash No. Series" := NoSeriesLine."PTSS SAF-T No. Series";
            "PTSS Hash Doc. No." := COPYSTR("No.", NoSeriesLine."PTSS SAF-T No. Series Del." + 1, STRLEN("No."));
            "PTSS Hash Amount Including VAT" := ABS("Amount Including VAT");
            "PTSS Hash Last Hash Used" := NoSeriesLine."PTSS Last Hash Used";
            TESTFIELD("PTSS Hash No. Series");
            TESTFIELD("PTSS Hash Doc. No.");
            IF "PTSS Hash No. Series" + "PTSS Hash Doc. No." <> "No." THEN
                ERROR(Text31022890);

            "PTSS Creation Date" := TODAY;
            "PTSS Creation Time" := TIME;
            "PTSS Hash" := GetHash("PTSS Hash Doc. Type", "Posting Date", "PTSS Hash Doc. No.", "PTSS Hash No. Series", "Currency Code", "Currency Factor",
                            "PTSS Hash Amount Including VAT", "PTSS Hash Last Hash Used", "PTSS Creation Date", "PTSS Creation Time");

            "PTSS Private Key Version" := GetPrivateKeyVersion;
            NoSeriesMgt.UpdateLastHashandNoPosted("Prepmt. Cr. Memo No. Series", "Posting Date", "PTSS Hash", "No.");
            MODIFY;
        END;
    end;

    procedure UpdateWhseShptSignature(var PostedWhseShptHeader: Record "Posted Whse. Shipment Header")
    var
        NoSeriesMgt: Codeunit "PTSS NoSeriesManagement";
        NoSeriesLine: Record "No. Series Line";
        NoSeries: Record "No. Series";
    begin
        WITH PostedWhseShptHeader DO BEGIN
            NoSeriesMgt.GetAndValidateNoSeriesLine(PostedWhseShptHeader."No. Series", PostedWhseShptHeader."Posting Date", TRUE, NoSeriesLine, 2);

            "PTSS Hash Doc. Type" := GetGTATDocumentTypeBySeriesNo(NoSeriesLine."Series Code");
            "PTSS Hash No. Series" := NoSeriesLine."PTSS SAF-T No. Series";
            "PTSS Hash Doc. No." := COPYSTR(PostedWhseShptHeader."No.", NoSeriesLine."PTSS SAF-T No. Series Del." + 1, STRLEN(PostedWhseShptHeader."No."));
            "PTSS Hash Amount Including VAT" := 0;
            "PTSS Hash Last Hash Used" := NoSeriesLine."PTSS Last Hash Used";

            TESTFIELD("PTSS Hash No. Series");
            TESTFIELD("PTSS Hash Doc. No.");

            IF "PTSS Hash No. Series" + "PTSS Hash Doc. No." <> "No." THEN
                ERROR(Text31022891);

            "PTSS Creation Date" := TODAY;
            "PTSS Creation Time" := TIME;

            "PTSS Hash" := GetHash("PTSS Hash Doc. Type", "Posting Date", "PTSS Hash Doc. No.", "PTSS Hash No. Series", '', 0,
                                                 "PTSS Hash Amount Including VAT", PostedWhseShptHeader."PTSS Hash Last Hash Used", "PTSS Creation Date", "PTSS Creation Time");

            "PTSS Private Key Version" := GetPrivateKeyVersion;
            NoSeriesMgt.UpdateLastHashandNoPosted("No. Series", "Posting Date", "PTSS Hash", "No.");
            MODIFY;
        END;
    end;

    procedure UpdateServiceInvSignature(ServHeader: Record "Service Header"; var ServInvHeader: Record "Service Invoice Header")
    var
        NoSeriesLine: Record "No. Series Line";
        NoSeriesMgt: Codeunit "PTSS NoSeriesManagement";
    begin
        WITH ServInvHeader DO BEGIN
            NoSeriesMgt.GetAndValidateNoSeriesLine("No. Series", "Posting Date", TRUE, NoSeriesLine, 1);

            "PTSS Hash Doc. Type" := GetInvoiceDocumentTypeBySeriesNo(NoSeriesLine."Series Code");
            "PTSS Hash No. Series" := NoSeriesLine."PTSS SAF-T No. Series";
            "PTSS Hash Doc. No." := COPYSTR("No.", NoSeriesLine."PTSS SAF-T No. Series Del." + 1, STRLEN("No."));
            CALCFIELDS("Amount Including VAT");
            "PTSS Hash Amount Including VAT" := ABS("Amount Including VAT");
            "PTSS Hash Last Hash Used" := NoSeriesLine."PTSS Last Hash Used";
            TESTFIELD("PTSS Hash No. Series");
            TESTFIELD("PTSS Hash Doc. No.");

            IF "PTSS Hash No. Series" + "PTSS Hash Doc. No." <> "No." THEN
                ERROR(Text31022891);

            "PTSS Creation Date" := TODAY;
            "PTSS Creation Time" := TIME;
            "PTSS Hash" := GetHash("PTSS Hash Doc. Type", "Posting Date", "PTSS Hash Doc. No.", "PTSS Hash No. Series", "Currency Code", "Currency Factor",
                            "PTSS Hash Amount Including VAT", ServInvHeader."PTSS Hash Last Hash Used", "PTSS Creation Date", "PTSS Creation Time");
            "PTSS Private Key Version" := GetPrivateKeyVersion;
            NoSeriesMgt.UpdateLastHashandNoPosted("No. Series", "Posting Date", "PTSS Hash", "No.");
            MODIFY;
        END;
    end;

    local procedure UpdateServCrMemoSignature(ServHeader: Record "Service Header"; VAR ServCrMemoHeader: Record "Service Cr.Memo Header")
    var
        NoSeriesLine: Record "No. Series Line";
        NoSeriesMgt: Codeunit "PTSS NoSeriesManagement";
    begin
        WITH ServCrMemoHeader DO BEGIN
            NoSeriesMgt.GetAndValidateNoSeriesLine("No. Series", "Posting Date", TRUE, NoSeriesLine, 1);
            "PTSS Hash Doc. Type" := GetInvoiceDocumentTypeBySeriesNo(NoSeriesLine."Series Code");
            "PTSS Hash No. Series" := NoSeriesLine."PTSS SAF-T No. Series";
            "PTSS Hash Doc. No." := COPYSTR(ServCrMemoHeader."No.", NoSeriesLine."PTSS SAF-T No. Series Del." + 1, STRLEN("No."));
            CALCFIELDS("Amount Including VAT");
            "PTSS Hash Amount Including VAT" := ABS("Amount Including VAT");
            "PTSS Hash Last Hash Used" := NoSeriesLine."PTSS Last Hash Used";
            TESTFIELD("PTSS Hash No. Series");
            TESTFIELD("PTSS Hash Doc. No.");

            IF "PTSS Hash No. Series" + "PTSS Hash Doc. No." <> "No." THEN
                ERROR(Text31022891);

            "PTSS Creation Date" := TODAY;
            "PTSS Creation Time" := TIME;
            "PTSS Hash" := GetHash("PTSS Hash Doc. Type", "Posting Date", "PTSS Hash Doc. No.", "PTSS Hash No. Series", "Currency Code", "Currency Factor",
                            "PTSS Hash Amount Including VAT", "PTSS Hash Last Hash Used", "PTSS Creation Date", ServCrMemoHeader."PTSS Creation Time");
            "PTSS Private Key Version" := GetPrivateKeyVersion;
            NoSeriesMgt.UpdateLastHashandNoPosted("No. Series", "Posting Date", "PTSS Hash", "No.");
            MODIFY;
        END;
    end;

    procedure UpdateServShptSignature(var ServiceShipmentHeader: Record "Service Shipment Header")
    var
        NoSeriesLine: Record "No. Series Line";
        NoSeriesMgt: Codeunit "PTSS NoSeriesManagement";
    begin
        WITH ServiceShipmentHeader DO BEGIN
            NoSeriesMgt.GetAndValidateNoSeriesLine(ServiceShipmentHeader."No. Series", ServiceShipmentHeader."Posting Date", TRUE, NoSeriesLine, 2);

            "PTSS Hash Doc. Type" := GetGTATDocumentTypeBySeriesNo(NoSeriesLine."Series Code");
            "PTSS Hash No. Series" := NoSeriesLine."PTSS SAF-T No. Series";
            "PTSS Hash Doc. No." := COPYSTR("No.", NoSeriesLine."PTSS SAF-T No. Series Del." + 1, STRLEN("No."));
            "PTSS Hash Amount Including VAT" := 0;
            "PTSS Hash Last Hash Used" := NoSeriesLine."PTSS Last Hash Used";

            ServiceShipmentHeader.TESTFIELD("PTSS Hash No. Series");
            ServiceShipmentHeader.TESTFIELD("PTSS Hash Doc. No.");

            IF "PTSS Hash No. Series" + "PTSS Hash Doc. No." <> "No." THEN
                ERROR(Text31022891);

            "PTSS Creation Date" := TODAY;
            "PTSS Creation Time" := TIME;

            "PTSS Hash" :=
              GetHash("PTSS Hash Doc. Type", "Posting Date", "PTSS Hash Doc. No.", "PTSS Hash No. Series", "Currency Code", "Currency Factor",
                      "PTSS Hash Amount Including VAT", "PTSS Hash Last Hash Used", "PTSS Creation Date", "PTSS Creation Time");

            "PTSS Private Key Version" := GetPrivateKeyVersion;
            NoSeriesMgt.UpdateLastHashandNoPosted("No. Series", "Posting Date", "PTSS Hash", "No.");
            MODIFY;
        END;
    end;


    //Invoice
    [EventSubscriber(ObjectType::Codeunit, 80, 'OnAfterPostSalesLines', '', true, true)]
    local procedure OnAfterPostSalesLinesPT(var SalesHeader: Record "Sales Header"; var SalesShipmentHeader: Record "Sales Shipment Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var ReturnReceiptHeader: Record "Return Receipt Header"; WhseShip: Boolean; WhseReceive: Boolean; var SalesLinesProcessed: Boolean; CommitIsSuppressed: Boolean)
    begin
        IF SalesHeader.Invoice then
            IF SalesHeader."Document Type" IN [SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Invoice] THEN
                UpdateInvoiceSignature(SalesHeader, SalesInvoiceHeader)
            ELSE
                IF SalesHeader."Document Type" IN [SalesHeader."Document Type"::"Return Order", SalesHeader."Document Type"::"Credit Memo"] THEN
                    UpdateCrMemoSignature(SalesHeader, SalesCrMemoHeader);


    end;

    //Shipment
    [EventSubscriber(ObjectType::Codeunit, 80, 'OnAfterSalesShptHeaderInsert', '', true, true)]
    local procedure InsertShipmentHeaderPT(var SalesShipmentHeader: Record "Sales Shipment Header"; SalesHeader: Record "Sales Header"; SuppressCommit: Boolean)
    begin
        //IF NOT PreviewMode THEN
        UpdateShipmentSignature(SalesShipmentHeader);
    end;

    //Return Shipment
    [EventSubscriber(ObjectType::Codeunit, 90, 'OnAfterReturnShptHeaderInsert', '', true, true)]
    local procedure InsertReturnShipmentHeader(var ReturnShptHeader: Record "Return Shipment Header"; var PurchHeader: Record "Purchase Header"; CommitIsSupressed: Boolean)
    begin
        //IF NOT PreviewMode THEN
        UpdateReturnShipSignature(ReturnShptHeader);
    end;

    //Shipment
    [EventSubscriber(ObjectType::Codeunit, 90, 'OnAfterSalesShptHeaderInsert', '', true, true)]
    local procedure InsertSalesShptHeaderPT(var SalesShipmentHeader: Record "Sales Shipment Header"; SalesOrderHeader: Record "Sales Header"; CommitIsSuppressed: Boolean)
    begin
        //IF NOT PreviewMode THEN
        UpdateShipmentSignature(SalesShipmentHeader);
    end;

    //Issued Reminder
    [EventSubscriber(ObjectType::Codeunit, 393, 'OnAfterIssueReminder', '', true, true)]
    local procedure IssueReminderPT(var ReminderHeader: Record "Reminder Header"; IssuedReminderNo: Code[20])
    var
        IssuedReminderHeader: Record "Issued Reminder Header";
    begin
        IF ReminderHeader."PTSS Sign on Issuing" THEN BEGIN
            IssuedReminderHeader.Get(IssuedReminderNo);
            UpdateIssueReminderSignature(IssuedReminderHeader);
        END;
    end;

    //Finance Charge
    [EventSubscriber(ObjectType::Codeunit, 395, 'OnAfterIssueFinChargeMemo', '', true, true)]
    local procedure IssueFinChargeMemoPT(var FinChargeMemoHeader: Record "Finance Charge Memo Header"; IssuedFinChargeMemoNo: Code[20])
    var
        IssuedFinChrgMemoHeader: Record "Issued Fin. Charge Memo Header";
    begin
        IF FinChargeMemoHeader."PTSS Sign on Issuing" THEN BEGIN
            IssuedFinChrgMemoHeader.get(IssuedFinChargeMemoNo);
            UpdateFinanceChrgSignature(IssuedFinChrgMemoHeader);
        END;
    end;

    //Sales Prepayments
    [EventSubscriber(ObjectType::Codeunit, 442, 'OnAfterPostPrepayments', '', true, true)]
    local procedure PostPrepaymentsPT(var SalesHeader: Record "Sales Header"; DocumentType: Option; CommitIsSuppressed: Boolean; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    var
        DocType: Option "Invoice","Credit Memo";
    begin
        DocType := DocumentType;
        CASE DocType OF
            DocType::Invoice:
                UpdatePrepmtSalesInvSignature(SalesHeader, SalesInvoiceHeader);
            DocType::"Credit Memo":
                UpdatePrepmtSalesCrMemoSignature(SalesHeader, SalesCrMemoHeader);
        END;
    end;

    //Transfer Order Shipment
    [EventSubscriber(ObjectType::Codeunit, 5704, 'OnAfterInsertTransShptHeader', '', true, true)]
    local procedure InsertTransShptHeaderPT(var TransferHeader: Record "Transfer Header"; var TransferShipmentHeader: Record "Transfer Shipment Header")
    begin
        UpdateTransferShipSignature(TransferShipmentHeader);
    end;

    //Whse. Shipment - Event Requested
    // [EventSubscriber(ObjectType::Codeunit, 5763, OnAfterPostedWhseShptHeaderInsert , '', true, true)]
    // local procedure MyProcedure(Var PostedWhseShptHeader, WarehouseShipmentHeader)
    // begin
    //    UpdateWhseShptSignature(PostedWhseShptHeader);
    // end;

    //Service Shipmnet
    [EventSubscriber(ObjectType::Codeunit, 5988, 'OnAfterServShptHeaderInsert', '', true, true)]
    local procedure ServShptHeaderInsertPT(var ServiceShipmentHeader: Record "Service Shipment Header"; ServiceHeader: Record "Service Header")
    begin
        UpdateServShptSignature(ServiceShipmentHeader);
    end;

    //Service Invoice
    [EventSubscriber(ObjectType::Codeunit, 5988, 'OnAfterServInvHeaderInsert', '', true, true)]
    local procedure ServInvHeaderInsertPT(var ServiceInvoiceHeader: Record "Service Invoice Header"; ServiceHeader: Record "Service Header")
    begin
        UpdateServiceInvSignature(ServiceHeader, ServiceInvoiceHeader);
    end;

    //Service Credit Memo
    [EventSubscriber(ObjectType::Codeunit, 5988, 'OnAfterServCrMemoHeaderInsert', '', true, true)]
    local procedure ServCrMemoHeaderInsertPT(var ServiceCrMemoHeader: Record "Service Cr.Memo Header"; ServiceHeader: Record "Service Header")
    begin
        UpdateServCrMemoSignature(ServiceHeader, ServiceCrMemoHeader);
    end;
}

