codeunit 31022930 "PTSS AccSchedManagement"
{
    [EventSubscriber(ObjectType::Codeunit, 8, 'OnBeforeTestBalance', '', true, true)]
    local procedure CalcGLAcc(var GLAccount: Record "G/L Account"; var AccScheduleName: Record "Acc. Schedule Name"; var AccScheduleLine: Record "Acc. Schedule Line"; var ColumnLayout: Record "Column Layout"; AmountType: Integer; var ColValue: Decimal; CalcAddCurr: Boolean; var TestBalance: Boolean; var GLEntry: Record "G/L Entry"; var GLBudgetEntry: Record "G/L Budget Entry")
    begin
        CalcGLAccPT(GLAccount, AccScheduleName, AccScheduleLine, ColumnLayout, AmountType, ColValue, CalcAddCurr, TestBalance, GLEntry, GLBudgetEntry);
    end;

    local procedure CalcGLAccPT(var GLAcc: Record "G/L Account"; var AccScheduleName: Record "Acc. Schedule Name"; var AccScheduleLine: Record "Acc. Schedule Line"; var ColumnLayout: Record "Column Layout"; AmountType: Integer; ColValue: Decimal; CalcAddCurr: Boolean; var TestBalance: Boolean; var GLEntry: Record "G/L Entry"; var GLBudgetEntry: Record "G/L Budget Entry") //ColValue: Decimal
    var
        IsHandled: Boolean;
        UseDimfilter: Boolean;
        AmountType1: Option "Net Amount","Debit Amount","Credit Amount";
        AmountType2: Option "Net Amount","Debit Amount","Credit Amount";
        AmountType3: Option "Net Amount","Debit Amount","Credit Amount";
        Balance1: Boolean;
        Balance2: Boolean;
        Balance3: Boolean;
        Balance: Decimal;
        UseBusUnitFilter: Boolean;

        AnalysisViewEntry: Record "Analysis View Entry";
        AnalysisViewBudgetEntry: Record "Analysis View Budget Entry";
        AnalysisViewEntry1: Record "Analysis View Entry";
        AnalysisViewBudgetEntry1: Record "Analysis View Budget Entry";
    begin
        ColValue := 0;
        //IsHandled := FALSE;
        // IF IsHandled THEN
        // EXIT(ColValue);

        UseDimFilter := FALSE;
        IF AccScheduleName.Name <> AccScheduleLine."Schedule Name" THEN
            AccScheduleName.GET(AccScheduleLine."Schedule Name");

        //soft,sn
        AmountType1 := ColumnLayout."Amount Type";
        AmountType2 := ColumnLayout."PTSS Amount Type 2";
        AmountType3 := ColumnLayout."PTSS Amount Type 3";
        Balance1 := ColumnLayout."PTSS Balance 1";
        Balance2 := ColumnLayout."PTSS Balance 2";
        Balance3 := ColumnLayout."PTSS Balance 3";
        //soft,en

        IF ConflictAmountType(AccScheduleLine, ColumnLayout."Amount Type", AmountType1) THEN
            //soft,o EXIT(0);
            ColValue := 0; //soft,n

        TestBalance :=
        AccScheduleLine.Show IN [AccScheduleLine.Show::"When Positive Balance", AccScheduleLine.Show::"When Negative Balance"];
        IF ColumnLayout."Column Type" <> ColumnLayout."Column Type"::Formula THEN BEGIN
            UseBusUnitFilter := (AccScheduleLine.GETFILTER("Business Unit Filter") <> '') OR (ColumnLayout."Business Unit Totaling" <> '');
            UseDimFilter := HasDimFilter(AccScheduleLine, ColumnLayout);
            CASE ColumnLayout."Ledger Entry Type" OF
                ColumnLayout."Ledger Entry Type"::Entries:
                    IF AccScheduleName."Analysis View Name" = '' THEN
                        WITH GLEntry DO BEGIN
                            SetGLAccGLEntryFilters(GLAcc, GLEntry, AccScheduleLine, ColumnLayout, UseBusUnitFilter, UseDimFilter);
                            SetGLAcc1GLEntryFilters(GLAcc, GLAcc1, GLEntry, AccScheduleLine, ColumnLayout);
                            //soft,n
                            //soft,so
                            //CASE AmountType OF
                            //  AmountType::"Net Amount":
                            //soft,eo
                            //soft,sn
                            CASE TRUE OF
                                ((AmountType1 = AmountType1::"Net Amount") AND (AccScheduleLine."PTSS Column Value" = 0)) OR
                                ((AmountType2 = AmountType2::"Net Amount") AND (AccScheduleLine."PTSS Column Value" = 1)) OR
                                ((AmountType3 = AmountType3::"Net Amount") AND (AccScheduleLine."PTSS Column Value" = 2)):
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
                                ((AmountType = AmountType1::"Debit Amount") AND (AccScheduleLine."PTSS Column Value" = 0)) AND not (AccScheduleLine."PTSS Balance") OR
                                ((AmountType2 = AmountType2::"Debit Amount") AND (AccScheduleLine."PTSS Column Value" = 1)) AND not (AccScheduleLine."PTSS Balance") OR
                                ((AmountType3 = AmountType3::"Debit Amount") AND (AccScheduleLine."PTSS Column Value" = 2)) AND not (AccScheduleLine."PTSS Balance"):
                                    //soft,en
                                    IF CalcAddCurr THEN BEGIN
                                        IF TestBalance THEN BEGIN
                                            CALCSUMS("Add.-Currency Debit Amount", "Additional-Currency Amount");
                                            Balance := "Additional-Currency Amount";
                                        END ELSE
                                            CALCSUMS("Add.-Currency Debit Amount");
                                        ColValue := "Add.-Currency Debit Amount";
                                    END ELSE BEGIN
                                        IF TestBalance THEN BEGIN
                                            CALCSUMS("Debit Amount", Amount);
                                            Balance := Amount;
                                        END ELSE
                                            CALCSUMS("Debit Amount");
                                        ColValue := "Debit Amount";
                                    END;
                                //soft,o AmountType::"Credit Amount":
                                //soft,sn
                                ((AmountType = AmountType1::"Credit Amount") AND (AccScheduleLine."PTSS Column Value" = 0)) AND not (AccScheduleLine."PTSS Balance") OR
                                ((AmountType2 = AmountType2::"Credit Amount") AND (AccScheduleLine."PTSS Column Value" = 1)) AND not (AccScheduleLine."PTSS Balance") OR
                                ((AmountType3 = AmountType3::"Credit Amount") AND (AccScheduleLine."PTSS Column Value" = 2)) AND not (AccScheduleLine."PTSS Balance"):
                                    //soft,en
                                    IF CalcAddCurr THEN BEGIN
                                        IF TestBalance THEN BEGIN
                                            CALCSUMS("Add.-Currency Credit Amount", "Additional-Currency Amount");
                                            Balance := "Additional-Currency Amount";
                                        END ELSE
                                            CALCSUMS("Add.-Currency Credit Amount");
                                        ColValue := "Add.-Currency Credit Amount";
                                    END ELSE BEGIN
                                        IF TestBalance THEN BEGIN
                                            CALCSUMS("Credit Amount", Amount);
                                            Balance := Amount;
                                        END ELSE
                                            CALCSUMS("Credit Amount");
                                        ColValue := "Credit Amount";
                                    END;
                                //soft,sn
                                ((AmountType = AmountType1::"Debit Amount") AND (AccScheduleLine."PTSS Column Value" = 0)) AND (AccScheduleLine."PTSS Balance") OR
                                ((AmountType2 = AmountType2::"Debit Amount") AND (AccScheduleLine."PTSS Column Value" = 1)) AND (AccScheduleLine."PTSS Balance") OR
                                ((AmountType3 = AmountType3::"Debit Amount") AND (AccScheduleLine."PTSS Column Value" = 2)) AND (AccScheduleLine."PTSS Balance"):
                                    IF AccScheduleLine."Totaling Type" = AccScheduleLine."Totaling Type"::"Total Accounts" THEN BEGIN
                                        IF CalcAddCurr THEN BEGIN
                                            GLAcc1.CALCFIELDS("Additional-Currency Net Change");
                                            IF GLAcc1."Additional-Currency Net Change" > 0 THEN
                                                ColValue := GLAcc1."Additional-Currency Net Change";
                                        END ELSE BEGIN
                                            GLAcc1.CALCFIELDS("Net Change");
                                            IF GLAcc1."Net Change" > 0 THEN
                                                ColValue := GLAcc1."Net Change";
                                        END;
                                    END ELSE BEGIN
                                        IF CalcAddCurr THEN BEGIN
                                            GLAcc1.CALCSUMS("Additional-Currency Net Change");
                                            IF GLAcc1."Additional-Currency Net Change" > 0 THEN
                                                ColValue := GLAcc1."Additional-Currency Net Change";
                                        END ELSE BEGIN
                                            GLAcc1.CALCSUMS("Net Change");
                                            IF GLAcc1."Net Change" > 0 THEN
                                                ColValue := GLAcc1."Net Change";
                                        END;
                                    END;
                                ((AmountType = AmountType1::"Credit Amount") AND (AccScheduleLine."PTSS Column Value" = 0)) AND (AccScheduleLine."PTSS Balance") OR
                                ((AmountType2 = AmountType2::"Credit Amount") AND (AccScheduleLine."PTSS Column Value" = 1)) AND (AccScheduleLine."PTSS Balance") OR
                                ((AmountType3 = AmountType3::"Credit Amount") AND (AccScheduleLine."PTSS Column Value" = 2)) AND (AccScheduleLine."PTSS Balance"):
                                    IF AccScheduleLine."Totaling Type" = AccScheduleLine."Totaling Type"::"Total Accounts" THEN BEGIN
                                        IF CalcAddCurr THEN BEGIN
                                            GLAcc1.CALCFIELDS("Additional-Currency Net Change");
                                            IF GLAcc1."Additional-Currency Net Change" < 0 THEN
                                                ColValue := GLAcc1."Additional-Currency Net Change";
                                        END ELSE BEGIN
                                            GLAcc1.CALCFIELDS("Net Change");
                                            IF GLAcc1."Net Change" < 0 THEN
                                                ColValue := GLAcc1."Net Change";
                                        END;
                                    END ELSE BEGIN
                                        IF CalcAddCurr THEN BEGIN
                                            GLAcc1.CALCSUMS("Additional-Currency Net Change");
                                            IF GLAcc1."Additional-Currency Net Change" < 0 THEN
                                                ColValue := GLAcc1."Additional-Currency Net Change";
                                        END ELSE BEGIN
                                            GLAcc1.CALCSUMS("Net Change");
                                            IF GLAcc1."Net Change" < 0 THEN
                                                ColValue := GLAcc1."Net Change";
                                        END;
                                    END;
                                    //soft,en
                            END;
                        END
                    ELSE
                        WITH AnalysisViewEntry DO BEGIN
                            SetGLAccAnalysisViewEntryFilters(GLAcc, AnalysisViewEntry, AccScheduleLine, ColumnLayout);
                            SetGLAcc1AnalysisViewEntryFilters(GLAcc, GLAcc1, AnalysisViewEntry, AnalysisViewEntry1, AccScheduleLine);
                            //soft,n
                            //soft,so
                            //CASE AmountType OF
                            //  AmountType::"Net Amount":
                            //soft,sn
                            CASE TRUE OF
                                ((AmountType = AmountType1::"Net Amount") AND (AccScheduleLine."PTSS Column Value" = 0)) OR
                                ((AmountType2 = AmountType2::"Net Amount") AND (AccScheduleLine."PTSS Column Value" = 1)) OR
                                ((AmountType3 = AmountType3::"Net Amount") AND (AccScheduleLine."PTSS Column Value" = 2)):
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
                                ((AmountType = AmountType1::"Debit Amount") AND (AccScheduleLine."PTSS Column Value" = 0)) AND not (AccScheduleLine."PTSS Balance") OR
                                ((AmountType2 = AmountType2::"Debit Amount") AND (AccScheduleLine."PTSS Column Value" = 1)) AND not (AccScheduleLine."PTSS Balance") OR
                                ((AmountType3 = AmountType3::"Debit Amount") AND (AccScheduleLine."PTSS Column Value" = 2)) AND not (AccScheduleLine."PTSS Balance"):
                                    //soft,en
                                    IF CalcAddCurr THEN BEGIN
                                        IF TestBalance THEN BEGIN
                                            CALCSUMS("Add.-Curr. Debit Amount", "Add.-Curr. Amount");
                                            Balance := "Add.-Curr. Amount";
                                        END ELSE
                                            CALCSUMS("Add.-Curr. Debit Amount");
                                        ColValue := "Add.-Curr. Debit Amount";
                                    END ELSE BEGIN
                                        IF TestBalance THEN BEGIN
                                            CALCSUMS("Debit Amount", Amount);
                                            Balance := Amount;
                                        END ELSE
                                            CALCSUMS("Debit Amount");
                                        ColValue := "Debit Amount";
                                    END;
                                //soft,o AmountType::"Credit Amount":
                                //soft,sn
                                ((AmountType = AmountType1::"Credit Amount") AND (AccScheduleLine."PTSS Column Value" = 0)) AND not (AccScheduleLine."PTSS Balance") OR
                                ((AmountType2 = AmountType2::"Credit Amount") AND (AccScheduleLine."PTSS Column Value" = 1)) AND not (AccScheduleLine."PTSS Balance") OR
                                ((AmountType3 = AmountType3::"Credit Amount") AND (AccScheduleLine."PTSS Column Value" = 2)) AND not (AccScheduleLine."PTSS Balance"):
                                    //soft,en
                                    IF CalcAddCurr THEN BEGIN
                                        IF TestBalance THEN BEGIN
                                            CALCSUMS("Add.-Curr. Credit Amount", "Add.-Curr. Amount");
                                            Balance := "Add.-Curr. Amount";
                                        END ELSE
                                            CALCSUMS("Add.-Curr. Credit Amount");
                                        ColValue := "Add.-Curr. Credit Amount";
                                    END ELSE BEGIN
                                        IF TestBalance THEN BEGIN
                                            CALCSUMS("Credit Amount", Amount);
                                            Balance := Amount;
                                        END ELSE
                                            CALCSUMS("Credit Amount");
                                        ColValue := "Credit Amount";
                                    END;
                                //soft,sn
                                ((AmountType = AmountType1::"Debit Amount") AND (AccScheduleLine."PTSS Column Value" = 0)) AND (AccScheduleLine."PTSS Balance") OR
                                ((AmountType2 = AmountType2::"Debit Amount") AND (AccScheduleLine."PTSS Column Value" = 1)) AND (AccScheduleLine."PTSS Balance") OR
                                ((AmountType3 = AmountType3::"Debit Amount") AND (AccScheduleLine."PTSS Column Value" = 2)) AND (AccScheduleLine."PTSS Balance"):
                                    BEGIN
                                        IF AccScheduleLine."Totaling Type" = AccScheduleLine."Totaling Type"::"Total Accounts" THEN BEGIN
                                            IF CalcAddCurr THEN BEGIN
                                                AnalysisViewEntry1.CALCSUMS("Add.-Curr. Amount");
                                                IF AnalysisViewEntry1."Add.-Curr. Amount" > 0 THEN
                                                    ColValue := AnalysisViewEntry1."Add.-Curr. Amount";
                                            END ELSE BEGIN
                                                AnalysisViewEntry1.CALCSUMS(Amount);
                                                IF AnalysisViewEntry1.Amount > 0 THEN
                                                    ColValue := AnalysisViewEntry1.Amount;
                                            END;
                                        END ELSE
                                            IF GLAcc1.FINDSET THEN
                                                REPEAT
                                                    AnalysisViewEntry1.SETFILTER("Account No.", GLAcc1."No.");
                                                    IF CalcAddCurr THEN BEGIN
                                                        AnalysisViewEntry1.CALCSUMS("Add.-Curr. Amount");
                                                        IF AnalysisViewEntry1."Add.-Curr. Amount" > 0 THEN
                                                            ColValue += AnalysisViewEntry1."Add.-Curr. Amount";
                                                    END ELSE BEGIN
                                                        AnalysisViewEntry1.CALCSUMS(Amount);
                                                        IF AnalysisViewEntry1.Amount > 0 THEN
                                                            ColValue += AnalysisViewEntry1.Amount;
                                                    END;
                                                UNTIL GLAcc1.NEXT = 0;
                                    END;
                                ((AmountType = AmountType1::"Credit Amount") AND (AccScheduleLine."PTSS Column Value" = 0)) AND (AccScheduleLine."PTSS Balance") OR
                                ((AmountType2 = AmountType2::"Credit Amount") AND (AccScheduleLine."PTSS Column Value" = 1)) AND (AccScheduleLine."PTSS Balance") OR
                                ((AmountType3 = AmountType3::"Credit Amount") AND (AccScheduleLine."PTSS Column Value" = 2)) AND (AccScheduleLine."PTSS Balance"):
                                    BEGIN
                                        IF AccScheduleLine."Totaling Type" = AccScheduleLine."Totaling Type"::"Total Accounts" THEN BEGIN
                                            IF CalcAddCurr THEN BEGIN
                                                AnalysisViewEntry1.CALCSUMS("Add.-Curr. Amount");
                                                IF AnalysisViewEntry1."Add.-Curr. Amount" < 0 THEN
                                                    ColValue := AnalysisViewEntry1."Add.-Curr. Amount";
                                            END ELSE BEGIN
                                                AnalysisViewEntry1.CALCSUMS(Amount);
                                                IF AnalysisViewEntry1.Amount < 0 THEN
                                                    ColValue := AnalysisViewEntry1.Amount;
                                            END;
                                        END ELSE BEGIN
                                            IF GLAcc1.FINDSET THEN
                                                REPEAT
                                                    AnalysisViewEntry1.SETFILTER("Account No.", GLAcc1."No.");
                                                    IF CalcAddCurr THEN BEGIN
                                                        AnalysisViewEntry1.CALCSUMS("Add.-Curr. Amount");
                                                        IF AnalysisViewEntry1."Add.-Curr. Amount" < 0 THEN
                                                            ColValue += AnalysisViewEntry1."Add.-Curr. Amount";
                                                    END ELSE BEGIN
                                                        AnalysisViewEntry1.CALCSUMS(Amount);
                                                        IF AnalysisViewEntry1.Amount < 0 THEN
                                                            ColValue += AnalysisViewEntry1.Amount;
                                                    END;
                                                UNTIL GLAcc1.NEXT = 0;
                                        END;
                                    END;
                                    //soft,en
                            END;
                        END;
                ColumnLayout."Ledger Entry Type"::"Budget Entries":
                    BEGIN
                        IF AccScheduleName."Analysis View Name" = '' THEN
                            WITH GLBudgetEntry DO BEGIN
                                SetGLAccGLBudgetEntryFilters(GLAcc, GLBudgetEntry, AccScheduleLine, ColumnLayout, UseBusUnitFilter, UseDimFilter);
                                CASE AmountType1 OF
                                    AmountType1::"Net Amount":
                                        BEGIN
                                            CALCSUMS(Amount);
                                            ColValue := Amount;
                                        END;
                                    (AmountType1::"Debit Amount"):
                                        BEGIN

                                            IF not Balance1 THEN BEGIN //soft,n
                                                CALCSUMS(Amount);
                                                ColValue := Amount;
                                                IF ColValue < 0 THEN
                                                    ColValue := 0;
                                                //soft,sn
                                            END ELSE begin
                                                GLAcc.CALCFIELDS("Net Change");
                                                ColValue := GLAcc."Net Change";
                                                IF ColValue < 0 THEN
                                                    ColValue := 0;
                                            END;
                                            //soft,en
                                        END;
                                    AmountType1::"Credit Amount":
                                        BEGIN
                                            IF not Balance1 THEN BEGIN //soft,n
                                                CALCSUMS(Amount);
                                                ColValue := -Amount;
                                                IF ColValue < 0 THEN
                                                    ColValue := 0;
                                                //soft,sn
                                            END ELSE begin
                                                GLAcc.CALCFIELDS("Net Change");
                                                ColValue := GLAcc."Net Change";
                                                IF ColValue > 0 THEN
                                                    ColValue := 0;
                                            END;
                                            //soft,en
                                        END;
                                END;
                                Balance := Amount;
                            END
                        ELSE
                            WITH AnalysisViewBudgetEntry DO BEGIN
                                SetGLAccAnalysisViewBudgetEntries(GLAcc, AnalysisViewBudgetEntry, AccScheduleLine, ColumnLayout);
                                SetGLAcc1AnalysisViewBudgetEntries(GLAcc, GLAcc1, AnalysisViewBudgetEntry, AnalysisViewBudgetEntry1, AccScheduleLine);
                                CASE AmountType1 OF
                                    AmountType1::"Net Amount":
                                        BEGIN
                                            CALCSUMS(Amount);
                                            ColValue := Amount;
                                        END;
                                    AmountType1::"Debit Amount":
                                        BEGIN
                                            IF not Balance1 THEN BEGIN //soft,n
                                                CALCSUMS(Amount);
                                                ColValue := Amount;
                                                IF ColValue < 0 THEN
                                                    ColValue := 0;
                                                //soft,sn
                                            END ELSE begin
                                                IF AccScheduleLine."Totaling Type" = AccScheduleLine."Totaling Type"::"Total Accounts" THEN BEGIN
                                                    GLAcc1.CALCFIELDS("Budgeted Amount");
                                                    IF GLAcc1."Budgeted Amount" > 0 THEN
                                                        ColValue := GLAcc1."Budgeted Amount";
                                                END ELSE BEGIN
                                                    GLAcc1.CALCSUMS("Budgeted Amount");
                                                    IF GLAcc1."Budgeted Amount" > 0 THEN
                                                        ColValue := GLAcc1."Budgeted Amount";
                                                END;
                                                //soft,en
                                            END;
                                        END;
                                    AmountType1::"Credit Amount":
                                        BEGIN
                                            IF not Balance1 THEN BEGIN //soft,n
                                                CALCSUMS(Amount);
                                                ColValue := -Amount;
                                                IF ColValue < 0 THEN
                                                    ColValue := 0;
                                                //soft,sn
                                            END ELSE BEGIN
                                                IF AccScheduleLine."Totaling Type" = AccScheduleLine."Totaling Type"::"Total Accounts" THEN BEGIN
                                                    GLAcc1.CALCFIELDS("Budgeted Amount");
                                                    IF GLAcc1."Budgeted Amount" < 0 THEN
                                                        ColValue := GLAcc1."Budgeted Amount";
                                                END ELSE BEGIN
                                                    GLAcc1.CALCSUMS("Budgeted Amount");
                                                    IF GLAcc1."Budgeted Amount" < 0 THEN
                                                        ColValue := GLAcc1."Budgeted Amount";
                                                END;
                                            END;
                                            //soft,en
                                        END;
                                        //soft,sn
                                END;
                                Balance := Amount;
                            END;
                        IF CalcAddCurr THEN
                            ColValue := CalcLCYToACY(ColValue);
                    END;
            END;
        end;
    END;

    local procedure ConflictAmountType(AccSchedLine: Record "Acc. Schedule Line"; ColumnLayoutAmtType: Option "Net Amount","Debit Amount","Credit Amount"; Var AmountType: Option): Boolean
    begin
        IF (ColumnLayoutAmtType = AccSchedLine."Amount Type") OR (AccSchedLine."Amount Type" = AccSchedLine."Amount Type"::"Net Amount") THEN
            AmountType := ColumnLayoutAmtType
        ELSE
            IF ColumnLayoutAmtType = ColumnLayoutAmtType::"Net Amount" THEN
                AmountType := AccSchedLine."Amount Type"
            ELSE
                EXIT(TRUE);
        EXIT(FALSE);
    end;

    local procedure HasDimFilter(var AccSchedLine: Record "Acc. Schedule Line"; Var ColumnLayout: Record "Column Layout"): Boolean
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

    local procedure SetGLAccGLEntryFilters(Var GLAcc: Record "G/L Account"; Var GLEntry: Record "G/L Entry"; Var AccSchedLine: Record "Acc. Schedule Line"; Var ColumnLayout: Record "Column Layout"; UseBusUnitFilter: Boolean; UseDimFilter: Boolean)
    begin
        WITH GLEntry DO BEGIN
            IF UseBusUnitFilter THEN
                IF UseDimFilter THEN
                    SETCURRENTKEY(
                        "G/L Account No.", "Business Unit Code", "Global Dimension 1 Code", "Global Dimension 2 Code")
                ELSE
                    SETCURRENTKEY(
                        "G/L Account No.", "Business Unit Code", "Posting Date")
            ELSE
                IF UseDimFilter THEN
                    SETCURRENTKEY("G/L Account No.", "Global Dimension 1 Code", "Global Dimension 2 Code")
                ELSE
                    SETCURRENTKEY("G/L Account No.", "Posting Date");
            IF GLAcc.Totaling = '' THEN
                SETRANGE("G/L Account No.", GLAcc."No.")
            ELSE
                SETFILTER("G/L Account No.", GLAcc.Totaling);
            GLAcc.COPYFILTER("Date Filter", "Posting Date");
            AccSchedLine.COPYFILTER("Business Unit Filter", "Business Unit Code");
            AccSchedLine.COPYFILTER("Dimension 1 Filter", "Global Dimension 1 Code");
            AccSchedLine.COPYFILTER("Dimension 2 Filter", "Global Dimension 2 Code");
            FILTERGROUP(2);
            SETFILTER("Global Dimension 1 Code", AccSchedMgmt.GetDimTotalingFilter(1, AccSchedLine."Dimension 1 Totaling"));
            SETFILTER("Global Dimension 2 Code", AccSchedMgmt.GetDimTotalingFilter(2, AccSchedLine."Dimension 2 Totaling"));
            FILTERGROUP(8);
            SETFILTER("Global Dimension 1 Code", AccSchedMgmt.GetDimTotalingFilter(1, ColumnLayout."Dimension 1 Totaling"));
            SETFILTER("Global Dimension 2 Code", AccSchedMgmt.GetDimTotalingFilter(2, ColumnLayout."Dimension 2 Totaling"));
            SETFILTER("Business Unit Code", ColumnLayout."Business Unit Totaling");
            FILTERGROUP(0);
        END;
    end;

    local procedure SetGLAcc1GLEntryFilters(GLAcc: Record "G/L Account"; var GLAcc1: Record "G/L Account"; GLEntry: Record "G/L Entry"; AccSchedLine: Record "Acc. Schedule Line"; ColumnLayout: Record "Column Layout")
    begin
        GLAcc1 := GLAcc;
        GLAcc1.COPYFILTERS(GLAcc);
        GLAcc1.SETFILTER("No.", GLAcc.Totaling);
        GLAcc1.SETFILTER("Global Dimension 1 Filter", GLEntry.GETFILTER("Global Dimension 1 Code"));
        GLAcc1.SETFILTER("Global Dimension 2 Filter", GLEntry.GETFILTER("Global Dimension 2 Code"));
        GLAcc1.SETFILTER("Business Unit Filter", ColumnLayout."Business Unit Totaling");
        IF AccSchedLine."Totaling Type" = AccSchedLine."Totaling Type"::"Total Accounts" THEN
            GLAcc1.SETRANGE("Account Type", GLAcc1."Account Type"::Total)
        ELSE
            GLAcc1.SETRANGE("Account Type", GLAcc1."Account Type"::Posting);
    end;

    local procedure SetGLAccAnalysisViewEntryFilters(var GLAcc: Record "G/L Account"; Var AnalysisViewEntry: Record "Analysis View Entry"; Var AccSchedLine: Record "Acc. Schedule Line"; Var ColumnLayout: Record "Column Layout")
    begin
        WITH AnalysisViewEntry DO BEGIN
            SETRANGE("Analysis View Code", AccSchedName."Analysis View Name");
            SETRANGE("Account Source", "Account Source"::"G/L Account");
            IF GLAcc.Totaling = '' THEN
                SETRANGE("Account No.", GLAcc."No.")
            ELSE
                SETFILTER("Account No.", GLAcc.Totaling);
            GLAcc.COPYFILTER("Date Filter", "Posting Date");
            AccSchedLine.COPYFILTER("Business Unit Filter", "Business Unit Code");
            CopyDimFilters(AccSchedLine);
            FILTERGROUP(2);
            SetDimFilters(
                AccSchedMgmt.GetDimTotalingFilter(1, AccSchedLine."Dimension 1 Totaling"),
                AccSchedMgmt.GetDimTotalingFilter(2, AccSchedLine."Dimension 2 Totaling"),
                AccSchedMgmt.GetDimTotalingFilter(3, AccSchedLine."Dimension 3 Totaling"),
                AccSchedMgmt.GetDimTotalingFilter(4, AccSchedLine."Dimension 4 Totaling"));
            FILTERGROUP(8);
            SetDimFilters(
                AccSchedMgmt.GetDimTotalingFilter(1, ColumnLayout."Dimension 1 Totaling"),
                AccSchedMgmt.GetDimTotalingFilter(2, ColumnLayout."Dimension 2 Totaling"),
                AccSchedMgmt.GetDimTotalingFilter(3, ColumnLayout."Dimension 3 Totaling"),
                AccSchedMgmt.GetDimTotalingFilter(4, ColumnLayout."Dimension 4 Totaling"));
            SETFILTER("Business Unit Code", ColumnLayout."Business Unit Totaling");
            FILTERGROUP(0);
        END;
    end;

    local procedure SetGLAcc1AnalysisViewEntryFilters(GLAcc: Record "G/L Account"; VAR GLAcc1: Record "G/L Account"; AnalysisViewEntry: Record "Analysis View Entry"; VAR AnalysisViewEntry1: Record "Analysis View Entry"; AccSchedLine: Record "Acc. Schedule Line")
    begin
        GLAcc1 := GLAcc;
        GLAcc1.COPYFILTERS(GLAcc);
        AnalysisViewEntry1 := AnalysisViewEntry;
        AnalysisViewEntry1.COPYFILTERS(AnalysisViewEntry);
        IF AccSchedLine."Totaling Type" = AccSchedLine."Totaling Type"::"Total Accounts" THEN
            AnalysisViewEntry1.SETFILTER("Account No.", GLAcc1."No.")
        ELSE BEGIN
            GLAcc1.SETRANGE("Account Type", GLAcc1."Account Type"::Posting);
            GLAcc1.SETFILTER("No.", GLAcc1.Totaling);
        END;
    end;

    local procedure SetGLAccGLBudgetEntryFilters(VAR GLAcc: Record "G/L Account"; VAR GLBudgetEntry: Record "G/L Budget Entry"; VAR AccSchedLine: Record "Acc. Schedule Line"; VAR ColumnLayout: Record "Column Layout"; UseBusUnitFilter: Boolean; UseDimFilter: Boolean)
    begin
        WITH GLBudgetEntry DO BEGIN
            IF UseBusUnitFilter OR UseDimFilter THEN
                SETCURRENTKEY(
                "Budget Name", "G/L Account No.", "Business Unit Code",
                "Global Dimension 1 Code", "Global Dimension 2 Code",
                "Budget Dimension 1 Code", "Budget Dimension 2 Code",
                "Budget Dimension 3 Code", "Budget Dimension 4 Code", Date)
            ELSE
                SETCURRENTKEY("Budget Name", "G/L Account No.", Date);
            IF GLAcc.Totaling = '' THEN
                SETRANGE("G/L Account No.", GLAcc."No.")
            ELSE
                SETFILTER("G/L Account No.", GLAcc.Totaling);
            GLAcc.COPYFILTER("Date Filter", Date);
            AccSchedLine.COPYFILTER("G/L Budget Filter", "Budget Name");
            AccSchedLine.COPYFILTER("Business Unit Filter", "Business Unit Code");
            AccSchedLine.COPYFILTER("Dimension 1 Filter", "Global Dimension 1 Code");
            AccSchedLine.COPYFILTER("Dimension 2 Filter", "Global Dimension 2 Code");
            FILTERGROUP(2);
            SETFILTER("Global Dimension 1 Code", AccSchedMgmt.GetDimTotalingFilter(1, AccSchedLine."Dimension 1 Totaling"));
            SETFILTER("Global Dimension 2 Code", AccSchedMgmt.GetDimTotalingFilter(2, AccSchedLine."Dimension 2 Totaling"));
            FILTERGROUP(8);
            SETFILTER("Global Dimension 1 Code", AccSchedMgmt.GetDimTotalingFilter(1, ColumnLayout."Dimension 1 Totaling"));
            SETFILTER("Global Dimension 2 Code", AccSchedMgmt.GetDimTotalingFilter(2, ColumnLayout."Dimension 2 Totaling"));
            SETFILTER("Business Unit Code", ColumnLayout."Business Unit Totaling");
            FILTERGROUP(0);
        END;
    end;

    local procedure SetGLAccAnalysisViewBudgetEntries(VAR GLAcc: Record "G/L Account"; VAR AnalysisViewBudgetEntry: Record "Analysis View Budget Entry"; VAR AccSchedLine: Record "Acc. Schedule Line"; VAR ColumnLayout: Record "Column Layout")
    begin
        WITH AnalysisViewBudgetEntry DO BEGIN
            IF GLAcc.Totaling = '' THEN
                SETRANGE("G/L Account No.", GLAcc."No.")
            ELSE
                SETFILTER("G/L Account No.", GLAcc.Totaling);
            SETRANGE("Analysis View Code", AccSchedName."Analysis View Name");
            GLAcc.COPYFILTER("Date Filter", "Posting Date");
            AccSchedLine.COPYFILTER("G/L Budget Filter", "Budget Name");
            AccSchedLine.COPYFILTER("Business Unit Filter", "Business Unit Code");
            CopyDimFilters(AccSchedLine);
            FILTERGROUP(2);
            SetDimFilters(
                AccSchedMgmt.GetDimTotalingFilter(1, AccSchedLine."Dimension 1 Totaling"),
                AccSchedMgmt.GetDimTotalingFilter(2, AccSchedLine."Dimension 2 Totaling"),
                AccSchedMgmt.GetDimTotalingFilter(3, AccSchedLine."Dimension 3 Totaling"),
                AccSchedMgmt.GetDimTotalingFilter(4, AccSchedLine."Dimension 4 Totaling"));
            FILTERGROUP(8);
            SetDimFilters(
                AccSchedMgmt.GetDimTotalingFilter(1, ColumnLayout."Dimension 1 Totaling"),
                AccSchedMgmt.GetDimTotalingFilter(2, ColumnLayout."Dimension 2 Totaling"),
                AccSchedMgmt.GetDimTotalingFilter(3, ColumnLayout."Dimension 3 Totaling"),
                AccSchedMgmt.GetDimTotalingFilter(4, ColumnLayout."Dimension 4 Totaling"));
            SETFILTER("Business Unit Code", ColumnLayout."Business Unit Totaling");
            FILTERGROUP(0);
        END;
    end;

    local procedure SetGLAcc1AnalysisViewBudgetEntries(GLAcc: Record "G/L Account"; VAR GLAcc1: Record "G/L Account"; AnalysisViewBudgetEntry: Record "Analysis View Budget Entry"; VAR Analysis1ViewBudgetEntry: Record "Analysis View Budget Entry"; AccSchedLine: Record "Acc. Schedule Line")
    begin
        GLAcc1 := GLAcc;
        GLAcc1.COPYFILTERS(GLAcc);
        IF AccSchedLine."Totaling Type" = AccSchedLine."Totaling Type"::"Total Accounts" THEN
            GLAcc1.SETRANGE("Account Type", GLAcc1."Account Type"::Total)
        ELSE BEGIN
            GLAcc1.SETRANGE("Account Type", GLAcc."Account Type"::Posting);
            GLAcc1.SETFILTER("No.", GLAcc.Totaling);
        END;
    end;

    local procedure CalcLCYToACY(ColValue: Decimal): Decimal
    begin
        IF NOT GLSetupRead THEN BEGIN
            GLSetup.GET;
            GLSetupRead := TRUE;
            IF GLSetup."Additional Reporting Currency" <> '' THEN
                AddRepCurrency.GET(GLSetup."Additional Reporting Currency");
        END;
        IF GLSetup."Additional Reporting Currency" <> '' THEN
            EXIT(ROUND(ExchangeAmtAddCurrToLCY(ColValue), AddRepCurrency."Amount Rounding Precision"));
        EXIT(0);
    end;

    local procedure ExchangeAmtAddCurrToLCY(AmountLCY: Decimal): Decimal
    begin
        IF NOT GLSetupRead THEN BEGIN
            GLSetup.GET;
            GLSetupRead := TRUE;
        END;

        EXIT(
        CurrExchRate.ExchangeAmtLCYToFCY(
            WORKDATE, GLSetup."Additional Reporting Currency", AmountLCY,
            CurrExchRate.ExchangeRate(WORKDATE, GLSetup."Additional Reporting Currency")));
    end;

    var
        GLSetupRead: Boolean;
        GLSetup: Record "General Ledger Setup";
        AddRepCurrency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        AccSchedMgmt: Codeunit AccSchedManagement;
        AccSchedName: Record "Acc. Schedule Name";
        GLAcc1: Record "G/L Account";
}