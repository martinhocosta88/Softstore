report 31022893 "Normalized Account Schedule"
{

    DefaultLayout = RDLC;
    RDLCLayout = './Normalized Account Schedule.rdl';
    Caption = 'Normalized Account Schedule';

    dataset
    {
        dataitem(DataItem5444; Integer)
        {
            DataItemTableView = SORTING (Number)
                                WHERE (Number = CONST (1));
        }
        dataitem(DataItemAccScheduleName; "Acc. Schedule Name")
        {
            RequestFilterFields = Name, "Default Column Layout";
            column(Acc__Schedule_Name_Name; Name)
            {
            }
            dataitem(DataItemAccScheduleLine; "Acc. Schedule Line")
            {
                DataItemLink = "Schedule Name" = FIELD (Name);
                DataItemTableView = SORTING ("Schedule Name", "Line No.");
                RequestFilterFields = "Date Filter", "Dimension 1 Filter", "Dimension 2 Filter";
                column(UPPERCASE__Acc__Schedule_Name__Description_; UPPERCASE(DataItemAccScheduleName.Description))
                {
                }
                column(FORMAT_TODAY_0_4_; FORMAT(TODAY, 0, 4))
                {
                }
                column(CabTexto; CabTexto)
                {
                }
                column(USERID; USERID)
                {
                }
                column(Acc__Schedule_Line__TABLENAME__________AccSchFilter; DataItemAccScheduleLine.TABLENAME + ': ' + AccSchFilter)
                {
                }
                column(UPPERCASE_CurrType_; UPPERCASE(CurrType))
                {
                }
                column(Cabecalho_3_; Cabecalho[3])
                {
                }
                column(Cabecalho_6_; Cabecalho[6])
                {
                }
                column(Cabecalho_1_; Cabecalho[1])
                {
                }
                column(Cabecalho_2_; Cabecalho[2])
                {
                }
                column(ArredCabecalho_1_; ArredCabecalho[1])
                {
                    AutoCalcField = false;
                }
                column(ArredCabecalho_2_; ArredCabecalho[2])
                {
                    AutoCalcField = false;
                }
                column(ArredCabecalho_3_; ArredCabecalho[3])
                {
                    AutoCalcField = false;
                }
                column(ArredCabecalho_6_; ArredCabecalho[6])
                {
                    AutoCalcField = false;
                }
                column(ColValuesAsText1_6_; ColValuesAsText1[6])
                {
                }
                column(ColValuesAsText1_4_; ColValuesAsText1[4])
                {
                }
                column(ImprimeLin; ImprimeLin)
                {
                }
                column(ColValuesAsText1_3_; ColValuesAsText1[3])
                {
                }
                column(ColValuesAsText1_2_; ColValuesAsText1[2])
                {
                }
                column(ColValuesAsText1_1_; ColValuesAsText1[1])
                {
                }
                column(Acc__Schedule_Line__Acc__Schedule_Line__Type; DataItemAccScheduleLine.Type)
                {
                }
                column(ImprimeLin1; ImprimeLin1)
                {
                }
                column(Type_Assets; DataItemAccScheduleLine.Type = DataItemAccScheduleLine.Type::Assets)
                {
                }
                column(Acc__Schedule_Line__Row_No__; "Row No.")
                {
                }
                column(PADSTR_____Indentation___2____Description; PADSTR(' ', Indentation * 2) + Description)
                {
                }
                column(ColValuesAsText_1_; ColValuesAsText[1])
                {
                    AutoCalcField = false;
                }
                column(ColValuesAsText_2_; ColValuesAsText[2])
                {
                    AutoCalcField = false;
                }
                column(ColValuesAsText_3_; ColValuesAsText[3])
                {
                    AutoCalcField = false;
                }
                column(ColValuesAsText_6_; ColValuesAsText[6])
                {
                    AutoCalcField = false;
                }
                column(Acc__Schedule_Line__Row_No___Control7; "Row No.")
                {
                }
                column(PADSTR_____Indentation___2____Description_Control8; PADSTR(' ', Indentation * 2) + Description)
                {
                }
                column(ColValuesAsText_1__Control9; ColValuesAsText[1])
                {
                    AutoCalcField = false;
                }
                column(ColValuesAsText_6__Control11; ColValuesAsText[6])
                {
                    AutoCalcField = false;
                }
                column(New_Page; NoOfLines)
                {
                }
                column(Acc__Schedule_Line__Row_No___Control92; "Row No.")
                {
                }
                column(PADSTR_____Indentation___2____Description_Control93; PADSTR(' ', Indentation * 2) + Description)
                {
                }
                column(ColValuesAsText_1__Control94; ColValuesAsText[1])
                {
                    AutoCalcField = false;
                }
                column(ColValuesAsText_2__Control95; ColValuesAsText[2])
                {
                    AutoCalcField = false;
                }
                column(ColValuesAsText_3__Control96; ColValuesAsText[3])
                {
                    AutoCalcField = false;
                }
                column(ColValuesAsText_6__Control99; ColValuesAsText[6])
                {
                    AutoCalcField = false;
                }
                column(Acc__Schedule_Line__Row_No___Control12; "Row No.")
                {
                }
                column(PADSTR_____Indentation___2____Description_Control13; PADSTR(' ', Indentation * 2) + Description)
                {
                }
                column(ColValuesAsText_1__Control14; ColValuesAsText[1])
                {
                    AutoCalcField = false;
                }
                column(ColValuesAsText_6__Control16; ColValuesAsText[6])
                {
                    AutoCalcField = false;
                }
                column(PageCaption; PageCaptionLbl)
                {
                }
                column(ANALYTIC_BALANCECaption; ANALYTIC_BALANCECaptionLbl)
                {
                }
                column(Row_No_Caption; Row_No_CaptionLbl)
                {
                }
                column(DescriptionCaption; DescriptionCaptionLbl)
                {
                }
                column(Acc__Schedule_Line_Schedule_Name; "Schedule Name")
                {
                }
                column(Acc__Schedule_Line_Line_No_; "Line No.")
                {
                }

                trigger OnAfterGetRecord();
                begin
                    CLEAR(ImprimeLin);
                    CLEAR(ImprimeLin1);
                    CLEAR(NotZero);
                    CLEAR(NotZero1);

                    VarRoundHdr := ArredCabecalho[1];
                    IF ImprValoresEmDivAdic THEN
                        CabTexto := Text31022895 + '' + GenLedgerSetup."Additional Reporting Currency"
                    ELSE BEGIN
                        GenLedgerSetup.TESTFIELD("LCY Code");
                        CabTexto := Text31022895 + '' + GenLedgerSetup."LCY Code";
                    END;

                    VarCabecalho := Cabecalho[1];

                    IF NOT (DataItemAccScheduleLine.Type = DataItemAccScheduleLine.Type::Assets) THEN
                        IF DataItemAccScheduleLine.Type = DataItemAccScheduleLine.Type::Liabilities THEN BEGIN
                            Cabecalho[1] := ' ';
                            Cabecalho[2] := ' ';
                            Cabecalho[3] := VarCabecalho
                        END ELSE BEGIN
                            VarCabecalho3 := 'AB (N)';
                            Cabecalho[1] := ' ';
                            Cabecalho[2] := ' ';
                            Cabecalho[3] := VarCabecalho3
                        END;

                    WITH ColumnLayoutTemp DO BEGIN
                        IF "Rounding Factor" IN ["Rounding Factor"::"1000", "Rounding Factor"::"1000000"] THEN
                            CASE "Rounding Factor" OF
                                "Rounding Factor"::"1000":
                                    VarRoundHdr3 := '(Milhares)';
                                "Rounding Factor"::"1000000":
                                    VarRoundHdr3 := '(Milhões)';
                            END;
                    END;

                    IF DataItemAccScheduleLine.Type = DataItemAccScheduleLine.Type::Liabilities THEN BEGIN
                        ArredCabecalho[1] := ' ';
                        ArredCabecalho[2] := ' ';
                        ArredCabecalho[3] := VarRoundHdr
                    END ELSE BEGIN
                        ArredCabecalho[1] := ' ';
                        ArredCabecalho[2] := ' ';
                        ArredCabecalho[3] := VarRoundHdr3
                    END;

                    IF (DataItemAccScheduleLine.Type = DataItemAccScheduleLine.Type::Assets) THEN BEGIN
                        NotZero := FALSE;
                        ImprimeLin := NOT
                                 (DataItemAccScheduleLine.Show IN [DataItemAccScheduleLine.Show::No, DataItemAccScheduleLine.Show::"When Positive Balance"]);
                        IF ImprimeLin THEN BEGIN
                            NotZero := CalcColumns;
                            IF DataItemAccScheduleLine.Show = DataItemAccScheduleLine.Show::"If Any Column Not Zero" THEN
                                ImprimeLin := NotZero;
                        END;

                        NotZero1 := FALSE;
                        ImprimeLin1 := (DataItemAccScheduleLine.Show IN [DataItemAccScheduleLine.Show::"When Positive Balance"]);
                        IF ImprimeLin1 THEN
                            NotZero1 := CalcColumns;
                    END ELSE BEGIN
                        NotZero := FALSE;
                        ImprimeLin := NOT
                                 (DataItemAccScheduleLine.Show IN [DataItemAccScheduleLine.Show::No, DataItemAccScheduleLine.Show::"When Positive Balance"]);
                        IF ImprimeLin THEN BEGIN
                            NotZero := CalcColumns;
                            IF DataItemAccScheduleLine.Show = DataItemAccScheduleLine.Show::"If Any Column Not Zero" THEN
                                ImprimeLin := NotZero;
                        END;

                        NotZero1 := FALSE;
                        ImprimeLin1 := (DataItemAccScheduleLine.Show IN [DataItemAccScheduleLine.Show::"When Positive Balance"]);
                        IF ImprimeLin1 THEN
                            NotZero1 := CalcColumns;
                    END;

                    IF AccScheduleLine."Line No." = 0 THEN
                        CurrType := FORMAT(DataItemAccScheduleLine.Type);

                    IF AccScheduleLine."New Page" THEN BEGIN
                        NoOfLines := NoOfLines + 1;
                        AccScheduleLine.NEXT;
                        CurrType := FORMAT(AccScheduleLine.Type);
                        AccScheduleLine.NEXT(-1);
                    END;
                    AccScheduleLine := DataItemAccScheduleLine;

                    FOR i := 1 TO MaxColsShow DO BEGIN
                        ShowColValues[i] := 0;
                        ColValuesAsText[i] := '';
                    END;

                    IF UsePrePrint THEN
                        Description := ''
                    ELSE
                        Description := PADSTR('', Indentation * 2) + Description;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                TESTFIELD(Standardized, TRUE);
            end;

            trigger OnPreDataItem();
            begin
                IF DataItemAccScheduleName.GETRANGEMIN(Name) <> DataItemAccScheduleName.GETRANGEMAX(Name) THEN
                    ERROR(Text31022894);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ImprValoresEmDivAdic; ImprValoresEmDivAdic)
                    {
                        Caption = 'Show Amounts in Add. currency';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport();
    begin
        IF DadosIdGeral AND (DataEncto = 0D) THEN
            ERROR(Text31022890);

        CompanyInformation.GET;
        PartirNomeEmpresa(CompanyInformation, NomeEmp);

        DataItemAccScheduleName.FINDFIRST;
        DataItemAccScheduleName.TESTFIELD("Default Column Layout");
        ColumnLayoutName := DataItemAccScheduleName."Default Column Layout";
        InicEsqCta;
        GenLedgerSetup.GET;
    end;

    var
        AccSchBuffer: Record "Acc. Schedule Buffer" temporary;
        CompanyInformation: Record "Company Information";
        ColumnLayoutTemp: Record "Column Layout" temporary;
        GenLedgerSetup: Record "General Ledger Setup";
        AccSchedManagement: Codeunit AccSchedManagement;
        AccSchedManagementPT: Codeunit AccSchedManagementPT;
        UsePrePrint: Boolean;
        AccSchFilter: Text[250];
        FiscalYear1: Text[30];
        FiscalYear2: Text[30];
        NomeEmp: array[2] of Text[32];
        CurrType: Text[30];
        CabTexto: Text[30];
        DataEncto: Date;
        Pessoal: array[4] of Integer;
        DadosIdGeral: Boolean;
        PunteroToken: Integer;
        ShowColValues: array[6] of Decimal;
        ColValuesAsText: array[6] of Text[30];
        MaxColsShow: Integer;
        i: Integer;
        StartingDate: Date;
        EndingDate: Date;
        StartingDateioFiscal: Date;
        ColumnLayoutName: Code[10];
        ShowCurrError: Boolean;
        ImprValoresEmDivAdic: Boolean;
        Cabecalho: array[6] of Text[30];
        ArredCabecalho: array[6] of Text[30];
        IsRound: Boolean;
        Text31022890: Label 'Specify the date that the accounts refer to';
        Text31022891: Label '(Thousands)';
        Text31022892: Label '(Millions)';
        Text31022893: Label '* ERROR *';
        Text31022894: Label 'Select just one account scheme';
        AccSchName: Record "Acc. Schedule Name";
        Text31022895: Label 'All amounts in ';
        VarCabecalho: Text[30];
        VarCabecalho3: Text[30];
        ImprimeLin: Boolean;
        NotZero: Boolean;
        ImprimeLin1: Boolean;
        NotZero1: Boolean;
        VarRoundHdr: Text[30];
        VarRoundHdr3: Text[30];
        ColValuesAsText1: array[6] of Text[30];
        NoOfLines: Integer;
        AccScheduleLine: Record "Acc. Schedule Line";
        PageCaptionLbl: Label 'Page';
        ANALYTIC_BALANCECaptionLbl: Label 'ANALYTIC BALANCE';
        Row_No_CaptionLbl: Label 'Row No.';
        DescriptionCaptionLbl: Label 'Description';

    procedure PartirNomeEmpresa(var CompanyInformation2: Record "Company Information"; var Linha: array[2] of Text[132]);
    var
        NomeCompleto: Text[101];
        NovoToken: Text[50];
        LinhaCompleta: Boolean;
        NaoMaisTokens: Boolean;
    begin
        NomeCompleto := CompanyInformation2.Name + ' ' + CompanyInformation2."Name 2";
        LinhaCompleta := FALSE;
        NaoMaisTokens := FALSE;
        Token(NomeCompleto, Linha[1]);
        REPEAT
            Token(NomeCompleto, NovoToken);
            IF NovoToken = '' THEN
                NaoMaisTokens := TRUE
            ELSE
                IF STRLEN(Linha[1] + NovoToken) + 1 > MAXSTRLEN(NomeEmp[1]) THEN BEGIN
                    LinhaCompleta := TRUE;
                    Linha[2] := NovoToken;
                END ELSE
                    Linha[1] := Linha[1] + ' ' + NovoToken;
        UNTIL NaoMaisTokens OR LinhaCompleta;

        IF LinhaCompleta THEN BEGIN
            LinhaCompleta := FALSE;
            REPEAT
                Token(NomeCompleto, NovoToken);
                IF NovoToken = '' THEN
                    NaoMaisTokens := TRUE
                ELSE
                    IF STRLEN(Linha[2] + NovoToken) + 1 > MAXSTRLEN(NomeEmp[2]) THEN
                        LinhaCompleta := TRUE
                    ELSE
                        Linha[2] := Linha[2] + ' ' + NovoToken;
            UNTIL NaoMaisTokens OR LinhaCompleta;
        END;
    end;

    procedure Token(Cadeia: Text[132]; var Token: Text[132]);
    var
        "Carácter": Text[30];
    begin
        Token := '';
        REPEAT
            PunteroToken := PunteroToken + 1;
            Carácter := COPYSTR(Cadeia, PunteroToken, 1);
        UNTIL Carácter <> ' ';

        WHILE (Carácter <> ' ') AND (Carácter <> '') DO BEGIN
            Token := Token + Carácter;
            PunteroToken := PunteroToken + 1;
            Carácter := COPYSTR(Cadeia, PunteroToken, 1);
        END;
    end;

    procedure InicEsqCta();
    var
        NDeCols: Integer;
    begin
        StartingDate := DataItemAccScheduleLine.GETRANGEMIN("Date Filter");
        EndingDate := DataItemAccScheduleLine.GETRANGEMAX("Date Filter");
        StartingDateioFiscal := AccSchedManagement.FindFiscalYear(EndingDate);

        FiscalYear1 := FORMAT(DATE2DMY(CALCDATE('<1Y-1D>', StartingDateioFiscal), 3));
        FiscalYear2 := FORMAT(DATE2DMY(CALCDATE('<-1D>', StartingDateioFiscal), 3));
        IF UsePrePrint THEN BEGIN
            FiscalYear1 := COPYSTR(FiscalYear1, 4);
            FiscalYear2 := COPYSTR(FiscalYear2, 4);
        END;

        MaxColsShow := ARRAYLEN(ShowColValues);
        AccSchFilter := DataItemAccScheduleLine.GETFILTERS;

        IsRound := FALSE;
        NDeCols := 0;

        AccSchedManagement.CopyColumnsToTemp(ColumnLayoutName, ColumnLayoutTemp);

        WITH ColumnLayoutTemp DO BEGIN
            i := 0;
            IF FINDSET THEN BEGIN
                REPEAT
                    IF Show <> Show::Never THEN BEGIN
                        i := i + 1;
                        IF i <= MaxColsShow THEN BEGIN
                            Cabecalho[i] := "Column Header";
                            ArredCabecalho[i] := '';
                            IF "Rounding Factor" IN ["Rounding Factor"::"1000", "Rounding Factor"::"1000000"] THEN BEGIN
                                IsRound := TRUE;
                                CASE "Rounding Factor" OF
                                    "Rounding Factor"::"1000":
                                        ArredCabecalho[i] := Text31022891;
                                    "Rounding Factor"::"1000000":
                                        ArredCabecalho[i] := Text31022892;
                                END;
                            END;
                        END;
                    END;
                    NDeCols := NDeCols + 1;
                UNTIL (i >= MaxColsShow) OR (NEXT = 0);
                MaxColsShow := i;
            END;
        END;
    end;

    procedure CalcColumns(): Boolean;
    var
        NotZero: Boolean;
    begin
        NotZero := FALSE;
        WITH ColumnLayoutTemp DO BEGIN
            SETRANGE("Column Layout Name", ColumnLayoutName);
            i := 0;
            IF FINDSET THEN
                REPEAT
                    IF ColumnLayoutTemp.Show <> ColumnLayoutTemp.Show::Never THEN BEGIN
                        i := i + 1;
                        ShowColValues[i] := AccSchedManagementPT.CalcCell(DataItemAccScheduleLine, ColumnLayoutTemp, FALSE);
                        IF AccSchedManagementPT.GetDivisionError THEN BEGIN
                            IF ShowCurrError THEN BEGIN
                                ColValuesAsText[i] := Text31022893;
                                ColValuesAsText1[i] := Text31022893;
                            END
                            ELSE BEGIN
                                ColValuesAsText[i] := '';
                                ColValuesAsText1[i] := '';
                            END
                        END ELSE BEGIN
                            NotZero := NotZero OR (ShowColValues[i] <> 0);
                            ColValuesAsText[i] :=
                              AccSchedManagement.FormatCellAsText(ColumnLayoutTemp, ShowColValues[i], ImprValoresEmDivAdic);
                            ColValuesAsText1[i] :=
                              AccSchedManagement.FormatCellAsText(ColumnLayoutTemp, ShowColValues[i], ImprValoresEmDivAdic);
                        END;
                    END;
                UNTIL (i >= MaxColsShow) OR (NEXT = 0);
        END;

        EXIT(NotZero);
    end;

    local procedure ObterDivisa(): Code[10];
    begin
        IF ImprValoresEmDivAdic THEN
            EXIT(GenLedgerSetup."Additional Reporting Currency")
        ELSE
            EXIT('');
    end;
}

