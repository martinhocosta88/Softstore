table 31022926 "PTSS VAT Report File Buffer"
{
    // IRC Modelo 22

    Caption = 'VAT Report File Buffer';

    fields
    {
        field(1; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(2; "Line Value"; Text[250])
        {
            Caption = 'Line Value';
        }
    }

    keys
    {
        key(Key1; "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        CompanyInfo: Record "Company Information";
        CurrentLine: Integer;
        Blank: Label ' ';
        DANUALText: Label 'DANUAL';
        CurrencyCode: Label 'EUR';
        EncodingType: Label 'ASCII';
        YearFormat: Label '<Year4><Month,2><Day,2>';
        HeadingZero: Label '0';
        ZeroOne: Label '01';
        ZeroTwo: Label '02';
        ZeroThree: Label '03';
        DPIVAText: Label 'DPIVA';
        DRECAText: Label 'DRECA';
        MODText: Label 'Mod.22';
        AnnexA: Label 'A';
        AnnexF: Label 'F';
        AnnexG: Label 'G';
        AnnexL: Label 'L';
        AnnexM: Label 'M';
        AnnexO: Label 'O';
        AnnexP: Label 'P';
        AnnexQ: Label 'Q';
        FirstQuarterText: Label '03T';
        SecondQuarterText: Label '06T';
        ThirdQuarterText: Label '09T';
        FourthQuarterText: Label '12T';
        Print40: Boolean;
        Print41: Boolean;
        boolFrameA: Boolean;
        indice: Integer;
        gTotal: Integer;
        gResumes: array[10] of Integer;
        PrintRoc: Boolean;
        intRoc: Integer;

    procedure NewLine()
    begin
        IF FINDLAST THEN BEGIN
            "Line No." := "Line No." + 1;
            "Line Value" := '';
        END;
        INSERT;
    end;

    procedure PadLine(FillCharacter: Text[1])
    begin
        FINDLAST;
        "Line Value" := PADSTR("Line Value", 172, FillCharacter);
        MODIFY;
    end;

    procedure PadLinetill134Characters(FillCharacter: Text[1])
    begin
        FINDLAST;
        "Line Value" := PADSTR("Line Value", 134, FillCharacter);
        MODIFY;
    end;

    procedure InsertIntegerValue(Value: Integer; Size: Integer)
    begin
        FINDLAST;
        "Line Value" := "Line Value" + CONVERTSTR(FORMAT(Value, Size, 0), Blank, HeadingZero);
        MODIFY;
    end;

    procedure InsertTextValue(Value: Text[172]; Size: Integer; FillCharacter: Text[1])
    begin
        FINDLAST;
        "Line Value" := "Line Value" + PADSTR(COPYSTR(Value, 1, Size), Size, FillCharacter);
        MODIFY;
    end;

    procedure SaveFile(Path: Text[250])
    var
        FileHandle: File;
        InputStream: InStream;
        OutputStream: OutStream;
        tmpBlob: Record TempBlob;
    begin
        //XXX A Resolver Escrita Ficheiro
        // FileHandle.TEXTMODE(TRUE);
        // FileHandle.WRITEMODE(TRUE);
        // FileHandle.CREATETEMPFILE();
        // IF FINDSET THEN
        //   REPEAT
        //     FileHandle.WRITE ("Line Value");
        //   UNTIL (NEXT = 0);

        // FileHandle.CREATEINSTREAM(InputStreamObj);
        // DOWNLOADFROMSTREAM(InputStreamObj,'','',Text31022894,Path);
        // FileHandle.CLOSE;

        tmpBlob.Blob.CreateOutStream(OutputStream);
        IF FINDSET then
            REPEAT
                OutputStream.WriteText("Line Value");
            UNTIL (NEXT = 0);

        tmpBlob.Blob.CreateInStream(InputStream);
        DownloadFromStream(InputStream, '', '', '', Path);


    end;

    procedure LoadFile(Path: Text[250]): Boolean
    begin
    end;

    procedure InsertFileHeader(FileDate: Date)
    begin
        NewLine;
        InsertIntegerValue(1, 3);
        InsertTextValue(EncodingType, 5, Blank);
        InsertIntegerValue(3, 2);
        InsertIntegerValue(4, 2);
        PadLine(Blank);
    end;

    procedure InsertDeclarationHeader(StartDate: Date; EndDate: Date; Year: Integer)
    begin
        CompanyInfo.GET;
        NewLine;
        InsertIntegerValue(2, 3);
        InsertTextValue(DANUALText, 6, Blank);
        InsertTextValue(CompanyInfo."VAT Registration No.", 9, Blank);
        InsertTextValue(FORMAT(StartDate, 0, YearFormat), 8, Blank);
        InsertTextValue(FORMAT(EndDate, 0, YearFormat), 8, Blank);
        InsertIntegerValue(Year, 4);
        InsertTextValue(CurrencyCode, 3, Blank);
        PadLine(Blank);
    end;

    procedure InsertYearlyHeader(FinCode: Integer; VolPerc: Integer; ActCode: Integer; Type: Option First,Substitution; RepNIF: Text[20]; TOCNIF: Text[20])
    begin
        CompanyInfo.GET;
        NewLine;
        InsertIntegerValue(3, 3);
        InsertIntegerValue(FinCode, 4);
        InsertTextValue(CompanyInfo."PTSS CAE Code", 5, Blank);
        InsertIntegerValue(VolPerc, 3);
        InsertIntegerValue(ActCode, 4);
        InsertIntegerValue(0, 4);
        InsertIntegerValue(Type + 1, 1);
        InsertTextValue(RepNIF, 9, Blank);
        InsertTextValue(TOCNIF, 9, Blank);
        PadLine(Blank);
    end;

    procedure InsertYearlyDetail(AnnexO: Boolean; AnnexP: Boolean)
    begin
        NewLine;
        InsertIntegerValue(4, 3);
        InsertIntegerValue(0, 13);

        IF AnnexO THEN
            InsertIntegerValue(1, 1)
        ELSE
            InsertIntegerValue(0, 1);

        IF AnnexP THEN
            InsertIntegerValue(1, 1)
        ELSE
            InsertIntegerValue(0, 1);

        InsertIntegerValue(0, 1);
        PadLine(Blank);
    end;

    procedure InsertYearlyTrailer()
    begin
        NewLine;
        InsertIntegerValue(5, 3);
        InsertIntegerValue(1, 3);
        PadLine(Blank);
    end;

    procedure InsertDeclarationTrailer()
    begin
        NewLine;
        InsertIntegerValue(6, 3);
        InsertIntegerValue(COUNT - 3, 9);
        PadLine(Blank);
    end;

    procedure InsertFileTrailer()
    begin
        NewLine;
        InsertIntegerValue(999, 3);
        InsertIntegerValue(COUNT - 2, 9);
        PadLine(Blank);
    end;

    procedure InsertAnnexHeader(Type: Text[1]; Year: Integer)
    begin
    end;

    procedure InsertAnnexDetail(Type: Text[1]; NIF: Text[20]; Amount: Integer)
    begin
        NewLine;
        InsertTextValue(Type + ZeroTwo, 3, Blank);
        InsertIntegerValue(CurrentLine, 5);
        CurrentLine := CurrentLine + 1;
        InsertTextValue(NIF, 9, Blank);
        InsertIntegerValue(Amount, 11);
        PadLine(Blank);
    end;

    procedure InsertAnnexTrailer(Type: Text[1]; "Count": Integer; Total: Integer)
    begin
        NewLine;
        InsertTextValue(Type + ZeroThree, 3, Blank);
        InsertIntegerValue(Count, 5);
        InsertIntegerValue(Total, 14);
        PadLine(Blank);
    end;

    procedure InsertFileHeaderVATSt(FileDate: Date)
    begin
        NewLine;
        InsertIntegerValue(1, 2);
        InsertTextValue(EncodingType, 5, Blank);
        InsertIntegerValue(4, 2);
        InsertTextValue(FORMAT(FileDate, 0, YearFormat), 8, Blank);
        PadLine(Blank);
    end;

    procedure InsertDeclarationHeaderVATSt(InOutPeriod: Option " ",Inside,Outside)
    var
        VatRegNo: Code[20];
    begin
        CompanyInfo.GET;
        NewLine;
        InsertIntegerValue(2, 2);
        InsertTextValue(DPIVAText, 5, Blank);
        VatRegNo := CompanyInfo."VAT Registration No.";
        IF STRLEN(VatRegNo) < 9 THEN
            VatRegNo := FORMAT(VatRegNo, 9, '<Text,9><Filler Character,0>');
        InsertTextValue(VatRegNo, 9, Blank);
        CASE InOutPeriod OF
            0:
                InsertIntegerValue(0, 1);
            1:
                InsertIntegerValue(1, 1);
            2:
                InsertIntegerValue(2, 1)
        END;
        PadLine(Blank);
    end;

    procedure InsertVATPerDeclarationHeader(Headquarter: Integer; Continent: Boolean; Azores: Boolean; Madeira: Boolean; RealState: Boolean; InterEuropean: Boolean; RecapitulativeDecl: Boolean; InexOp: Boolean; DeclYear: Integer; PeriodMonth: Option " ",January,February,March,April,May,June,Jule,August,September,October,November,December; PeriodQuarter: Option " ",FirstQuarter,SecondQuarter,ThirdQuarter,FourthQuarter; CustEntries: Integer; VendEntries: Integer; ReturnVAT: Integer)
    var
        i: Integer;
        Period: Text[3];
    begin
        NewLine;
        InsertIntegerValue(3, 2);
        InsertIntegerValue(Headquarter + 1, 1);

        IF (Continent = TRUE) THEN
            i := i + 100;
        IF (Azores = TRUE) THEN
            i := i + 20;
        IF (Madeira = TRUE) THEN
            i := i + 3;
        IF (i <> 0) THEN BEGIN
            InsertIntegerValue(i, 3);
        END ELSE
            InsertIntegerValue(0, 3);

        IF (RealState = TRUE) THEN BEGIN
            InsertIntegerValue(4, 1);
        END ELSE
            InsertIntegerValue(0, 1);

        IF InterEuropean OR RecapitulativeDecl THEN
            InsertIntegerValue(5, 1)
        ELSE
            InsertIntegerValue(0, 1);

        InsertIntegerValue(CustEntries, 1);
        InsertIntegerValue(VendEntries, 1);
        InsertIntegerValue(ReturnVAT, 1);

        IF (InexOp = TRUE) THEN BEGIN
            InsertIntegerValue(1, 1);
        END ELSE
            InsertIntegerValue(0, 1);

        InsertIntegerValue(DeclYear, 4);

        Period := PeriodEquivalence(PeriodMonth, PeriodQuarter);
        InsertTextValue(Period, 3, Blank);
        PadLine(Blank);
    end;

    procedure InsertVATPerDeclDetailI(X1: Decimal; X5: Decimal; X3: Decimal; X7: Decimal; X8: Decimal; X9: Decimal; X10: Decimal; X16: Decimal) ReturnValue: Decimal
    begin
        NewLine;
        InsertIntegerValue(4, 2);
        InsertDecimalValue(ABS(X1 * 100), 12);
        InsertDecimalValue(ABS(X5 * 100), 12);
        InsertDecimalValue(ABS(X3 * 100), 12);
        InsertDecimalValue(ROUND(ABS(X7), 1, '<') * 100, 12);
        InsertDecimalValue(ABS(X8 * 100), 12);
        InsertDecimalValue(ABS(X9 * 100), 12);
        InsertDecimalValue(ABS(X10 * 100), 12);
        InsertDecimalValue(
          (ROUND(ABS(X1), 0.001, '<') + ROUND(ABS(X5), 0.001, '<') + ROUND(ABS(X3), 0.001, '<') + ROUND(ABS(X7), 1, '<') +
          ROUND(ABS(X8), 0.001, '<') + ROUND(ABS(X9), 0.001, '<') + ROUND(ABS(X10), 0.001, '<') + ROUND(ABS(X16), 0.001, '<')) * 100, 12);

        ReturnValue :=
          (ROUND(ABS(X1), 0.001, '<') + ROUND(ABS(X5), 0.001, '<') + ROUND(ABS(X3), 0.001, '<') + ROUND(ABS(X7), 1, '<') +
          ROUND(ABS(X8), 0.001, '<') + ROUND(ABS(X9), 0.001, '<') + ROUND(ABS(X10), 0.001, '<') + ROUND(ABS(X16), 0.001, '<')) * 100;

        PadLine(Blank);
        EXIT(ReturnValue);
    end;

    procedure InsertVATPerDeclDetailII(X20: Decimal; X21: Decimal; X23: Decimal; X22: Decimal; X24: Decimal; X40: Decimal; X61: Decimal; X65: Decimal; X67: Decimal; VATCom: Decimal): Decimal
    var
        FinalSum: Decimal;
    begin
        NewLine;
        InsertIntegerValue(5, 2);
        InsertDecimalValue(ABS(X20 * 100), 12);
        InsertDecimalValue(ABS(X21 * 100), 12);
        InsertDecimalValue(ABS(X23 * 100), 12);
        InsertDecimalValue(ABS(X22 * 100), 12);
        InsertDecimalValue(ABS(X24 * 100), 12);
        InsertDecimalValue(ABS(X40 * 100), 12);
        InsertDecimalValue(ABS(X61 * 100), 12);
        InsertDecimalValue(ABS(X65 * 100), 12);
        InsertDecimalValue(ABS(X67 * 100), 12);
        InsertDecimalValue(ABS(VATCom * 100), 12);

        FinalSum := ((ROUND(ABS(X20), 0.001, '<') + ROUND(ABS(X21), 0.001, '<') + ROUND(ABS(X23), 0.001, '<') + ROUND(ABS(X22), 0.001, '<') +
                     ROUND(ABS(X24), 0.001, '<') + ROUND(ABS(X61), 0.001, '<') + ROUND(ABS(X65), 0.001, '<') + ROUND(ABS(X67), 0.001, '<')
                     + ROUND(ABS(X40), 0.001, '<') + ABS(VATCom)) * 100);

        InsertDecimalValue(ABS(FinalSum), 12);
        PadLine(Blank);
        EXIT(FinalSum);
    end;

    procedure InsertVATPerDeclDetailIII(X2: Decimal; X6: Decimal; X4: Decimal; X11: Decimal; X17: Decimal; X41: Decimal; X66: Decimal; X68: Decimal; ReqRefund: Boolean; FinalSum: Decimal) ReturnValue: Decimal
    var
        FinalSumII: Decimal;
    begin
        CLEAR(FinalSumII);
        CLEAR(ReturnValue);
        NewLine;
        InsertIntegerValue(6, 2);
        InsertDecimalValue(ABS(X2 * 100), 12);
        InsertDecimalValue(ABS(X6 * 100), 12);
        InsertDecimalValue(ABS(X4 * 100), 12);
        InsertDecimalValue(ABS(X11 * 100), 12);
        InsertDecimalValue(ABS((X41) * 100), 12);
        InsertDecimalValue(ABS(X66 * 100), 12);
        InsertDecimalValue(ABS(X68 * 100), 12);

        InsertDecimalValue((ROUND(ABS(X2), 0.001, '<') + ROUND(ABS(X6), 0.001, '<') + ROUND(ABS(X4), 0.001, '<') + ROUND(ABS(X11), 0.001, '<')
                            + ROUND(ABS(X17), 0.001, '<') + ROUND(ABS(X41), 0.001, '<') + ROUND(ABS(X66), 0.001, '<') + ROUND(ABS(X68), 0.001, '<'
        ))
                            * 100, 12);
        FinalSumII :=
          (ROUND(ABS(X2), 0.001, '<') + ROUND(ABS(X6), 0.001, '<') + ROUND(ABS(X4), 0.001, '<') + ROUND(ABS(X11), 0.001, '<') +
          ROUND(ABS(X17), 0.001, '<') + ROUND(ABS(X41), 0.001, '<') + ROUND(ABS(X66), 0.001, '<') + ROUND(ABS(X68), 0.001, '<')) * 100;

        IF (ABS(FinalSumII) - ABS(FinalSum) > 0) THEN BEGIN
            InsertDecimalValue(ABS(ABS(FinalSumII) - ABS(FinalSum)), 12);
        END ELSE
            InsertDecimalValue(0, 12);

        IF (ABS(FinalSum) - ABS(FinalSumII) > 0) THEN BEGIN
            InsertDecimalValue(ABS(ABS(FinalSum) - ABS(FinalSumII)), 12);
        END ELSE BEGIN
            InsertDecimalValue(0, 12);
        END;

        IF (ReqRefund = TRUE) THEN BEGIN
            IF (ABS(FinalSum) - ABS(FinalSumII) > 0) THEN BEGIN
                InsertDecimalValue(ABS(ABS(FinalSum) - ABS(FinalSumII)), 12);
            END ELSE
                InsertDecimalValue(0, 12);
        END ELSE
            InsertDecimalValue(0, 12);

        PadLine(Blank);
        EXIT(FinalSumII);
    end;

    procedure InsertVATPerDeclDetailIV(LineSixValue: Decimal; X262: Decimal; X263: Decimal; Operation: Boolean; X264: Decimal; FirstDecl: Option " ",Yes,No; StartDateReg: Date; LastDecl: Option " ",Yes,No; EndDateReg: Date; DeclYear: Integer) ReturnValue: Decimal
    begin
        NewLine;
        InsertIntegerValue(7, 2);
        InsertDecimalValue(ABS(LineSixValue), 12);
        ReturnValue := LineSixValue;
        IF DeclYear < 2010 THEN BEGIN
            InsertDecimalValue(ABS(X262 * 100), 12);
            InsertDecimalValue(ABS(X263 * 100), 12);
        END ELSE BEGIN
            InsertDecimalValue(0, 12);
            InsertDecimalValue(0, 12);
        END;

        IF (Operation = TRUE) THEN BEGIN
            InsertIntegerValue(1, 1);
        END ELSE
            InsertIntegerValue(0, 1);

        IF (Operation = FALSE) THEN BEGIN
            InsertIntegerValue(2, 1);
        END ELSE
            InsertIntegerValue(0, 1);
        IF DeclYear < 2010 THEN BEGIN
            IF (Operation = TRUE) THEN BEGIN
                InsertDecimalValue(ABS(X264 * 100), 12);
            END ELSE
                InsertIntegerValue(0, 12);

            IF (FirstDecl = 0) THEN
                FirstDecl := 2;
            IF (LastDecl = 0) THEN
                LastDecl := 2;
            InsertIntegerValue(FirstDecl, 1);
            InsertTextValue(FORMAT(StartDateReg, 0, YearFormat), 8, HeadingZero);
            InsertIntegerValue(LastDecl, 1);
            InsertTextValue(FORMAT(EndDateReg, 0, YearFormat), 8, HeadingZero);
        END ELSE
            InsertIntegerValue(0, 30);
        PadLine(Blank);
        EXIT(ReturnValue);
    end;

    procedure InsertVATPerDeclDetailV(X12: Decimal; X14: Decimal; X15: Decimal; X16: Decimal; X13: Decimal; X17: Decimal; DeclYear: Integer)
    begin
        NewLine;
        InsertIntegerValue(30, 2);
        IF DeclYear < 2010 THEN BEGIN
            InsertDecimalValue(0, 12);
            InsertDecimalValue(0, 12);
            InsertDecimalValue(0, 12);
            InsertDecimalValue(0, 12);
            InsertDecimalValue(0, 12);
            InsertDecimalValue(0, 12);
        END ELSE BEGIN
            InsertDecimalValue(ABS(X12 * 100), 12);
            InsertDecimalValue(ABS(X14 * 100), 12);
            InsertDecimalValue(ABS(X15 * 100), 12);
            InsertDecimalValue(ABS(X16 * 100), 12);
            InsertDecimalValue(ABS((X13) * 100), 12);
            InsertDecimalValue(ABS(X17 * 100), 12);
        END;
        PadLine(Blank);
    end;

    procedure InsertVATPerDeclDetailVI(X97: Decimal; X98: Decimal; X99: Decimal; X100: Decimal; X101: Decimal; X102: Decimal; X103: Decimal; X104: Decimal; DeclYear: Integer)
    begin
        NewLine;
        InsertIntegerValue(31, 2);
        IF DeclYear < 2010 THEN BEGIN
            InsertDecimalValue(0, 12);
            InsertDecimalValue(0, 12);
            InsertDecimalValue(0, 12);
            InsertDecimalValue(0, 12);
            InsertDecimalValue(0, 12);
            InsertDecimalValue(0, 12);
            InsertDecimalValue(0, 12);
            InsertDecimalValue(0, 12);
            InsertDecimalValue(0, 12);
        END ELSE BEGIN
            InsertDecimalValue(ABS(X97 * 100), 12);
            InsertDecimalValue(ABS(X98 * 100), 12);
            InsertDecimalValue(ABS(X99 * 100), 12);
            InsertDecimalValue(ABS(X100 * 100), 12);
            InsertDecimalValue(ABS(X101 * 100), 12);
            InsertDecimalValue(ABS(X102 * 100), 12);
            InsertDecimalValue(ABS(X103 * 100), 12);
            InsertDecimalValue(ABS(X104 * 100), 12);
            InsertDecimalValue((ROUND(ABS(X97), 0.001, '<') + ROUND(ABS(X98), 0.001, '<')
                                + ROUND(ABS(X99), 0.001, '<') + ROUND(ABS(X100), 0.001, '<')
                                + ROUND(ABS(X101), 0.001, '<') + ROUND(ABS(X102), 0.001, '<') + ROUND(ABS(X103), 0.001, '<')
                                + ROUND(ABS(X104), 0.001, '<')) * 100, 12);
        END;
        PadLine(Blank);
    end;

    procedure InsertVATPerDeclTrailer(RegistersNo: Integer; AccountantFiscalNo: Integer; SumAllValues: Decimal)
    begin
        NewLine;
        InsertIntegerValue(8, 2);
        InsertIntegerValue(RegistersNo, 3);
        InsertIntegerValue(AccountantFiscalNo, 9);
        InsertDecimalValue(SumAllValues, 13);
        PadLine(Blank);
    end;

    procedure InsertVATPerDeclAnnexRHeader(AnnexLoc: Option " ",Continent,Azores,Madeira; DeclYear: Integer; PeriodMonth: Option " ",January,February,March,April,May,June,Jule,August,September,October,November,December; PeriodQuarter: Option " ",FirstQuarter,SecondQuarter,ThirdQuarter,FourthQuarter)
    var
        Period: Text[3];
    begin
        CompanyInfo.GET;
        NewLine;
        InsertIntegerValue(9, 2);
        InsertIntegerValue(AnnexLoc, 1);
        InsertTextValue(CompanyInfo."VAT Registration No.", 9, Blank);
        InsertIntegerValue(DeclYear, 4);
        Period := PeriodEquivalence(PeriodMonth, PeriodQuarter);
        InsertTextValue(Period, 3, Blank);
        PadLine(Blank);
    end;

    procedure PeriodEquivalence(PeriodMonth: Option " ",January,February,March,April,May,June,Jule,August,September,October,November,December; PeriodQuarter: Option " ",FirstQuarter,SecondQuarter,ThirdQuarter,FourthQuarter): Text[3]
    var
        period: Text[3];
    begin
        CASE PeriodMonth OF
            PeriodMonth::January:
                BEGIN
                    period := '01 ';
                END;
            PeriodMonth::February:
                BEGIN
                    period := '02 ';
                END;
            PeriodMonth::March:
                BEGIN
                    period := '03 ';
                END;
            PeriodMonth::April:
                BEGIN
                    period := '04 ';
                END;
            PeriodMonth::May:
                BEGIN
                    period := '05 ';
                END;
            PeriodMonth::June:
                BEGIN
                    period := '06 ';
                END;
            PeriodMonth::Jule:
                BEGIN
                    period := '07 ';
                END;
            PeriodMonth::August:
                BEGIN
                    period := '08 ';
                END;
            PeriodMonth::September:
                BEGIN
                    period := '09 ';
                END;
            PeriodMonth::October:
                BEGIN
                    period := '10 ';
                END;
            PeriodMonth::November:
                BEGIN
                    period := '11 ';
                END;
            PeriodMonth::December:
                BEGIN
                    period := '12 ';
                END;
        END;

        CASE PeriodQuarter OF
            PeriodQuarter::FirstQuarter:
                BEGIN
                    period := '03T';
                END;
            PeriodQuarter::SecondQuarter:
                BEGIN
                    period := '06T';
                END;
            PeriodQuarter::ThirdQuarter:
                BEGIN
                    period := '09T';
                END;
            PeriodQuarter::FourthQuarter:
                BEGIN
                    period := '12T';
                END;
        END;
        EXIT(period);
    end;

    procedure InsertVATPerDecAnnexRlDetailI(X1: Decimal; X5: Decimal; X3: Decimal; X7: Decimal; X8: Decimal; X9: Decimal; X10: Decimal; X16: Decimal; AnnexLoc: Option " Continent",Azores,Madeira) ReturnValue: Decimal
    begin
        NewLine;
        InsertIntegerValue(10, 2);
        InsertIntegerValue(AnnexLoc, 1);
        InsertDecimalValue(ABS(X1 * 100), 12);
        InsertDecimalValue(ABS(X5 * 100), 12);
        InsertDecimalValue(ABS(X3 * 100), 12);
        InsertDecimalValue(ROUND(ABS(X7), 1, '<') * 100, 12);
        InsertDecimalValue(ABS(X8 * 100), 12);
        InsertDecimalValue(ABS(X9 * 100), 12);
        InsertDecimalValue(ABS(X10 * 100), 12);


        InsertDecimalValue(
          (ROUND(ABS(X1), 0.001, '<') + ROUND(ABS(X5), 0.001, '<') + ROUND(ABS(X3), 0.001, '<') +
          ROUND(ABS(X7), 1, '<') + ROUND(ABS(X8), 0.001, '<') + ROUND(ABS(X9), 0.001, '<') +
          ROUND(ABS(X10), 0.001, '<') + ROUND(ABS(X16), 0.001, '<')) * 100, 12);

        ReturnValue :=
          (ROUND(ABS(X1), 0.001, '<') + ROUND(ABS(X5), 0.001, '<') + ROUND(ABS(X3), 0.001, '<') +
          ROUND(ABS(X7), 1, '<') + ROUND(ABS(X8), 0.001, '<') + ROUND(ABS(X9), 0.001, '<') +
          ROUND(ABS(X10), 0.001, '<') + ROUND(ABS(X16), 0.001, '<')) * 100;
        PadLine(Blank);
        EXIT(ReturnValue);
    end;

    procedure InsertVATPerDeclAnnexRDetailII(X20: Decimal; X21: Decimal; X23: Decimal; X22: Decimal; X24: Decimal; X2: Decimal; X6: Decimal; X4: Decimal; X11: Decimal; AnnexLoc: Option " ",Continent,Azores,Madeira): Decimal
    var
        ReturnValue: Decimal;
    begin
        NewLine;
        InsertIntegerValue(11, 2);
        InsertIntegerValue(AnnexLoc, 1);
        InsertDecimalValue(ABS(X20 * 100), 12);
        InsertDecimalValue(ABS(X21 * 100), 12);
        InsertDecimalValue(ABS(X23 * 100), 12);
        InsertDecimalValue(ABS(X22 * 100), 12);
        InsertDecimalValue(ABS(X24 * 100), 12);

        InsertDecimalValue((ROUND(ABS(X20), 0.001, '<') + ROUND(ABS(X21), 0.001, '<') + ROUND(ABS(X23), 0.001, '<') + ROUND(ABS(X22), 0.001, '<')
                            + ROUND(ABS(X24), 0.001, '<')) * 100, 12);

        InsertDecimalValue(ABS(X2 * 100), 12);
        InsertDecimalValue(ABS(X6 * 100), 12);
        InsertDecimalValue(ABS(X4 * 100), 12);
        InsertDecimalValue(ABS(X11 * 100), 12);

        ReturnValue := (ROUND(ABS(X20), 0.001, '<') + ROUND(ABS(X21), 0.001, '<') + ROUND(ABS(X23), 0.001, '<') + ROUND(ABS(X22), 0.001, '<')
                        + ROUND(ABS(X24), 0.001, '<')) * 100;

        PadLine(Blank);
        EXIT(ReturnValue);
    end;

    procedure InsertVATPerDeclAnexRDetailIII(AnnexLoc: Option " ",Continent,Azores,Madeira; X2: Decimal; X6: Decimal; X4: Decimal; X11: Decimal; X17: Decimal; Operation: Boolean; X264: Decimal; DeclYear: Integer) ReturnValue: Integer
    begin
        NewLine;
        InsertIntegerValue(12, 2);
        InsertIntegerValue(AnnexLoc, 1);

        InsertDecimalValue(
          (ROUND(ABS(X2), 0.001, '<') + ROUND(ABS(X6), 0.001, '<') + ROUND(ABS(X4), 0.001, '<') +
          ROUND(ABS(X11), 0.001, '<') + ROUND(ABS(X17), 0.001, '<')) * 100, 12);

        ReturnValue :=
          (ROUND(ABS(X2), 0.001, '<') + ROUND(ABS(X6), 0.001, '<') + ROUND(ABS(X4), 0.001, '<') + ROUND(ABS(X11), 0.001, '<')
          + ROUND(ABS(X17), 0.001, '<')) * 100;

        IF (Operation = TRUE) THEN BEGIN
            InsertIntegerValue(1, 1);
        END ELSE
            InsertIntegerValue(0, 1);

        IF (Operation = FALSE) THEN BEGIN
            InsertIntegerValue(2, 1);
        END ELSE
            InsertIntegerValue(0, 1);
        IF Operation AND (DeclYear < 2010) THEN
            InsertDecimalValue(ABS(X264 * 100), 12)
        ELSE
            InsertIntegerValue(0, 12);

        PadLine(Blank);
        EXIT(ReturnValue);
    end;

    procedure InsertVATPerDeclAnnexRDetailIV(X12: Decimal; X14: Decimal; X15: Decimal; X16: Decimal; X13: Decimal; X17: Decimal; AnnexLoc: Option " ",Continent,Azores,Madeira; DeclYear: Integer): Decimal
    var
        ReturnValue: Decimal;
    begin
        NewLine;
        InsertIntegerValue(32, 2);
        InsertIntegerValue(AnnexLoc, 1);
        IF DeclYear < 2010 THEN BEGIN
            InsertDecimalValue(0, 12);
            InsertDecimalValue(0, 12);
            InsertDecimalValue(0, 12);
            InsertDecimalValue(0, 12);
            InsertDecimalValue(0, 12);
            InsertDecimalValue(0, 12);
        END ELSE BEGIN
            InsertDecimalValue(ABS(X12 * 100), 12);
            InsertDecimalValue(ABS(X14 * 100), 12);
            InsertDecimalValue(ABS(X15 * 100), 12);
            InsertDecimalValue(ABS(X16 * 100), 12);
            InsertDecimalValue(ABS(X13 * 100), 12);
            InsertDecimalValue(ABS(X17 * 100), 12);
        END;
        PadLine(Blank);
    end;

    procedure InsertVATPerDeclAnnexRDetailV(X65: Decimal; X66: Decimal; X67: Decimal; X68: Decimal; X69: Decimal; X70: Decimal; X71: Decimal; X72: Decimal; X73: Decimal; AnnexLoc: Option " ",Continent,Azores,Madeira; DeclYear: Integer): Decimal
    var
        ReturnValue: Decimal;
    begin
        NewLine;
        InsertIntegerValue(33, 2);
        InsertIntegerValue(AnnexLoc, 1);
        IF DeclYear < 2010 THEN BEGIN
            InsertDecimalValue(0, 12);
            InsertDecimalValue(0, 12);
            InsertDecimalValue(0, 12);
            InsertDecimalValue(0, 12);
            InsertDecimalValue(0, 12);
            InsertDecimalValue(0, 12);
            InsertDecimalValue(0, 12);
            InsertDecimalValue(0, 12);
            InsertDecimalValue(0, 12);
        END ELSE BEGIN
            InsertDecimalValue(ABS(X65 * 100), 12);
            InsertDecimalValue(ABS(X66 * 100), 12);
            InsertDecimalValue(ABS(X67 * 100), 12);
            InsertDecimalValue(ABS(X68 * 100), 12);
            InsertDecimalValue(ABS(X69 * 100), 12);
            InsertDecimalValue(ABS(X70 * 100), 12);
            InsertDecimalValue(ABS(X71 * 100), 12);
            InsertDecimalValue(ABS(X72 * 100), 12);
            InsertDecimalValue((ROUND(ABS(X65), 0.001, '<') + ROUND(ABS(X66), 0.001, '<')
                                + ROUND(ABS(X67), 0.001, '<') + ROUND(ABS(X68), 0.001, '<')
                                + ROUND(ABS(X69), 0.001, '<') + ROUND(ABS(X70), 0.001, '<')
                                + ROUND(ABS(X71), 0.001, '<') + ROUND(ABS(X72), 0.001, '<'))
                                * 100, 12);
        END;
        PadLine(Blank);
    end;

    procedure InsertVATPerDeclAnnexTrailer(AnnexLoc: Option " Continent",Azores,Madeira; RegistersNo: Integer; "Sum": Integer)
    begin
        NewLine;
        InsertIntegerValue(13, 2);
        InsertIntegerValue(AnnexLoc, 1);
        InsertIntegerValue(RegistersNo, 3);
        InsertDecimalValue(Sum, 13);
        PadLine(Blank);
    end;

    procedure InsertVATDecalrationTrailer(Number: Integer)
    begin
        NewLine;
        InsertIntegerValue(98, 2);
        InsertDecimalValue(Number, 9);
        PadLine(Blank);
    end;

    procedure InsertVATPerDeclFileTrailer(Number: Integer)
    begin
        NewLine;
        InsertIntegerValue(99, 2);
        InsertDecimalValue(Number, 9);
        PadLine(Blank);
    end;

    procedure InsertVATPerDeclAnnexIHeader(DeclYear: Integer; PeriodMonth: Option " ",January,February,March,April,May,June,Jule,August,September,Ovtober,Nobember,December; PeriodQuarter: Option " FirstQuarter",SecondQuarter,ThirdQuarter,FourthQuarter)
    var
        Period: Text[3];
    begin
        CompanyInfo.GET;
        NewLine;
        InsertIntegerValue(20, 2);
        InsertTextValue(CompanyInfo."VAT Registration No.", 9, Blank);
        InsertIntegerValue(DeclYear, 4);
        Period := PeriodEquivalence(PeriodMonth, PeriodQuarter);
        InsertTextValue(Period, 3, Blank);
        PadLine(Blank);
    end;

    procedure InsertVATPerDeclAnnexDetail(CustomerNo: Text[30]; Amount: Decimal; Type: Option "1","4"; LineNumber: Integer; CountryCode: Text[2]; VATRegistrationNo: Text[12])
    var
        Sign: Text[1];
    begin
        NewLine;
        InsertIntegerValue(21, 2);
        InsertIntegerValue(LineNumber, 5);
        InsertTextValue(CountryCode, 2, Blank);
        InsertTextValue(VATRegistrationNo, 12, Blank);
        Sign := DefineSign(Amount);
        InsertTextValue(Sign, 1, Blank);
        InsertIntegerValue(ABS(ROUND(Amount, 1, '<') * 100), 12);
        InsertIntegerValue(Type, 1);
        PadLine(Blank);
    end;

    procedure InsertVATPerDeclAnnexITrailer(LineNumber: Integer; "Sum": Decimal; Transport: Integer)
    var
        Sign: Text[1];
    begin
        NewLine;
        InsertIntegerValue(22, 2);
        InsertIntegerValue(LineNumber, 5);
        Sign := DefineSign(Sum);
        InsertTextValue(Sign, 1, Blank);
        InsertDecimalValue(Sum * 100, 12);
        Sign := DefineSign(Transport);
        InsertTextValue(Sign, 1, Blank);
        InsertIntegerValue(ROUND(Transport, 1, '<') * 100, 12);
        PadLine(Blank);
    end;

    procedure InsertVATPerDeclAnnexCEHeader(DeclYear: Integer; PeriodMonth: Option " ",January,February,March,April,May,June,July,August,September,October,November,December; PeriodQuarter: Option " FirstQuarter",SecondQuarter,ThirdQuarter,FourthQuarter; AnnexDeclYear: Integer; AnnexPeriodMonth: Option " ",January,February,March,April,May,June,July,August,September,October,November,December; AnnexPeriodQuarter: Option " FirstQuarter",SecondQuarter,ThirdQuarter,FourthQuarter)
    var
        Period: Text[3];
    begin
        CompanyInfo.GET;
        NewLine;
        InsertIntegerValue(40, 2);
        InsertIntegerValue(AnnexDeclYear, 4);
        Period := PeriodEquivalence(AnnexPeriodMonth, AnnexPeriodQuarter);
        InsertTextValue(Period, 3, Blank);
        InsertTextValue(CompanyInfo."VAT Registration No.", 9, Blank);
        InsertIntegerValue(DeclYear, 4);
        Period := PeriodEquivalence(PeriodMonth, PeriodQuarter);
        InsertTextValue(Period, 3, Blank);
        PadLine(Blank);
    end;

    procedure InsertVATPerDeclAnnexCEDetail(DeclType: Integer; DeclYear: Integer; DeclMonth: Integer; DeclQuarter: Integer; LineNumber: Integer; VATRegistrationNo: Text[20]; Amount: Decimal)
    var
        Sign: Text[1];
        Period: Text[3];
    begin
        NewLine;
        InsertIntegerValue(DeclType, 2);
        InsertIntegerValue(DeclYear, 4);
        Period := PeriodEquivalence(DeclMonth, DeclQuarter);
        InsertTextValue(Period, 3, Blank);
        InsertIntegerValue(LineNumber, 5);
        IF DeclType = 41 THEN
            InsertTextValue(VATRegistrationNo, 9, HeadingZero)
        ELSE
            InsertTextValue(VATRegistrationNo, 20, Blank);
        InsertIntegerValue(ABS(ROUND(Amount * 100, 1, '<')), 12);
        PadLine(Blank);
    end;

    procedure InsertVATPerDeclAnnexCETrailer(DeclYear: Integer; DeclMonth: Integer; DeclQuarter: Integer; RegistersNumber: Integer; CustRelLowValueOpBase: Decimal; ForeignOps: Decimal; OtherOps: Decimal; Totals: Decimal)
    var
        Period: Text[3];
    begin
        NewLine;
        InsertIntegerValue(49, 2);
        InsertIntegerValue(DeclYear, 4);
        Period := PeriodEquivalence(DeclMonth, DeclQuarter);
        InsertTextValue(Period, 3, Blank);
        InsertIntegerValue(RegistersNumber, 9);
        InsertDecimalValue(CustRelLowValueOpBase * 100, 12);
        InsertDecimalValue(ForeignOps * 100, 12);
        InsertDecimalValue(OtherOps * 100, 12);
        InsertDecimalValue(Totals * 100, 14);
        PadLine(Blank);
    end;

    procedure InsertVATPerDeclAnnexVEHeader(DeclYear: Integer; PeriodMonth: Option " ",January,February,March,April,May,June,July,August,September,October,November,December; PeriodQuarter: Option " FirstQuarter",SecondQuarter,ThirdQuarter,FourthQuarter; AnnexDeclYear: Integer; AnnexPeriodMonth: Option " ",January,February,March,April,May,June,July,August,September,October,November,December; AnnexPeriodQuarter: Option " FirstQuarter",SecondQuarter,ThirdQuarter,FourthQuarter)
    var
        Period: Text[3];
    begin
        CompanyInfo.GET;
        NewLine;
        InsertIntegerValue(50, 2);
        InsertIntegerValue(AnnexDeclYear, 4);
        Period := PeriodEquivalence(AnnexPeriodMonth, AnnexPeriodQuarter);
        InsertTextValue(Period, 3, Blank);
        InsertTextValue(CompanyInfo."VAT Registration No.", 9, Blank);
        InsertIntegerValue(DeclYear, 4);
        Period := PeriodEquivalence(PeriodMonth, PeriodQuarter);
        InsertTextValue(Period, 3, Blank);
        PadLine(Blank);
    end;

    procedure InsertVATPerDeclAnnexVEDetail(DeclType: Integer; DeclYear: Integer; DeclMonth: Integer; DeclQuarter: Integer; LineNumber: Integer; CountryCode: Text[2]; VATRegistrationNo: Text[20]; DocumentNo: Text[20]; DocumentDate: Date; Base: Decimal; VATAmount: Decimal)
    var
        Sign: Text[1];
        Period: Text[3];
    begin
        NewLine;
        InsertIntegerValue(DeclType, 2);
        InsertIntegerValue(DeclYear, 4);
        Period := PeriodEquivalence(DeclMonth, DeclQuarter);
        InsertTextValue(Period, 3, Blank);
        InsertIntegerValue(LineNumber, 5);
        InsertTextValue(CountryCode, 2, Blank);
        InsertTextValue(VATRegistrationNo, 12, Blank);
        InsertTextValue(DocumentNo, 14, '0');
        InsertIntegerValue(DATE2DMY(DocumentDate, 3), 4);
        InsertIntegerValue(DATE2DMY(DocumentDate, 2), 2);
        InsertIntegerValue(ABS(ROUND(Base * 100, 1, '<')), 12);
        InsertIntegerValue(ABS(ROUND(VATAmount * 100, 1, '<')), 12);
        PadLine(Blank);
    end;

    procedure InsertVATPerDeclAnnexVETrailer(DeclYear: Integer; DeclMonth: Integer; DeclQuarter: Integer; RegistersNumber: Integer; VendRelLowValueOpBase: Decimal; VendRelLowValueOpAmount: Decimal; TotalsBase: Decimal; TotalsVATAmount: Decimal)
    var
        Period: Text[3];
    begin
        NewLine;
        InsertIntegerValue(59, 2);
        InsertIntegerValue(DeclYear, 4);
        Period := PeriodEquivalence(DeclMonth, DeclQuarter);
        InsertTextValue(Period, 3, Blank);
        InsertIntegerValue(RegistersNumber, 9);
        InsertDecimalValue(VendRelLowValueOpBase * 100, 12);
        InsertDecimalValue(VendRelLowValueOpAmount * 100, 12);
        InsertDecimalValue(TotalsBase * 100, 14);
        InsertDecimalValue(TotalsVATAmount * 100, 14);
        PadLine(Blank);
    end;

    procedure InsertVATPerDeclAnnexRVHeader(DeclYear: Integer; PeriodMonth: Option " ",January,February,March,April,May,June,July,August,September,October,November,December; PeriodQuarter: Option " FirstQuarter",SecondQuarter,ThirdQuarter,FourthQuarter; AnnexDeclYear: Integer; AnnexPeriodMonth: Option " ",January,February,March,April,May,June,July,August,September,October,November,December; AnnexPeriodQuarter: Option " FirstQuarter",SecondQuarter,ThirdQuarter,FourthQuarter)
    var
        Period: Text[3];
    begin
        CompanyInfo.GET;
        NewLine;
        InsertIntegerValue(70, 2);
        InsertIntegerValue(AnnexDeclYear, 4);
        Period := PeriodEquivalence(AnnexPeriodMonth, AnnexPeriodQuarter);
        InsertTextValue(Period, 3, Blank);
        InsertTextValue(CompanyInfo."VAT Registration No.", 9, Blank);
        InsertIntegerValue(DeclYear, 4);
        Period := PeriodEquivalence(PeriodMonth, PeriodQuarter);
        InsertTextValue(Period, 3, Blank);
        PadLine(Blank);
    end;

    procedure InsertVATPerDeclAnnexRVDetail(DeclType: Integer; DeclYear: Integer; DeclMonth: Integer; DeclQuarter: Integer; LineNumber: Integer; VATRegistrationNo: Text[20]; DocumentDate: Date; Base: Decimal; VATAmount: Decimal)
    var
        Sign: Text[1];
        Period: Text[3];
    begin
        NewLine;
        InsertIntegerValue(DeclType, 2);
        InsertIntegerValue(DeclYear, 4);
        Period := PeriodEquivalence(DeclMonth, DeclQuarter);
        InsertTextValue(Period, 3, Blank);
        InsertIntegerValue(LineNumber, 5);
        InsertTextValue(VATRegistrationNo, 9, HeadingZero);
        InsertIntegerValue(DATE2DMY(DocumentDate, 3), 4);
        InsertIntegerValue(DATE2DMY(DocumentDate, 2), 2);
        InsertIntegerValue(ABS(ROUND(Base * 100, 1, '<')), 12);
        InsertIntegerValue(ABS(ROUND(VATAmount * 100, 1, '<')), 12);
        PadLine(Blank);
    end;

    procedure InsertVATPerDeclAnnexRVTrailer(DeclYear: Integer; DeclMonth: Integer; DeclQuarter: Integer; RegistersNumber: Integer; RegularLowValueOpBase: Decimal; RegularLowValueOpAmount: Decimal; ProRataBase: Decimal; ProRataAmount: Decimal; OtherBase: Decimal; OtherAmount: Decimal; TotalsBase: Decimal; TotalsVATAmount: Decimal)
    var
        Period: Text[3];
    begin
        NewLine;
        InsertIntegerValue(79, 2);
        InsertIntegerValue(DeclYear, 4);
        Period := PeriodEquivalence(DeclMonth, DeclQuarter);
        InsertTextValue(Period, 3, Blank);
        InsertIntegerValue(RegistersNumber, 9);
        InsertDecimalValue(RegularLowValueOpBase * 100, 12);
        InsertDecimalValue(RegularLowValueOpAmount * 100, 12);
        InsertDecimalValue(ProRataBase * 100, 12);
        InsertDecimalValue(ProRataAmount * 100, 12);
        InsertDecimalValue(OtherBase * 100, 12);
        InsertDecimalValue(OtherAmount * 100, 12);
        InsertDecimalValue(TotalsBase * 100, 14);
        InsertDecimalValue(TotalsVATAmount * 100, 14);
        PadLine(Blank);
    end;

    procedure DefineSign(Value: Decimal): Text[30]
    begin
        IF (Value < 0) THEN
            EXIT('-')
        ELSE
            EXIT('+');
    end;

    procedure GiveInvertedSign(Value: Decimal): Text[30]
    begin
        IF (Value > 0) THEN
            EXIT('-')
        ELSE
            EXIT('+');
    end;

    procedure InsertDecimalValue(Value: Decimal; Size: Integer)
    begin
        FINDLAST;
        "Line Value" := "Line Value" + CONVERTSTR(FORMAT(ROUND(Value, 1, '<'), Size, 1), Blank, HeadingZero);
        MODIFY;
    end;

    procedure InsertMod22FileHeader(FileDate: Date)
    begin
        NewLine;
        InsertIntegerValue(1, 2);
        InsertTextValue(EncodingType, 5, Blank);
        InsertIntegerValue(11, 2);
        InsertTextValue(FORMAT(FileDate, 0, YearFormat), 8, Blank);
        PadLine(Blank);
    end;

    procedure InsertMod22DeclarationHeader(StartDate: Date; EndDate: Date; Year: Integer)
    var
        FileDate: Date;
        GLSetup: Record "General Ledger Setup";
    begin
        CompanyInfo.GET;
        GLSetup.GET;
        NewLine;
        InsertIntegerValue(2, 2);
        InsertTextValue(MODText, 6, Blank);
        InsertTextValue(CompanyInfo."VAT Registration No.", 9, Blank);
        InsertTextValue(FORMAT(StartDate, 0, YearFormat), 8, Blank);
        InsertTextValue(FORMAT(EndDate, 0, YearFormat), 8, Blank);
        InsertIntegerValue(Year, 4);
        InsertTextValue(GLSetup."LCY Code", 3, Blank);
        PadLine(Blank);
    end;

    procedure InsertMod22Header(TaxAuth: Code[4]; VATRegNo: Text[20]; LegalRepFisc: Text[20]; AccFiscNo: Text[20]; AnexA: Boolean; AnexB: Boolean; AnexC: Boolean)
    begin
        NewLine;
        InsertIntegerValue(3, 2);
        InsertTextValue(FORMAT(TaxAuth), 4, Blank);
        InsertTextValue(HeadingZero, 8, HeadingZero);
        InsertTextValue(HeadingZero, 9, HeadingZero);
        InsertTextValue(HeadingZero, 33, HeadingZero);
        IF AnexA THEN
            InsertIntegerValue(1, 1)
        ELSE
            InsertIntegerValue(0, 1);
        IF AnexB THEN
            InsertIntegerValue(2, 1)
        ELSE
            InsertIntegerValue(0, 1);
        IF AnexC THEN
            InsertIntegerValue(3, 1)
        ELSE
            InsertIntegerValue(0, 1);
        InsertTextValue(LegalRepFisc, 9, Blank);
        InsertTextValue(AccFiscNo, 9, Blank);
        PadLine(Blank);
    end;

    procedure InsertSign(Sign: Boolean)
    var
        NegSign: Label '-';
        PosSign: Label '+';
    begin
        FINDLAST;
        IF Sign THEN
            "Line Value" := "Line Value" + PosSign
        ELSE
            "Line Value" := "Line Value" + NegSign;
        MODIFY;
    end;

    procedure InsertDet04(Values: array[23] of Decimal)
    var
        I: Integer;
    begin
        NewLine;
        InsertIntegerValue(4, 2);

        FOR I := 1 TO 11 DO BEGIN
            IF (I = 1) THEN
                IF COPYSTR(FORMAT(Values[I]), 1, 1) = '-' THEN
                    InsertSign(FALSE)
                ELSE
                    InsertSign(TRUE);
            IF (I = 4) THEN BEGIN
                InsertSign(TRUE);
                InsertIntegerValue(0, 14);
            END;
            InsertDecimalValue(ABS(Values[I]) * 100, 12)
        END;
        PadLine(Blank);
    end;

    procedure InsertDet05(Values: array[23] of Decimal)
    var
        I: Integer;
    begin
        NewLine;
        InsertIntegerValue(5, 2);

        FOR I := 1 TO 14 DO
            InsertDecimalValue(ABS(Values[I]) * 100, 12);
        PadLine(Blank);
    end;

    procedure InsertDet06(Values: array[23] of Decimal)
    var
        I: Integer;
    begin
        NewLine;
        InsertIntegerValue(6, 2);

        FOR I := 1 TO 12 DO BEGIN
            InsertDecimalValue(ABS(Values[I]) * 100, 12);
            IF I = 8 THEN BEGIN
                InsertSign(TRUE);
                InsertIntegerValue(0, 14);
            END;
        END;
        PadLine(Blank);
    end;

    procedure InsertDet07(Values: array[23] of Decimal)
    var
        I: Integer;
    begin
        NewLine;
        InsertIntegerValue(7, 2);

        FOR I := 1 TO 10 DO
            InsertDecimalValue(ABS(Values[I]) * 100, 12);
        InsertIntegerValue(0, 28);
        InsertTextValue(Blank, 14, Blank);
        PadLine(Blank);
    end;

    procedure InsertDet08(Values: array[23] of Decimal)
    var
        I: Integer;
    begin
        NewLine;
        InsertIntegerValue(8, 2);

        InsertTextValue(HeadingZero, 13, HeadingZero);
        FOR I := 1 TO 12 DO BEGIN
            IF ((I = 2) OR (I = 12)) AND (Values[I] = 0) THEN
                InsertTextValue(Blank, 12, Blank)
            ELSE
                InsertDecimalValue(ABS(Values[I]) * 100, 12);
            IF (I = 10) THEN
                InsertTextValue(Blank, 12, Blank)
        END;
        PadLine(Blank);
    end;

    procedure InsertDet09(Values: array[23] of Decimal)
    var
        I: Integer;
    begin
        NewLine;
        InsertIntegerValue(9, 2);

        FOR I := 1 TO 13 DO BEGIN
            IF (I = 10) AND (Values[I] = 0) THEN
                InsertTextValue(Blank, 12, Blank)
            ELSE
                InsertDecimalValue(ABS(Values[I]) * 100, 12);
            IF (I = 8) THEN
                InsertTextValue(Blank, 12, Blank);
        END;
        PadLine(Blank);
    end;

    procedure InsertDet10(Values: array[23] of Decimal; ShowBlank: array[23] of Boolean)
    var
        I: Integer;
    begin
        NewLine;
        InsertIntegerValue(10, 2);

        FOR I := 1 TO 10 DO BEGIN
            IF (I = 6) OR (I = 8) THEN
                IF COPYSTR(FORMAT(Values[I]), 1, 1) = '-' THEN
                    InsertSign(FALSE)
                ELSE
                    InsertSign(TRUE);
            IF (I = 9) THEN
                InsertTextValue(Blank, 14, Blank);
            InsertDecimalValue(ABS(Values[I]) * 100, 12);
            IF (I = 5) THEN BEGIN
                InsertTextValue(Blank, 12, Blank);
                InsertIntegerValue(0, 14);
            END;
        END;
        PadLine(Blank);
    end;

    procedure InsertDet11(Values: array[23] of Decimal)
    var
        I: Integer;
    begin
        NewLine;
        InsertIntegerValue(11, 2);

        FOR I := 1 TO 8 DO
            IF (I = 4) THEN BEGIN
                InsertDecimalValue(ABS(Values[I]) * 100, 12);
                InsertIntegerValue(0, 65);
            END ELSE
                InsertDecimalValue(ABS(Values[I]) * 100, 12);
        PadLine(Blank);
    end;

    procedure InsertDet12(Values: array[23] of Decimal)
    var
        I: Integer;
    begin
        NewLine;
        InsertIntegerValue(12, 2);

        FOR I := 1 TO 9 DO BEGIN
            IF (I = 2) THEN
                InsertDecimalValue(ABS(Values[I]) * 100, 14)
            ELSE
                InsertDecimalValue(ABS(Values[I]) * 100, 12);
            IF (I = 1) OR (I = 4) THEN
                InsertIntegerValue(0, 28);
        END;
        PadLine(Blank);
    end;

    procedure InsertDet13(Values: array[23] of Decimal; AnnexBselected: Boolean; ShowBlank: array[23] of Boolean)
    var
        I: Integer;
    begin
        NewLine;
        InsertIntegerValue(13, 2);

        IF AnnexBselected THEN BEGIN
            FOR I := 1 TO 10 DO BEGIN
                IF (I = 1) THEN
                    InsertIntegerValue(0, 28);
                InsertDecimalValue(ABS(Values[I]) * 100, 12);
                IF (I = 9) THEN
                    InsertIntegerValue(0, 12);
            END;
        END ELSE
            InsertIntegerValue(0, 160);
        PadLine(Blank);
    end;

    procedure InsertDet14(Values: array[23] of Decimal)
    var
        I: Integer;
    begin
        NewLine;
        InsertIntegerValue(14, 2);

        FOR I := 1 TO 8 DO
            InsertDecimalValue(ABS(Values[I]) * 100, 12);
        PadLine(Blank);
    end;

    procedure InsertDet15(Values: array[23] of Decimal)
    var
        I: Integer;
    begin
        NewLine;
        InsertIntegerValue(15, 2);

        FOR I := 1 TO 14 DO BEGIN
            IF I = 14 THEN
                InsertDecimalValue(ABS(Values[I]) * 100, 8)
            ELSE
                InsertDecimalValue(ABS(Values[I]) * 100, 12);
        END;
        PadLine(Blank);
    end;

    procedure InsertMod22Trailer(ExistDetail: Boolean)
    begin
        NewLine;
        InsertIntegerValue(39, 2);

        InsertIntegerValue(12, 3);
        InsertTextValue(HeadingZero, 15, HeadingZero);
        InsertSign(TRUE);
        InsertIntegerValue(0, 14);
        PadLine(Blank);
    end;

    procedure InsertAnexAHeader(Year: Integer)
    begin
        CompanyInfo.GET;
        NewLine;
        InsertIntegerValue(40, 2);

        InsertTextValue(CompanyInfo."VAT Registration No.", 9, Blank);
        InsertIntegerValue(Year, 4);
        PadLine(Blank);
    end;

    procedure InsertAnexADet01(SalarMass: Decimal; Tax: Decimal; Product: Decimal; LineNo: Integer)
    var
        Munic: Record "PTSS Municipalities";
    begin
        CompanyInfo.GET;
        NewLine;
        InsertIntegerValue(41, 2);

        InsertIntegerValue(LineNo, 3);
        InsertTextValue(FORMAT(CompanyInfo."PTSS Municipality"), 4, Blank);
        IF LineNo = 0 THEN
            InsertTextValue(Blank, 28, Blank)
        ELSE BEGIN
            InsertDecimalValue(SalarMass * 100, 12);
            InsertDecimalValue(Tax * 100, 4);
            InsertDecimalValue(Product * 100, 12);
        END;

        PadLine(Blank);
    end;

    procedure InsertAnexATrailer(TotalSM: Decimal; TotalProd: Decimal; NoOfRegsMunic: Integer)
    begin
        NewLine;
        InsertIntegerValue(49, 2);

        InsertIntegerValue(NoOfRegsMunic, 3);
        InsertDecimalValue(TotalSM * 100, 12);
        InsertDecimalValue(TotalProd * 100, 12);
        InsertIntegerValue(0, 16);
        InsertTextValue(Blank, 4, Blank);
        InsertIntegerValue(0, 12);
        PadLine(Blank);
    end;

    procedure InsertAnexBHeader(Year: Integer)
    begin
        CompanyInfo.GET;
        NewLine;
        InsertIntegerValue(60, 2);

        InsertTextValue(CompanyInfo."VAT Registration No.", 9, Blank);
        InsertIntegerValue(Year, 4);
        PadLine(Blank);
    end;

    procedure InsertAnexBDet01(Values: array[23] of Decimal; ShowBlank: array[23] of Boolean)
    var
        I: Integer;
    begin
        NewLine;
        InsertIntegerValue(61, 2);

        FOR I := 1 TO 5 DO
            IF ShowBlank[I] THEN
                InsertTextValue(Blank, 12, Blank)
            ELSE
                InsertDecimalValue(ABS(Values[I]) * 100, 12);
        InsertTextValue(Blank, 88, Blank);
        PadLine(Blank);
    end;

    procedure InsertAnexBDet02(Values: array[23] of Decimal; ShowBlank: array[23] of Boolean)
    var
        I: Integer;
    begin
        NewLine;
        InsertIntegerValue(62, 2);

        FOR I := 1 TO 3 DO
            IF ShowBlank[I] THEN
                InsertTextValue(Blank, 12, Blank)
            ELSE
                InsertDecimalValue(ABS(Values[I]) * 100, 12);
        InsertTextValue(Blank, 36, Blank);
        PadLine(Blank);
    end;

    procedure InsertAnexBTrailer()
    begin
        NewLine;
        InsertIntegerValue(69, 2);

        InsertTextValue(Blank, 14, Blank);
        PadLine(Blank);
    end;

    procedure InsertAnexCHeader(Year: Integer)
    begin
        CompanyInfo.GET;
        NewLine;
        InsertIntegerValue(70, 2);

        InsertTextValue(CompanyInfo."VAT Registration No.", 9, Blank);
        InsertIntegerValue(Year, 4);
        PadLine(Blank);
    end;

    procedure InsertAnexCDet01(Values: array[23] of Decimal; ShowBlank: array[23] of Boolean; var TotalVolume: Decimal)
    var
        I: Integer;
    begin
        CompanyInfo.GET;
        NewLine;
        InsertIntegerValue(71, 2);

        TotalVolume := 0;
        FOR I := 1 TO 13 DO BEGIN
            IF ShowBlank[I] THEN
                InsertTextValue(Blank, 12, Blank)
            ELSE
                InsertDecimalValue(ABS(Values[I]) * 100, 12);
            IF I = 3 THEN
                InsertTextValue(Blank, 6, Blank);
            IF I = 6 THEN
                InsertTextValue(Blank, 3, Blank);
            IF I IN [1, 2, 3] THEN
                TotalVolume := TotalVolume + Values[I];
        END;
        PadLine(Blank);
    end;

    procedure InsertAnexCDet02(Values: array[23] of Decimal; ShowBlank: array[23] of Boolean; TotalVolume: Decimal)
    var
        I: Integer;
    begin
        NewLine;
        InsertIntegerValue(72, 2);

        FOR I := 1 TO 5 DO
            IF ShowBlank[I] THEN
                InsertTextValue(Blank, 12, Blank)
            ELSE
                InsertDecimalValue(ABS(Values[I]) * 100, 12);

        PadLine(Blank);
        InsertAnexCTrailer(TotalVolume);
    end;

    procedure InsertAnexCTrailer(TotalVol: Decimal)
    begin
        NewLine;
        InsertIntegerValue(79, 2);

        IF TotalVol = 0 THEN
            InsertTextValue(Blank, 14, Blank)
        ELSE
            InsertDecimalValue(ABS(TotalVol) * 100, 14);
        PadLine(Blank);
    end;

    procedure InsertMod22DeclarationTrailer()
    begin
        NewLine;
        InsertIntegerValue(88, 2);

        InsertTextValue(HeadingZero, 1, HeadingZero);
        InsertIntegerValue(COUNT - 3, 2);
        PadLine(Blank);

        NewLine;
        InsertIntegerValue(99, 2);
        InsertTextValue(HeadingZero, 1, HeadingZero);
        InsertIntegerValue(COUNT - 2, 2);
        PadLine(Blank);
    end;

    procedure InsertECFileHeader(FileDate: Date)
    begin
        NewLine;
        InsertIntegerValue(1, 2);
        InsertTextValue(EncodingType, 5, Blank);
        InsertIntegerValue(1, 2);
        InsertTextValue(FORMAT(FileDate, 0, YearFormat), 8, Blank);
        PadLinetill134Characters(Blank);
    end;

    procedure InsertECDeclarationHeader(DeclYear: Integer; Month: Option; Quarter: Option; LastMonthInQuarter: Option)
    var
        MonthText: Text[30];
    begin
        CompanyInfo.GET;
        NewLine;
        InsertIntegerValue(2, 2);
        InsertTextValue(DRECAText, 5, Blank);
        InsertTextValue(CompanyInfo."VAT Registration No.", 9, Blank);
        InsertIntegerValue(DeclYear, 4);
        IF Month > 0 THEN BEGIN
            IF Month < 10 THEN
                MonthText := '0' + FORMAT(Month)
            ELSE
                MonthText := FORMAT(Month);
            InsertTextValue(MonthText, 3, Blank);
        END ELSE BEGIN
            CASE Quarter OF
                1:
                    InsertTextValue(FirstQuarterText, 3, Blank);
                2:
                    InsertTextValue(SecondQuarterText, 3, Blank);
                3:
                    InsertTextValue(ThirdQuarterText, 3, Blank);
                4:
                    InsertTextValue(FourthQuarterText, 3, Blank);
            END;
            IF LastMonthInQuarter = 0 THEN
                InsertTextValue(Blank, 2, Blank)
            ELSE
                InsertTextValue('0' + FORMAT((3 * Quarter - 3) + LastMonthInQuarter - (LastMonthInQuarter DIV 2)), 2, Blank);
            IF LastMonthInQuarter = 2 THEN
                InsertTextValue('0' + FORMAT((3 * Quarter - 3) + LastMonthInQuarter), 2, Blank)
            ELSE
                InsertTextValue(Blank, 2, Blank);
        END;

        PadLinetill134Characters(Blank);
    end;

    procedure InsertRecapDeclarationHeader(TypeOfDeclaration: Integer; FirstDeclPeriodChange: Option; ReplacemntDeclPrdChng: Boolean; MonthlyAmntReplPrvQAmt: Option; InexistOperations: Boolean; Others: Boolean)
    var
        i: Integer;
        Period: Text[3];
    begin
        NewLine;
        InsertIntegerValue(3, 2);
        InsertIntegerValue(TypeOfDeclaration, 1);
        InsertIntegerValue(FirstDeclPeriodChange, 1);
        IF ReplacemntDeclPrdChng THEN
            InsertIntegerValue(1, 1)
        ELSE
            InsertIntegerValue(0, 1);
        InsertIntegerValue(MonthlyAmntReplPrvQAmt, 1);
        IF InexistOperations THEN
            InsertIntegerValue(1, 1)
        ELSE
            InsertIntegerValue(0, 1);
        IF Others THEN
            InsertIntegerValue(1, 1)
        ELSE
            InsertIntegerValue(0, 1);
        PadLinetill134Characters(Blank);
    end;

    procedure InsertRecapDeclarationDetail(SrNo: Integer; EUCountryCode: Code[10]; VATRegistrationNo: Text[20]; Amount: Decimal; IndicatorCode: Integer)
    begin
        NewLine;
        InsertIntegerValue(4, 2);
        InsertIntegerValue(SrNo, 5);
        InsertTextValue(EUCountryCode, 2, Blank);
        InsertTextValue(VATRegistrationNo, 12, Blank);
        InsertTextValue(GiveInvertedSign(Amount), 1, Blank);
        InsertDecimalValue(ROUND(ABS(Amount), 1) * 100, 12);
        InsertIntegerValue(IndicatorCode, 1);
        PadLinetill134Characters(Blank);
    end;

    procedure InsertRecapDeclarationTrailer(LineNumber: Integer; AccountantFiscalNumber: Integer; TotalSumIndicator1: Decimal; TransportEquipTotalSalesAmt: Decimal; TotalSumIndicator4: Decimal; TotalSumIndicator5: Decimal)
    begin
        NewLine;
        InsertIntegerValue(9, 2);
        InsertIntegerValue(LineNumber, 5);
        InsertIntegerValue(AccountantFiscalNumber, 9);
        InsertTextValue(GiveInvertedSign(TotalSumIndicator1), 1, Blank);
        InsertDecimalValue(ROUND(ABS(TotalSumIndicator1), 1) * 100, 12);
        InsertTextValue(DefineSign(TransportEquipTotalSalesAmt), 1, Blank);
        InsertDecimalValue(ROUND(ABS(TransportEquipTotalSalesAmt), 1) * 100, 12);
        InsertTextValue(GiveInvertedSign(TotalSumIndicator4), 1, Blank);
        InsertDecimalValue(ROUND(ABS(TotalSumIndicator4), 1) * 100, 12);
        InsertTextValue(GiveInvertedSign(TotalSumIndicator5), 1, Blank);
        InsertDecimalValue(ROUND(ABS(TotalSumIndicator5), 1) * 100, 12);
        PadLinetill134Characters(Blank);
    end;

    procedure InsertECDeclarationTrailer(LineNumber: Integer)
    begin
        NewLine;
        InsertIntegerValue(89, 2);
        InsertIntegerValue(LineNumber, 9);
        PadLinetill134Characters(Blank);
    end;

    procedure InsertECFileTrailer(LineNumber: Integer)
    begin
        NewLine;
        InsertIntegerValue(99, 2);
        InsertIntegerValue(LineNumber, 9);
        PadLinetill134Characters(Blank);
    end;

    procedure InsertAnnex40Header(pStatementYear: Integer; pStatementPeriod: Text[3]; pStatementVATRegNo: Text[9])
    begin
        NewLine;
        InsertIntegerValue(60, 2);
        InsertIntegerValue(pStatementYear, 4);
        InsertTextValue(pStatementPeriod, 3, Blank);
        InsertTextValue(pStatementVATRegNo, 9, Blank);
        InsertTextValue(Blank, 116, Blank);

        Print40 := TRUE;
        gTotal += 1;
    end;

    procedure InsertAnnex41Header(pStatementYear: Integer; pStatementPeriod: Text[3]; pStatementVATRegNo: Text[9])
    begin
        NewLine;
        InsertIntegerValue(80, 2);
        InsertIntegerValue(pStatementYear, 4);
        InsertTextValue(pStatementPeriod, 3, Blank);
        InsertTextValue(pStatementVATRegNo, 9, Blank);
        InsertTextValue(Blank, 116, Blank);

        Print41 := TRUE;
        gTotal += 1;
    end;

    procedure InsertAnnex4041CustomerLine(pVATAnnexSetup: Record "PTSS VAT Annex Setup"; pLineNumber: Integer; pVATRegNo: Text[9]; pVATEntry: Record "VAT Entry")
    begin
        NewLine;

        CLEAR(indice);
        EVALUATE(indice, pVATAnnexSetup."Record Type");
        IF pVATAnnexSetup.Annex = pVATAnnexSetup.Annex::"40" THEN
            indice := indice - 60
        ELSE
            indice -= 80;

        InsertTextValue(pVATAnnexSetup."Record Type", 2, Blank);
        gResumes[indice] += 1;

        InsertIntegerValue(pLineNumber, 5);
        InsertTextValue(pVATAnnexSetup."Tax Authority Code", 2, Blank);
        InsertTextValue(pVATRegNo, 9, Blank);
        InsertIntegerValue(ABS(ROUND(pVATEntry.Base * 100, 1, '<')), 12);
        InsertIntegerValue(ABS(ROUND(pVATEntry.Amount * 100, 1, '<')), 12);
        InsertTextValue(Blank, 92, Blank);
    end;

    procedure InsertAnnex4041DocumentLine(pVATAnnexSetup: Record "PTSS VAT Annex Setup"; pLineNumber: Integer; pDocNo: Text[13]; pVATEntry: Record "VAT Entry")
    var
        VATNo: Integer;
    begin
        NewLine;
        InsertTextValue(pVATAnnexSetup."Record Type", 2, Blank);
        InsertIntegerValue(pLineNumber, 5);
        InsertTextValue(pVATAnnexSetup."Tax Authority Code", 2, Blank);

        IF pVATAnnexSetup.Annex = pVATAnnexSetup.Annex::"41" THEN BEGIN
            CLEAR(VATNo);
            EVALUATE(VATNo, pVATEntry."VAT Registration No.");
            InsertIntegerValue(VATNo, 9);
        END;

        pDocNo := PADSTR('0', 13 - STRLEN(pDocNo), '0') + pDocNo;
        InsertTextValue(pDocNo, 13, Blank);

        IF pVATAnnexSetup."Record Type" = '86' THEN
            InsertDecimalValue(ABS(ROUND(pVATEntry.Base * 100, 1, '<')), 12);

        InsertIntegerValue(ABS(ROUND(pVATEntry.Amount * 100, 1, '<')), 12);
        IF pVATAnnexSetup.Annex = pVATAnnexSetup.Annex::"40" THEN
            InsertTextValue(Blank, 100, Blank)
        ELSE BEGIN
            IF pVATAnnexSetup."Record Type" = '86' THEN
                InsertTextValue(Blank, 79, Blank)
            ELSE
                InsertTextValue(Blank, 91, Blank);
        END;
        CLEAR(indice);
        EVALUATE(indice, pVATAnnexSetup."Record Type");
        IF pVATAnnexSetup.Annex = pVATAnnexSetup.Annex::"40" THEN
            indice := indice - 60
        ELSE
            indice -= 80;

        gResumes[indice] += 1;
    end;

    procedure InsertAnnex4041ReasonLine(pVATAnnexSetup: Record "PTSS VAT Annex Setup"; pVATEntry: Record "VAT Entry"; LineNo: Integer)
    begin
        IF pVATAnnexSetup.Frame = pVATAnnexSetup.Frame::"2" THEN BEGIN
            IF (pVATAnnexSetup.SubSection = 'a') OR (pVATAnnexSetup.SubSection = '') THEN BEGIN
                NewLine;
                InsertTextValue(pVATAnnexSetup."Record Type", 2, Blank);
            END;
            IF (pVATAnnexSetup.SubSection = 'b') AND (LineNo = 1) THEN BEGIN
                NewLine;
                InsertTextValue(pVATAnnexSetup."Record Type", 2, Blank);
                InsertIntegerValue(0, 24);
            END;
            InsertIntegerValue(ABS(ROUND(pVATEntry.Base * 100, 1, '<')), 12);
            InsertIntegerValue(ABS(ROUND(pVATEntry.Amount * 100, 1, '<')), 12);
        END;

        IF pVATAnnexSetup.Frame = pVATAnnexSetup.Frame::"3" THEN BEGIN
            IF (pVATAnnexSetup.SubSection = 'a') OR (pVATAnnexSetup.SubSection = 'A') THEN BEGIN
                IF (LineNo = 1) THEN BEGIN
                    NewLine;
                    InsertTextValue(pVATAnnexSetup."Record Type", 2, Blank);
                    InsertIntegerValue(0, 24);
                END;
                InsertIntegerValue(ABS(ROUND(pVATEntry.Base * 100, 1, '<')), 12);
                InsertIntegerValue(ABS(ROUND(pVATEntry.Amount * 100, 1, '<')), 12);
                boolFrameA := TRUE;
            END;
            IF (pVATAnnexSetup.SubSection = 'b') OR (pVATAnnexSetup.SubSection = 'B') THEN BEGIN
                IF (LineNo = 1) THEN BEGIN
                    NewLine;
                    InsertTextValue(pVATAnnexSetup."Record Type", 2, Blank);
                    InsertIntegerValue(0, 48);
                END ELSE
                    IF NOT boolFrameA THEN
                        InsertIntegerValue(0, 24);

                InsertIntegerValue(ABS(ROUND(pVATEntry.Base * 100, 1, '<')), 12);
                InsertIntegerValue(ABS(ROUND(pVATEntry.Amount * 100, 1, '<')), 12);
            END;
        END;
        CLEAR(indice);
        EVALUATE(indice, pVATAnnexSetup."Record Type");
        IF pVATAnnexSetup.Annex = pVATAnnexSetup.Annex::"40" THEN
            indice := indice - 60
        ELSE
            indice -= 80;

        gResumes[indice] += 1;
    end;

    procedure LastVATAnnex40Line(pTotalAmount: Decimal; pVATregNo: Text[9]; pResumes: array[10] of Integer)
    begin
        IF Print40 THEN BEGIN
            IF gResumes[8] = 0 THEN BEGIN
                NewLine;
                InsertTextValue('68', 2, Blank);
                InsertIntegerValue(ABS(ROUND(0 * 100, 1, '<')), 12);
                InsertIntegerValue(ABS(ROUND(0 * 100, 1, '<')), 12);
            END;

            IF 74 - STRLEN("Line Value") > 0 THEN
                InsertIntegerValue(0, 74 - STRLEN("Line Value"));

            InsertIntegerValue(ABS(ROUND(pTotalAmount * 100, 1, '<')), 12);
            InsertTextValue(Blank, 48, Blank);
            NewLine;
            IF PrintRoc THEN BEGIN
                InsertTextValue('96', 2, Blank);
                InsertIntegerValue(1, 5);
                InsertTextValue(pVATregNo, 9, Blank);
                InsertTextValue(Blank, 118, Blank);
                NewLine;
            END;
            InsertTextValue('69', 2, Blank);

            InsertIntegerValue(gResumes[1], 5);
            InsertIntegerValue(gResumes[2], 5);
            InsertIntegerValue(gResumes[3], 5);
            InsertIntegerValue(gResumes[4], 5);
            InsertIntegerValue(gResumes[5], 5);
            InsertIntegerValue(gResumes[6], 5);
            InsertIntegerValue(gResumes[7], 5);
            InsertIntegerValue(intRoc, 5);
            InsertTextValue(Blank, 94, Blank);
            gTotal += CalcRecordsNo(40) + 1 + intRoc;
            CLEAR(gResumes);
        END;
    end;

    procedure LastVATAnnex41Line(pVATAnnexSetup: Record "PTSS VAT Annex Setup"; pTotalAmount: Decimal; pResumes: array[10] of Integer)
    begin
        IF Print41 THEN BEGIN
            IF gResumes[7] = 0 THEN BEGIN
                NewLine;
                InsertTextValue('87', 2, Blank);
                InsertIntegerValue(ABS(ROUND(0 * 100, 1, '<')), 12);
                InsertIntegerValue(ABS(ROUND(0 * 100, 1, '<')), 12);
            END;

            IF 50 - STRLEN("Line Value") > 0 THEN
                InsertIntegerValue(0, 50 - STRLEN("Line Value"));
            InsertIntegerValue(ABS(ROUND(pTotalAmount * 100, 1, '<')), 12);
            InsertTextValue(Blank, 72, Blank);
            NewLine;
            InsertTextValue('89', 2, Blank);
            InsertIntegerValue(gResumes[1], 5);
            InsertIntegerValue(gResumes[2], 5);
            InsertIntegerValue(gResumes[3], 5);
            InsertIntegerValue(gResumes[4], 5);
            InsertIntegerValue(gResumes[5], 5);
            InsertIntegerValue(gResumes[6], 5);

            InsertTextValue(Blank, 104, Blank);

            gTotal += CalcRecordsNo(41) + 1;
            CLEAR(gResumes);
        END;
    end;

    procedure InsertVAT40LastLine(Size: Integer)
    begin
        FINDLAST;
        IF STRLEN("Line Value") <> 134 THEN BEGIN
            "Line Value" := COPYSTR("Line Value", 1, 50) + CONVERTSTR(FORMAT(0, Size, 0), Blank, HeadingZero) + COPYSTR("Line Value", 51);
            MODIFY;
        END;
    end;

    procedure InsertVAT41LastLine(Size: Integer)
    begin
        FINDLAST;
        IF STRLEN("Line Value") <> 134 THEN BEGIN
            "Line Value" := COPYSTR("Line Value", 1, 26) + CONVERTSTR(FORMAT(0, Size, 0), Blank, HeadingZero) + COPYSTR("Line Value", 27);
            MODIFY;
        END;
    end;

    procedure LastVATAnnex40Line2(pVATAnnexSetup: Record "PTSS VAT Annex Setup"; pTotalAmount: Decimal; pVATregNo: Text[9]; pResumes: array[10] of Integer)
    begin
        IF Print40 THEN BEGIN
            NewLine;
            InsertTextValue(pVATAnnexSetup."Record Type", 2, Blank);
            InsertIntegerValue(0, 72);
            InsertIntegerValue(ABS(ROUND(pTotalAmount * 100, 1, '<')), 12);
            InsertTextValue(Blank, 48, Blank);
            NewLine;
            IF PrintRoc THEN BEGIN
                InsertTextValue('96', 2, Blank);
                InsertIntegerValue(1, 5);
                InsertTextValue(pVATregNo, 9, Blank);
                InsertTextValue(Blank, 118, Blank);
                NewLine;
            END;
            InsertTextValue('69', 2, Blank);
            InsertIntegerValue(gResumes[1], 5);
            InsertIntegerValue(gResumes[2], 5);
            InsertIntegerValue(gResumes[3], 5);
            InsertIntegerValue(gResumes[4], 5);
            InsertIntegerValue(gResumes[5], 5);
            InsertIntegerValue(gResumes[6], 5);
            InsertIntegerValue(gResumes[7], 5);
            InsertIntegerValue(intRoc, 5);
            InsertTextValue(Blank, 92, Blank);
            gTotal += CalcRecordsNo(40) + 1 + intRoc;
            CLEAR(gResumes);
        END;
    end;

    procedure LastVATAnnex41Line2(pVATAnnexSetup: Record "PTSS VAT Annex Setup"; pTotalAmount: Decimal; pResumes: array[10] of Integer)
    begin
        IF Print41 THEN BEGIN
            NewLine;
            InsertTextValue(pVATAnnexSetup."Record Type", 2, Blank);
            InsertIntegerValue(0, 48);
            InsertIntegerValue(ABS(ROUND(pTotalAmount * 100, 1, '<')), 12);
            InsertTextValue(Blank, 72, Blank);
            NewLine;
            InsertTextValue('89', 2, Blank);
            InsertIntegerValue(gResumes[1], 5);
            InsertIntegerValue(gResumes[2], 5);
            InsertIntegerValue(gResumes[3], 5);
            InsertIntegerValue(gResumes[4], 5);
            InsertIntegerValue(gResumes[5], 5);
            InsertIntegerValue(gResumes[6], 5);

            InsertTextValue(Blank, 102, Blank);

            gTotal += CalcRecordsNo(41) + 1;
            CLEAR(gResumes);
        END;
    end;

    procedure CalcRecordsNo(Type: Integer): Integer
    var
        Total: Integer;
        i: Integer;
    begin
        FOR i := 1 TO 8 DO BEGIN
            IF (Type = 40) AND (i = 8) THEN
                Total += 1
            ELSE
                IF (Type = 41) AND (i = 7) THEN
                    Total += 1
                ELSE
                    Total += gResumes[i];
        END;

        EXIT(Total);
    end;

    procedure getTotalRecords(): Integer
    var
        endTotal: Integer;
    begin
        endTotal := gTotal;
        CLEAR(gTotal);
        EXIT(endTotal);
    end;

    procedure InsertAnnex4041CustomerLine2(pVATAnnexSetup: Record "PTSS VAT Annex Setup"; pLineNumber: Integer; pTempTable: Record "PTSS Temporary Table")
    begin
        NewLine;

        CLEAR(indice);
        EVALUATE(indice, pVATAnnexSetup."Record Type");
        IF pVATAnnexSetup.Annex = pVATAnnexSetup.Annex::"40" THEN
            indice := indice - 60
        ELSE
            indice -= 80;

        InsertTextValue(pVATAnnexSetup."Record Type", 2, Blank);
        gResumes[indice] += 1;

        InsertIntegerValue(pLineNumber, 5);
        InsertTextValue(pVATAnnexSetup."Tax Authority Code", 2, Blank);
        InsertTextValue(pTempTable.Text2, 9, Blank);
        InsertIntegerValue(ABS(ROUND(pTempTable.Decimal2 * 100, 1, '<')), 12);
        InsertIntegerValue(ABS(ROUND(pTempTable.Decimal1 * 100, 1, '<')), 12);
        InsertTextValue(Blank, 92, Blank);
    end;

    procedure SetRocLine()
    begin
        PrintRoc := TRUE;
        intRoc := 1
    end;
}

