codeunit 8 "AccSchedManagementPT"
{
    TableNo = 85;

    trigger OnRun();
    begin
    end;

    var
        Text000 : Label 'DEFAULT';
        Text001 : Label'Default Schedule';
        Text002 : Label 'Default Columns';
        Text012 : Label 'You have entered an illegal value or a nonexistent row number.';
        Text013 : Label 'You have entered an illegal value or a nonexistent column number.';
        Text016 : Label '%1\\ %2 %3 %4';
        Text017 : Label 'The error occurred when the program tried to calculate:\';
        Text018 : Label 'Acc. Sched. Line: Row No. = %1, Line No. = %2, Totaling = %3\';
        Text019 : Label 'Acc. Sched. Column: Column No. = %1, Line No. = %2, Formula  = %3';
        Text020 : Label 'Because of circular references, the program cannot calculate a formula.';
        AccSchedName : Record "Acc. Schedule Name";
        AccountScheduleLine : Record "Acc. Schedule Line";
        ColumnLayoutName : Record "Column Layout Name";
        AccSchedCellValue : Record "Acc. Sched. Cell Value" temporary;
        CurrExchRate : Record "Currency Exchange Rate";
        GLSetup : Record "General Ledger Setup";
        AddRepCurrency : Record Currency;
        AnalysisView : Record "Analysis View";
        MatrixMgt : Codeunit "Matrix Management";
        AnalysisViewRead : Boolean;
        StartDate : Date;
        EndDate : Date;
        FiscalStartDate : Date;
        DivisionError : Boolean;
        PeriodError : Boolean;
        CallLevel : Integer;
        CallingAccSchedLineID : Integer;
        CallingColumnLayoutID : Integer;
        OldAccSchedLineFilters : Text;
        OldColumnLayoutFilters : Text;
        OldAccSchedLineName : Code[10];
        OldColumnLayoutName : Code[10];
        OldCalcAddCurr : Boolean;
        GLSetupRead : Boolean;
        Text021 : Label 'Conversion of dimension totaling filter %1 results in a filter that becomes too long.';
        BasePercentLine : array [50] of Integer;
        Text022 : Label 'You cannot have more than %1 lines with %2 of %3.';
        Text023 : Label 'Formulas ending with a percent sign require %2 %1 on a line before it.';
        Text024 : Label 'The %1 %3 on the %2 must equal the %4 %6 on the %5 when any Dimension Totaling is used in any Column.';
        ColumnFormulaMsg : Label 'Column formula: %1.';
        RowFormulaMsg : Label 'Row formula: %1.';
        ColumnFormulaErrorMsg : Label 'Column formula: %1. \Error: %2.';
        Recalculate : Boolean;
        SystemGeneratedAccSchedMsg : Label 'Warning: This account schedule may be automatically updated by the system, so any changes you make may be lost.';
        GlAcc1 : Record "G/L Account";
        PrintAmountsInAddCurrency : Boolean;
        Text31022890 : Label 'M';
        Text31022891 : Label 'Q';
        Text31022892 : Label 'Column Formula: %1';

    procedure OpenSchedule(var CurrentSchedName : Code[10];var AccSchedLine : Record "Acc. Schedule Line");
    begin
        CheckTemplateAndSetFilter(CurrentSchedName,AccSchedLine);
    end;

    procedure OpenAndCheckSchedule(var CurrentSchedName : Code[10];var AccSchedLine : Record "Acc. Schedule Line");
    var
        GeneralLedgerSetup : Record "General Ledger Setup";
    begin
        CheckTemplateAndSetFilter(CurrentSchedName,AccSchedLine);
        IF AccSchedLine.ISEMPTY THEN
          EXIT;
        GeneralLedgerSetup.GET;
        IF CurrentSchedName IN
           [GeneralLedgerSetup."Acc. Sched. for Balance Sheet",GeneralLedgerSetup."Acc. Sched. for Cash Flow Stmt",
            GeneralLedgerSetup."Acc. Sched. for Income Stmt.",GeneralLedgerSetup."Acc. Sched. for Retained Earn."]
        THEN
          MESSAGE(SystemGeneratedAccSchedMsg);
    end;

    local procedure CheckTemplateAndSetFilter(var CurrentSchedName : Code[10];var AccSchedLine : Record "Acc. Schedule Line");
    begin
        CheckTemplateName(CurrentSchedName);
        AccSchedLine.FILTERGROUP(2);
        AccSchedLine.SETRANGE("Schedule Name",CurrentSchedName);
        AccSchedLine.FILTERGROUP(0);
    end;

    local procedure CheckTemplateName(var CurrentSchedName : Code[10]);
    var
        AccSchedName : Record "Acc. Schedule Name";
    begin
        IF NOT AccSchedName.GET(CurrentSchedName) THEN BEGIN
          IF NOT AccSchedName.FINDFIRST THEN BEGIN
            AccSchedName.INIT;
            AccSchedName.Name := Text000;
            AccSchedName.Description := Text001;
            AccSchedName.INSERT;
            COMMIT;
          END;
          CurrentSchedName := AccSchedName.Name;
        END;
    end;

    procedure CheckName(CurrentSchedName : Code[10]);
    var
        AccSchedName : Record "Acc. Schedule Name";
    begin
        AccSchedName.GET(CurrentSchedName);
    end;

    procedure SetName(CurrentSchedName : Code[10];var AccSchedLine : Record "Acc. Schedule Line");
    begin
        AccSchedLine.FILTERGROUP(2);
        AccSchedLine.SETRANGE("Schedule Name",CurrentSchedName);
        AccSchedLine.FILTERGROUP(0);
        IF AccSchedLine.FIND('-') THEN;
    end;

    procedure LookupName(CurrentSchedName : Code[10];var EntrdSchedName : Text[10]) : Boolean;
    var
        AccSchedName : Record "Acc. Schedule Name";
    begin
        AccSchedName.Name := CurrentSchedName;
        IF PAGE.RUNMODAL(0,AccSchedName) <> ACTION::LookupOK THEN
          EXIT(FALSE);

        EntrdSchedName := AccSchedName.Name;
        EXIT(TRUE);
    end;

    procedure OpenColumns(var CurrentColumnName : Code[10];var ColumnLayout : Record "Column Layout");
    begin
        CheckColumnTemplateName(CurrentColumnName);
        ColumnLayout.FILTERGROUP(2);
        ColumnLayout.SETRANGE("Column Layout Name",CurrentColumnName);
        ColumnLayout.FILTERGROUP(0);
    end;
    local procedure CheckColumnTemplateName(var CurrentColumnName : Code[10]);
    var
        ColumnLayoutName : Record "Column Layout Name";
    begin
        IF NOT ColumnLayoutName.GET(CurrentColumnName) THEN BEGIN
          IF NOT ColumnLayoutName.FINDFIRST THEN BEGIN
            ColumnLayoutName.INIT;
            ColumnLayoutName.Name := Text000;
            ColumnLayoutName.Description := Text002;
            ColumnLayoutName.INSERT;
            COMMIT;
          END;
          CurrentColumnName := ColumnLayoutName.Name;
        END;
    end;
    procedure CheckColumnName(CurrentColumnName : Code[10]);
    var
        ColumnLayoutName : Record "Column Layout Name";
    begin
        ColumnLayoutName.GET(CurrentColumnName);
    end;

    procedure SetColumnName(CurrentColumnName : Code[10];var ColumnLayout : Record "Column Layout");
    begin
        ColumnLayout.RESET;
        ColumnLayout.FILTERGROUP(2);
        ColumnLayout.SETRANGE("Column Layout Name",CurrentColumnName);
        ColumnLayout.FILTERGROUP(0);
    end;

    procedure CopyColumnsToTemp(NewColumnName : Code[10];var TempColumnLayout : Record "Column Layout");
    var
        ColumnLayout : Record "Column Layout";
    begin
        TempColumnLayout.DELETEALL;
        ColumnLayout.SETRANGE("Column Layout Name",NewColumnName);
        IF ColumnLayout.FIND('-') THEN
          REPEAT
            TempColumnLayout := ColumnLayout;
            TempColumnLayout.INSERT;
          UNTIL ColumnLayout.NEXT = 0;
        IF TempColumnLayout.FIND('-') THEN;
    end;

    procedure LookupColumnName(CurrentColumnName : Code[10];var EntrdColumnName : Text[10]) : Boolean;
    var
        ColumnLayoutName : Record "Column Layout Name";
    begin
        ColumnLayoutName.Name := CurrentColumnName;
        IF PAGE.RUNMODAL(0,ColumnLayoutName) <> ACTION::LookupOK THEN
          EXIT(FALSE);

        EntrdColumnName := ColumnLayoutName.Name;
        EXIT(TRUE);
    end;

    procedure CheckAnalysisView(CurrentSchedName : Code[10];CurrentColumnName : Code[10];TestColumnName : Boolean);
    var
        ColumnLayout2 : Record "Column Layout";
        AnyColumnDimensions : Boolean;
    begin
        IF NOT AnalysisViewRead THEN BEGIN
          AnalysisViewRead := TRUE;
          IF CurrentSchedName <> AccSchedName.Name THEN BEGIN
            CheckTemplateName(CurrentSchedName);
            AccSchedName.GET(CurrentSchedName);
          END;
          IF TestColumnName THEN
            IF CurrentColumnName <> ColumnLayoutName.Name THEN BEGIN
              CheckColumnTemplateName(CurrentColumnName);
              ColumnLayoutName.GET(CurrentColumnName);
            END;
          IF AccSchedName."Analysis View Name" = '' THEN BEGIN
            IF NOT GLSetupRead THEN
              GLSetup.GET;
            GLSetupRead := TRUE;
            AnalysisView.INIT;
            AnalysisView."Dimension 1 Code" := GLSetup."Global Dimension 1 Code";
            AnalysisView."Dimension 2 Code" := GLSetup."Global Dimension 2 Code";
          END ELSE
            AnalysisView.GET(AccSchedName."Analysis View Name");
          IF AccSchedName."Analysis View Name" <> ColumnLayoutName."Analysis View Name" THEN BEGIN
            AnyColumnDimensions := FALSE;
            ColumnLayout2.SETRANGE("Column Layout Name",ColumnLayoutName.Name);
            IF ColumnLayout2.FIND('-') THEN
              REPEAT
                AnyColumnDimensions :=
                  (ColumnLayout2."Dimension 1 Totaling" <> '') OR
                  (ColumnLayout2."Dimension 2 Totaling" <> '') OR
                  (ColumnLayout2."Dimension 3 Totaling" <> '') OR
                  (ColumnLayout2."Dimension 4 Totaling" <> '');
              UNTIL AnyColumnDimensions OR (ColumnLayout2.NEXT = 0);
            IF AnyColumnDimensions THEN
              ERROR(
                Text024,
                AccSchedName.FIELDCAPTION("Analysis View Name"),
                AccSchedName.TABLECAPTION,
                AccSchedName."Analysis View Name",
                ColumnLayoutName.FIELDCAPTION("Analysis View Name"),
                ColumnLayoutName.TABLECAPTION,
                ColumnLayoutName."Analysis View Name");
          END;
        END;
    end;

    procedure FindFiscalYear(BalanceDate : Date) : Date;
    var
        AccountingPeriod : Record "Accounting Period";
    begin
        AccountingPeriod.SETRANGE("New Fiscal Year",TRUE);
        AccountingPeriod.SETRANGE("Starting Date",0D,BalanceDate);
        IF AccountingPeriod.FINDLAST THEN
          EXIT(AccountingPeriod."Starting Date");
        AccountingPeriod.RESET;
        AccountingPeriod.FINDFIRST;
        EXIT(AccountingPeriod."Starting Date");
    end;

    local procedure FindEndOfFiscalYear(BalanceDate : Date) : Date;
    var
        AccountingPeriod : Record "Accounting Period";
    begin
        AccountingPeriod.SETRANGE("New Fiscal Year",TRUE);
        AccountingPeriod.SETFILTER("Starting Date",'>%1',FindFiscalYear(BalanceDate));
        IF AccountingPeriod.FINDFIRST THEN
          EXIT(CALCDATE('<-1D>',AccountingPeriod."Starting Date"));
        EXIT(DMY2DATE(31,12,9999));
    end;

    local procedure AccPeriodStartEnd(Formula : Code[20];Date : Date;var StartDate : Date;var EndDate : Date);
    var
        ColumnLayout : Record "Column Layout";
        AccountingPeriod : Record "Accounting Period";
        AccountingPeriodFY : Record "Accounting Period";
        Steps : Integer;
        Type : Option " ",Period,"Fiscal year","Fiscal Halfyear","Fiscal Quarter";
        CurrentPeriodNo : Integer;
        RangeFromType : Option Int,CP,LP;
        RangeToType : Option Int,CP,LP;
        RangeFromInt : Integer;
        RangeToInt : Integer;
    begin
        IF Formula = '' THEN
          EXIT;

        ColumnLayout.ParsePeriodFormula(
          Formula,Steps,Type,RangeFromType,RangeToType,RangeFromInt,RangeToInt);

        // Find current period
        AccountingPeriod.SETFILTER("Starting Date",'<=%1',Date);
        IF NOT AccountingPeriod.FIND('+') THEN BEGIN
          AccountingPeriod.RESET;
          IF Steps < 0 THEN
            AccountingPeriod.FIND('-')
          ELSE
            AccountingPeriod.FIND('+')
        END;
        AccountingPeriod.RESET;

        CASE Type OF
          Type::Period:
            BEGIN
              IF AccountingPeriod.NEXT(Steps) <> Steps THEN
                PeriodError := TRUE;
              StartDate := AccountingPeriod."Starting Date";
              EndDate := AccPeriodEndDate(StartDate);
            END;
          Type::"Fiscal year":
            BEGIN
              AccountingPeriodFY := AccountingPeriod;
              WHILE NOT AccountingPeriodFY."New Fiscal Year" DO
                IF AccountingPeriodFY.FIND('<') THEN
                  CurrentPeriodNo += 1
                ELSE
                  AccountingPeriodFY."New Fiscal Year" := TRUE;
              AccountingPeriodFY.SETRANGE("New Fiscal Year",TRUE);
              AccountingPeriodFY.NEXT(Steps);

              AccPeriodStartOrEnd(AccountingPeriodFY,CurrentPeriodNo,RangeFromType,RangeFromInt,FALSE,StartDate);
              AccPeriodStartOrEnd(AccountingPeriodFY,CurrentPeriodNo,RangeToType,RangeToInt,TRUE,EndDate);
            END;
        END;
    end;

    local procedure AccPeriodEndDate(StartDate : Date) : Date;
    var
        AccountingPeriod : Record "Accounting Period";
    begin
        AccountingPeriod."Starting Date" := StartDate;
        IF AccountingPeriod.FIND('>') THEN
          EXIT(AccountingPeriod."Starting Date" - 1);
        EXIT(DMY2DATE(31,12,9999));
    end;

    local procedure AccPeriodGetPeriod(var AccountingPeriod : Record "Accounting Period";AccPeriodNo : Integer);
    begin
        CASE TRUE OF
          AccPeriodNo > 0:
            BEGIN
              AccountingPeriod.NEXT(AccPeriodNo);
              EXIT;
            END;
          AccPeriodNo = 0:
            EXIT;
          AccPeriodNo < 0:
            BEGIN
              AccountingPeriod.SETRANGE("New Fiscal Year",TRUE);
              IF NOT AccountingPeriod.FIND('>') THEN BEGIN
                AccountingPeriod.RESET;
                AccountingPeriod.FIND('+');
                EXIT;
              END;
              AccountingPeriod.RESET;
              AccountingPeriod.FIND('<');
              EXIT;
            END;
        END;
    end;

    local procedure AccPeriodStartOrEnd(AccountingPeriod : Record "Accounting Period";CurrentPeriodNo : Integer;RangeType : Option Int,CP,LP;RangeInt : Integer;EndDate : Boolean;var Date : Date);
    begin
        CASE RangeType OF
          RangeType::CP:
            AccPeriodGetPeriod(AccountingPeriod,CurrentPeriodNo);
          RangeType::LP:
            AccPeriodGetPeriod(AccountingPeriod,-1);
          RangeType::Int:
            AccPeriodGetPeriod(AccountingPeriod,RangeInt - 1);
        END;
        IF EndDate THEN
          Date := AccPeriodEndDate(AccountingPeriod."Starting Date")
        ELSE
          Date := AccountingPeriod."Starting Date";
    end;

    local procedure InitBasePercents(AccSchedLine : Record "Acc. Schedule Line";ColumnLayout : Record "Column Layout");
    var
        BaseIdx : Integer;
    begin
        CLEAR(BasePercentLine);
        BaseIdx := 0;

        WITH AccSchedLine DO BEGIN
          SETRANGE("Schedule Name","Schedule Name");
          IF FIND('-') THEN
            REPEAT
              IF "Totaling Type" = "Totaling Type"::"Set Base For Percent" THEN BEGIN
                BaseIdx := BaseIdx + 1;
                IF BaseIdx > ARRAYLEN(BasePercentLine) THEN
                  ShowError(
                    STRSUBSTNO(Text022,ARRAYLEN(BasePercentLine),FIELDCAPTION("Totaling Type"),"Totaling Type"),
                    AccSchedLine,ColumnLayout);
                BasePercentLine[BaseIdx] := "Line No.";
              END;
            UNTIL NEXT = 0;
        END;

        IF BaseIdx = 0 THEN BEGIN
          AccSchedLine."Totaling Type" := AccSchedLine."Totaling Type"::"Set Base For Percent";
          ShowError(
            STRSUBSTNO(Text023,AccSchedLine.FIELDCAPTION("Totaling Type"),AccSchedLine."Totaling Type"),
            AccSchedLine,ColumnLayout);
        END;
    end;

    local procedure GetBasePercentLine(AccSchedLine : Record "Acc. Schedule Line";ColumnLayout : Record "Column Layout") : Integer;
    var
        BaseIdx : Integer;
    begin
        IF BasePercentLine[1] = 0 THEN
          InitBasePercents(AccSchedLine,ColumnLayout);

        BaseIdx := ARRAYLEN(BasePercentLine);
        REPEAT
          IF BasePercentLine[BaseIdx] <> 0 THEN
            IF BasePercentLine[BaseIdx] < AccSchedLine."Line No." THEN
              EXIT(BasePercentLine[BaseIdx]);
          BaseIdx := BaseIdx - 1;
        UNTIL BaseIdx = 0;

        AccSchedLine."Totaling Type" := AccSchedLine."Totaling Type"::"Set Base For Percent";
        ShowError(
          STRSUBSTNO(Text023,AccSchedLine.FIELDCAPTION("Totaling Type"),AccSchedLine."Totaling Type"),
          AccSchedLine,ColumnLayout);
    end;

    procedure CalcCell(var AccSchedLine : Record "Acc. Schedule Line";var ColumnLayout : Record "Column Layout";CalcAddCurr : Boolean) : Decimal;
    var
        Result : Decimal;
    begin
        AccountScheduleLine.COPYFILTERS(AccSchedLine);
        StartDate := AccountScheduleLine.GETRANGEMIN("Date Filter");
        IF EndDate <> AccountScheduleLine.GETRANGEMAX("Date Filter") THEN BEGIN
          EndDate := AccountScheduleLine.GETRANGEMAX("Date Filter");
          FiscalStartDate := FindFiscalYear(EndDate);
        END;
        DivisionError := FALSE;
        PeriodError := FALSE;
        CallLevel := 0;
        CallingAccSchedLineID := AccSchedLine."Line No.";
        CallingColumnLayoutID := ColumnLayout."Line No.";

        IF (OldAccSchedLineFilters <> AccSchedLine.GETFILTERS) OR
           (OldColumnLayoutFilters <> ColumnLayout.GETFILTERS) OR
           (OldAccSchedLineName <> AccSchedLine."Schedule Name") OR
           (OldColumnLayoutName <> ColumnLayout."Column Layout Name") OR
           (OldCalcAddCurr <> CalcAddCurr) OR
           Recalculate
        THEN BEGIN
          AccSchedCellValue.RESET;
          AccSchedCellValue.DELETEALL;
          CLEAR(BasePercentLine);
          OldAccSchedLineFilters := AccSchedLine.GETFILTERS;
          OldColumnLayoutFilters := ColumnLayout.GETFILTERS;
          OldAccSchedLineName := AccSchedLine."Schedule Name";
          OldColumnLayoutName := ColumnLayout."Column Layout Name";
          OldCalcAddCurr := CalcAddCurr;
        END;

        Result := CalcCellValue(AccSchedLine,ColumnLayout,CalcAddCurr);
        WITH ColumnLayout DO BEGIN
          CASE Show OF
            Show::"When Positive":
              IF Result < 0 THEN
                Result := 0;
            Show::"When Negative":
              IF Result > 0 THEN
                Result := 0;
          END;
          IF "Show Opposite Sign" THEN
            Result := -Result;
          CASE "Show Indented Lines" OF
            "Show Indented Lines"::"Indented Only":
              IF AccSchedLine.Indentation = 0 THEN
                Result := 0;
            "Show Indented Lines"::"Non-Indented Only":
              IF AccSchedLine.Indentation > 0 THEN
                Result := 0;
          END;
        END;
        IF AccSchedLine."Show Opposite Sign" THEN
          Result := -Result;
        EXIT(Result);
    end;

    local procedure CalcCellValue(AccSchedLine : Record "Acc. Schedule Line";ColumnLayout : Record "Column Layout";CalcAddCurr : Boolean) : Decimal;
    var
        GLAcc : Record "G/L Account";
        CostType : Record "Cost Type";
        CFAccount : Record "Cash Flow Account";
        Result : Decimal;
        "//--soft-local--//" : Integer;
        Result2 : Decimal;
        //HistoricGLAcc : Record "31022909";
        AccSchedName : Record "Acc. Schedule Name";
    begin
        Result := 0;
        Result2 := 0; //soft,sn
        //soft,o IF AccSchedLine.Totaling <> '' THEN
        //soft,sn
        IF ((AccSchedLine.Totaling <> '') AND (ColumnLayout.Ref = ColumnLayout.Ref::"1")) OR
           ((AccSchedLine."Totaling 2" <> '') AND (ColumnLayout.Ref = ColumnLayout.Ref::"2"))  THEN
        //soft,en
          IF AccSchedCellValue.GET(AccSchedLine."Line No.",ColumnLayout."Line No.") THEN BEGIN
            Result := AccSchedCellValue.Value;
            //SS.10.00.03.02,o Result2 := AccSchedCellValue.Value2;
            DivisionError := DivisionError OR AccSchedCellValue."Has Error";
            PeriodError := PeriodError OR AccSchedCellValue."Period Error";
          END ELSE BEGIN
            IF ColumnLayout."Column Type" = ColumnLayout."Column Type"::Formula THEN
              Result :=
                EvaluateExpression(
                  FALSE,ColumnLayout.Formula,AccSchedLine,ColumnLayout,CalcAddCurr)
            ELSE
              IF AccSchedLine."Totaling Type" IN
                 [AccSchedLine."Totaling Type"::Formula,AccSchedLine."Totaling Type"::"Set Base For Percent"]
              THEN
              BEGIN 
                Result :=
                  EvaluateExpression(
                    TRUE,AccSchedLine.Totaling,AccSchedLine,ColumnLayout,CalcAddCurr);
              
                Result2 :=
                  EvaluateExpression(
                    TRUE, AccSchedLine."Totaling 2",AccSchedLine,ColumnLayout,CalcAddCurr)
              END
              
              ELSE
              BEGIN //soft,n
                IF (StartDate = 0D) OR (EndDate = 0D) OR (EndDate = DMY2DATE(31,12,9999)) THEN BEGIN
                  Result := 0;
                  PeriodError := TRUE;
                //soft,o END ELSE BEGIN
                //soft,sn
                END;
                IF ColumnLayout.Ref = ColumnLayout.Ref::"1" THEN BEGIN
                //soft,en
                  IF AccSchedLine."Totaling Type" IN
                     [AccSchedLine."Totaling Type"::"Posting Accounts",AccSchedLine."Totaling Type"::"Total Accounts"]
                  THEN BEGIN
                    AccSchedLine.COPYFILTERS(AccountScheduleLine);
                    //soft,o SetGLAccRowFilters(GLAcc,AccSchedLine);
                    //soft,sn
                    IF AccSchedName.GET(AccSchedLine."Schedule Name") AND AccSchedName."Acc. No. Referred to old Acc." THEN BEGIN
                      SetHistoricGLAccRowFilters(HistoricGLAcc,AccSchedLine,ColumnLayout);
                      SetHistoricGLAccColumnFilters(HistoricGLAcc,AccSchedLine,ColumnLayout);
                      IF (AccSchedLine."Totaling Type" = AccSchedLine."Totaling Type"::"Posting Accounts") AND
                         (STRLEN(AccSchedLine.Totaling) <= MAXSTRLEN(GLAcc.Totaling)) AND (STRPOS(AccSchedLine.Totaling,'*') = 0)
                      THEN BEGIN
                        HistoricGLAcc."Account Type" := HistoricGLAcc."Account Type"::Total;
                        HistoricGLAcc.Totaling := AccSchedLine.Totaling;
                        Result := Result + CalcHistoricGLAcc(HistoricGLAcc,AccSchedLine,ColumnLayout,CalcAddCurr);
                      END ELSE
                        IF HistoricGLAcc.FINDFIRST THEN
                          REPEAT
                            Result := Result + CalcHistoricGLAcc(HistoricGLAcc,AccSchedLine,ColumnLayout,CalcAddCurr);
                          UNTIL HistoricGLAcc.NEXT = 0;
                    END ELSE BEGIN
                      SetGLAccRowFilters(GLAcc,AccSchedLine,ColumnLayout);
                    //soft,en
                    SetGLAccColumnFilters(GLAcc,AccSchedLine,ColumnLayout);
                    IF (AccSchedLine."Totaling Type" = AccSchedLine."Totaling Type"::"Posting Accounts") AND
                       (STRLEN(AccSchedLine.Totaling) <= MAXSTRLEN(GLAcc.Totaling)) AND (STRPOS(AccSchedLine.Totaling,'*') = 0)
                    THEN BEGIN
                      GLAcc."Account Type" := GLAcc."Account Type"::Total;
                      GLAcc.Totaling := AccSchedLine.Totaling;
                      Result := Result + CalcGLAcc(GLAcc,AccSchedLine,ColumnLayout,CalcAddCurr);
                    END ELSE
                      IF GLAcc.FIND('-') THEN
                        REPEAT
                          Result := Result + CalcGLAcc(GLAcc,AccSchedLine,ColumnLayout,CalcAddCurr);
                        UNTIL GLAcc.NEXT = 0;
                  END;
                //soft,sn
                END ELSE BEGIN
                  AccSchedLine.COPYFILTERS(AccountScheduleLine);
                  IF AccSchedName.GET(AccSchedLine."Schedule Name") AND AccSchedName."Acc. No. Referred to old Acc." THEN BEGIN
                    SetHistoricGLAccRowFilters(HistoricGLAcc,AccSchedLine,ColumnLayout);
                    SetHistoricGLAccColumnFilters(HistoricGLAcc,AccSchedLine,ColumnLayout);
                    IF (AccSchedLine."Totaling Type" = AccSchedLine."Totaling Type"::"Posting Accounts") AND
                      (STRLEN(AccSchedLine."Totaling 2") <= 30)
                    THEN BEGIN
                      HistoricGLAcc."Account Type" := HistoricGLAcc."Account Type"::"2";
                      HistoricGLAcc.Totaling := AccSchedLine."Totaling 2";
                      Result2 := Result2 + CalcHistoricGLAcc(HistoricGLAcc,AccSchedLine,ColumnLayout,CalcAddCurr);
                    END ELSE
                      IF HistoricGLAcc.FINDFIRST THEN
                        REPEAT
                          Result2 := Result2 + CalcHistoricGLAcc(HistoricGLAcc,AccSchedLine,ColumnLayout,CalcAddCurr);
                        UNTIL HistoricGLAcc.NEXT = 0;
                  END ELSE BEGIN
                    SetGLAccRowFilters(GLAcc,AccSchedLine,ColumnLayout);
                    SetGLAccColumnFilters(GLAcc,AccSchedLine,ColumnLayout);
                    IF (AccSchedLine."Totaling Type" = AccSchedLine."Totaling Type"::"Posting Accounts") AND
                       (STRLEN(AccSchedLine."Totaling 2") <= 30)
                    THEN BEGIN
                      GLAcc."Account Type" := GLAcc."Account Type"::Total;
                      GLAcc.Totaling := AccSchedLine."Totaling 2";
                      Result2 := Result2 + CalcGLAcc(GLAcc,AccSchedLine,ColumnLayout,CalcAddCurr);
                    END ELSE
                      IF GLAcc.FINDFIRST THEN
                        REPEAT
                          Result2 := Result2 + CalcGLAcc(GLAcc,AccSchedLine,ColumnLayout,CalcAddCurr);
                        UNTIL GLAcc.NEXT = 0;
                  END;
              END;
              //soft,en
            END;//SS.10.00.03.03,n

                  IF AccSchedLine."Totaling Type" IN
                     [AccSchedLine."Totaling Type"::"Cost Type",AccSchedLine."Totaling Type"::"Cost Type Total"]
                  THEN BEGIN
                    AccSchedLine.COPYFILTERS(AccountScheduleLine);
                    SetCostTypeRowFilters(CostType,AccSchedLine,ColumnLayout);
                    SetCostTypeColumnFilters(CostType,AccSchedLine,ColumnLayout);

                    IF (AccSchedLine."Totaling Type" = AccSchedLine."Totaling Type"::"Cost Type") AND
                       (STRLEN(AccSchedLine.Totaling) <= MAXSTRLEN(GLAcc.Totaling)) AND (STRPOS(AccSchedLine.Totaling,'*') = 0)
                    THEN BEGIN
                      CostType.Type := CostType.Type::Total;
                      CostType.Totaling := AccSchedLine.Totaling;
                      Result := Result + CalcCostType(CostType,AccSchedLine,ColumnLayout,CalcAddCurr);
                    END ELSE BEGIN
                      IF CostType.FIND('-') THEN
                        REPEAT
                          Result := Result + CalcCostType(CostType,AccSchedLine,ColumnLayout,CalcAddCurr);
                        UNTIL CostType.NEXT = 0;
                    END;
                  END;

                  IF AccSchedLine."Totaling Type" IN
                     [AccSchedLine."Totaling Type"::"Cash Flow Entry Accounts",AccSchedLine."Totaling Type"::"Cash Flow Total Accounts"]
                  THEN BEGIN
                    AccSchedLine.COPYFILTERS(AccountScheduleLine);
                    SetCFAccRowFilter(CFAccount,AccSchedLine);
                    SetCFAccColumnFilter(CFAccount,AccSchedLine,ColumnLayout);
                    IF (AccSchedLine."Totaling Type" = AccSchedLine."Totaling Type"::"Cash Flow Entry Accounts") AND
                       (STRLEN(AccSchedLine.Totaling) <= 30)
                    THEN BEGIN
                      CFAccount."Account Type" := CFAccount."Account Type"::Total;
                      CFAccount.Totaling := AccSchedLine.Totaling;
                      Result := Result + CalcCFAccount(CFAccount,AccSchedLine,ColumnLayout);
                    END ELSE
                      IF CFAccount.FIND('-') THEN
                        REPEAT
                          Result := Result + CalcCFAccount(CFAccount,AccSchedLine,ColumnLayout);
                        UNTIL CFAccount.NEXT = 0;
                  END;
                END;
            AccSchedCellValue."Row No." := AccSchedLine."Line No.";
            AccSchedCellValue."Column No." := ColumnLayout."Line No.";
            AccSchedCellValue.Value := Result;
            AccSchedCellValue.Value2 := Result2; //soft,n
            AccSchedCellValue."Has Error" := DivisionError;
            AccSchedCellValue."Period Error" := PeriodError;
            AccSchedCellValue.INSERT;
          END;
          //soft,sn
          IF AccSchedLine."Reverse Sign" THEN
              Result := -Result;
          IF AccSchedLine."Positive Only" AND (Result < 0) THEN
              Result := 0;

          IF AccSchedLine."Reverse Sign 2" THEN
              Result2 := -Result2;
          IF AccSchedLine."Positive Only 2" AND (Result2 < 0) THEN
              Result2 := 0;

          IF ColumnLayout.Ref = ColumnLayout.Ref::"2" THEN
              Result := Result2;
          //SS.10.00.03.03,o END;
          //soft,en
        EXIT(Result);
    end;

    local procedure CalcGLAcc(var GLAcc : Record "G/L Account";var AccSchedLine : Record "Acc. Schedule Line";var ColumnLayout : Record "Column Layout";CalcAddCurr : Boolean) ColValue : Decimal;
    var
        GLEntry : Record "G/L Entry";
        GLBudgEntry : Record "G/L Budget Entry";
        AnalysisViewEntry : Record "Analysis View Entry";
        AnalysisViewBudgetEntry : Record "Analysis View Budget Entry";
        AmountType : Option "Net Amount","Debit Amount","Credit Amount",,,,,,"Debit Balance","Credit Balance";
        TestBalance : Boolean;
        Balance : Decimal;
        UseBusUnitFilter : Boolean;
        UseDimFilter : Boolean;
        "//--soft-local--//" : Integer;
        AnalysisViewEntry1 : Record "Analysis View Entry";
        AmountType2 : Option "Net Amount","Debit Amount","Credit Amount",,,,,,"Debit Balance","Credit Balance";
        AmountType3 : Option "Net Amount","Debit Amount","Credit Amount",,,,,,"Debit Balance","Credit Balance";
    begin
        ColValue := 0;
        UseDimFilter := FALSE;
        IF AccSchedName.Name <> AccSchedLine."Schedule Name" THEN
          AccSchedName.GET(AccSchedLine."Schedule Name");

        //soft,sn
        AmountType := ColumnLayout."Amount Type";
        AmountType2 := ColumnLayout."Amount Type 2";
        AmountType3 := ColumnLayout."Amount Type 3";
        //soft,en
        IF ConflictAmountType(AccSchedLine,ColumnLayout."Amount Type",AmountType) THEN
          EXIT(0);
        TestBalance :=
          AccSchedLine.Show IN [AccSchedLine.Show::"When Positive Balance",AccSchedLine.Show::"When Negative Balance"];
        IF ColumnLayout."Column Type" <> ColumnLayout."Column Type"::Formula THEN BEGIN
          UseBusUnitFilter := (AccSchedLine.GETFILTER("Business Unit Filter") <> '') OR (ColumnLayout."Business Unit Totaling" <> '');
          UseDimFilter := HasDimFilter(AccSchedLine,ColumnLayout);
          CASE ColumnLayout."Ledger Entry Type" OF
            ColumnLayout."Ledger Entry Type"::Entries:
              BEGIN
                IF AccSchedName."Analysis View Name" = '' THEN
                  WITH GLEntry DO BEGIN
                    IF UseBusUnitFilter THEN
                      IF UseDimFilter THEN
                        SETCURRENTKEY(
                          "G/L Account No.","Business Unit Code","Global Dimension 1 Code","Global Dimension 2 Code")
                      ELSE
                        SETCURRENTKEY(
                          "G/L Account No.","Business Unit Code","Posting Date")
                    ELSE
                      IF UseDimFilter THEN
                        SETCURRENTKEY("G/L Account No.","Global Dimension 1 Code","Global Dimension 2 Code")
                      ELSE
                        SETCURRENTKEY("G/L Account No.","Posting Date");
                    IF GLAcc.Totaling = '' THEN
                      SETRANGE("G/L Account No.",GLAcc."No.")
                    ELSE
                      SETFILTER("G/L Account No.",GLAcc.Totaling);
                    GLAcc.COPYFILTER("Date Filter","Posting Date");
                    AccSchedLine.COPYFILTER("Business Unit Filter","Business Unit Code");
                    AccSchedLine.COPYFILTER("Dimension 1 Filter","Global Dimension 1 Code");
                    AccSchedLine.COPYFILTER("Dimension 2 Filter","Global Dimension 2 Code");
                    FILTERGROUP(2);
                    SETFILTER("Global Dimension 1 Code",GetDimTotalingFilter(1,AccSchedLine."Dimension 1 Totaling"));
                    SETFILTER("Global Dimension 2 Code",GetDimTotalingFilter(2,AccSchedLine."Dimension 2 Totaling"));
                    FILTERGROUP(8);
                    SETFILTER("Global Dimension 1 Code",GetDimTotalingFilter(1,ColumnLayout."Dimension 1 Totaling"));
                    SETFILTER("Global Dimension 2 Code",GetDimTotalingFilter(2,ColumnLayout."Dimension 2 Totaling"));
                    SETFILTER("Business Unit Code",ColumnLayout."Business Unit Totaling");
                    FILTERGROUP(0);
                    //soft,so
                    //CASE AmountType OF
                    //  AmountType::"Net Amount":
                    //soft,eo
                    //soft,sn
                    CASE TRUE OF
                      ((AmountType = AmountType::"Net Amount") AND (AccSchedLine."Column Value" = 0)) OR
                      ((AmountType2 = AmountType2::"Net Amount") AND (AccSchedLine."Column Value" = 1)) OR
                      ((AmountType3 = AmountType3::"Net Amount") AND (AccSchedLine."Column Value" = 2)):
                    //soft,en
                        BEGIN
                          IF CalcAddCurr THEN BEGIN
                            CALCSUMS("Additional-Currency Amount");
                            ColValue := "Additional-Currency Amount";
                          END ELSE BEGIN
                            CALCSUMS(Amount);
                            ColValue := Amount;
                          END;
                          Balance := ColValue;
                        END;
                      //soft,o AmountType::"Debit Amount":
                      //soft,sn
                      ((AmountType = AmountType::"Debit Amount") AND (AccSchedLine."Column Value" = 0)) OR
                      ((AmountType2 = AmountType2::"Debit Amount") AND (AccSchedLine."Column Value" = 1)) OR
                      ((AmountType3 = AmountType3::"Debit Amount") AND (AccSchedLine."Column Value" = 2)):
                      //soft,en
                        BEGIN
                          IF CalcAddCurr THEN BEGIN
                            IF TestBalance THEN BEGIN
                              CALCSUMS("Add.-Currency Debit Amount","Additional-Currency Amount");
                              Balance := "Additional-Currency Amount";
                            END ELSE
                              CALCSUMS("Add.-Currency Debit Amount");
                            ColValue := "Add.-Currency Debit Amount";
                          END ELSE BEGIN
                            IF TestBalance THEN BEGIN
                              CALCSUMS("Debit Amount",Amount);
                              Balance := Amount;
                            END ELSE
                              CALCSUMS("Debit Amount");
                            ColValue := "Debit Amount";
                          END;
                        END;
                      //soft,o AmountType::"Credit Amount":
                      //soft,sn
                      ((AmountType = AmountType::"Credit Amount") AND (AccSchedLine."Column Value" = 0)) OR
                      ((AmountType2 = AmountType2::"Credit Amount") AND (AccSchedLine."Column Value" = 1)) OR
                      ((AmountType3 = AmountType3::"Credit Amount") AND (AccSchedLine."Column Value" = 2)):
                      //soft,en
                        BEGIN
                          IF CalcAddCurr THEN BEGIN
                            IF TestBalance THEN BEGIN
                              CALCSUMS("Add.-Currency Credit Amount","Additional-Currency Amount");
                              Balance := "Additional-Currency Amount";
                            END ELSE
                              CALCSUMS("Add.-Currency Credit Amount");
                            ColValue := "Add.-Currency Credit Amount";
                          END ELSE BEGIN
                            IF TestBalance THEN BEGIN
                              CALCSUMS("Credit Amount",Amount);
                              Balance := Amount;
                            END ELSE
                              CALCSUMS("Credit Amount");
                            ColValue := "Credit Amount";
                          END;
                        END;
                      //soft,sn
                        ((AmountType = AmountType::"Debit Balance") AND (AccSchedLine."Column Value" = 0)) OR
                        ((AmountType2 = AmountType2::"Debit Balance") AND (AccSchedLine."Column Value" = 1)) OR
                        ((AmountType3 = AmountType3::"Debit Balance") AND (AccSchedLine."Column Value" = 2)):
                          BEGIN
                            GlAcc1 := GLAcc;
                            GlAcc1.COPYFILTERS(GLAcc);
                            //SS.10.00.03.01,sn
                            GlAcc1.SETFILTER("No.",GLAcc.Totaling);
                            GlAcc1.SETFILTER("Global Dimension 1 Filter",GLEntry.GETFILTER("Global Dimension 1 Code"));
                            GlAcc1.SETFILTER("Global Dimension 2 Filter",GLEntry.GETFILTER("Global Dimension 2 Code"));
                            GlAcc1.SETFILTER("Business Unit Filter",ColumnLayout."Business Unit Totaling");
                            IF AccSchedLine."Totaling Type" = AccSchedLine."Totaling Type"::"Total Accounts" THEN BEGIN
                              GlAcc1.SETRANGE("Account Type",GlAcc1."Account Type"::Total);
                              IF PrintAmountsInAddCurrency THEN BEGIN
                                GlAcc1.CALCFIELDS("Additional-Currency Net Change");
                                IF GlAcc1."Additional-Currency Net Change" > 0 THEN
                                  ColValue := GlAcc1."Additional-Currency Net Change";
                              END ELSE BEGIN
                                GlAcc1.CALCFIELDS("Net Change");
                                IF GlAcc1."Net Change" > 0 THEN
                                  ColValue := GlAcc1."Net Change";
                              END;
                            END ELSE BEGIN
                            //SS.10.00.03.01,en
                              GlAcc1.SETRANGE("Account Type",GlAcc1."Account Type"::Posting);
                              //SS.10.00.03.01,so
                              //GlAcc1.SETFILTER("No.",GLAcc.Totaling);
                              //GlAcc1.SETFILTER("Global Dimension 1 Filter",GLEntry.GETFILTER("Global Dimension 1 Code"));
                              //GlAcc1.SETFILTER("Global Dimension 2 Filter",GLEntry.GETFILTER("Global Dimension 2 Code"));
                              //GlAcc1.SETFILTER("Business Unit Filter",ColumnLayout."Business Unit Totaling"); //soft,n
                              //SS.10.00.03.01,eo
                              IF NOT GlAcc1.ISEMPTY THEN BEGIN
                                GlAcc1.FINDSET;
                                REPEAT
                                  IF PrintAmountsInAddCurrency THEN BEGIN
                                    GlAcc1.CALCFIELDS("Additional-Currency Net Change");
                                    IF GlAcc1."Additional-Currency Net Change" > 0 THEN
                                      ColValue := ColValue + GlAcc1."Additional-Currency Net Change";
                                  END ELSE BEGIN
                                    GlAcc1.CALCFIELDS("Net Change");
                                    IF GlAcc1."Net Change" > 0 THEN
                                      ColValue := ColValue + GlAcc1."Net Change";
                                  END;
                                UNTIL GlAcc1.NEXT = 0;
                              END;
                            END; //SS.10.00.03.01,n
                          END;

                        ((AmountType = AmountType::"Credit Balance") AND (AccSchedLine."Column Value" = 0)) OR
                        ((AmountType2 = AmountType2::"Credit Balance") AND (AccSchedLine."Column Value" = 1)) OR
                        ((AmountType3 = AmountType3::"Credit Balance") AND (AccSchedLine."Column Value" = 2)):
                          BEGIN
                            GlAcc1 := GLAcc;
                            GlAcc1.COPYFILTERS(GLAcc);
                            //SS.10.00.03.01,sn
                            GlAcc1.SETFILTER("No.",GLAcc.Totaling);
                            GlAcc1.SETFILTER("Global Dimension 1 Filter",GLEntry.GETFILTER("Global Dimension 1 Code"));
                            GlAcc1.SETFILTER("Global Dimension 2 Filter",GLEntry.GETFILTER("Global Dimension 2 Code"));
                            GlAcc1.SETFILTER("Business Unit Filter",ColumnLayout."Business Unit Totaling");
                            IF AccSchedLine."Totaling Type" = AccSchedLine."Totaling Type"::"Total Accounts" THEN BEGIN
                              GlAcc1.SETRANGE("Account Type",GlAcc1."Account Type"::Total);
                              IF PrintAmountsInAddCurrency THEN BEGIN
                                GlAcc1.CALCFIELDS("Additional-Currency Net Change");
                                IF GlAcc1."Additional-Currency Net Change" < 0 THEN
                                  ColValue := GlAcc1."Additional-Currency Net Change";
                              END ELSE BEGIN
                                GlAcc1.CALCFIELDS("Net Change");
                                IF GlAcc1."Net Change" < 0 THEN
                                  ColValue := GlAcc1."Net Change";
                              END;
                            END ELSE BEGIN
                            //SS.10.00.03.01,en
                              GlAcc1.SETRANGE("Account Type",GlAcc1."Account Type"::Posting);
                              //SS.10.00.03.01,so
                              //GlAcc1.SETFILTER("No.",GLAcc.Totaling);
                              //GlAcc1.SETFILTER("Global Dimension 1 Filter",GLEntry.GETFILTER("Global Dimension 1 Code"));
                              //GlAcc1.SETFILTER("Global Dimension 2 Filter",GLEntry.GETFILTER("Global Dimension 2 Code"));
                              //GlAcc1.SETFILTER("Business Unit Filter",ColumnLayout."Business Unit Totaling"); //soft,n
                              //SS.10.00.03.01,eo
                              IF NOT GlAcc1.ISEMPTY THEN BEGIN
                                GlAcc1.FINDSET;
                                REPEAT
                                  IF PrintAmountsInAddCurrency THEN BEGIN
                                    GlAcc1.CALCFIELDS("Additional-Currency Net Change");
                                    IF GlAcc1."Additional-Currency Net Change" < 0 THEN ColValue := ColValue + GlAcc1."Additional-Currency Net Change";
                                  END ELSE BEGIN
                                    GlAcc1.CALCFIELDS("Net Change");
                                    IF GlAcc1."Net Change" < 0 THEN ColValue := ColValue + GlAcc1."Net Change";
                                  END;
                                UNTIL GlAcc1.NEXT = 0;
                              END;
                            END; //SS.10.00.03.01,n
                          END;
                    //soft,en
                    END;
                  END
                ELSE
                  WITH AnalysisViewEntry DO BEGIN
                    SETRANGE("Analysis View Code",AccSchedName."Analysis View Name");
                    SETRANGE("Account Source","Account Source"::"G/L Account");
                    IF GLAcc.Totaling = '' THEN
                      SETRANGE("Account No.",GLAcc."No.")
                    ELSE
                      SETFILTER("Account No.",GLAcc.Totaling);
                    GLAcc.COPYFILTER("Date Filter","Posting Date");
                    AccSchedLine.COPYFILTER("Business Unit Filter","Business Unit Code");
                    CopyDimFilters(AccSchedLine);
                    FILTERGROUP(2);
                    SetDimFilters(
                      GetDimTotalingFilter(1,AccSchedLine."Dimension 1 Totaling"),
                      GetDimTotalingFilter(2,AccSchedLine."Dimension 2 Totaling"),
                      GetDimTotalingFilter(3,AccSchedLine."Dimension 3 Totaling"),
                      GetDimTotalingFilter(4,AccSchedLine."Dimension 4 Totaling"));

                    SETFILTER("Business Unit Code",ColumnLayout."Business Unit Totaling"); //soft,n
                    FILTERGROUP(8);
                    SetDimFilters(
                      GetDimTotalingFilter(1,ColumnLayout."Dimension 1 Totaling"),
                      GetDimTotalingFilter(2,ColumnLayout."Dimension 2 Totaling"),
                      GetDimTotalingFilter(3,ColumnLayout."Dimension 3 Totaling"),
                      GetDimTotalingFilter(4,ColumnLayout."Dimension 4 Totaling"));
                    SETFILTER("Business Unit Code",ColumnLayout."Business Unit Totaling");
                    FILTERGROUP(0);
                    //soft,so
                    //CASE AmountType OF
                    //  AmountType::"Net Amount":
                    //soft,eo
                    //soft,sn
                      CASE TRUE OF
                        ((AmountType = AmountType::"Net Amount") AND (AccSchedLine."Column Value" = 0)) OR
                        ((AmountType2 = AmountType2::"Net Amount") AND (AccSchedLine."Column Value" = 1)) OR
                        ((AmountType3 = AmountType3::"Net Amount") AND (AccSchedLine."Column Value" = 2)):
                    //soft,en
                        BEGIN
                          IF CalcAddCurr THEN BEGIN
                            CALCSUMS("Add.-Curr. Amount");
                            ColValue := "Add.-Curr. Amount";
                          END ELSE BEGIN
                            CALCSUMS(Amount);
                            ColValue := Amount;
                          END;
                          Balance := ColValue;
                        END;
                    //soft,o AmountType::"Debit Amount":
                        //soft,sn
                        ((AmountType = AmountType::"Debit Amount") AND (AccSchedLine."Column Value" = 0)) OR
                        ((AmountType2 = AmountType2::"Debit Amount") AND (AccSchedLine."Column Value" = 1)) OR
                        ((AmountType3 = AmountType3::"Debit Amount") AND (AccSchedLine."Column Value" = 2)):
                        //soft,en
                        BEGIN
                          IF CalcAddCurr THEN BEGIN
                            IF TestBalance THEN BEGIN
                              CALCSUMS("Add.-Curr. Debit Amount","Add.-Curr. Amount");
                              Balance := "Add.-Curr. Amount";
                            END ELSE
                              CALCSUMS("Add.-Curr. Debit Amount");
                            ColValue := "Add.-Curr. Debit Amount";
                          END ELSE BEGIN
                            IF TestBalance THEN BEGIN
                              CALCSUMS("Debit Amount",Amount);
                              Balance := Amount;
                            END ELSE
                              CALCSUMS("Debit Amount");
                            ColValue := "Debit Amount";
                          END;
                        END;
                      //soft,o AmountType::"Credit Amount":
                        //soft,sn
                        ((AmountType = AmountType::"Credit Amount") AND (AccSchedLine."Column Value" = 0)) OR
                        ((AmountType2 = AmountType2::"Credit Amount") AND (AccSchedLine."Column Value" = 1)) OR
                        ((AmountType3 = AmountType3::"Credit Amount") AND (AccSchedLine."Column Value" = 2)):
                        //soft,en
                        BEGIN
                          IF CalcAddCurr THEN BEGIN
                            IF TestBalance THEN BEGIN
                              CALCSUMS("Add.-Curr. Credit Amount","Add.-Curr. Amount");
                              Balance := "Add.-Curr. Amount";
                            END ELSE
                              CALCSUMS("Add.-Curr. Credit Amount");
                            ColValue := "Add.-Curr. Credit Amount";
                          END ELSE BEGIN
                            IF TestBalance THEN BEGIN
                              CALCSUMS("Credit Amount",Amount);
                              Balance := Amount;
                            END ELSE
                              CALCSUMS("Credit Amount");
                            ColValue := "Credit Amount";
                          END;
                        END;
                        //soft,sn
                        ((AmountType = AmountType::"Debit Balance") AND (AccSchedLine."Column Value" = 0)) OR
                        ((AmountType2 = AmountType2::"Debit Balance") AND (AccSchedLine."Column Value" = 1)) OR
                        ((AmountType3 = AmountType3::"Debit Balance") AND (AccSchedLine."Column Value" = 2)):
                          BEGIN
                            AnalysisViewEntry1 := AnalysisViewEntry;
                            AnalysisViewEntry1.COPYFILTERS(AnalysisViewEntry);
                            GlAcc1 := GLAcc;
                            GlAcc1.COPYFILTERS(GLAcc);
                            //SS.10.00.03.01,sn
                            IF AccSchedLine."Totaling Type" = AccSchedLine."Totaling Type"::"Total Accounts" THEN BEGIN
                              AnalysisViewEntry1.SETFILTER("Account No.",GLAcc."No.");
                              IF PrintAmountsInAddCurrency THEN BEGIN
                                AnalysisViewEntry1.CALCSUMS("Add.-Curr. Amount");
                                IF AnalysisViewEntry1."Add.-Curr. Amount" > 0 THEN
                                  ColValue := AnalysisViewEntry1."Add.-Curr. Amount";
                              END ELSE BEGIN
                                AnalysisViewEntry1.CALCSUMS(Amount);
                                IF AnalysisViewEntry1.Amount > 0 THEN
                                  ColValue := AnalysisViewEntry1.Amount;
                              END;
                            END ELSE BEGIN
                            //SS.10.00.03.01,en
                              GlAcc1.SETRANGE("Account Type",GlAcc1."Account Type"::Posting);
                              GlAcc1.SETFILTER("No.",GLAcc.Totaling);
                              IF NOT GlAcc1.ISEMPTY THEN BEGIN
                                GlAcc1.FINDSET;
                                REPEAT
                                  AnalysisViewEntry1.SETFILTER("Account No.",GlAcc1."No.");
                                  IF PrintAmountsInAddCurrency THEN BEGIN
                                    AnalysisViewEntry1.CALCSUMS("Add.-Curr. Amount");
                                    IF AnalysisViewEntry1."Add.-Curr. Amount" > 0 THEN
                                      ColValue := ColValue + AnalysisViewEntry1."Add.-Curr. Amount";
                                  END ELSE BEGIN
                                    AnalysisViewEntry1.CALCSUMS(Amount);
                                    IF AnalysisViewEntry1.Amount > 0 THEN
                                      ColValue := ColValue + AnalysisViewEntry1.Amount;
                                    END;
                                UNTIL GlAcc1.NEXT = 0;
                              END;
                            END; //SS.10.00.03.01,n
                          END;
                        ((AmountType = AmountType::"Credit Balance") AND (AccSchedLine."Column Value" = 0)) OR
                        ((AmountType2 = AmountType2::"Credit Balance") AND (AccSchedLine."Column Value" = 1)) OR
                        ((AmountType3 = AmountType3::"Credit Balance") AND (AccSchedLine."Column Value" = 2)):
                          BEGIN
                            AnalysisViewEntry1 := AnalysisViewEntry;
                            AnalysisViewEntry1.COPYFILTERS(AnalysisViewEntry);
                            GlAcc1 := GLAcc;
                            GlAcc1.COPYFILTERS(GLAcc);
                            //SS.10.00.03.01,sn
                            IF AccSchedLine."Totaling Type" = AccSchedLine."Totaling Type"::"Total Accounts" THEN BEGIN
                              AnalysisViewEntry1.SETFILTER("Account No.",GLAcc."No.");
                              IF PrintAmountsInAddCurrency THEN BEGIN
                                AnalysisViewEntry1.CALCSUMS("Add.-Curr. Amount");
                                IF AnalysisViewEntry1."Add.-Curr. Amount" < 0 THEN
                                  ColValue := AnalysisViewEntry1."Add.-Curr. Amount";
                              END ELSE BEGIN
                                AnalysisViewEntry1.CALCSUMS(Amount);
                                IF AnalysisViewEntry1.Amount < 0 THEN
                                  ColValue := AnalysisViewEntry1.Amount;
                              END;
                            END ELSE BEGIN
                            //SS.10.00.03.01,en
                              GlAcc1.SETRANGE("Account Type",GlAcc1."Account Type"::Posting);
                              GlAcc1.SETFILTER("No.",GLAcc.Totaling);
                              IF NOT GlAcc1.ISEMPTY THEN BEGIN
                                GlAcc1.FINDSET;
                                REPEAT
                                  AnalysisViewEntry1.SETFILTER("Account No.",GlAcc1."No.");
                                  IF PrintAmountsInAddCurrency THEN BEGIN
                                    AnalysisViewEntry1.CALCSUMS("Add.-Curr. Amount");
                                    IF AnalysisViewEntry1."Add.-Curr. Amount" < 0 THEN
                                      ColValue := ColValue + AnalysisViewEntry1."Add.-Curr. Amount";
                                  END ELSE BEGIN
                                    AnalysisViewEntry1.CALCSUMS(Amount);
                                    IF AnalysisViewEntry1.Amount < 0 THEN
                                      ColValue := ColValue + AnalysisViewEntry1.Amount;
                                  END;
                                UNTIL GlAcc1.NEXT = 0;
                              END;
                            END; //SS.10.00.03.01,n
                          END;
                        END;
                        //soft,en
                  END;
              END;
            ColumnLayout."Ledger Entry Type"::"Budget Entries":
              BEGIN
                IF AccSchedName."Analysis View Name" = '' THEN
                  WITH GLBudgEntry DO BEGIN
                    IF UseBusUnitFilter OR UseDimFilter THEN
                      SETCURRENTKEY(
                        "Budget Name","G/L Account No.","Business Unit Code",
                        "Global Dimension 1 Code","Global Dimension 2 Code",
                        "Budget Dimension 1 Code","Budget Dimension 2 Code",
                        "Budget Dimension 3 Code","Budget Dimension 4 Code",Date)
                    ELSE
                      SETCURRENTKEY("Budget Name","G/L Account No.",Date);
                    IF GLAcc.Totaling = '' THEN
                      SETRANGE("G/L Account No.",GLAcc."No.")
                    ELSE
                      SETFILTER("G/L Account No.",GLAcc.Totaling);
                    GLAcc.COPYFILTER("Date Filter",Date);
                    AccSchedLine.COPYFILTER("G/L Budget Filter","Budget Name");
                    AccSchedLine.COPYFILTER("Business Unit Filter","Business Unit Code");
                    AccSchedLine.COPYFILTER("Dimension 1 Filter","Global Dimension 1 Code");
                    AccSchedLine.COPYFILTER("Dimension 2 Filter","Global Dimension 2 Code");
                    FILTERGROUP(2);
                    SETFILTER("Global Dimension 1 Code",GetDimTotalingFilter(1,AccSchedLine."Dimension 1 Totaling"));
                    SETFILTER("Global Dimension 2 Code",GetDimTotalingFilter(2,AccSchedLine."Dimension 2 Totaling"));
                    FILTERGROUP(8);
                    SETFILTER("Global Dimension 1 Code",GetDimTotalingFilter(1,ColumnLayout."Dimension 1 Totaling"));
                    SETFILTER("Global Dimension 2 Code",GetDimTotalingFilter(2,ColumnLayout."Dimension 2 Totaling"));
                    SETFILTER("Business Unit Code",ColumnLayout."Business Unit Totaling");
                    FILTERGROUP(0);

                    CASE AmountType OF
                      AmountType::"Net Amount":
                        BEGIN
                          CALCSUMS(Amount);
                          ColValue := Amount;
                        END;
                      AmountType::"Debit Amount":
                        BEGIN
                          CALCSUMS(Amount);
                          ColValue := Amount;
                          IF ColValue < 0 THEN
                            ColValue := 0;
                        END;
                      AmountType::"Credit Amount":
                        BEGIN
                          CALCSUMS(Amount);
                          ColValue := -Amount;
                          IF ColValue < 0 THEN
                            ColValue := 0;
                        END;
                       //soft,sn
                       AmountType::"Debit Balance" :
                         BEGIN
                           GLAcc.CALCFIELDS("Net Change");
                            ColValue := GLAcc."Net Change";
                            IF ColValue < 0 THEN
                            ColValue := 0;
                         END;
                       AmountType::"Credit Balance" :
                         BEGIN
                           GLAcc.CALCFIELDS("Net Change");
                           ColValue := GLAcc."Net Change";
                           IF ColValue > 0 THEN
                             ColValue := 0;
                         END;
                        //soft,en
                    END;
                    Balance := Amount;
                  END
                ELSE
                  WITH AnalysisViewBudgetEntry DO BEGIN
                    IF GLAcc.Totaling = '' THEN
                      SETRANGE("G/L Account No.",GLAcc."No.")
                    ELSE
                      SETFILTER("G/L Account No.",GLAcc.Totaling);
                    SETRANGE("Analysis View Code",AccSchedName."Analysis View Name");
                    GLAcc.COPYFILTER("Date Filter","Posting Date");
                    AccSchedLine.COPYFILTER("G/L Budget Filter","Budget Name");
                    AccSchedLine.COPYFILTER("Business Unit Filter","Business Unit Code");
                    CopyDimFilters(AccSchedLine);
                    FILTERGROUP(2);

                    SetDimFilters(
                      GetDimTotalingFilter(1,AccSchedLine."Dimension 1 Totaling"),
                      GetDimTotalingFilter(2,AccSchedLine."Dimension 2 Totaling"),
                      GetDimTotalingFilter(3,AccSchedLine."Dimension 3 Totaling"),
                      GetDimTotalingFilter(4,AccSchedLine."Dimension 4 Totaling"));

                    SETFILTER("Business Unit Code",ColumnLayout."Business Unit Totaling"); //soft,n
                    FILTERGROUP(8);
                    SetDimFilters(
                      GetDimTotalingFilter(1,ColumnLayout."Dimension 1 Totaling"),
                      GetDimTotalingFilter(2,ColumnLayout."Dimension 2 Totaling"),
                      GetDimTotalingFilter(3,ColumnLayout."Dimension 3 Totaling"),
                      GetDimTotalingFilter(4,ColumnLayout."Dimension 4 Totaling"));
                    SETFILTER("Business Unit Code",ColumnLayout."Business Unit Totaling");
                    FILTERGROUP(0);

                    CASE AmountType OF
                      AmountType::"Net Amount":
                        BEGIN
                          CALCSUMS(Amount);
                          ColValue := Amount;
                        END;
                      AmountType::"Debit Amount":
                        BEGIN
                          CALCSUMS(Amount);
                          ColValue := Amount;
                          IF ColValue < 0 THEN
                            ColValue := 0;
                        END;
                      AmountType::"Credit Amount":
                        BEGIN
                          CALCSUMS(Amount);
                          ColValue := -Amount;
                          IF ColValue < 0 THEN
                            ColValue := 0;
                        END;
                       //soft,sn
                       AmountType::"Debit Balance" :
                         BEGIN
                           GlAcc1 := GLAcc;
                           GlAcc1.COPYFILTERS(GLAcc);
                           //SS.10.00.03.01,sn
                            IF AccSchedLine."Totaling Type" = AccSchedLine."Totaling Type"::"Total Accounts" THEN BEGIN
                              GlAcc1.SETRANGE("Account Type",GlAcc1."Account Type"::Total);
                              GlAcc1.CALCFIELDS("Budgeted Amount");
                                IF GlAcc1."Budgeted Amount" > 0 THEN
                                  ColValue := GlAcc1."Budgeted Amount";
                            END ELSE BEGIN
                           //SS.10.00.03.01,en
                             GlAcc1.SETRANGE("Account Type",GLAcc."Account Type"::Posting);
                             GlAcc1.SETFILTER("No.",GLAcc.Totaling);
                             IF NOT GlAcc1.ISEMPTY THEN BEGIN
                               GlAcc1.FINDSET;
                               REPEAT
                                 GlAcc1.CALCFIELDS("Budgeted Amount");
                                 IF GlAcc1."Budgeted Amount" > 0 THEN
                                   ColValue := ColValue + GlAcc1."Budgeted Amount";
                               UNTIL GlAcc1.NEXT = 0;
                             END;
                           END; //SS.10.00.03.01,n
                         END;
                       AmountType::"Credit Balance" :
                         BEGIN
                           GlAcc1 := GLAcc;
                           GlAcc1.COPYFILTERS(GLAcc);
                           //SS.10.00.03.01,sn
                            IF AccSchedLine."Totaling Type" = AccSchedLine."Totaling Type"::"Total Accounts" THEN BEGIN
                              GlAcc1.SETRANGE("Account Type",GlAcc1."Account Type"::Total);
                              GlAcc1.CALCFIELDS("Budgeted Amount");
                                IF GlAcc1."Budgeted Amount" < 0 THEN
                                  ColValue := GlAcc1."Budgeted Amount";
                            END ELSE BEGIN
                           //SS.10.00.03.01,en
                             GlAcc1.SETRANGE("Account Type",GLAcc."Account Type"::Posting);
                             GlAcc1.SETFILTER("No.",GLAcc.Totaling);
                             IF NOT GlAcc1.ISEMPTY THEN BEGIN
                               GlAcc1.FINDSET;
                               REPEAT
                                   GlAcc1.CALCFIELDS("Budgeted Amount");
                                   IF GlAcc1."Budgeted Amount" < 0 THEN ColValue := ColValue + GlAcc1."Budgeted Amount";
                               UNTIL GlAcc1.NEXT = 0;
                             END;
                           END; //SS.10.00.03.01,n
                         END;
                      //soft,sn
                    END;
                    Balance := Amount;
                  END;
                IF CalcAddCurr THEN
                  ColValue := CalcLCYToACY(ColValue);
              END;
          END;
          IF TestBalance THEN BEGIN
            IF AccSchedLine.Show = AccSchedLine.Show::"When Positive Balance" THEN
              IF Balance < 0 THEN
                EXIT(0);
            IF AccSchedLine.Show = AccSchedLine.Show::"When Negative Balance" THEN
              IF Balance > 0 THEN
                EXIT(0);
          END;
        END;
        EXIT(ColValue);
    end;

    local procedure CalcCFAccount(var CFAccount : Record "Cash Flow Account";var AccSchedLine : Record "Acc. Schedule Line";var ColumnLayout : Record "Column Layout") ColValue : Decimal;
    var
        CFForecastEntry : Record "Cash Flow Forecast Entry";
        AnalysisViewEntry : Record "Analysis View Entry";
        AmountType : Option "Net Amount","Debit Amount","Credit Amount",,,,,,"Debit Balance","Credit Balance";
        "//--soft-local--//" : Integer;
        AmountType2 : Option "Net Amount","Debit Amount","Credit Amount",,,,,,"Debit Balance","Credit Balance";
        AmountType3 : Option "Net Amount","Debit Amount","Credit Amount",,,,,,"Debit Balance","Credit Balance";
    begin
        ColValue := 0;
        IF AccSchedName.Name <> AccSchedLine."Schedule Name" THEN
          AccSchedName.GET(AccSchedLine."Schedule Name");

        //soft,sn
        AmountType := ColumnLayout."Amount Type";
        AmountType2 := ColumnLayout."Amount Type 2";
        AmountType3 := ColumnLayout."Amount Type 3";
        //soft,en

        IF ConflictAmountType(AccSchedLine,ColumnLayout."Amount Type",AmountType) THEN
          EXIT(0);

        IF ColumnLayout."Column Type" <> ColumnLayout."Column Type"::Formula THEN
          CASE ColumnLayout."Ledger Entry Type" OF
            ColumnLayout."Ledger Entry Type"::Entries:
              BEGIN
                IF AccSchedName."Analysis View Name" = '' THEN
                  WITH CFForecastEntry DO BEGIN
                    SETCURRENTKEY(
                      "Cash Flow Account No.","Cash Flow Forecast No.","Global Dimension 1 Code",
                      "Global Dimension 2 Code","Cash Flow Date");
                    IF CFAccount.Totaling = '' THEN
                      SETRANGE("Cash Flow Account No.",CFAccount."No.")
                    ELSE
                      SETFILTER("Cash Flow Account No.",CFAccount.Totaling);
                    CFAccount.COPYFILTER("Date Filter","Cash Flow Date");
                    AccSchedLine.COPYFILTER("Cash Flow Forecast Filter","Cash Flow Forecast No.");
                    AccSchedLine.COPYFILTER("Dimension 1 Filter","Global Dimension 1 Code");
                    AccSchedLine.COPYFILTER("Dimension 2 Filter","Global Dimension 2 Code");
                    FILTERGROUP(2);
                    SETFILTER("Global Dimension 1 Code",AccSchedLine."Dimension 1 Totaling");
                    SETFILTER("Global Dimension 2 Code",AccSchedLine."Dimension 2 Totaling");
                    FILTERGROUP(8);
                    SETFILTER("Global Dimension 1 Code",GetDimTotalingFilter(1,ColumnLayout."Dimension 1 Totaling"));
                    SETFILTER("Global Dimension 2 Code",GetDimTotalingFilter(2,ColumnLayout."Dimension 2 Totaling"));
                    FILTERGROUP(0);
                    CASE ColumnLayout."Amount Type" OF
                      ColumnLayout."Amount Type"::"Net Amount":
                        BEGIN
                          CALCSUMS("Amount (LCY)");
                          ColValue := "Amount (LCY)";
                        END;
                    END;
                  END
                ELSE
                  WITH AnalysisViewEntry DO BEGIN
                    SETRANGE("Analysis View Code",AccSchedName."Analysis View Name");

                    SETRANGE("Account Source","Account Source"::"Cash Flow Account");
                    IF CFAccount.Totaling = '' THEN
                      SETRANGE("Account No.",CFAccount."No.")
                    ELSE
                      SETFILTER("Account No.",CFAccount.Totaling);
                    CFAccount.COPYFILTER("Date Filter","Posting Date");
                    AccSchedLine.COPYFILTER("Cash Flow Forecast Filter","Cash Flow Forecast No.");
                    CopyDimFilters(AccSchedLine);
                    FILTERGROUP(2);
                    SetDimFilters(
                      GetDimTotalingFilter(1,AccSchedLine."Dimension 1 Totaling"),
                      GetDimTotalingFilter(2,AccSchedLine."Dimension 2 Totaling"),
                      GetDimTotalingFilter(3,AccSchedLine."Dimension 3 Totaling"),
                      GetDimTotalingFilter(4,AccSchedLine."Dimension 4 Totaling"));
                    FILTERGROUP(8);
                    SetDimFilters(
                      GetDimTotalingFilter(1,ColumnLayout."Dimension 1 Totaling"),
                      GetDimTotalingFilter(2,ColumnLayout."Dimension 2 Totaling"),
                      GetDimTotalingFilter(3,ColumnLayout."Dimension 3 Totaling"),
                      GetDimTotalingFilter(4,ColumnLayout."Dimension 4 Totaling"));
                    FILTERGROUP(0);

                    CASE ColumnLayout."Amount Type" OF
                      ColumnLayout."Amount Type"::"Net Amount":
                        BEGIN
                          CALCSUMS(Amount);
                          ColValue := Amount;
                        END;
                    END;
                  END;
              END;
          END;

        EXIT(ColValue);
    end;

    procedure SetGLAccRowFilters(var GLAcc : Record "G/L Account";var AccSchedLine2 : Record "Acc. Schedule Line";var AccSchedColumn : Record "Column Layout");
    begin
        WITH AccSchedLine2 DO
          CASE "Totaling Type" OF
            "Totaling Type"::"Posting Accounts":
              BEGIN
              //soft,o GLAcc.SETFILTER("No.",Totaling);
              //soft,sn
              IF AccSchedColumn.ref = AccSchedColumn.ref::"1" THEN
                GLAcc.SETFILTER("No.",Totaling)
              ELSE
                GLAcc.SETFILTER("No.","Totaling 2");
              //soft,en
                GLAcc.SETRANGE("Account Type",GLAcc."Account Type"::Posting);
              END;
            "Totaling Type"::"Total Accounts":
              BEGIN
                //soft,o GLAcc.SETFILTER("No.",Totaling);
                //soft,sn
                IF AccSchedColumn.Ref = AccSchedColumn.Ref::"1" THEN
                  GLAcc.SETFILTER("No.",Totaling)
                ELSE
                  GLAcc.SETFILTER("No.","Totaling 2");
                //soft,en
                GLAcc.SETFILTER("Account Type",'<>%1',GLAcc."Account Type"::Posting);
              END;
          END;
    end;

    procedure SetCFAccRowFilter(var CFAccount : Record "Cash Flow Account";var AccSchedLine2 : Record "Acc. Schedule Line");
    begin
        WITH AccSchedLine2 DO BEGIN
          COPYFILTER("Cash Flow Forecast Filter",CFAccount."Cash Flow Forecast Filter");

          CASE "Totaling Type" OF
            "Totaling Type"::"Cash Flow Entry Accounts":
              BEGIN
                CFAccount.SETFILTER("No.",Totaling);
                CFAccount.SETRANGE("Account Type",CFAccount."Account Type"::Entry);
              END;
            "Totaling Type"::"Cash Flow Total Accounts":
              BEGIN
                CFAccount.SETFILTER("No.",Totaling);
                CFAccount.SETFILTER("Account Type",'<>%1',CFAccount."Account Type"::Entry);
              END;
          END;
        END;
    end;

    procedure SetGLAccColumnFilters(var GLAcc : Record "G/L Account";AccSchedLine2 : Record "Acc. Schedule Line";var ColumnLayout : Record "Column Layout");
    var
        FromDate : Date;
        ToDate : Date;
        FiscalStartDate2 : Date;
    begin
        WITH ColumnLayout DO BEGIN
          CalcColumnDates("Comparison Date Formula","Comparison Period Formula",FromDate,ToDate,FiscalStartDate2);
          CASE "Column Type" OF
            "Column Type"::"Net Change":
              CASE AccSchedLine2."Row Type" OF
                AccSchedLine2."Row Type"::"Net Change":
                  GLAcc.SETRANGE("Date Filter",FromDate,ToDate);
                AccSchedLine2."Row Type"::"Beginning Balance":
                  GLAcc.SETFILTER("Date Filter",'..%1',CLOSINGDATE(FromDate - 1)); // always includes closing date
                AccSchedLine2."Row Type"::"Balance at Date":
                  GLAcc.SETRANGE("Date Filter",0D,ToDate);
              END;
            "Column Type"::"Balance at Date":
              IF AccSchedLine2."Row Type" = AccSchedLine2."Row Type"::"Beginning Balance" THEN
                GLAcc.SETRANGE("Date Filter",0D) // Force a zero return
              ELSE
                GLAcc.SETRANGE("Date Filter",0D,ToDate);
            "Column Type"::"Beginning Balance":
              IF AccSchedLine2."Row Type" = AccSchedLine2."Row Type"::"Balance at Date" THEN
                GLAcc.SETRANGE("Date Filter",0D) // Force a zero return
              ELSE
                GLAcc.SETRANGE(
                  "Date Filter",0D,CLOSINGDATE(FromDate - 1));
            "Column Type"::"Year to Date":
              CASE AccSchedLine2."Row Type" OF
                AccSchedLine2."Row Type"::"Net Change":
                  GLAcc.SETRANGE("Date Filter",FiscalStartDate2,ToDate);
                AccSchedLine2."Row Type"::"Beginning Balance":
                  GLAcc.SETFILTER("Date Filter",'..%1',CLOSINGDATE(FiscalStartDate2 - 1)); // always includes closing date
                AccSchedLine2."Row Type"::"Balance at Date":
                  GLAcc.SETRANGE("Date Filter",0D,ToDate);
              END;
            "Column Type"::"Rest of Fiscal Year":
              CASE AccSchedLine2."Row Type" OF
                AccSchedLine2."Row Type"::"Net Change":
                  GLAcc.SETRANGE(
                    "Date Filter",CALCDATE('<+1D>',ToDate),FindEndOfFiscalYear(FiscalStartDate2));
                AccSchedLine2."Row Type"::"Beginning Balance":
                  GLAcc.SETRANGE("Date Filter",0D,ToDate);
                AccSchedLine2."Row Type"::"Balance at Date":
                  GLAcc.SETRANGE("Date Filter",0D,FindEndOfFiscalYear(ToDate));
              END;
            "Column Type"::"Entire Fiscal Year":
              CASE AccSchedLine2."Row Type" OF
                AccSchedLine2."Row Type"::"Net Change":
                  GLAcc.SETRANGE(
                    "Date Filter",
                    FiscalStartDate2,
                    FindEndOfFiscalYear(FiscalStartDate2));
                AccSchedLine2."Row Type"::"Beginning Balance":
                  GLAcc.SETFILTER("Date Filter",'..%1',CLOSINGDATE(FiscalStartDate2 - 1)); // always includes closing date
                AccSchedLine2."Row Type"::"Balance at Date":
                  GLAcc.SETRANGE("Date Filter",0D,FindEndOfFiscalYear(ToDate));
              END;
          END;
        END;
    end;

    procedure SetCFAccColumnFilter(var CFAccount : Record "Cash Flow Account";AccSchedLine2 : Record "Acc. Schedule Line";var ColumnLayout2 : Record "Column Layout");
    var
        FromDate : Date;
        ToDate : Date;
        FiscalStartDate2 : Date;
    begin
        WITH ColumnLayout2 DO BEGIN
          CalcColumnDates("Comparison Date Formula","Comparison Period Formula",FromDate,ToDate,FiscalStartDate2);
          CASE "Column Type" OF
            "Column Type"::"Net Change":
              CASE AccSchedLine2."Row Type" OF
                AccSchedLine2."Row Type"::"Net Change":
                  CFAccount.SETRANGE("Date Filter",FromDate,ToDate);
                AccSchedLine2."Row Type"::"Beginning Balance":
                  CFAccount.SETFILTER("Date Filter",'..%1',CLOSINGDATE(FromDate - 1));
                AccSchedLine2."Row Type"::"Balance at Date":
                  CFAccount.SETRANGE("Date Filter",0D,ToDate);
              END;
            "Column Type"::"Balance at Date":
              IF AccSchedLine2."Row Type" = AccSchedLine2."Row Type"::"Beginning Balance" THEN
                CFAccount.SETRANGE("Date Filter",0D) // Force a zero return
              ELSE
                CFAccount.SETRANGE("Date Filter",0D,ToDate);
            "Column Type"::"Beginning Balance":
              IF AccSchedLine2."Row Type" = AccSchedLine2."Row Type"::"Balance at Date" THEN
                CFAccount.SETRANGE("Date Filter",0D) // Force a zero return
              ELSE
                CFAccount.SETRANGE(
                  "Date Filter",0D,CALCDATE('<-1D>',FromDate));
            "Column Type"::"Year to Date":
              CASE AccSchedLine2."Row Type" OF
                AccSchedLine2."Row Type"::"Net Change":
                  CFAccount.SETRANGE("Date Filter",FiscalStartDate2,ToDate);
                AccSchedLine2."Row Type"::"Beginning Balance":
                  CFAccount.SETFILTER("Date Filter",'..%1',FiscalStartDate2 - 1);
                AccSchedLine2."Row Type"::"Balance at Date":
                  CFAccount.SETRANGE("Date Filter",0D,ToDate);
              END;
            "Column Type"::"Rest of Fiscal Year":
              CASE AccSchedLine2."Row Type" OF
                AccSchedLine2."Row Type"::"Net Change":
                  CFAccount.SETRANGE(
                    "Date Filter",
                    CALCDATE('<+1D>',ToDate),FindEndOfFiscalYear(FiscalStartDate2));
                AccSchedLine2."Row Type"::"Beginning Balance":
                  CFAccount.SETRANGE("Date Filter",0D,ToDate);
                AccSchedLine2."Row Type"::"Balance at Date":
                  CFAccount.SETRANGE("Date Filter",0D,FindEndOfFiscalYear(ToDate));
              END;
            "Column Type"::"Entire Fiscal Year":
              CASE AccSchedLine2."Row Type" OF
                AccSchedLine2."Row Type"::"Net Change":
                  CFAccount.SETRANGE(
                    "Date Filter",
                    FiscalStartDate2,FindEndOfFiscalYear(FiscalStartDate2));
                AccSchedLine2."Row Type"::"Beginning Balance":
                  CFAccount.SETFILTER("Date Filter",'..%1',CLOSINGDATE(FiscalStartDate2 - 1));
                AccSchedLine2."Row Type"::"Balance at Date":
                  CFAccount.SETRANGE("Date Filter",0D,FindEndOfFiscalYear(ToDate));
              END;
          END;
        END;
    end;

    local procedure EvaluateExpression(IsAccSchedLineExpression : Boolean;Expression : Text;AccSchedLine : Record "Acc. Schedule Line";ColumnLayout : Record "Column Layout";CalcAddCurr : Boolean) : Decimal;
    var
        AccSchedLine2 : Record "Acc. Schedule Line";
        Result : Decimal;
        Parantheses : Integer;
        Operator : Char;
        LeftOperand : Text;
        RightOperand : Text;
        LeftResult : Decimal;
        RightResult : Decimal;
        i : Integer;
        IsExpression : Boolean;
        IsFilter : Boolean;
        Operators : Text[8];
        OperatorNo : Integer;
        AccSchedLineID : Integer;
    begin
        Result := 0;

        CallLevel := CallLevel + 1;
        IF CallLevel > 25 THEN
          ShowError(Text020,
            AccSchedLine,ColumnLayout);

        Expression := DELCHR(Expression,'<>',' ');
        IF STRLEN(Expression) > 0 THEN BEGIN
          Parantheses := 0;
          IsExpression := FALSE;
          //soft,o Operators := '+-*/^%';
          Operators := '+-*/^%['; //soft,n
          OperatorNo := 1;
          REPEAT
            i := STRLEN(Expression);
            REPEAT
              IF Expression[i] = '(' THEN
                Parantheses := Parantheses + 1
              ELSE
                IF Expression[i] = ')' THEN
                  Parantheses := Parantheses - 1;
              IF (Parantheses = 0) AND (Expression[i] = Operators[OperatorNo]) THEN
                IsExpression := TRUE
              ELSE
                i := i - 1;
            UNTIL IsExpression OR (i <= 0);
            IF NOT IsExpression THEN
              OperatorNo := OperatorNo + 1;
          UNTIL (OperatorNo > STRLEN(Operators)) OR IsExpression;
          IF IsExpression THEN BEGIN
            IF i > 1 THEN
              LeftOperand := COPYSTR(Expression,1,i - 1)
            ELSE
              LeftOperand := '';
            IF i < STRLEN(Expression) THEN
              RightOperand := COPYSTR(Expression,i + 1)
            ELSE
              RightOperand := '';
            Operator := Expression[i];
            LeftResult :=
              EvaluateExpression(
                IsAccSchedLineExpression,LeftOperand,AccSchedLine,ColumnLayout,CalcAddCurr);
            IF (RightOperand = '') AND (Operator = '%') AND NOT IsAccSchedLineExpression AND
               (AccSchedLine."Totaling Type" <> AccSchedLine."Totaling Type"::"Set Base For Percent")
            THEN BEGIN
              AccSchedLine2.COPY(AccSchedLine);
              AccSchedLine2."Line No." := GetBasePercentLine(AccSchedLine,ColumnLayout);
              AccSchedLine2.FIND;
              RightResult :=
                EvaluateExpression(
                  IsAccSchedLineExpression,LeftOperand,AccSchedLine2,ColumnLayout,CalcAddCurr);
            END ELSE
              RightResult :=
                EvaluateExpression(
                  IsAccSchedLineExpression,RightOperand,AccSchedLine,ColumnLayout,CalcAddCurr);
            CASE Operator OF
              '^':
                Result := POWER(LeftResult,RightResult);
              '%':
                IF RightResult = 0 THEN BEGIN
                  Result := 0;
                  DivisionError := TRUE;
                END ELSE
                  Result := 100 * LeftResult / RightResult;
              '*':
                Result := LeftResult * RightResult;
              '/':
                IF RightResult = 0 THEN BEGIN
                  Result := 0;
                  DivisionError := TRUE;
                END ELSE
                  Result := LeftResult / RightResult;
              '+':
                Result := LeftResult + RightResult;
              '-':
                Result := LeftResult - RightResult;
              //soft,sn
              '[':
                IF RightResult >= 0 THEN
                  Result := LeftResult + RightResult
                ELSE
                  Result := LeftResult;
              //soft,en
            END;
          END ELSE
            IF (Expression[1] = '(') AND (Expression[STRLEN(Expression)] = ')') THEN
              Result :=
                EvaluateExpression(
                  IsAccSchedLineExpression,COPYSTR(Expression,2,STRLEN(Expression) - 2),
                  AccSchedLine,ColumnLayout,CalcAddCurr)
            ELSE BEGIN
              IsFilter :=
                (STRPOS(Expression,'..') +
                 STRPOS(Expression,'|') +
                 STRPOS(Expression,'<') +
                 STRPOS(Expression,'>') +
                 STRPOS(Expression,'&') +
                 STRPOS(Expression,'=') > 0);
              IF (STRLEN(Expression) > 10) AND (NOT IsFilter) THEN
                EVALUATE(Result,Expression)
              ELSE
                IF IsAccSchedLineExpression THEN BEGIN
                  AccSchedLine.SETRANGE("Schedule Name",AccSchedLine."Schedule Name");
                  AccSchedLine.SETFILTER("Row No.",Expression);
                  AccSchedLineID := AccSchedLine."Line No.";
                  IF AccSchedLine.FIND('-') THEN
                    REPEAT
                      IF AccSchedLine."Line No." <> AccSchedLineID THEN
                        Result := Result + CalcCellValue(AccSchedLine,ColumnLayout,CalcAddCurr);
                    UNTIL AccSchedLine.NEXT = 0
                  ELSE
                    IF IsFilter OR (NOT EVALUATE(Result,Expression)) THEN
                      ShowError(Text012,AccSchedLine,ColumnLayout);
                END ELSE BEGIN
                  ColumnLayout.SETRANGE("Column Layout Name",ColumnLayout."Column Layout Name");
                  ColumnLayout.SETFILTER("Column No.",Expression);
                  AccSchedLineID := ColumnLayout."Line No.";
                  IF ColumnLayout.FIND('-') THEN
                    REPEAT
                      IF ColumnLayout."Line No." <> AccSchedLineID THEN
                        Result := Result + CalcCellValue(AccSchedLine,ColumnLayout,CalcAddCurr);
                    UNTIL ColumnLayout.NEXT = 0
                  ELSE
                    IF IsFilter OR (NOT EVALUATE(Result,Expression)) THEN
                      ShowError(Text013,AccSchedLine,ColumnLayout);
                END;
            END;
        END;
        CallLevel := CallLevel - 1;
        EXIT(Result);
    end;

    // procedure FormatCellAsText(var ColumnLayout2 : Record "Column Layout";Value : Decimal;CalcAddCurr : Boolean) : Text[30];
    // var
    //     ValueAsText : Text[30];
    // begin
    //     ValueAsText := MatrixMgt.FormatValue(Value,ColumnLayout2."Rounding Factor",CalcAddCurr);

    //     IF (ValueAsText <> '') AND
    //        (ColumnLayout2."Column Type" = ColumnLayout2."Column Type"::Formula) AND
    //        (STRPOS(ColumnLayout2.Formula,'%') > 1)
    //     THEN
    //       ValueAsText := ValueAsText + '%';

    //     EXIT(ValueAsText);
    // end;

    procedure GetDivisionError() : Boolean;
    begin
        EXIT(DivisionError);
    end;

    // procedure GetPeriodError() : Boolean;
    // begin
    //     EXIT(PeriodError);
    // end;

    local procedure ShowError(MessageLine : Text[100];var AccSchedLine : Record "Acc. Schedule Line";var ColumnLayout : Record "Column Layout");
    begin
        AccSchedLine.SETRANGE("Schedule Name",AccSchedLine."Schedule Name");
        AccSchedLine.SETRANGE("Line No.",CallingAccSchedLineID);
        IF AccSchedLine.FINDFIRST THEN;
        ColumnLayout.SETRANGE("Column Layout Name",ColumnLayout."Column Layout Name");
        ColumnLayout.SETRANGE("Line No.",CallingColumnLayoutID);
        IF ColumnLayout.FINDFIRST THEN
        ERROR(
          STRSUBSTNO(
            Text016,
            MessageLine,
            Text017,
            STRSUBSTNO(Text018,AccSchedLine."Row No.",AccSchedLine."Line No.",AccSchedLine.Totaling),
            STRSUBSTNO(Text019,ColumnLayout."Column No.",ColumnLayout."Line No.",ColumnLayout.Formula)));
    end;

    procedure InsertGLAccounts(var AccSchedLine : Record "Acc. Schedule Line");
    var
        GLAcc : Record "G/L Account";
        GLAccList : Page "G/L Account List";
        AccCounter : Integer;
        AccSchedLineNo : Integer;
    begin
        GLAccList.LOOKUPMODE(TRUE);
        IF GLAccList.RUNMODAL = ACTION::LookupOK THEN BEGIN
          GLAccList.SetSelection(GLAcc);
          AccCounter := GLAcc.COUNT;
          IF AccCounter > 0 THEN BEGIN
            AccSchedLineNo := AccSchedLine."Line No.";
            MoveAccSchedLines(AccSchedLine,AccCounter);
            IF GLAcc.FINDSET THEN
              REPEAT
                AccSchedLine.INIT;
                AccSchedLineNo := AccSchedLineNo + 10000;
                AccSchedLine."Line No." := AccSchedLineNo;
                AccSchedLine.Description := GLAcc.Name;
                AccSchedLine.Indentation := GLAcc.Indentation;
                AccSchedLine.Bold := GLAcc."Account Type" <> GLAcc."Account Type"::Posting;
                IF GLAcc."Account Type" IN
                   //soft,o [GLAcc."Account Type"::Posting,GLAcc."Account Type"::Total,GLAcc."Account Type"::"End-Total"]
                   [GLAcc."Account Type"::Posting,GLAcc."Account Type"::Total] //soft,n
                THEN BEGIN
                  AccSchedLine.Totaling := GLAcc."No.";
                  AccSchedLine."Row No." := COPYSTR(GLAcc."No.",1,MAXSTRLEN(AccSchedLine."Row No."));
                END;
                IF GLAcc."Account Type" IN
                   //soft,o [GLAcc."Account Type"::Total,GLAcc."Account Type"::"End-Total"]
                   [GLAcc."Account Type"::Total] //soft,n
                THEN
                  AccSchedLine."Totaling Type" := AccSchedLine."Totaling Type"::"Total Accounts"
                ELSE
                  AccSchedLine."Totaling Type" := AccSchedLine."Totaling Type"::"Posting Accounts";
                AccSchedLine.INSERT;
              UNTIL GLAcc.NEXT = 0;
          END;
        END;
    end;

    // procedure InsertCFAccounts(var AccSchedLine : Record "Acc. Schedule Line");
    // var
    //     CashFlowAcc : Record "Cash Flow Account";
    //     CashFlowAccList : Page "Cash Flow Account List";
    //     AccCounter : Integer;
    //     AccSchedLineNo : Integer;
    // begin
    //     CashFlowAccList.LOOKUPMODE(TRUE);
    //     IF CashFlowAccList.RUNMODAL = ACTION::LookupOK THEN BEGIN
    //       CashFlowAccList.SetSelection(CashFlowAcc);
    //       AccCounter := CashFlowAcc.COUNT;
    //       IF AccCounter > 0 THEN BEGIN
    //         AccSchedLineNo := AccSchedLine."Line No.";
    //         MoveAccSchedLines(AccSchedLine,AccCounter);
    //         IF CashFlowAcc.FINDSET THEN
    //           REPEAT
    //             AccSchedLine.INIT;
    //             AccSchedLineNo := AccSchedLineNo + 10000;
    //             AccSchedLine."Line No." := AccSchedLineNo;
    //             AccSchedLine.Description := CashFlowAcc.Name;
    //             IF CashFlowAcc."Account Type" IN
    //                [CashFlowAcc."Account Type"::Entry,CashFlowAcc."Account Type"::Total,CashFlowAcc."Account Type"::"End-Total"]
    //             THEN BEGIN
    //               AccSchedLine.Totaling := CashFlowAcc."No.";
    //               AccSchedLine."Row No." := COPYSTR(CashFlowAcc."No.",1,MAXSTRLEN(AccSchedLine."Row No."));
    //             END;
    //             IF CashFlowAcc."Account Type" IN
    //                [CashFlowAcc."Account Type"::Total,CashFlowAcc."Account Type"::"End-Total"]
    //             THEN
    //               AccSchedLine."Totaling Type" := AccSchedLine."Totaling Type"::"Cash Flow Total Accounts"
    //             ELSE
    //               AccSchedLine."Totaling Type" := AccSchedLine."Totaling Type"::"Cash Flow Entry Accounts";
    //             AccSchedLine.INSERT;
    //           UNTIL CashFlowAcc.NEXT = 0;
    //       END;
    //     END;
    // end;

    // procedure InsertCostTypes(var AccSchedLine : Record "Acc. Schedule Line");
    // var
    //     CostType : Record "Cost Type";
    //     CostTypeList : Page "Cost Type List";
    //     AccCounter : Integer;
    //     AccSchedLineNo : Integer;
    // begin
    //     CostTypeList.LOOKUPMODE(TRUE);
    //     IF CostTypeList.RUNMODAL = ACTION::LookupOK THEN BEGIN
    //       CostTypeList.SetSelection(CostType);
    //       AccCounter := CostType.COUNT;
    //       IF AccCounter > 0 THEN BEGIN
    //         AccSchedLineNo := AccSchedLine."Line No.";
    //         MoveAccSchedLines(AccSchedLine,AccCounter);
    //         IF CostType.FINDSET THEN
    //           REPEAT
    //             AccSchedLine.INIT;
    //             AccSchedLineNo := AccSchedLineNo + 10000;
    //             AccSchedLine."Line No." := AccSchedLineNo;
    //             AccSchedLine.Description := CostType.Name;
    //             IF CostType.Type IN
    //                [CostType.Type::"Cost Type",CostType.Type::Total,CostType.Type::"End-Total"]
    //             THEN BEGIN
    //               AccSchedLine.Totaling := CostType."No.";
    //               AccSchedLine."Row No." := COPYSTR(CostType."No.",1,MAXSTRLEN(AccSchedLine."Row No."));
    //             END;
    //             IF CostType.Type IN
    //                [CostType.Type::Total,CostType.Type::"End-Total"]
    //             THEN
    //               AccSchedLine."Totaling Type" := AccSchedLine."Totaling Type"::"Cost Type Total"
    //             ELSE
    //               AccSchedLine."Totaling Type" := AccSchedLine."Totaling Type"::"Cost Type";
    //             AccSchedLine.INSERT;
    //           UNTIL CostType.NEXT = 0;
    //       END;
    //     END;
    // end;

    local procedure ExchangeAmtAddCurrToLCY(AmountLCY : Decimal) : Decimal;
    begin
        IF NOT GLSetupRead THEN BEGIN
          GLSetup.GET;
          GLSetupRead := TRUE;
        END;

        EXIT(
          CurrExchRate.ExchangeAmtLCYToFCY(
            WORKDATE,GLSetup."Additional Reporting Currency",AmountLCY,
            CurrExchRate.ExchangeRate(WORKDATE,GLSetup."Additional Reporting Currency")));
    end;

    // procedure SetAccSchedName(var NewAccSchedName : Record "Acc. Schedule Name");
    // begin
    //     AccSchedName := NewAccSchedName;
    // end;

    procedure GetDimTotalingFilter(DimNo : Integer;DimTotaling : Text[250]) : Text[1024];
    var
        DimTotaling2 : Text[250];
        DimTotalPart : Text[250];
        ResultFilter : Text[1024];
        ResultFilter2 : Text[1024];
        i : Integer;
    begin
        IF DimTotaling = '' THEN
          EXIT(DimTotaling);
        DimTotaling2 := DimTotaling;
        REPEAT
          i := STRPOS(DimTotaling2,'|');
          IF i > 0 THEN BEGIN
            DimTotalPart := COPYSTR(DimTotaling2,1,i - 1);
            IF i < STRLEN(DimTotaling2) THEN
              DimTotaling2 := COPYSTR(DimTotaling2,i + 1)
            ELSE
              DimTotaling2 := '';
          END ELSE
            DimTotalPart := DimTotaling2;
          ResultFilter2 := ConvDimTotalingFilter(DimNo,DimTotalPart);
          IF ResultFilter2 <> '' THEN
            IF STRLEN(ResultFilter) + STRLEN(ResultFilter2) + 1 > MAXSTRLEN(ResultFilter) THEN
              ERROR(Text021,DimTotaling);

          IF ResultFilter <> '' THEN
            ResultFilter := ResultFilter + '|';
          ResultFilter := COPYSTR(ResultFilter + ResultFilter2,1,MAXSTRLEN(ResultFilter));
        UNTIL i <= 0;
        EXIT(ResultFilter);
    end;

    local procedure ConvDimTotalingFilter(DimNo : Integer;DimTotaling : Text[250]) : Text[1024];
    var
        DimVal : Record "Dimension Value";
        CostAccSetup : Record "Cost Accounting Setup";
        DimCode : Code[20];
        ResultFilter : Text[1024];
        DimValTotaling : Boolean;
    begin
        IF CostAccSetup.GET THEN;
        IF DimTotaling = '' THEN
          EXIT(DimTotaling);

        CheckAnalysisView(AccSchedName.Name,'',FALSE);

        CASE DimNo OF
          1:
            DimCode := AnalysisView."Dimension 1 Code";
          2:
            DimCode := AnalysisView."Dimension 2 Code";
          3:
            DimCode := AnalysisView."Dimension 3 Code";
          4:
            DimCode := AnalysisView."Dimension 4 Code";
          5:
            DimCode := CostAccSetup."Cost Center Dimension";
          6:
            DimCode := CostAccSetup."Cost Object Dimension";
        END;
        IF DimCode = '' THEN
          EXIT(DimTotaling);

        DimVal.SETRANGE("Dimension Code",DimCode);
        DimVal.SETFILTER(Code,DimTotaling);
        IF DimVal.FIND('-') THEN
          REPEAT
            DimValTotaling :=
              DimVal."Dimension Value Type" IN
              [DimVal."Dimension Value Type"::Total,DimVal."Dimension Value Type"::"End-Total"];
            IF DimValTotaling AND (DimVal.Totaling <> '') THEN BEGIN
              IF STRLEN(ResultFilter) + STRLEN(DimVal.Totaling) + 1 > MAXSTRLEN(ResultFilter) THEN
                ERROR(Text021,DimTotaling);
              IF ResultFilter <> '' THEN
                ResultFilter := ResultFilter + '|';
              ResultFilter := ResultFilter + DimVal.Totaling;
            END;
          UNTIL (DimVal.NEXT = 0) OR NOT DimValTotaling;

        IF DimValTotaling THEN
          EXIT(ResultFilter);

        EXIT(DimTotaling);
    end;

    local procedure CalcCostType(var CostType : Record "Cost Type";var AccSchedLine : Record "Acc. Schedule Line";var ColumnLayout : Record "Column Layout";CalcAddCurr : Boolean) ColValue : Decimal;
    var
        CostEntry : Record "Cost Entry";
        CostBudgEntry : Record "Cost Budget Entry";
        AmountType : Option "Net Amount","Debit Amount","Credit Amount",,,,,,"Debit Balance","Credit Balance";
        UseDimFilter : Boolean;
        TestBalance : Boolean;
        Balance : Decimal;
        "//--soft-local--//" : Integer;
        GLEntry : Record "G/L Entry";
        GLBudgEntry : Record "G/L Budget Entry";
        AnalysisViewEntry : Record "Analysis View Entry";
        AnalysisViewBudgetEntry : Record "Analysis View Budget Entry";
    begin
        ColValue := 0;
        IF AccSchedName.Name <> AccSchedLine."Schedule Name" THEN
          AccSchedName.GET(AccSchedLine."Schedule Name");

        IF ConflictAmountType(AccSchedLine,ColumnLayout."Amount Type",AmountType) THEN
          EXIT(0);

        TestBalance :=
          AccSchedLine.Show IN [AccSchedLine.Show::"When Positive Balance",AccSchedLine.Show::"When Negative Balance"];

        IF ColumnLayout."Column Type" <> ColumnLayout."Column Type"::Formula THEN BEGIN
          UseDimFilter := HasDimFilter(AccSchedLine,ColumnLayout) OR HasCostDimFilter(AccSchedLine);
          IF ColumnLayout."Ledger Entry Type" = ColumnLayout."Ledger Entry Type"::Entries THEN BEGIN
            WITH CostEntry DO BEGIN
              IF UseDimFilter THEN
                SETCURRENTKEY("Cost Type No.","Cost Center Code","Cost Object Code")
              ELSE
                SETCURRENTKEY("Cost Type No.","Posting Date");
              IF CostType.Totaling = '' THEN
                SETRANGE("Cost Type No.",CostType."No.")
              ELSE
                SETFILTER("Cost Type No.",CostType.Totaling);
              CostType.COPYFILTER("Date Filter","Posting Date");
              AccSchedLine.COPYFILTER("Cost Center Filter","Cost Center Code");
              AccSchedLine.COPYFILTER("Cost Object Filter","Cost Object Code");
              FILTERGROUP(2);
              SETFILTER("Cost Center Code",GetDimTotalingFilter(5,AccSchedLine."Cost Center Totaling"));
              SETFILTER("Cost Object Code",GetDimTotalingFilter(6,AccSchedLine."Cost Object Totaling"));
              //soft,sn
              FILTERGROUP(6);
              SETFILTER("Cost Center Code",GetDimTotalingFilter(1,ColumnLayout."Dimension 1 Totaling"));
              SETFILTER("Cost Object Code",GetDimTotalingFilter(2,ColumnLayout."Dimension 2 Totaling"));
              //soft,en
              FILTERGROUP(8);
              SETFILTER("Cost Center Code",GetDimTotalingFilter(5,ColumnLayout."Cost Center Totaling"));
              SETFILTER("Cost Object Code",GetDimTotalingFilter(6,ColumnLayout."Cost Object Totaling"));
              FILTERGROUP(0);
            END;
            CASE AmountType OF
              AmountType::"Net Amount":
                BEGIN
                  IF CalcAddCurr THEN BEGIN
                    CostEntry.CALCSUMS("Additional-Currency Amount");
                    ColValue := CostEntry."Additional-Currency Amount";
                  END ELSE BEGIN
                    CostEntry.CALCSUMS(Amount);
                    ColValue := CostEntry.Amount;
                  END;
                  Balance := ColValue;
                END;
              AmountType::"Debit Amount":
                BEGIN
                  IF CalcAddCurr THEN BEGIN
                    CostEntry.CALCSUMS("Add.-Currency Debit Amount","Additional-Currency Amount");
                    IF TestBalance THEN
                      Balance := CostEntry."Additional-Currency Amount";
                    ColValue := CostEntry."Add.-Currency Debit Amount";
                  END ELSE BEGIN
                    IF TestBalance THEN BEGIN
                      CostEntry.CALCSUMS("Debit Amount",Amount);
                      Balance := CostEntry.Amount;
                    END ELSE
                      CostEntry.CALCSUMS("Debit Amount");
                    ColValue := CostEntry."Debit Amount";
                  END;
                END;
              AmountType::"Credit Amount":
                BEGIN
                  IF CalcAddCurr THEN BEGIN
                    CostEntry.CALCSUMS("Add.-Currency Credit Amount","Additional-Currency Amount");
                    IF TestBalance THEN
                      Balance := CostEntry."Additional-Currency Amount";
                    ColValue := CostEntry."Add.-Currency Credit Amount";
                  END ELSE BEGIN
                    IF TestBalance THEN BEGIN
                      CostEntry.CALCSUMS("Credit Amount",Amount);
                      Balance := CostEntry.Amount;
                    END ELSE
                      CostEntry.CALCSUMS("Credit Amount");
                    ColValue := CostEntry."Credit Amount";
                  END;
                END;
            END;
          END;

          IF ColumnLayout."Ledger Entry Type" = ColumnLayout."Ledger Entry Type"::"Budget Entries" THEN BEGIN
            WITH CostBudgEntry DO BEGIN
              SETCURRENTKEY("Budget Name","Cost Type No.","Cost Center Code","Cost Object Code",Date);

              IF CostType.Totaling = '' THEN
                SETRANGE("Cost Type No.",CostType."No.")
              ELSE
                SETFILTER("Cost Type No.",CostType.Totaling);

              CostType.COPYFILTER("Date Filter",Date);
              AccSchedLine.COPYFILTER("Cost Budget Filter","Budget Name");
              AccSchedLine.COPYFILTER("Cost Center Filter","Cost Center Code");
              AccSchedLine.COPYFILTER("Cost Object Filter","Cost Object Code");

              FILTERGROUP(2);
              SETFILTER("Cost Center Code",GetDimTotalingFilter(5,AccSchedLine."Cost Center Totaling"));
              SETFILTER("Cost Object Code",GetDimTotalingFilter(6,AccSchedLine."Cost Object Totaling"));
              //soft,sn
              FILTERGROUP(6);
              SETFILTER("Cost Center Code",GetDimTotalingFilter(1,ColumnLayout."Dimension 1 Totaling"));
              SETFILTER("Cost Object Code",GetDimTotalingFilter(2,ColumnLayout."Dimension 2 Totaling"));
              //soft,en
              FILTERGROUP(8);
              SETFILTER("Cost Center Code",GetDimTotalingFilter(5,ColumnLayout."Cost Center Totaling"));
              SETFILTER("Cost Object Code",GetDimTotalingFilter(6,ColumnLayout."Cost Object Totaling"));
              FILTERGROUP(0);
            END;

            CostBudgEntry.CALCSUMS(Amount);

            CASE AmountType OF
              AmountType::"Net Amount":
                ColValue := CostBudgEntry.Amount;
              AmountType::"Debit Amount":
                IF CostBudgEntry.Amount > 0 THEN
                  ColValue := CostBudgEntry.Amount;
              AmountType::"Credit Amount":
                IF CostBudgEntry.Amount < 0 THEN
                  ColValue := CostBudgEntry.Amount;
            END;
            Balance := CostBudgEntry.Amount;
            IF CalcAddCurr THEN
              ColValue := CalcLCYToACY(ColValue);
          END;

          IF TestBalance THEN BEGIN
            IF AccSchedLine.Show = AccSchedLine.Show::"When Positive Balance" THEN
              IF Balance < 0 THEN
                EXIT(0);
            IF AccSchedLine.Show = AccSchedLine.Show::"When Negative Balance" THEN
              IF Balance > 0 THEN
                EXIT(0);
          END;
        END;
        EXIT(ColValue);
    end;

    procedure SetCostTypeRowFilters(var CostType : Record "Cost Type";var AccSchedLine2 : Record "Acc. Schedule Line";var ColumnLayout : Record "Column Layout");
    begin
        WITH AccSchedLine2 DO BEGIN
          CASE "Totaling Type" OF
            "Totaling Type"::"Cost Type":
              BEGIN
                CostType.SETFILTER("No.",Totaling);
                CostType.SETRANGE(Type,CostType.Type::"Cost Type");
              END;
            "Totaling Type"::"Cost Type Total":
              BEGIN
                CostType.SETFILTER("No.",Totaling);
                CostType.SETFILTER(Type,'<>%1',CostType.Type::"Cost Type");
              END;
          END;

          CostType.SETFILTER("Cost Center Filter",GETFILTER("Cost Center Filter"));
          CostType.SETFILTER("Cost Object Filter",GETFILTER("Cost Object Filter"));
          IF ColumnLayout."Ledger Entry Type" = ColumnLayout."Ledger Entry Type"::"Budget Entries" THEN
            CostType.SETFILTER("Budget Filter",GETFILTER("Cost Budget Filter"));
        END;
    end;

    procedure SetCostTypeColumnFilters(var CostType : Record "Cost Type";AccSchedLine2 : Record "Acc. Schedule Line";var ColumnLayout : Record "Column Layout");
    var
        FromDate : Date;
        ToDate : Date;
        FiscalStartDate2 : Date;
    begin
        WITH ColumnLayout DO BEGIN
          CalcColumnDates("Comparison Date Formula","Comparison Period Formula",FromDate,ToDate,FiscalStartDate2);
          CASE "Column Type" OF
            "Column Type"::"Net Change":
              CASE AccSchedLine2."Row Type" OF
                AccSchedLine2."Row Type"::"Net Change":
                  CostType.SETRANGE("Date Filter",FromDate,ToDate);
                AccSchedLine2."Row Type"::"Beginning Balance":
                  CostType.SETFILTER("Date Filter",'<%1',FromDate);
                AccSchedLine2."Row Type"::"Balance at Date":
                  CostType.SETRANGE("Date Filter",0D,ToDate);
              END;
            "Column Type"::"Balance at Date":
              IF AccSchedLine2."Row Type" = AccSchedLine2."Row Type"::"Beginning Balance" THEN
                CostType.SETRANGE("Date Filter",0D) // Force a zero return
              ELSE
                CostType.SETRANGE("Date Filter",0D,ToDate);
            "Column Type"::"Beginning Balance":
              IF AccSchedLine2."Row Type" = AccSchedLine2."Row Type"::"Balance at Date" THEN
                CostType.SETRANGE("Date Filter",0D) // Force a zero return
              ELSE
                CostType.SETRANGE(
                  "Date Filter",0D,CALCDATE('<-1D>',FromDate));
            "Column Type"::"Year to Date":
              CASE AccSchedLine2."Row Type" OF
                AccSchedLine2."Row Type"::"Net Change":
                  CostType.SETRANGE("Date Filter",FiscalStartDate2,ToDate);
                AccSchedLine2."Row Type"::"Beginning Balance":
                  CostType.SETFILTER("Date Filter",'<%1',FiscalStartDate2);
                AccSchedLine2."Row Type"::"Balance at Date":
                  CostType.SETRANGE("Date Filter",0D,ToDate);
              END;
            "Column Type"::"Rest of Fiscal Year":
              CASE AccSchedLine2."Row Type" OF
                AccSchedLine2."Row Type"::"Net Change":
                  CostType.SETRANGE(
                    "Date Filter",CALCDATE('<+1D>',ToDate),FindEndOfFiscalYear(FiscalStartDate2));
                AccSchedLine2."Row Type"::"Beginning Balance":
                  CostType.SETRANGE("Date Filter",0D,ToDate);
                AccSchedLine2."Row Type"::"Balance at Date":
                  CostType.SETRANGE("Date Filter",0D,FindEndOfFiscalYear(ToDate));
              END;
            "Column Type"::"Entire Fiscal Year":
              CASE AccSchedLine2."Row Type" OF
                AccSchedLine2."Row Type"::"Net Change":
                  CostType.SETRANGE(
                    "Date Filter",FiscalStartDate2,FindEndOfFiscalYear(FiscalStartDate2));
                AccSchedLine2."Row Type"::"Beginning Balance":
                  CostType.SETFILTER("Date Filter",'<%1',FiscalStartDate2);
                AccSchedLine2."Row Type"::"Balance at Date":
                  CostType.SETRANGE("Date Filter",0D,FindEndOfFiscalYear(ToDate));
              END;
          END;
        END;
    end;

    local procedure HasDimFilter(var AccSchedLine : Record "Acc. Schedule Line";var ColumnLayout : Record "Column Layout") : Boolean;
    begin
        EXIT((AccSchedLine."Dimension 1 Totaling" <> '') OR
          (AccSchedLine."Dimension 2 Totaling" <> '') OR
          (AccSchedLine."Dimension 3 Totaling" <> '') OR
          (AccSchedLine."Dimension 4 Totaling" <> '') OR
          (AccSchedLine.GETFILTER("Dimension 1 Filter") <> '') OR
          (AccSchedLine.GETFILTER("Dimension 2 Filter") <> '') OR
          (AccSchedLine.GETFILTER("Dimension 3 Filter") <> '') OR
          (AccSchedLine.GETFILTER("Dimension 4 Filter") <> '') OR
          (ColumnLayout."Dimension 1 Totaling" <> '') OR
          (ColumnLayout."Dimension 2 Totaling" <> '') OR
          (ColumnLayout."Dimension 3 Totaling" <> '') OR
          (ColumnLayout."Dimension 4 Totaling" <> '') OR
          (ColumnLayout."Cost Center Totaling" <> '') OR
          (ColumnLayout."Cost Object Totaling" <> ''));
    end;

    local procedure HasCostDimFilter(var AccSchedLine : Record "Acc. Schedule Line") : Boolean;
    begin
        EXIT((AccSchedLine."Cost Center Totaling" <> '') OR
          (AccSchedLine."Cost Object Totaling" <> '') OR
          (AccSchedLine.GETFILTER("Cost Center Filter") <> '') OR
          (AccSchedLine.GETFILTER("Cost Object Filter") <> ''));
    end;

    procedure CalcColumnDates(ComparisonDateFormula : DateFormula;ComparisonPeriodFormula : Code[20];var FromDate : Date;var ToDate : Date;var FiscalStartDate2 : Date);
    begin
        IF (FORMAT(ComparisonDateFormula) <> '0') AND (FORMAT(ComparisonDateFormula) <> '') THEN BEGIN
          FromDate := CALCDATE(ComparisonDateFormula,StartDate);
          ToDate := CALCDATE(ComparisonDateFormula,EndDate);
          IF (StartDate = CALCDATE('<-CM>',StartDate)) AND
             (FromDate = CALCDATE('<-CM>',FromDate)) AND
             (EndDate = CALCDATE('<CM>',EndDate))
          THEN
            ToDate := CALCDATE('<CM>',ToDate);
          FiscalStartDate2 := FindFiscalYear(ToDate);
        END ELSE
          IF ComparisonPeriodFormula <> '' THEN BEGIN
            AccPeriodStartEnd(ComparisonPeriodFormula,StartDate,FromDate,ToDate);
            FiscalStartDate2 := FindFiscalYear(ToDate);
          END ELSE BEGIN
            FromDate := StartDate;
            ToDate := EndDate;
            FiscalStartDate2 := FiscalStartDate;
          END;
    end;

    local procedure MoveAccSchedLines(var AccSchedLine : Record "Acc. Schedule Line";Place : Integer);
    var
        AccSchedLineNo : Integer;
        I : Integer;
    begin
        AccSchedLineNo := AccSchedLine."Line No.";
        AccSchedLine.SETRANGE("Schedule Name",AccSchedLine."Schedule Name");
        IF AccSchedLine.FIND('+') THEN
          REPEAT
            I := AccSchedLine."Line No.";
            IF I > AccSchedLineNo THEN BEGIN
              AccSchedLine.DELETE;
              AccSchedLine."Line No." := I + 10000 * Place;
              AccSchedLine.INSERT;
            END;
          UNTIL (I <= AccSchedLineNo) OR (AccSchedLine.NEXT(-1) = 0);
    end;

    procedure SetStartDateEndDate(NewStartDate : Date;NewEndDate : Date);
    begin
        StartDate := NewStartDate;
        EndDate := NewEndDate;
    end;

    local procedure ConflictAmountType(AccSchedLine : Record "Acc. Schedule Line";ColumnLayoutAmtType : Option "Net Amount","Debit Amount","Credit Amount",,,,,,"Debit Balance","Credit Balance";var AmountType : Option) : Boolean;
    begin
        IF (ColumnLayoutAmtType = AccSchedLine."Amount Type") OR
           (AccSchedLine."Amount Type" = AccSchedLine."Amount Type"::"Net Amount")
        THEN
          AmountType := ColumnLayoutAmtType
        ELSE
          IF ColumnLayoutAmtType = ColumnLayoutAmtType::"Net Amount" THEN
            AmountType := AccSchedLine."Amount Type"
          ELSE
            EXIT(TRUE);
        EXIT(FALSE);
    end;

    procedure DrillDown(TempColumnLayout : Record "Column Layout" temporary;var AccScheduleLine : Record "Acc. Schedule Line";PeriodLength : Option);
    var
        AccScheduleOverview : Page "Acc. Schedule Overview";
        ErrorType : Option "None","Division by Zero","Period Error",Both;
    begin
        WITH AccScheduleLine DO BEGIN
          IF TempColumnLayout."Column Type" = TempColumnLayout."Column Type"::Formula THEN BEGIN
            CalcFieldError(ErrorType,"Line No.",TempColumnLayout."Line No.");
            IF ErrorType <> ErrorType::None THEN
              MESSAGE(STRSUBSTNO(ColumnFormulaErrorMsg,TempColumnLayout.Formula,FORMAT(ErrorType)))
            ELSE
              MESSAGE(ColumnFormulaMsg,TempColumnLayout.Formula);
            EXIT;
          END;

          IF "Totaling Type" IN ["Totaling Type"::Formula,"Totaling Type"::"Set Base For Percent"] THEN BEGIN
            MESSAGE(RowFormulaMsg,Totaling);
            EXIT;
          END;

          IF Totaling = '' THEN
            EXIT;

          IF "Totaling Type" IN ["Totaling Type"::"Cash Flow Entry Accounts","Totaling Type"::"Cash Flow Total Accounts"] THEN
            DrillDownOnCFAccount(TempColumnLayout,AccScheduleLine)
          ELSE
            DrillDownOnGLAccount(TempColumnLayout,AccScheduleLine);
        END;
    end;

    procedure DrillDownFromOverviewPage(TempColumnLayout : Record "Column Layout" temporary;var AccScheduleLine : Record "Acc. Schedule Line";PeriodLength : Option);
    begin
        WITH AccScheduleLine DO BEGIN
          IF "Totaling Type" IN ["Totaling Type"::Formula,"Totaling Type"::"Set Base For Percent"] THEN
            MESSAGE(RowFormulaMsg,Totaling)
          ELSE
            DrillDown(TempColumnLayout,AccScheduleLine,PeriodLength);
        END;
    end;

    local procedure DrillDownOnGLAccount(TempColumnLayout : Record "Column Layout" temporary;var AccScheduleLine : Record "Acc. Schedule Line");
    var
        GLAcc : Record "G/L Account";
        GLAccAnalysisView : Record "G/L Account (Analysis View)";
        CostType : Record "Cost Type";
        ChartOfAccsAnalysisView : Page "Chart of Accs. (Analysis View)";
    begin
        WITH AccScheduleLine DO
          IF "Totaling Type" IN ["Totaling Type"::"Cost Type","Totaling Type"::"Cost Type Total"] THEN BEGIN
            SetCostTypeRowFilters(CostType,AccScheduleLine,TempColumnLayout);
            SetCostTypeColumnFilters(CostType,AccScheduleLine,TempColumnLayout);
            COPYFILTER("Cost Center Filter",CostType."Cost Center Filter");
            COPYFILTER("Cost Object Filter",CostType."Cost Object Filter");
            COPYFILTER("Cost Budget Filter",CostType."Budget Filter");
            CostType.FILTERGROUP(2);
            CostType.SETFILTER("Cost Center Filter",GetDimTotalingFilter(1,"Cost Center Totaling"));
            CostType.SETFILTER("Cost Object Filter",GetDimTotalingFilter(1,"Cost Object Totaling"));
            CostType.FILTERGROUP(8);
            CostType.SETFILTER("Cost Center Filter",GetDimTotalingFilter(1,TempColumnLayout."Cost Center Totaling"));
            CostType.SETFILTER("Cost Object Filter",GetDimTotalingFilter(1,TempColumnLayout."Cost Object Totaling"));
            CostType.FILTERGROUP(0);
            PAGE.RUN(PAGE::"Chart of Cost Types",CostType);
          END ELSE BEGIN
            COPYFILTER("Business Unit Filter",GLAcc."Business Unit Filter");
            COPYFILTER("G/L Budget Filter",GLAcc."Budget Filter");
            SetGLAccRowFilters(GLAcc,AccScheduleLine,TempColumnLayout);
            SetGLAccColumnFilters(GLAcc,AccScheduleLine,TempColumnLayout);
            AccSchedName.GET("Schedule Name");
            IF AccSchedName."Analysis View Name" = '' THEN BEGIN
              COPYFILTER("Dimension 1 Filter",GLAcc."Global Dimension 1 Filter");
              COPYFILTER("Dimension 2 Filter",GLAcc."Global Dimension 2 Filter");
              COPYFILTER("Business Unit Filter",GLAcc."Business Unit Filter");
              GLAcc.FILTERGROUP(2);
              GLAcc.SETFILTER("Global Dimension 1 Filter",GetDimTotalingFilter(1,"Dimension 1 Totaling"));
              GLAcc.SETFILTER("Global Dimension 2 Filter",GetDimTotalingFilter(2,"Dimension 2 Totaling"));
              GLAcc.FILTERGROUP(8);
              GLAcc.SETFILTER("Business Unit Filter",TempColumnLayout."Business Unit Totaling");
              GLAcc.SETFILTER("Global Dimension 1 Filter",GetDimTotalingFilter(1,TempColumnLayout."Dimension 1 Totaling"));
              GLAcc.SETFILTER("Global Dimension 2 Filter",GetDimTotalingFilter(2,TempColumnLayout."Dimension 2 Totaling"));
              GLAcc.FILTERGROUP(0);
              PAGE.RUN(PAGE::"Chart of Accounts (G/L)",GLAcc)
            END ELSE BEGIN
              GLAcc.COPYFILTER("Date Filter",GLAccAnalysisView."Date Filter");
              GLAcc.COPYFILTER("Budget Filter",GLAccAnalysisView."Budget Filter");
              GLAcc.COPYFILTER("Business Unit Filter",GLAccAnalysisView."Business Unit Filter");
              GLAccAnalysisView.SETRANGE("Analysis View Filter",AccSchedName."Analysis View Name");
              GLAccAnalysisView.CopyDimFilters(AccScheduleLine);
              GLAccAnalysisView.FILTERGROUP(2);
              GLAccAnalysisView.SetDimFilters(
                GetDimTotalingFilter(1,"Dimension 1 Totaling"),GetDimTotalingFilter(2,"Dimension 2 Totaling"),
                GetDimTotalingFilter(3,"Dimension 3 Totaling"),GetDimTotalingFilter(4,"Dimension 4 Totaling"));
              GLAccAnalysisView.FILTERGROUP(8);
              GLAccAnalysisView.SetDimFilters(
                GetDimTotalingFilter(1,TempColumnLayout."Dimension 1 Totaling"),
                GetDimTotalingFilter(2,TempColumnLayout."Dimension 2 Totaling"),
                GetDimTotalingFilter(3,TempColumnLayout."Dimension 3 Totaling"),
                GetDimTotalingFilter(4,TempColumnLayout."Dimension 4 Totaling"));
              GLAccAnalysisView.SETFILTER("Business Unit Filter",TempColumnLayout."Business Unit Totaling");
              GLAccAnalysisView.FILTERGROUP(0);
              CLEAR(ChartOfAccsAnalysisView);
              ChartOfAccsAnalysisView.InsertTempGLAccAnalysisViews(GLAcc);
              ChartOfAccsAnalysisView.SETTABLEVIEW(GLAccAnalysisView);
              ChartOfAccsAnalysisView.RUN;
            END;
          END;
    end;

    local procedure DrillDownOnCFAccount(TempColumnLayout : Record "Column Layout" temporary;var AccScheduleLine : Record "Acc. Schedule Line");
    var
        CFAccount : Record 841;
        GLAccAnalysisView : Record "G/L Account (Analysis View)";
        ChartOfAccsAnalysisView : Page "Chart of Accs. (Analysis View)";
    begin
        WITH AccScheduleLine DO BEGIN
          COPYFILTER("Cash Flow Forecast Filter",CFAccount."Cash Flow Forecast Filter");

          SetCFAccRowFilter(CFAccount,AccScheduleLine);
          SetCFAccColumnFilter(CFAccount,AccScheduleLine,TempColumnLayout);
          AccSchedName.GET("Schedule Name");
          IF AccSchedName."Analysis View Name" = '' THEN BEGIN
            COPYFILTER("Dimension 1 Filter",CFAccount."Global Dimension 1 Filter");
            COPYFILTER("Dimension 2 Filter",CFAccount."Global Dimension 2 Filter");
            CFAccount.FILTERGROUP(2);
            CFAccount.SETFILTER("Global Dimension 1 Filter",GetDimTotalingFilter(1,"Dimension 1 Totaling"));
            CFAccount.SETFILTER("Global Dimension 2 Filter",GetDimTotalingFilter(2,"Dimension 2 Totaling"));
            CFAccount.FILTERGROUP(8);
            CFAccount.SETFILTER("Global Dimension 1 Filter",GetDimTotalingFilter(1,TempColumnLayout."Dimension 1 Totaling"));
            CFAccount.SETFILTER("Global Dimension 2 Filter",GetDimTotalingFilter(2,TempColumnLayout."Dimension 2 Totaling"));
            CFAccount.FILTERGROUP(0);
            PAGE.RUN(PAGE::"Chart of Cash Flow Accounts",CFAccount)
          END ELSE BEGIN
            CFAccount.COPYFILTER("Date Filter",GLAccAnalysisView."Date Filter");
            CFAccount.COPYFILTER("Cash Flow Forecast Filter",GLAccAnalysisView."Cash Flow Forecast Filter");
            GLAccAnalysisView.SETRANGE("Analysis View Filter",AccSchedName."Analysis View Name");
            GLAccAnalysisView.CopyDimFilters(AccScheduleLine);
            GLAccAnalysisView.FILTERGROUP(2);
            GLAccAnalysisView.SetDimFilters(
              GetDimTotalingFilter(1,"Dimension 1 Totaling"),
              GetDimTotalingFilter(2,"Dimension 2 Totaling"),
              GetDimTotalingFilter(3,"Dimension 3 Totaling"),
              GetDimTotalingFilter(4,"Dimension 4 Totaling"));
            GLAccAnalysisView.FILTERGROUP(8);
            GLAccAnalysisView.SetDimFilters(
              GetDimTotalingFilter(1,TempColumnLayout."Dimension 1 Totaling"),
              GetDimTotalingFilter(2,TempColumnLayout."Dimension 2 Totaling"),
              GetDimTotalingFilter(3,TempColumnLayout."Dimension 3 Totaling"),
              GetDimTotalingFilter(4,TempColumnLayout."Dimension 4 Totaling"));
            GLAccAnalysisView.FILTERGROUP(0);
            CLEAR(ChartOfAccsAnalysisView);
            ChartOfAccsAnalysisView.InsertTempCFAccountAnalysisVie(CFAccount);
            ChartOfAccsAnalysisView.SETTABLEVIEW(GLAccAnalysisView);
            ChartOfAccsAnalysisView.RUN;
          END;
        END;
    end;

    procedure FindPeriod(var AccScheduleLine : Record "Acc. Schedule Line";SearchText : Text[3];PeriodType : Option Day,Week,Month,Quarter,Year,"Accounting Period");
    var
        Calendar : Record 2000000007;
        PeriodFormMgt : Codeunit PeriodFormManagement;
    begin
        WITH AccScheduleLine DO BEGIN
          IF GETFILTER("Date Filter") <> '' THEN BEGIN
            Calendar.SETFILTER("Period Start",GETFILTER("Date Filter"));
            IF NOT PeriodFormMgt.FindDate('+',Calendar,PeriodType) THEN
              PeriodFormMgt.FindDate('+',Calendar,PeriodType::Day);
            Calendar.SETRANGE("Period Start");
          END;
          PeriodFormMgt.FindDate(SearchText,Calendar,PeriodType);
          SETRANGE("Date Filter",Calendar."Period Start",Calendar."Period End");
          IF GETRANGEMIN("Date Filter") = GETRANGEMAX("Date Filter") THEN
            SETRANGE("Date Filter",GETRANGEMIN("Date Filter"));
        END;
    end;

    procedure CalcFieldError(var ErrorType : Option "None","Division by Zero","Period Error",Both;RowNo : Integer;ColumnNo : Integer);
    begin
        AccSchedCellValue.SETRANGE("Row No.",RowNo);
        AccSchedCellValue.SETRANGE("Column No.",ColumnNo);
        ErrorType := ErrorType::None;
        IF AccSchedCellValue.FINDFIRST THEN
          CASE TRUE OF
            AccSchedCellValue."Has Error":
              ErrorType := ErrorType::"Division by Zero";
            AccSchedCellValue."Period Error":
              ErrorType := ErrorType::"Period Error";
            AccSchedCellValue."Has Error" AND AccSchedCellValue."Period Error":
              ErrorType := ErrorType::Both;
          END;

        AccSchedCellValue.SETRANGE("Row No.");
        AccSchedCellValue.SETRANGE("Column No.");
    end;

    procedure ForceRecalculate(NewRecalculate : Boolean);
    begin
        Recalculate := NewRecalculate;
    end;

    local procedure CalcLCYToACY(ColValue : Decimal) : Decimal;
    begin
        IF NOT GLSetupRead THEN BEGIN
          GLSetup.GET;
          GLSetupRead := TRUE;
          IF GLSetup."Additional Reporting Currency" <> '' THEN
            AddRepCurrency.GET(GLSetup."Additional Reporting Currency");
        END;
        IF GLSetup."Additional Reporting Currency" <> '' THEN
          EXIT(ROUND(ExchangeAmtAddCurrToLCY(ColValue),AddRepCurrency."Amount Rounding Precision"));
        EXIT(0);
    end;

    procedure InitPrintAmountsInAddCurrency(Value : Boolean);
    begin
        //soft,sn
        PrintAmountsInAddCurrency := Value;
        //soft,en
    end;

    // procedure SetHistoricGLAccRowFilters(var HistoricGLAcc : Record "31022909";var AccSchedLine2 : Record "85";var AccSchedColumn : Record "334");
    // begin
    //     //soft,sn
    //     WITH AccSchedLine2 DO BEGIN
    //       CASE "Totaling Type" OF
    //         "Totaling Type"::"Posting Accounts":
    //         BEGIN
    //           IF AccSchedColumn.Ref = AccSchedColumn.Ref::"1" THEN
    //              HistoricGLAcc.SETFILTER("No.",Totaling)
    //           ELSE
    //              HistoricGLAcc.SETFILTER("No.","Totaling 2");
    //           HistoricGLAcc.SETRANGE("Account Type",HistoricGLAcc."Account Type"::Posting);
    //         END;
    //         "Totaling Type"::"Total Accounts":
    //         BEGIN
    //           IF AccSchedColumn.Ref = AccSchedColumn.Ref::"1" THEN
    //              HistoricGLAcc.SETFILTER("No.",Totaling)
    //           ELSE
    //              HistoricGLAcc.SETFILTER("No.","Totaling 2");
    //           HistoricGLAcc.SETFILTER("Account Type",'<>%1',HistoricGLAcc."Account Type"::Posting);
    //         END;
    //       END;
    //     END;
    // end;

    // procedure SetHistoricGLAccColumnFilters(var HistoricGLAcc : Record "31022909";AccSchedLine2 : Record "85";var ColumnLayout : Record "334");
    // var
    //     FromDate : Date;
    //     ToDate : Date;
    //     FiscalStartDate2 : Date;
    // begin
    //     //soft,sn
    //     WITH ColumnLayout DO BEGIN
    //       IF (FORMAT("Comparison Date Formula") <> '0') AND (FORMAT("Comparison Date Formula") <> '') THEN BEGIN
    //         FromDate := CALCDATE("Comparison Date Formula",StartDate);
    //         IF (EndDate = CALCDATE('<CM>',EndDate)) AND
    //            ((STRPOS(FORMAT("Comparison Date Formula"),Text31022890) > 0) OR
    //             (STRPOS(FORMAT("Comparison Date Formula"),Text31022891) > 0) OR
    //             (STRPOS(FORMAT("Comparison Date Formula"),Text31022892) > 0))
    //     THEN
    //           ToDate := CALCDATE('<CM>',CALCDATE("Comparison Date Formula",EndDate))
    //         ELSE
    //           ToDate := CALCDATE("Comparison Date Formula",EndDate);
    //         FiscalStartDate2 := FindFiscalYear(ToDate);
    //       END ELSE IF "Comparison Period Formula" <> '' THEN BEGIN
    //         AccPeriodStartEnd("Comparison Period Formula",StartDate,FromDate,ToDate);
    //         FiscalStartDate2 := FindFiscalYear(ToDate);
    //       END ELSE BEGIN
    //         FromDate := StartDate;
    //         ToDate := EndDate;
    //         FiscalStartDate2 := FiscalStartDate;
    //       END;
    //       CASE "Column Type" OF
    //         "Column Type"::"Net Change" :
    //           CASE AccSchedLine2."Row Type" OF
    //             AccSchedLine2."Row Type"::"Net Change":
    //               HistoricGLAcc.SETRANGE("Date Filter",FromDate,ToDate);
    //             AccSchedLine2."Row Type"::"Beginning Balance":
    //               HistoricGLAcc.SETFILTER("Date Filter",'<%1',FromDate);  // always includes closing date
    //             AccSchedLine2."Row Type"::"Balance at Date":
    //               HistoricGLAcc.SETRANGE("Date Filter",0D,ToDate);
    //           END;
    //         "Column Type"::"Balance at Date" :
    //           IF AccSchedLine2."Row Type" = AccSchedLine2."Row Type"::"Beginning Balance" THEN
    //             HistoricGLAcc.SETRANGE("Date Filter",0D)   // Force a zero return
    //     ELSE
    //             HistoricGLAcc.SETRANGE("Date Filter",0D,ToDate);
    //         "Column Type"::"Beginning Balance" :
    //           IF AccSchedLine2."Row Type" = AccSchedLine2."Row Type"::"Balance at Date" THEN
    //             HistoricGLAcc.SETRANGE("Date Filter",0D)   // Force a zero return
    //       ELSE
    //             HistoricGLAcc.SETRANGE(
    //               "Date Filter",0D,CLOSINGDATE(FromDate-1));
    //         "Column Type"::"Year to Date" :
    //           CASE AccSchedLine2."Row Type" OF
    //             AccSchedLine2."Row Type"::"Net Change":
    //               HistoricGLAcc.SETRANGE("Date Filter",FiscalStartDate2,ToDate);
    //             AccSchedLine2."Row Type"::"Beginning Balance":
    //               HistoricGLAcc.SETFILTER("Date Filter",'<%1',FiscalStartDate2);  // always includes closing date
    //             AccSchedLine2."Row Type"::"Balance at Date":
    //               HistoricGLAcc.SETRANGE("Date Filter",0D,ToDate);
    //           END;
    //         "Column Type"::"Rest of Fiscal Year" :
    //           CASE AccSchedLine2."Row Type" OF
    //             AccSchedLine2."Row Type"::"Net Change":
    //               HistoricGLAcc.SETRANGE(
    //                 "Date Filter",CALCDATE('<+1D>',ToDate),FindEndOfFiscalYear(FiscalStartDate2));
    //             AccSchedLine2."Row Type"::"Beginning Balance":
    //               HistoricGLAcc.SETRANGE("Date Filter",0D,ToDate);
    //             AccSchedLine2."Row Type"::"Balance at Date":
    //               HistoricGLAcc.SETRANGE("Date Filter",0D,FindEndOfFiscalYear(ToDate));
    //           END;
    //         "Column Type"::"Entire Fiscal Year" :
    //           CASE AccSchedLine2."Row Type" OF
    //             AccSchedLine2."Row Type"::"Net Change":
    //               HistoricGLAcc.SETRANGE(
    //                 "Date Filter",
    //                 FiscalStartDate2,
    //                 FindEndOfFiscalYear(FiscalStartDate2));
    //             AccSchedLine2."Row Type"::"Beginning Balance":
    //               HistoricGLAcc.SETFILTER("Date Filter",'<%1',FiscalStartDate2);  // always includes closing date
    //             AccSchedLine2."Row Type"::"Balance at Date":
    //               HistoricGLAcc.SETRANGE("Date Filter",0D,FindEndOfFiscalYear(ToDate));
    //           END;
    //       END;
    //     END;
    //     //soft,en
    // end;

    // local procedure CalcHistoricGLAcc(var HistoricGLAcc : Record "31022909";var AccSchedLine : Record "85";var ColumnLayout : Record "334";CalcAddCurr : Boolean) ColValue : Decimal;
    // var
    //     GLEntry : Record "17";
    //     GLBudgEntry : Record "96";
    //     AnalysisViewEntry : Record "365";
    //     AnalysisViewBudgetEntry : Record "366";
    //     AmountType : Option "Net Amount","Debit Amount","Credit Amount",,,,,,"Debit Balance","Credit Balance";
    //     TestBalance : Boolean;
    //     Balance : Decimal;
    //     UseBusUnitFilter : Boolean;
    //     UseDimFilter : Boolean;
    //     AnalysisViewEntry1 : Record "365";
    //     AmountType2 : Option "Net Amount","Debit Amount","Credit Amount",,,,,,"Debit Balance","Credit Balance";
    //     AmountType3 : Option "Net Amount","Debit Amount","Credit Amount",,,,,,"Debit Balance","Credit Balance";
    // begin
    //     //soft,sn
    //     ColValue := 0;
    //     IF AccSchedName.Name <> AccSchedLine."Schedule Name" THEN
    //       AccSchedName.GET(AccSchedLine."Schedule Name");
    //     AmountType :=  ColumnLayout."Amount Type";
    //     AmountType2 :=  ColumnLayout."Amount Type 2";
    //     AmountType3 :=  ColumnLayout."Amount Type 3";
    //     CASE AccSchedLine."Amount Type" OF
    //       AccSchedLine."Amount Type"::"Debit Amount":
    //         CASE AmountType OF
    //           AmountType::"Net Amount":
    //             AmountType := AmountType::"Debit Amount";
    //           AmountType::"Credit Amount":
    //             EXIT(0);
    //       END;
    //       AccSchedLine."Amount Type"::"Credit Amount":
    //         CASE AmountType OF
    //           AmountType::"Net Amount":
    //             AmountType := AmountType::"Credit Amount";
    //           AmountType::"Debit Amount":
    //             EXIT(0);
    //         END;
    //       END;
    //     TestBalance :=
    //       AccSchedLine.Show IN [AccSchedLine.Show::"When Positive Balance",AccSchedLine.Show::"When Negative Balance"];
    //     IF ColumnLayout."Column Type" <> ColumnLayout."Column Type"::Formula THEN BEGIN
    //       UseBusUnitFilter := (AccSchedLine.GETFILTER("Business Unit Filter") <> '') OR (ColumnLayout."Business Unit Totaling" <> '');
    //       UseDimFilter :=
    //         (AccSchedLine."Dimension 1 Totaling" <> '') OR
    //         (AccSchedLine."Dimension 2 Totaling" <> '') OR
    //         (AccSchedLine."Dimension 3 Totaling" <> '') OR
    //         (AccSchedLine."Dimension 4 Totaling" <> '') OR
    //         (AccSchedLine.GETFILTER("Dimension 1 Filter") <> '') OR
    //         (AccSchedLine.GETFILTER("Dimension 2 Filter") <> '') OR
    //         (AccSchedLine.GETFILTER("Dimension 3 Filter") <> '') OR
    //         (AccSchedLine.GETFILTER("Dimension 4 Filter") <> '') OR
    //         (ColumnLayout."Dimension 1 Totaling" <> '') OR
    //         (ColumnLayout."Dimension 2 Totaling" <> '') OR
    //         (ColumnLayout."Dimension 3 Totaling" <> '') OR
    //         (ColumnLayout."Dimension 4 Totaling" <> '');
    //        CASE ColumnLayout."Ledger Entry Type" OF
    //         ColumnLayout."Ledger Entry Type"::Entries :
    //           BEGIN
    //             IF AccSchedName."Analysis View Name" = '' THEN
    //               WITH GLEntry DO BEGIN
    //                 IF UseBusUnitFilter THEN
    //                   IF UseDimFilter THEN
    //                     SETCURRENTKEY(
    //                       "Old G/L Account No.","Business Unit Code","Global Dimension 1 Code","Global Dimension 2 Code")
    //                   ELSE
    //                     SETCURRENTKEY(
    //                       "Old G/L Account No.","Business Unit Code","Posting Date")
    //                 ELSE
    //                   IF UseDimFilter THEN
    //                     SETCURRENTKEY("Old G/L Account No.","Global Dimension 1 Code","Global Dimension 2 Code")
    //                   ELSE
    //                     SETCURRENTKEY("Old G/L Account No.","Posting Date");
    //                 IF HistoricGLAcc.Totaling = '' THEN
    //                   SETRANGE("Old G/L Account No.",HistoricGLAcc."No.")
    //                 ELSE
    //                   SETFILTER("Old G/L Account No.",HistoricGLAcc.Totaling);
    //                 HistoricGLAcc.COPYFILTER("Date Filter","Posting Date");
    //                 AccSchedLine.COPYFILTER("Business Unit Filter","Business Unit Code");
    //                 AccSchedLine.COPYFILTER("Dimension 1 Filter","Global Dimension 1 Code");
    //                 AccSchedLine.COPYFILTER("Dimension 2 Filter","Global Dimension 2 Code");
    //                 FILTERGROUP(2);
    //                 SETFILTER("Global Dimension 1 Code",GetDimTotalingFilter(1,AccSchedLine."Dimension 1 Totaling"));
    //                 SETFILTER("Global Dimension 2 Code",GetDimTotalingFilter(2,AccSchedLine."Dimension 2 Totaling"));
    //                 FILTERGROUP(6);
    //                 SETFILTER("Global Dimension 1 Code",GetDimTotalingFilter(1,ColumnLayout."Dimension 1 Totaling"));
    //                 SETFILTER("Global Dimension 2 Code",GetDimTotalingFilter(2,ColumnLayout."Dimension 2 Totaling"));
    //                 SETFILTER("Business Unit Code",ColumnLayout."Business Unit Totaling");
    //                 FILTERGROUP(0);

    //                 CASE TRUE OF
    //                   ((AmountType = AmountType::"Net Amount") AND (AccSchedLine."Column Value" = 0)) OR
    //                   ((AmountType2 = AmountType2::"Net Amount") AND (AccSchedLine."Column Value" = 1)) OR
    //                   ((AmountType3 = AmountType3::"Net Amount") AND (AccSchedLine."Column Value" = 2)):
    //                     BEGIN
    //                       IF CalcAddCurr THEN BEGIN
    //                         CALCSUMS("Additional-Currency Amount");
    //                         ColValue := "Additional-Currency Amount";
    //                       END ELSE BEGIN
    //                         CALCSUMS(Amount);
    //                         ColValue := Amount;
    //                       END;
    //                       Balance := ColValue;
    //                     END;
    //                     ((AmountType = AmountType::"Debit Amount") AND (AccSchedLine."Column Value" = 0)) OR
    //                     ((AmountType2 = AmountType2::"Debit Amount") AND (AccSchedLine."Column Value" = 1)) OR
    //                     ((AmountType3 = AmountType3::"Debit Amount") AND (AccSchedLine."Column Value" = 2)):
    //                     BEGIN
    //                       IF CalcAddCurr THEN BEGIN
    //                         IF TestBalance THEN BEGIN
    //                           CALCSUMS("Add.-Currency Debit Amount","Additional-Currency Amount");
    //                           Balance := "Additional-Currency Amount";
    //                         END ELSE
    //                           CALCSUMS("Add.-Currency Debit Amount");
    //                         ColValue := "Add.-Currency Debit Amount";
    //                       END ELSE BEGIN
    //                         IF TestBalance THEN BEGIN
    //                           CALCSUMS("Debit Amount",Amount);
    //                           Balance := Amount;
    //                         END ELSE
    //                           CALCSUMS("Debit Amount");
    //                         ColValue := "Debit Amount";
    //                       END;
    //                     END;
    //                     ((AmountType = AmountType::"Credit Amount") AND (AccSchedLine."Column Value" = 0)) OR
    //                     ((AmountType2 = AmountType2::"Credit Amount") AND (AccSchedLine."Column Value" = 1)) OR
    //                     ((AmountType3 = AmountType3::"Credit Amount") AND (AccSchedLine."Column Value" = 2)):
    //                     BEGIN
    //                       IF CalcAddCurr THEN BEGIN
    //                         IF TestBalance THEN BEGIN
    //                           CALCSUMS("Add.-Currency Credit Amount","Additional-Currency Amount");
    //                           Balance := "Additional-Currency Amount";
    //                         END ELSE
    //                           CALCSUMS("Add.-Currency Credit Amount");
    //                         ColValue := "Add.-Currency Credit Amount";
    //                       END ELSE BEGIN
    //                         IF TestBalance THEN BEGIN
    //                           CALCSUMS("Credit Amount",Amount);
    //                           Balance := Amount;
    //                         END ELSE
    //                           CALCSUMS("Credit Amount");
    //                         ColValue := "Credit Amount";
    //                       END;
    //                     END;
    //                     ((AmountType = AmountType::"Debit Balance") AND (AccSchedLine."Column Value" = 0)) OR
    //                     ((AmountType2 = AmountType2::"Debit Balance") AND (AccSchedLine."Column Value" = 1)) OR
    //                     ((AmountType3 = AmountType3::"Debit Balance") AND (AccSchedLine."Column Value" = 2)):
    //                       BEGIN
    //                         HistoricGlAcc1 := HistoricGLAcc;
    //                         HistoricGlAcc1.COPYFILTERS(HistoricGLAcc);
    //                         //SS.10.00.03.01,sn
    //                         HistoricGlAcc1.SETFILTER("No.",HistoricGLAcc.Totaling);
    //                         HistoricGlAcc1.SETFILTER("Global Dimension 1 Filter",GLEntry.GETFILTER("Global Dimension 1 Code"));
    //                         HistoricGlAcc1.SETFILTER("Global Dimension 2 Filter",GLEntry.GETFILTER("Global Dimension 2 Code"));
    //                         IF AccSchedLine."Totaling Type" = AccSchedLine."Totaling Type"::"Total Accounts" THEN BEGIN
    //                           HistoricGlAcc1.SETRANGE("Account Type",GlAcc1."Account Type"::Total);
    //                           IF PrintAmountsInAddCurrency THEN BEGIN
    //                               HistoricGlAcc1.CALCFIELDS("Additional-Currency Net Change");
    //                               IF HistoricGlAcc1."Net Change" > 0 THEN
    //                                 ColValue := HistoricGlAcc1."Additional-Currency Net Change";
    //                             END ELSE BEGIN
    //                               HistoricGlAcc1.CALCFIELDS("Net Change");
    //                               IF HistoricGlAcc1."Net Change" > 0 THEN
    //                                 ColValue := HistoricGlAcc1."Net Change";
    //                             END;
    //                         END ELSE BEGIN
    //                         //SS.10.00.03.01,en
    //                           HistoricGlAcc1.SETRANGE("Account Type",HistoricGlAcc1."Account Type"::Posting);
    //                           //SS.10.00.03.01,so
    //                           //HistoricGlAcc1.SETFILTER("No.",HistoricGLAcc.Totaling);
    //                           //HistoricGlAcc1.SETFILTER("Global Dimension 1 Filter",GLEntry.GETFILTER("Global Dimension 1 Code"));
    //                           //HistoricGlAcc1.SETFILTER("Global Dimension 2 Filter",GLEntry.GETFILTER("Global Dimension 2 Code"));
    //                           //SS.10.00.03.01,eo
    //                           IF NOT HistoricGlAcc1.ISEMPTY THEN BEGIN
    //                             HistoricGlAcc1.FINDSET;
    //                             REPEAT
    //                               IF PrintAmountsInAddCurrency THEN BEGIN
    //                                 HistoricGlAcc1.CALCFIELDS("Additional-Currency Net Change");
    //                                 IF HistoricGlAcc1."Net Change" > 0 THEN
    //                                   ColValue := ColValue + HistoricGlAcc1."Additional-Currency Net Change";
    //                               END ELSE BEGIN
    //                                 HistoricGlAcc1.CALCFIELDS("Net Change");
    //                                 IF HistoricGlAcc1."Net Change" > 0 THEN
    //                                   ColValue := ColValue + HistoricGlAcc1."Net Change";
    //                               END;
    //                             UNTIL HistoricGlAcc1.NEXT = 0;
    //                           END;
    //                         END; //SS.10.00.03.01,n
    //                       END;

    //                     ((AmountType = AmountType::"Credit Balance") AND (AccSchedLine."Column Value" = 0)) OR
    //                     ((AmountType2 = AmountType2::"Credit Balance") AND (AccSchedLine."Column Value" = 1)) OR
    //                     ((AmountType3 = AmountType3::"Credit Balance") AND (AccSchedLine."Column Value" = 2)):
    //                       BEGIN
    //                         HistoricGlAcc1 := HistoricGLAcc;
    //                         HistoricGlAcc1.COPYFILTERS(HistoricGLAcc);
    //                         //SS.10.00.03.01,sn
    //                         HistoricGlAcc1.SETFILTER("No.",HistoricGLAcc.Totaling);
    //                         HistoricGlAcc1.SETFILTER("Global Dimension 1 Filter",GLEntry.GETFILTER("Global Dimension 1 Code"));
    //                         HistoricGlAcc1.SETFILTER("Global Dimension 2 Filter",GLEntry.GETFILTER("Global Dimension 2 Code"));
    //                         IF AccSchedLine."Totaling Type" = AccSchedLine."Totaling Type"::"Total Accounts" THEN BEGIN
    //                           HistoricGlAcc1.SETRANGE("Account Type",GlAcc1."Account Type"::Total);
    //                           IF PrintAmountsInAddCurrency THEN BEGIN
    //                             HistoricGlAcc1.CALCFIELDS("Additional-Currency Net Change");
    //                             IF HistoricGlAcc1."Net Change" < 0 THEN
    //                               ColValue := HistoricGlAcc1."Additional-Currency Net Change";
    //                           END ELSE BEGIN
    //                             HistoricGlAcc1.CALCFIELDS("Net Change");
    //                             IF HistoricGlAcc1."Net Change" < 0 THEN
    //                               ColValue := HistoricGlAcc1."Net Change";
    //                           END;
    //                         END ELSE BEGIN
    //                           //SS.10.00.03.01,en
    //                           HistoricGlAcc1.SETRANGE("Account Type",HistoricGlAcc1."Account Type"::Posting);
    //                           //SS.10.00.03.01,so
    //                           //HistoricGlAcc1.SETFILTER("No.",HistoricGLAcc.Totaling);
    //                           //HistoricGlAcc1.SETFILTER("Global Dimension 1 Filter",GLEntry.GETFILTER("Global Dimension 1 Code"));
    //                           //HistoricGlAcc1.SETFILTER("Global Dimension 2 Filter",GLEntry.GETFILTER("Global Dimension 2 Code"));
    //                           //SS.10.00.03.01,eo
    //                           IF NOT HistoricGlAcc1.ISEMPTY THEN BEGIN
    //                             HistoricGlAcc1.FINDSET;
    //                             REPEAT
    //                               IF PrintAmountsInAddCurrency THEN BEGIN
    //                                 HistoricGlAcc1.CALCFIELDS("Additional-Currency Net Change");
    //                                 IF HistoricGlAcc1."Net Change" < 0 THEN
    //                                   ColValue := ColValue + HistoricGlAcc1."Additional-Currency Net Change";
    //                               END ELSE BEGIN
    //                                 HistoricGlAcc1.CALCFIELDS("Net Change");
    //                                 IF HistoricGlAcc1."Net Change" < 0 THEN
    //                                   ColValue := ColValue + HistoricGlAcc1."Net Change";
    //                               END;
    //                             UNTIL HistoricGlAcc1.NEXT = 0;
    //                           END;
    //                         END; //SS.10.00.03.01,n
    //                       END;
    //                   END;
    //                 END
    //               ELSE
    //                 WITH AnalysisViewEntry DO BEGIN
    //                   SETRANGE("Analysis View Code",AccSchedName."Analysis View Name");
    //                   IF HistoricGLAcc.Totaling = '' THEN
    //                     SETRANGE("Old G/L Account No.",HistoricGLAcc."No.")
    //                   ELSE
    //                     SETFILTER("Old G/L Account No.",HistoricGLAcc.Totaling);
    //                   HistoricGLAcc.COPYFILTER("Date Filter","Posting Date");
    //                   AccSchedLine.COPYFILTER("Business Unit Filter","Business Unit Code");
    //                   AccSchedLine.COPYFILTER("Dimension 1 Filter","Dimension 1 Value Code");
    //                   AccSchedLine.COPYFILTER("Dimension 2 Filter","Dimension 2 Value Code");
    //                   AccSchedLine.COPYFILTER("Dimension 3 Filter","Dimension 3 Value Code");
    //                   AccSchedLine.COPYFILTER("Dimension 4 Filter","Dimension 4 Value Code");
    //                   FILTERGROUP(2);
    //                   SETFILTER("Dimension 1 Value Code",GetDimTotalingFilter(1,AccSchedLine."Dimension 1 Totaling"));
    //                   SETFILTER("Dimension 2 Value Code",GetDimTotalingFilter(2,AccSchedLine."Dimension 2 Totaling"));
    //                   SETFILTER("Dimension 3 Value Code",GetDimTotalingFilter(3,AccSchedLine."Dimension 3 Totaling"));
    //                   SETFILTER("Dimension 4 Value Code",GetDimTotalingFilter(4,AccSchedLine."Dimension 4 Totaling"));
    //                   FILTERGROUP(6);
    //                   SETFILTER("Dimension 1 Value Code",GetDimTotalingFilter(1,ColumnLayout."Dimension 1 Totaling"));
    //                   SETFILTER("Dimension 2 Value Code",GetDimTotalingFilter(2,ColumnLayout."Dimension 2 Totaling"));
    //                   SETFILTER("Dimension 3 Value Code",GetDimTotalingFilter(3,ColumnLayout."Dimension 3 Totaling"));
    //                   SETFILTER("Dimension 4 Value Code",GetDimTotalingFilter(4,ColumnLayout."Dimension 4 Totaling"));
    //                   SETFILTER("Business Unit Code",ColumnLayout."Business Unit Totaling");
    //                   FILTERGROUP(0);

    //                   CASE TRUE OF
    //                     ((AmountType = AmountType::"Net Amount") AND (AccSchedLine."Column Value" = 0)) OR
    //                     ((AmountType2 = AmountType2::"Net Amount") AND (AccSchedLine."Column Value" = 1)) OR
    //                     ((AmountType3 = AmountType3::"Net Amount") AND (AccSchedLine."Column Value" = 2)):
    //     BEGIN
    //                         IF CalcAddCurr THEN BEGIN
    //                           CALCSUMS("Add.-Curr. Amount");
    //                           ColValue := "Add.-Curr. Amount";
    //       END ELSE BEGIN
    //                           CALCSUMS(Amount);
    //                           ColValue := Amount;
    //                         END;
    //                         Balance := ColValue;
    //                       END;
    //                     ((AmountType = AmountType::"Debit Amount") AND (AccSchedLine."Column Value" = 0)) OR
    //                     ((AmountType2 = AmountType2::"Debit Amount") AND (AccSchedLine."Column Value" = 1)) OR
    //                     ((AmountType3 = AmountType3::"Debit Amount") AND (AccSchedLine."Column Value" = 2)):
    //                       BEGIN
    //                         IF CalcAddCurr THEN BEGIN
    //                           IF TestBalance THEN BEGIN
    //                             CALCSUMS("Add.-Curr. Debit Amount","Add.-Curr. Amount");
    //                             Balance := "Add.-Curr. Amount";
    //                           END ELSE
    //                             CALCSUMS("Add.-Curr. Debit Amount");
    //                             ColValue := "Add.-Curr. Debit Amount";
    //         END ELSE BEGIN
    //                           IF TestBalance THEN BEGIN
    //                             CALCSUMS("Debit Amount",Amount);
    //                             Balance := Amount;
    //                           END ELSE
    //                             CALCSUMS("Debit Amount");
    //                             ColValue := "Debit Amount";
    //                           END;
    //                         END;
    //                     ((AmountType = AmountType::"Credit Amount") AND (AccSchedLine."Column Value" = 0)) OR
    //                     ((AmountType2 = AmountType2::"Credit Amount") AND (AccSchedLine."Column Value" = 1)) OR
    //                     ((AmountType3 = AmountType3::"Credit Amount") AND (AccSchedLine."Column Value" = 2)):
    //                       BEGIN
    //                         IF CalcAddCurr THEN BEGIN
    //                           IF TestBalance THEN BEGIN
    //                             CALCSUMS("Add.-Curr. Credit Amount","Add.-Curr. Amount");
    //                             Balance := "Add.-Curr. Amount";
    //                           END ELSE
    //                             CALCSUMS("Add.-Curr. Credit Amount");
    //                           ColValue := "Add.-Curr. Credit Amount";
    //                         END ELSE BEGIN
    //                           IF TestBalance THEN BEGIN
    //                             CALCSUMS("Credit Amount",Amount);
    //                             Balance := Amount;
    //                           END ELSE
    //                             CALCSUMS("Credit Amount");
    //                           ColValue := "Credit Amount";
    //                         END;
    //                       END;
    //                     ((AmountType = AmountType::"Debit Balance") AND (AccSchedLine."Column Value" = 0)) OR
    //                     ((AmountType2 = AmountType2::"Debit Balance") AND (AccSchedLine."Column Value" = 1)) OR
    //                     ((AmountType3 = AmountType3::"Debit Balance") AND (AccSchedLine."Column Value" = 2)):
    //                       BEGIN
    //                         AnalysisViewEntry1 := AnalysisViewEntry;
    //                         AnalysisViewEntry1.COPYFILTERS(AnalysisViewEntry);
    //                         HistoricGlAcc1 := HistoricGLAcc;
    //                         HistoricGlAcc1.COPYFILTERS(HistoricGLAcc);
    //                         //SS.10.00.03.01,sn
    //                         IF AccSchedLine."Totaling Type" = AccSchedLine."Totaling Type"::"Total Accounts" THEN BEGIN
    //                           AnalysisViewEntry1.SETFILTER("Old G/L Account No.",HistoricGLAcc."No.");
    //                           IF PrintAmountsInAddCurrency THEN BEGIN
    //                             AnalysisViewEntry1.CALCSUMS("Add.-Curr. Amount");
    //                             IF AnalysisViewEntry1."Add.-Curr. Amount" > 0 THEN
    //                               ColValue := AnalysisViewEntry1."Add.-Curr. Amount";
    //                           END ELSE BEGIN
    //                             AnalysisViewEntry1.CALCSUMS(Amount);
    //                             IF AnalysisViewEntry1.Amount > 0 THEN
    //                               ColValue := AnalysisViewEntry1.Amount;
    //                           END;
    //                         END ELSE BEGIN
    //                         //SS.10.00.03.01,en
    //                           HistoricGlAcc1.SETRANGE("Account Type",HistoricGlAcc1."Account Type"::Posting);
    //                           HistoricGlAcc1.SETFILTER("No.",HistoricGLAcc.Totaling);
    //                           IF NOT HistoricGlAcc1.ISEMPTY THEN BEGIN
    //                             HistoricGlAcc1.FINDSET;
    //                             REPEAT
    //                               AnalysisViewEntry1.SETFILTER("Old G/L Account No.",HistoricGlAcc1."No.");
    //                               IF PrintAmountsInAddCurrency THEN BEGIN
    //                                 AnalysisViewEntry1.CALCSUMS("Add.-Curr. Amount");
    //                                 IF AnalysisViewEntry1."Add.-Curr. Amount" > 0 THEN
    //                                   ColValue := ColValue + AnalysisViewEntry1."Add.-Curr. Amount";
    //                               END ELSE BEGIN
    //                                 AnalysisViewEntry1.CALCSUMS(Amount);
    //                                 IF AnalysisViewEntry1.Amount > 0 THEN
    //                                   ColValue := ColValue + AnalysisViewEntry1.Amount;
    //                                 END;
    //                             UNTIL HistoricGlAcc1.NEXT = 0;
    //                           END;
    //                         END;
    //                       END;
    //                     ((AmountType = AmountType::"Credit Balance") AND (AccSchedLine."Column Value" = 0)) OR
    //                     ((AmountType2 = AmountType2::"Credit Balance") AND (AccSchedLine."Column Value" = 1)) OR
    //                     ((AmountType3 = AmountType3::"Credit Balance") AND (AccSchedLine."Column Value" = 2)):
    //                       BEGIN
    //                         AnalysisViewEntry1 := AnalysisViewEntry;
    //                         AnalysisViewEntry1.COPYFILTERS(AnalysisViewEntry);
    //                         HistoricGlAcc1 := HistoricGLAcc;
    //                         HistoricGlAcc1.COPYFILTERS(HistoricGLAcc);
    //                         //SS.10.00.03.01,sn
    //                         IF AccSchedLine."Totaling Type" = AccSchedLine."Totaling Type"::"Total Accounts" THEN BEGIN
    //                           AnalysisViewEntry1.SETFILTER("Old G/L Account No.",HistoricGLAcc."No.");
    //                           IF PrintAmountsInAddCurrency THEN BEGIN
    //                             AnalysisViewEntry1.CALCSUMS("Add.-Curr. Amount");
    //                             IF AnalysisViewEntry1."Add.-Curr. Amount" < 0 THEN
    //                               ColValue := AnalysisViewEntry1."Add.-Curr. Amount";
    //                           END ELSE BEGIN
    //                             AnalysisViewEntry1.CALCSUMS(Amount);
    //                             IF AnalysisViewEntry1.Amount < 0 THEN
    //                               ColValue := AnalysisViewEntry1.Amount;
    //                           END;
    //                         END ELSE BEGIN
    //                         //SS.10.00.03.01,en
    //                           HistoricGlAcc1.SETRANGE("Account Type",HistoricGlAcc1."Account Type"::Posting);
    //                           HistoricGlAcc1.SETFILTER("No.",HistoricGLAcc.Totaling);
    //                           IF NOT HistoricGlAcc1.ISEMPTY THEN BEGIN
    //                             HistoricGlAcc1.FINDSET;
    //                             REPEAT
    //                               AnalysisViewEntry1.SETFILTER("Old G/L Account No.",HistoricGlAcc1."No.");
    //                               IF PrintAmountsInAddCurrency THEN BEGIN
    //                                 AnalysisViewEntry1.CALCSUMS("Add.-Curr. Amount");
    //                                 IF AnalysisViewEntry1."Add.-Curr. Amount" < 0 THEN
    //                                   ColValue := ColValue + AnalysisViewEntry1."Add.-Curr. Amount";
    //                               END ELSE BEGIN
    //                                 AnalysisViewEntry1.CALCSUMS(Amount);
    //                                 IF AnalysisViewEntry1.Amount < 0 THEN
    //                                   ColValue := ColValue + AnalysisViewEntry1.Amount;
    //                               END;
    //                             UNTIL HistoricGlAcc1.NEXT = 0;
    //                           END;
    //                         END; //SS.10.00.03.01,n
    //                       END;
    //         END;
    //       END;
    //     END;

    //           ColumnLayout."Ledger Entry Type"::"Budget Entries" :
    //             BEGIN
    //              IF AccSchedName."Analysis View Name" = '' THEN
    //                WITH GLBudgEntry DO BEGIN
    //                  IF UseBusUnitFilter OR UseDimFilter THEN
    //                    SETCURRENTKEY(
    //                      "Budget Name","Old G/L Account No.","Business Unit Code",
    //                      "Global Dimension 1 Code","Global Dimension 2 Code",
    //                      "Budget Dimension 1 Code","Budget Dimension 2 Code",
    //                      "Budget Dimension 3 Code","Budget Dimension 4 Code",Date)
    //                  ELSE
    //                    SETCURRENTKEY("Budget Name","Old G/L Account No.",Date);
    //                  IF HistoricGLAcc.Totaling = '' THEN
    //                    SETRANGE("Old G/L Account No.",HistoricGLAcc."No.")
    //                  ELSE
    //                    SETFILTER("Old G/L Account No.",HistoricGLAcc.Totaling);
    //                  HistoricGLAcc.COPYFILTER("Date Filter",Date);
    //                  AccSchedLine.COPYFILTER("G/L Budget Filter","Budget Name");
    //                  AccSchedLine.COPYFILTER("Business Unit Filter","Business Unit Code");
    //                  AccSchedLine.COPYFILTER("Dimension 1 Filter","Global Dimension 1 Code");
    //                  AccSchedLine.COPYFILTER("Dimension 2 Filter","Global Dimension 2 Code");
    //                  FILTERGROUP(2);
    //                  SETFILTER("Global Dimension 1 Code",GetDimTotalingFilter(1,AccSchedLine."Dimension 1 Totaling"));
    //                  SETFILTER("Global Dimension 2 Code",GetDimTotalingFilter(2,AccSchedLine."Dimension 2 Totaling"));
    //                  FILTERGROUP(6);
    //                  SETFILTER("Global Dimension 1 Code",GetDimTotalingFilter(1,ColumnLayout."Dimension 1 Totaling"));
    //                  SETFILTER("Global Dimension 2 Code",GetDimTotalingFilter(2,ColumnLayout."Dimension 2 Totaling"));
    //                  SETFILTER("Business Unit Code",ColumnLayout."Business Unit Totaling");
    //                  FILTERGROUP(0);

    //                  CASE AmountType OF
    //                    AmountType::"Net Amount" :
    //                      BEGIN
    //                        CALCSUMS(Amount);
    //                        ColValue := Amount;
    //                      END;
    //                    AmountType::"Debit Amount" :
    //                      BEGIN
    //                        CALCSUMS(Amount);
    //                        ColValue := Amount;
    //                         IF ColValue < 0 THEN
    //                          ColValue := 0;
    //                      END;
    //                    AmountType::"Credit Amount" :
    //                      BEGIN
    //                        CALCSUMS(Amount);
    //                        ColValue := -Amount;
    //                        IF ColValue < 0 THEN
    //                          ColValue := 0;
    //                      END;
    //                    AmountType::"Debit Balance" :
    //                      BEGIN
    //                        HistoricGLAcc.CALCFIELDS("Net Change");
    //                         ColValue := HistoricGLAcc."Net Change";
    //                         IF ColValue < 0 THEN
    //                         ColValue := 0;
    //                      END;
    //                    AmountType::"Credit Balance" :
    //                      BEGIN
    //                        HistoricGLAcc.CALCFIELDS("Net Change");
    //                        ColValue := HistoricGLAcc."Net Change";
    //                        IF ColValue > 0 THEN
    //                          ColValue := 0;
    //                      END;
    //                  END;
    //                  Balance := Amount;
    //                END
    //              ELSE
    //                WITH AnalysisViewBudgetEntry DO BEGIN
    //                  IF HistoricGLAcc.Totaling = '' THEN
    //                    SETRANGE("Old G/L Account No.",HistoricGLAcc."No.")
    //                  ELSE
    //                    SETFILTER("Old G/L Account No.",HistoricGLAcc.Totaling);
    //                  SETRANGE("Analysis View Code",AccSchedName."Analysis View Name");
    //                  HistoricGLAcc.COPYFILTER("Date Filter","Posting Date");
    //                  AccSchedLine.COPYFILTER("G/L Budget Filter","Budget Name");
    //                  AccSchedLine.COPYFILTER("Business Unit Filter","Business Unit Code");
    //                  AccSchedLine.COPYFILTER("Dimension 1 Filter","Dimension 1 Value Code");
    //                  AccSchedLine.COPYFILTER("Dimension 2 Filter","Dimension 2 Value Code");
    //                  AccSchedLine.COPYFILTER("Dimension 3 Filter","Dimension 3 Value Code");
    //                  AccSchedLine.COPYFILTER("Dimension 4 Filter","Dimension 4 Value Code");
    //                  FILTERGROUP(2);
    //                  SETFILTER("Dimension 1 Value Code",GetDimTotalingFilter(1,AccSchedLine."Dimension 1 Totaling"));
    //                  SETFILTER("Dimension 2 Value Code",GetDimTotalingFilter(2,AccSchedLine."Dimension 2 Totaling"));
    //                  SETFILTER("Dimension 3 Value Code",GetDimTotalingFilter(3,AccSchedLine."Dimension 3 Totaling"));
    //                  SETFILTER("Dimension 4 Value Code",GetDimTotalingFilter(4,AccSchedLine."Dimension 4 Totaling"));
    //                  FILTERGROUP(6);
    //                  SETFILTER("Dimension 1 Value Code",GetDimTotalingFilter(1,ColumnLayout."Dimension 1 Totaling"));
    //                  SETFILTER("Dimension 2 Value Code",GetDimTotalingFilter(2,ColumnLayout."Dimension 2 Totaling"));
    //                  SETFILTER("Dimension 3 Value Code",GetDimTotalingFilter(3,ColumnLayout."Dimension 3 Totaling"));
    //                  SETFILTER("Dimension 4 Value Code",GetDimTotalingFilter(4,ColumnLayout."Dimension 4 Totaling"));
    //                  SETFILTER("Business Unit Code",ColumnLayout."Business Unit Totaling");
    //                  FILTERGROUP(0);

    //                  CASE AmountType OF
    //                    AmountType::"Net Amount" :
    //                      BEGIN
    //                        CALCSUMS(Amount);
    //                        ColValue := Amount;
    //                      END;
    //                    AmountType::"Debit Amount" :
    //                      BEGIN
    //                        CALCSUMS(Amount);
    //                        ColValue := Amount;
    //                        IF ColValue < 0 THEN
    //                          ColValue := 0;
    //                      END;
    //                    AmountType::"Credit Amount" :
    //                      BEGIN
    //                        CALCSUMS(Amount);
    //                        ColValue := -Amount;
    //                        IF ColValue < 0 THEN
    //                          ColValue := 0;
    //                      END;
    //                    AmountType::"Debit Balance" :
    //                      BEGIN
    //                        HistoricGlAcc1 := HistoricGLAcc;
    //                        HistoricGlAcc1.COPYFILTERS(HistoricGLAcc);
    //                        //SS.10.00.03.01,sn
    //                        HistoricGlAcc1.SETFILTER("No.",HistoricGLAcc.Totaling);
    //                         IF AccSchedLine."Totaling Type" = AccSchedLine."Totaling Type"::"Total Accounts" THEN BEGIN
    //                           HistoricGlAcc1.SETRANGE("Account Type",GlAcc1."Account Type"::Total);
    //                           HistoricGlAcc1.CALCSUMS("Budgeted Amount");
    //                           IF HistoricGlAcc1."Budgeted Amount" > 0 THEN
    //                             ColValue := HistoricGlAcc1."Budgeted Amount";
    //                         END ELSE BEGIN
    //                         //SS.10.00.03.01,en
    //                           HistoricGlAcc1.SETRANGE("Account Type",HistoricGLAcc."Account Type"::Posting);
    //                           //SS.10.00.03.01,o HistoricGlAcc1.SETFILTER("No.",HistoricGLAcc.Totaling);
    //                           IF NOT HistoricGlAcc1.ISEMPTY THEN BEGIN
    //                             HistoricGlAcc1.FINDSET;
    //                             REPEAT
    //                               HistoricGlAcc1.CALCFIELDS("Budgeted Amount");
    //                               IF HistoricGlAcc1."Budgeted Amount" > 0 THEN
    //                                 ColValue := ColValue + HistoricGlAcc1."Budgeted Amount";
    //                             UNTIL HistoricGlAcc1.NEXT = 0;
    //                           END;
    //                         END; //SS.10.00.03.01,n
    //                       END;
    //                    AmountType::"Credit Balance" :
    //                      BEGIN
    //                        HistoricGlAcc1 := HistoricGLAcc;
    //                        HistoricGlAcc1.COPYFILTERS(HistoricGLAcc);
    //                        //SS.10.00.03.01,sn
    //                        HistoricGlAcc1.SETFILTER("No.",HistoricGLAcc.Totaling);
    //                         IF AccSchedLine."Totaling Type" = AccSchedLine."Totaling Type"::"Total Accounts" THEN BEGIN
    //                           HistoricGlAcc1.SETRANGE("Account Type",GlAcc1."Account Type"::Total);
    //                           HistoricGlAcc1.CALCFIELDS("Budgeted Amount");
    //                           IF HistoricGlAcc1."Budgeted Amount" < 0 THEN
    //                             ColValue := HistoricGlAcc1."Budgeted Amount";
    //                         END ELSE BEGIN
    //                         //SS.10.00.03.01,en
    //                           HistoricGlAcc1.SETRANGE("Account Type",HistoricGLAcc."Account Type"::Posting);
    //                           //SS.10.00.03.01,O HistoricGlAcc1.SETFILTER("No.",HistoricGLAcc.Totaling);
    //                           IF NOT HistoricGlAcc1.ISEMPTY THEN BEGIN
    //                             HistoricGlAcc1.FINDSET;
    //                             REPEAT
    //                               HistoricGlAcc1.CALCFIELDS("Budgeted Amount");
    //                               IF HistoricGlAcc1."Budgeted Amount" < 0 THEN
    //                                 ColValue := ColValue + HistoricGlAcc1."Budgeted Amount";
    //                             UNTIL HistoricGlAcc1.NEXT = 0;
    //                           END;
    //                        END; //SS.10.00.03.01,n
    //                      END;
    //                  END;
    //                  Balance := Amount;
    //                END;
    //              IF CalcAddCurr THEN BEGIN
    //                IF NOT GLSetupRead THEN BEGIN
    //                  GLSetup.GET;
    //                  GLSetupRead := TRUE;
    //                  IF GLSetup."Additional Reporting Currency" <> '' THEN
    //                    AddRepCurrency.GET(GLSetup."Additional Reporting Currency");
    //                END;
    //                IF GLSetup."Additional Reporting Currency" <> '' THEN
    //                  ColValue := ROUND(ExchangeAmtAddCurrToLCY(ColValue),AddRepCurrency."Amount Rounding Precision")
    //                ELSE
    //                  ColValue := 0;
    //              END;
    //            END;
    //       END;
    //       IF TestBalance THEN BEGIN
    //         IF AccSchedLine.Show = AccSchedLine.Show::"When Positive Balance" THEN
    //           IF Balance < 0 THEN
    //             EXIT(0);
    //         IF AccSchedLine.Show = AccSchedLine.Show::"When Negative Balance" THEN
    //           IF Balance > 0 THEN
    //             EXIT(0);
    //       END;
    //     END;
    //     EXIT(ColValue);
    //     //soft,en
    // end;
}

