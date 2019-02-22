report 31023105 "PTSS Close Income Statement"
{
    // Lancamento Regularizacao

    ApplicationArea = All;
    Caption = 'Close Income Statement';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = SORTING ("No.")
                                WHERE ("Account Type" = CONST (Posting),
                                      "Income/Balance" = CONST ("Income Statement"));
            dataitem("G/L Entry"; "G/L Entry")
            {
                DataItemLink = "G/L Account No." = FIELD ("No.");
                DataItemTableView = SORTING ("G/L Account No.", "Posting Date");

                trigger OnAfterGetRecord()
                var
                    TempDimBuf: Record "Dimension Buffer" temporary;
                    TempDimBuf2: Record "Dimension Buffer" temporary;
                    DimensionBufferID: Integer;
                    RowOffset: Integer;
                begin
                    EntryCount := EntryCount + 1;
                    IF CURRENTDATETIME - LastWindowUpdateDateTime > 1000 THEN BEGIN
                        LastWindowUpdateDateTime := CURRENTDATETIME;
                        Window.UPDATE(3, ROUND(EntryCount / MaxEntry * 10000, 1));
                    END;

                    IF GroupSum THEN BEGIN
                        CalcSumsInFilter("G/L Entry", RowOffset);
                        GetGLEntryDimensions("Entry No.", TempDimBuf, "Dimension Set ID");
                    END;
                    // Disponibilizar quando Desenvolvido
                    // IF "DRF Code" <> '' THEN
                    //   GenJnlLine."DRF Code" := "DRF Code";

                    IF (Amount <> 0) OR ("Additional-Currency Amount" <> 0) THEN BEGIN
                        IF NOT GroupSum THEN BEGIN
                            TotalAmount += Amount;
                            IF GLSetup."Additional Reporting Currency" <> '' THEN
                                TotalAmountAddCurr += "Additional-Currency Amount";

                            GetGLEntryDimensions("Entry No.", TempDimBuf, "Dimension Set ID");
                        END;

                        IF TempSelectedDim.FIND('-') THEN
                            REPEAT
                                IF TempDimBuf.GET(DATABASE::"G/L Entry", "Entry No.", TempSelectedDim."Dimension Code")
                                THEN BEGIN
                                    TempDimBuf2."Table ID" := TempDimBuf."Table ID";
                                    TempDimBuf2."Dimension Code" := TempDimBuf."Dimension Code";
                                    TempDimBuf2."Dimension Value Code" := TempDimBuf."Dimension Value Code";
                                    TempDimBuf2.INSERT;
                                END;
                            UNTIL TempSelectedDim.NEXT = 0;

                        DimensionBufferID := DimBufMgt.GetDimensionId(TempDimBuf2);

                        EntryNoAmountBuf.RESET;
                        IF ClosePerBusUnit AND FIELDACTIVE("Business Unit Code") THEN
                            EntryNoAmountBuf."Business Unit Code" := "Business Unit Code"
                        ELSE
                            EntryNoAmountBuf."Business Unit Code" := '';
                        EntryNoAmountBuf."Entry No." := DimensionBufferID;
                        IF EntryNoAmountBuf.FIND THEN BEGIN
                            EntryNoAmountBuf.Amount := EntryNoAmountBuf.Amount + Amount;
                            EntryNoAmountBuf.Amount2 := EntryNoAmountBuf.Amount2 + "Additional-Currency Amount";
                            EntryNoAmountBuf.MODIFY;
                        END ELSE BEGIN
                            EntryNoAmountBuf.Amount := Amount;
                            EntryNoAmountBuf.Amount2 := "Additional-Currency Amount";
                            EntryNoAmountBuf.INSERT;
                        END;
                    END;

                    IF GroupSum THEN
                        NEXT(RowOffset);
                end;

                trigger OnPostDataItem()
                var
                    TempDimBuf2: Record "Dimension Buffer" temporary;
                    GlobalDimVal1: Code[20];
                    GlobalDimVal2: Code[20];
                    NewDimensionID: Integer;
                begin
                    EntryNoAmountBuf.RESET;
                    MaxEntry := EntryNoAmountBuf.COUNT;
                    EntryCount := 0;
                    Window.UPDATE(2, Text012);
                    Window.UPDATE(3, 0);

                    IF EntryNoAmountBuf.FIND('-') THEN
                        REPEAT
                            EntryCount := EntryCount + 1;
                            IF CURRENTDATETIME - LastWindowUpdateDateTime > 1000 THEN BEGIN
                                LastWindowUpdateDateTime := CURRENTDATETIME;
                                Window.UPDATE(3, ROUND(EntryCount / MaxEntry * 10000, 1));
                            END;

                            IF (EntryNoAmountBuf.Amount <> 0) OR (EntryNoAmountBuf.Amount2 <> 0) THEN BEGIN
                                GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
                                GenJnlLine."Account No." := "G/L Account No.";
                                GenJnlLine."Source Code" := SourceCodeSetup."Close Income Statement";
                                GenJnlLine."Reason Code" := GenJnlBatch."Reason Code";
                                GenJnlLine.VALIDATE(Amount, -EntryNoAmountBuf.Amount);

                                GenJnlLine."System-Created Entry" := TRUE;

                                GenJnlLine."Source Currency Amount" := -EntryNoAmountBuf.Amount2;
                                GenJnlLine."Business Unit Code" := EntryNoAmountBuf."Business Unit Code";

                                TempDimBuf2.DELETEALL;
                                DimBufMgt.RetrieveDimensions(EntryNoAmountBuf."Entry No.", TempDimBuf2);
                                NewDimensionID := DimMgt.CreateDimSetIDFromDimBuf(TempDimBuf2);
                                GenJnlLine."Dimension Set ID" := NewDimensionID;
                                DimMgt.UpdateGlobalDimFromDimSetID(NewDimensionID, GlobalDimVal1, GlobalDimVal2);
                                GenJnlLine."Shortcut Dimension 1 Code" := '';
                                IF ClosePerGlobalDim1 THEN
                                    GenJnlLine."Shortcut Dimension 1 Code" := GlobalDimVal1;
                                GenJnlLine."Shortcut Dimension 2 Code" := '';
                                IF ClosePerGlobalDim2 THEN
                                    GenJnlLine."Shortcut Dimension 2 Code" := GlobalDimVal2;

                                HandleGenJnlLine;

                                UpdateBalAcc;

                            END;
                        UNTIL EntryNoAmountBuf.NEXT = 0;

                    EntryNoAmountBuf.DELETEALL;
                end;

                trigger OnPreDataItem()
                begin
                    Window.UPDATE(2, Text013);
                    Window.UPDATE(3, 0);

                    IF ClosePerGlobalDimOnly OR ClosePerBusUnit THEN
                        CASE TRUE OF
                            ClosePerBusUnit AND (ClosePerGlobalDim1 OR ClosePerGlobalDim2):
                                SETCURRENTKEY(
                                  "G/L Account No.", "Business Unit Code",
                                  "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date");
                            ClosePerBusUnit AND NOT (ClosePerGlobalDim1 OR ClosePerGlobalDim2):
                                SETCURRENTKEY(
                                  "G/L Account No.", "Business Unit Code", "Posting Date");
                            NOT ClosePerBusUnit AND (ClosePerGlobalDim1 OR ClosePerGlobalDim2):
                                SETCURRENTKEY(
                                  "G/L Account No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date");
                        END;

                    SETRANGE("Posting Date", FiscalYearStartDate, FiscYearClosingDate);

                    MaxEntry := COUNT;

                    EntryNoAmountBuf.DELETEALL;
                    EntryCount := 0;

                    LastWindowUpdateDateTime := CURRENTDATETIME;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                ThisAccountNo := ThisAccountNo + 1;
                Window.UPDATE(1, "No.");
                Window.UPDATE(4, ROUND(ThisAccountNo / NoOfAccounts * 10000, 1));
                Window.UPDATE(2, '');
                Window.UPDATE(3, 0);

                // Disponibilizar Quando Desenvolvido
                // IF "Associate DRF Code" THEN BEGIN
                TempGLAcc.INIT;
                TempGLAcc.TRANSFERFIELDS("G/L Account");
                TempGLAcc.INSERT;
                //   "Associate DRF Code" := FALSE;
                //   MODIFY;
                // END;

            end;

            trigger OnPostDataItem()
            begin
            end;

            trigger OnPreDataItem()
            begin
                NoOfAccounts := COUNT;
            end;
        }
    }

    requestpage
    {
        Caption = 'Close Income Statement';
        SaveValues = true;
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(FiscalYearEndingDate; EndDateReq)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Fiscal Year Ending Date';
                        ToolTip = 'Specifies the last date in the closed fiscal year. This date is used to determine the closing date.';

                        trigger OnValidate()
                        begin
                            ValidateEndDate(TRUE);
                        end;
                    }
                    field(GenJournalTemplate; GenJnlLine."Journal Template Name")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Gen. Journal Template';
                        TableRelation = "Gen. Journal Template";
                        ToolTip = 'Specifies the general journal template that is used by the batch job.';

                        trigger OnValidate()
                        begin
                            GenJnlLine."Journal Batch Name" := '';
                            DocNo := '';
                        end;
                    }
                    field(GenJournalBatch; GenJnlLine."Journal Batch Name")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Gen. Journal Batch';
                        Lookup = true;
                        ToolTip = 'Specifies the general journal batch that is used by the batch job.';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            GenJnlLine.TESTFIELD("Journal Template Name");
                            GenJnlTemplate.GET(GenJnlLine."Journal Template Name");
                            GenJnlBatch.FILTERGROUP(2);
                            GenJnlBatch.SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
                            GenJnlBatch.FILTERGROUP(0);
                            GenJnlBatch."Journal Template Name" := GenJnlLine."Journal Template Name";
                            GenJnlBatch.Name := GenJnlLine."Journal Batch Name";
                            IF PAGE.RUNMODAL(0, GenJnlBatch) = ACTION::LookupOK THEN BEGIN
                                Text := GenJnlBatch.Name;
                                EXIT(TRUE);
                            END;
                        end;

                        trigger OnValidate()
                        begin
                            IF GenJnlLine."Journal Batch Name" <> '' THEN BEGIN
                                GenJnlLine.TESTFIELD("Journal Template Name");
                                GenJnlBatch.GET(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");
                            END;
                            ValidateJnl;
                        end;
                    }
                    field(DocumentNo; DocNo)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Document No.';
                        ToolTip = 'Specifies the number of the document that is processed by the report or batch job.';
                    }
                    field(RetainedEarningsAcc; RetainedEarningsGLAcc."No.")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Retained Earnings Acc.';
                        TableRelation = "G/L Account" WHERE ("Account Type" = CONST (Posting),
                                                             "Account Category" = FILTER (' ' | Equity),
                                                             "Income/Balance" = CONST ("Balance Sheet"));
                        ToolTip = 'Specifies the retained earnings account that the batch job posts to. This account should be the same as the account that is used by the Close Income Statement batch job.';

                        trigger OnValidate()
                        begin
                            IF RetainedEarningsGLAcc."No." <> '' THEN BEGIN
                                RetainedEarningsGLAcc.FIND;
                                RetainedEarningsGLAcc.CheckGLAcc;
                            END;
                        end;
                    }
                    field(PostingDescription; PostingDescription)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posting Description';
                        ToolTip = 'Specifies the description that accompanies the posting.';
                    }
                    group("Close by")
                    {
                        Caption = 'Close by';
                        field(ClosePerBusUnit; ClosePerBusUnit)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Business Unit Code';
                            ToolTip = 'Specifies the code for the business unit, in a company group structure.';
                        }
                        field(Dimensions; ColumnDim)
                        {
                            ApplicationArea = Dimensions;
                            Caption = 'Dimensions';
                            Editable = false;
                            ToolTip = 'Specifies dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                            trigger OnAssistEdit()
                            var
                                TempSelectedDim2: Record "Selected Dimension" temporary;
                                s: Text[1024];
                            begin
                                DimSelectionBuf.SetDimSelectionMultiple(3, REPORT::"Close Income Statement", ColumnDim);

                                SelectedDim.GetSelectedDim(USERID, 3, REPORT::"Close Income Statement", '', TempSelectedDim2);
                                s := CheckDimPostingRules(TempSelectedDim2);
                                IF s <> '' THEN
                                    MESSAGE(s);
                            end;
                        }
                    }
                    field(InventoryPeriodClosed; IsInvtPeriodClosed)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Inventory Period Closed';
                        ToolTip = 'Specifies that the inventory period has been closed.';
                    }
                    field(PostEntries; PostEntries)
                    {
                        Caption = 'Post Entries';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        var
            GLAccount: Record "G/L Account";
            GLAccountCategory: Record "G/L Account Category";
        begin
            IF PostingDescription = '' THEN
                PostingDescription :=
                  COPYSTR(ObjTransl.TranslateObject(ObjTransl."Object Type"::Report, REPORT::"Close Income Statement"), 1, 30);
            EndDateReq := 0D;
            AccountingPeriod.SETRANGE("New Fiscal Year", TRUE);
            AccountingPeriod.SETRANGE("Date Locked", TRUE);
            IF AccountingPeriod.FINDLAST THEN BEGIN
                EndDateReq := AccountingPeriod."Starting Date" - 1;
                IF NOT ValidateEndDate(FALSE) THEN
                    EndDateReq := 0D;
            END ELSE
                IF EndDateReq = 0D THEN
                    ERROR(NoFiscalYearsErr);
            ValidateJnl;
            ColumnDim := DimSelectionBuf.GetDimSelectionText(3, REPORT::"Close Income Statement", '');
            IF RetainedEarningsGLAcc."No." = '' THEN BEGIN
                GLAccountCategory.SETRANGE("Account Category", GLAccountCategory."Account Category"::Equity);
                GLAccountCategory.SETRANGE(
                  "Additional Report Definition", GLAccountCategory."Additional Report Definition"::"Retained Earnings");
                IF GLAccountCategory.FINDFIRST THEN BEGIN
                    GLAccount.SETRANGE("Account Subcategory Entry No.", GLAccountCategory."Entry No.");
                    IF GLAccount.FINDFIRST THEN
                        RetainedEarningsGLAcc."No." := GLAccount."No.";
                END;
            END;
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    var
        UpdateAnalysisView: Codeunit "Update Analysis View";
    begin
        InsBalLines;

        IF GenJnlLine.ISEMPTY THEN BEGIN
            RecoverAssociatedDRFCode;
            EXIT;
        END;

        Window.CLOSE;
        Window.OPEN(Text31022890);
        IF PostEntries OR (GLSetup."Additional Reporting Currency" <> '') THEN BEGIN
            NoOfRecords := GenJnlLine.COUNT;
            Window.UPDATE(1, LineCount);
            GenJnlLine.FINDSET;
            REPEAT
                GenJnlLine2 := GenJnlLine;
                LineCount := LineCount + 1;
                Window.UPDATE(2, ROUND(LineCount / NoOfRecords * 10000, 1));
                GenJnlPostLine.RunWithCheck(GenJnlLine2);
            UNTIL GenJnlLine.NEXT = 0;
        END ELSE
            GenJnlManagement.TemplateSelectionFromBatch(GenJnlBatch);


        Window.CLOSE;
        COMMIT;
        IF GLSetup."Additional Reporting Currency" <> '' THEN BEGIN
            MESSAGE(Text016);
            UpdateAnalysisView.UpdateAll(0, TRUE);
        END ELSE
            MESSAGE(Text017);

        IF NOT HidePrintDialog THEN
            MESSAGE(Text016);

        RecoverAssociatedDRFCode;
    end;

    trigger OnPreReport()
    var
        s: Text[1024];
    begin
        IF EndDateReq = 0D THEN
            ERROR(Text000);
        ValidateEndDate(TRUE);
        IF DocNo = '' THEN
            ERROR(Text001);

        SelectedDim.GetSelectedDim(USERID, 3, REPORT::"Close Income Statement", '', TempSelectedDim);
        s := CheckDimPostingRules(TempSelectedDim);
        IF s <> '' THEN
            IF NOT CONFIRM(s + Text007, FALSE) THEN
                ERROR('');

        GenJnlBatch.GET(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");
        SourceCodeSetup.GET;
        GLSetup.GET;
        IF GLSetup."Additional Reporting Currency" <> '' THEN BEGIN

            IF NOT CONFIRM(
                 Text003 +
                 Text005 +
                 Text007, FALSE)
            THEN
                ERROR('');
        END;

        IF PostEntries THEN
            GenJnlLine.DELETEALL;

        Window.OPEN(Text008 + Text009 + Text019 + Text010 + Text011);

        ClosePerGlobalDim1 := FALSE;
        ClosePerGlobalDim2 := FALSE;
        ClosePerGlobalDimOnly := TRUE;

        IF TempSelectedDim.FIND('-') THEN
            REPEAT
                IF TempSelectedDim."Dimension Code" = GLSetup."Global Dimension 1 Code" THEN
                    ClosePerGlobalDim1 := TRUE;
                IF TempSelectedDim."Dimension Code" = GLSetup."Global Dimension 2 Code" THEN
                    ClosePerGlobalDim2 := TRUE;
                IF (TempSelectedDim."Dimension Code" <> GLSetup."Global Dimension 1 Code") AND
                   (TempSelectedDim."Dimension Code" <> GLSetup."Global Dimension 2 Code")
                THEN
                    ClosePerGlobalDimOnly := FALSE;
            UNTIL TempSelectedDim.NEXT = 0;

        GenJnlLine.SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
        GenJnlLine.SETRANGE("Journal Batch Name", GenJnlLine."Journal Batch Name");
        IF NOT GenJnlLine.FINDLAST THEN;

        GenJnlLine.INIT;
        GenJnlLine."Posting Date" := FiscYearClosingDate;
        GenJnlLine."Document No." := DocNo;
        GenJnlLine.Description := PostingDescription;
        GenJnlLine."Posting No. Series" := GenJnlBatch."Posting No. Series";
        CLEAR(GenJnlPostLine);
    end;

    var
        AccountingPeriod: Record "Accounting Period";
        SourceCodeSetup: Record "Source Code Setup";
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
        RetainedEarningsGLAcc: Record "G/L Account";
        GLSetup: Record "General Ledger Setup";
        DimSelectionBuf: Record "Dimension Selection Buffer";
        ObjTransl: Record "Object Translation";
        SelectedDim: Record "Selected Dimension";
        TempSelectedDim: Record "Selected Dimension" temporary;
        EntryNoAmountBuf: Record "Entry No. Amount Buffer" temporary;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        DimMgt: Codeunit DimensionManagement;
        DimBufMgt: Codeunit "Dimension Buffer Management";
        Window: Dialog;
        FiscalYearStartDate: Date;
        FiscYearClosingDate: Date;
        EndDateReq: Date;
        DocNo: Code[20];
        PostingDescription: Text[50];
        ClosePerBusUnit: Boolean;
        ClosePerGlobalDim1: Boolean;
        ClosePerGlobalDim2: Boolean;
        ClosePerGlobalDimOnly: Boolean;
        TotalAmount: Decimal;
        TotalAmountAddCurr: Decimal;
        ColumnDim: Text[250];
        NoOfAccounts: Integer;
        ThisAccountNo: Integer;
        Text000: Label 'Enter the ending date for the fiscal year.';
        Text001: Label 'Enter a Document No.';
        Text002: Label 'Enter Retained Earnings Account No.';
        Text003: Label 'By using an additional reporting currency, this batch job will post closing entries directly to the general ledger.  ';
        Text005: Label 'These closing entries will not be transferred to a general journal before the program posts them to the general ledger.\\ ';
        Text007: Label '\Do you want to continue?';
        Text008: Label 'Creating general journal lines...\\';
        Text009: Label 'Account No.         #1##################\';
        Text010: Label 'Now performing      #2##################\';
        Text011: Label '                    @3@@@@@@@@@@@@@@@@@@\';
        Text019: Label '                    @4@@@@@@@@@@@@@@@@@@\';
        Text012: Label 'Creating Gen. Journal lines';
        Text013: Label 'Calculating Amounts';
        Text014: Label 'The fiscal year must be closed before the income statement can be closed.';
        Text015: Label 'The fiscal year does not exist.';
        Text017: Label 'The journal lines have successfully been created.';
        Text016: Label 'The closing entries have successfully been posted.';
        Text020: Label 'The following G/L Accounts have mandatory dimension codes that have not been selected:';
        Text021: Label '\\In order to post to these accounts you must also select these dimensions:';
        MaxEntry: Integer;
        EntryCount: Integer;
        LastWindowUpdateDateTime: DateTime;
        NoFiscalYearsErr: Label 'No closed fiscal year exists.';
        GenJnlLine2: Record "Gen. Journal Line";
        BalLineBuffer: Record "PTSS Inc. Stmt. Clos. Buffer" temporary;
        TempGLAcc: Record "G/L Account" temporary;
        HidePrintDialog: Boolean;
        NextDimID: Integer;
        LineCount: Integer;
        NoOfRecords: Integer;
        Text31022890: Label 'Posting lines         #1###### @2@@@@@@@@@@@@@';
        Text31022891: Label 'Collecting dimension informação';
        PostEntries: Boolean;
        GenJnlManagement: Codeunit GenJnlManagement;

    local procedure ValidateEndDate(RealMode: Boolean): Boolean
    var
        OK: Boolean;
    begin
        IF EndDateReq = 0D THEN
            EXIT;

        OK := AccountingPeriod.GET(EndDateReq + 1);
        IF OK THEN
            OK := AccountingPeriod."New Fiscal Year";
        IF OK THEN BEGIN
            IF NOT AccountingPeriod."Date Locked" THEN BEGIN
                IF NOT RealMode THEN
                    EXIT;
                ERROR(Text014);
            END;
            FiscYearClosingDate := CLOSINGDATE(EndDateReq);
            AccountingPeriod.SETRANGE("New Fiscal Year", TRUE);
            OK := AccountingPeriod.FIND('<');
            FiscalYearStartDate := AccountingPeriod."Starting Date";
        END;
        IF NOT OK THEN BEGIN
            IF NOT RealMode THEN
                EXIT;
            ERROR(Text015);
        END;
        EXIT(TRUE);
    end;

    local procedure ValidateJnl()
    begin
        DocNo := '';
        IF GenJnlBatch.GET(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name") THEN
            IF GenJnlBatch."No. Series" <> '' THEN
                DocNo := NoSeriesMgt.TryGetNextNo(GenJnlBatch."No. Series", EndDateReq);
    end;

    local procedure HandleGenJnlLine()
    begin
        OnBeforeHandleGenJnlLine(GenJnlLine);

        GenJnlLine."Additional-Currency Posting" :=
          GenJnlLine."Additional-Currency Posting"::None;
        IF GLSetup."Additional Reporting Currency" <> '' THEN BEGIN
            GenJnlLine."Source Currency Code" := GLSetup."Additional Reporting Currency";
            IF ZeroGenJnlAmount THEN BEGIN
                GenJnlLine."Additional-Currency Posting" :=
                  GenJnlLine."Additional-Currency Posting"::"Additional-Currency Amount Only";
                GenJnlLine.VALIDATE(Amount, GenJnlLine."Source Currency Amount");
                GenJnlLine."Source Currency Amount" := 0;
            END;
            IF GenJnlLine.Amount <> 0 THEN BEGIN
                GenJnlPostLine.RUN(GenJnlLine);
                IF DocNo = NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series", EndDateReq, FALSE) THEN
                    NoSeriesMgt.SaveNoSeries;
            END;
        END ELSE
            IF NOT ZeroGenJnlAmount THEN
                GenJnlLine.INSERT;
    end;

    local procedure CalcSumsInFilter(var GLEntrySource: Record "G/L Entry"; var Offset: Integer)
    var
        GLEntry: Record "G/L Entry";
    begin
        GLEntry.COPYFILTERS(GLEntrySource);
        IF ClosePerBusUnit THEN BEGIN
            GLEntry.SETRANGE("Business Unit Code", GLEntrySource."Business Unit Code");
            GenJnlLine."Business Unit Code" := GLEntrySource."Business Unit Code";
        END;
        IF ClosePerGlobalDim1 THEN BEGIN
            GLEntry.SETRANGE("Global Dimension 1 Code", GLEntrySource."Global Dimension 1 Code");
            IF ClosePerGlobalDim2 THEN
                GLEntry.SETRANGE("Global Dimension 2 Code", GLEntrySource."Global Dimension 2 Code");
        END;

        GLEntry.CALCSUMS(Amount);
        GLEntrySource.Amount := GLEntry.Amount;
        TotalAmount += GLEntrySource.Amount;
        IF GLSetup."Additional Reporting Currency" <> '' THEN BEGIN
            GLEntry.CALCSUMS("Additional-Currency Amount");
            GLEntrySource."Additional-Currency Amount" := GLEntry."Additional-Currency Amount";
            TotalAmountAddCurr += GLEntrySource."Additional-Currency Amount";
        END;
        Offset := GLEntry.COUNT - 1;
    end;

    local procedure GetGLEntryDimensions(EntryNo: Integer; var DimBuf: Record "Dimension Buffer"; DimensionSetID: Integer)
    var
        DimSetEntry: Record "Dimension Set Entry";
    begin
        DimSetEntry.SETRANGE("Dimension Set ID", DimensionSetID);
        IF DimSetEntry.FINDSET THEN
            REPEAT
                DimBuf."Table ID" := DATABASE::"G/L Entry";
                DimBuf."Entry No." := EntryNo;
                DimBuf."Dimension Code" := DimSetEntry."Dimension Code";
                DimBuf."Dimension Value Code" := DimSetEntry."Dimension Value Code";
                DimBuf.INSERT;
            UNTIL DimSetEntry.NEXT = 0;
    end;

    local procedure CheckDimPostingRules(var SelectedDim: Record "Selected Dimension"): Text[1024]
    var
        DefaultDim: Record "Default Dimension";
        ErrorText: Text[1024];
        DimText: Text[1024];
        PrevAcc: Code[20];
        Handled: Boolean;
    begin
        OnBeforeCheckDimPostingRules(SelectedDim, ErrorText, Handled);
        IF Handled THEN
            EXIT(ErrorText);

        DefaultDim.SETRANGE("Table ID", DATABASE::"G/L Account");
        DefaultDim.SETFILTER(
          "Value Posting", '%1|%2',
          DefaultDim."Value Posting"::"Same Code", DefaultDim."Value Posting"::"Code Mandatory");

        IF DefaultDim.FIND('-') THEN
            REPEAT
                SelectedDim.SETRANGE("Dimension Code", DefaultDim."Dimension Code");
                IF NOT SelectedDim.FIND('-') THEN BEGIN
                    IF STRPOS(DimText, DefaultDim."Dimension Code") < 1 THEN
                        DimText := DimText + ' ' + FORMAT(DefaultDim."Dimension Code");
                    IF PrevAcc <> DefaultDim."No." THEN BEGIN
                        PrevAcc := DefaultDim."No.";
                        IF ErrorText = '' THEN
                            ErrorText := Text020;
                        ErrorText := ErrorText + ' ' + FORMAT(DefaultDim."No.");
                    END;
                END;
                SelectedDim.SETRANGE("Dimension Code");
            UNTIL (DefaultDim.NEXT = 0) OR (STRLEN(ErrorText) > MAXSTRLEN(ErrorText) - MAXSTRLEN(DefaultDim."No.") - STRLEN(Text021) - 1);
        IF ErrorText <> '' THEN
            ErrorText := COPYSTR(ErrorText + Text021 + DimText, 1, MAXSTRLEN(ErrorText));
        EXIT(ErrorText);
    end;

    local procedure IsInvtPeriodClosed(): Boolean
    var
        AccPeriod: Record "Accounting Period";
        InvtPeriod: Record "Inventory Period";
    begin
        IF EndDateReq = 0D THEN
            EXIT;
        AccPeriod.GET(EndDateReq + 1);
        AccPeriod.NEXT(-1);
        EXIT(InvtPeriod.IsInvtPeriodClosed(AccPeriod."Starting Date"));
    end;

    [Scope('Personalization')]
    procedure InitializeRequestTest(EndDate: Date; GenJournalLine: Record "Gen. Journal Line"; GLAccount: Record "G/L Account"; CloseByBU: Boolean)
    begin
        EndDateReq := EndDate;
        GenJnlLine := GenJournalLine;
        ValidateJnl;
        RetainedEarningsGLAcc := GLAccount;
        ClosePerBusUnit := CloseByBU;
    end;

    local procedure ZeroGenJnlAmount(): Boolean
    begin
        EXIT((GenJnlLine.Amount = 0) AND (GenJnlLine."Source Currency Amount" <> 0))
    end;

    local procedure GroupSum(): Boolean
    begin
        EXIT(ClosePerGlobalDimOnly AND (ClosePerBusUnit OR ClosePerGlobalDim1));
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckDimPostingRules(SelectedDimension: Record "Selected Dimension"; var ErrorText: Text[1024]; var Handled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeHandleGenJnlLine(var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    procedure InsBalLines()
    begin
        IF NOT BalLineBuffer.ISEMPTY THEN BEGIN
            BalLineBuffer.FINDSET;
            REPEAT
                GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
                GLSetup.GET;
                IF NOT GLSetup."PTSS Use Dim. for Inc. Balance Acc." THEN BEGIN
                    GenJnlLine."Shortcut Dimension 1 Code" := '';
                    GenJnlLine."Shortcut Dimension 2 Code" := '';
                    GenJnlLine."Business Unit Code" := '';
                END ELSE BEGIN
                    GenJnlLine."Business Unit Code" := BalLineBuffer."Business Unit Code";
                    GenJnlLine."Shortcut Dimension 1 Code" := BalLineBuffer."Shortcut Dimension 1 Code";
                    GenJnlLine."Shortcut Dimension 2 Code" := BalLineBuffer."Shortcut Dimension 2 Code";
                END;
                GenJnlLine."Account No." := BalLineBuffer."Account No.";
                GenJnlLine."Source Code" := SourceCodeSetup."Close Income Statement";
                GenJnlLine."Reason Code" := GenJnlBatch."Reason Code";
                GenJnlLine."Additional-Currency Posting" :=
                  GenJnlLine."Additional-Currency Posting"::None;
                IF GLSetup."Additional Reporting Currency" <> '' THEN BEGIN
                    GenJnlLine."Source Currency Code" := GLSetup."Additional Reporting Currency";
                    IF (BalLineBuffer.Amount = 0) AND
                       (BalLineBuffer."Additional-Currency Amount" <> 0)
                    THEN BEGIN
                        GenJnlLine.VALIDATE(Amount, -BalLineBuffer."Additional-Currency Amount");
                        GenJnlLine.VALIDATE("Source Currency Amount", 0);
                        GenJnlLine."Additional-Currency Posting" :=
                          GenJnlLine."Additional-Currency Posting"::"Additional-Currency Amount Only";
                    END ELSE BEGIN
                        GenJnlLine.VALIDATE(Amount, -BalLineBuffer.Amount);
                        GenJnlLine.VALIDATE("Source Currency Amount", -BalLineBuffer."Additional-Currency Amount");
                    END;
                END ELSE
                    GenJnlLine.VALIDATE(Amount, -BalLineBuffer.Amount);
                GenJnlLine."System-Created Entry" := TRUE;
                GenJnlLine.INSERT;

                GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
                IF BalLineBuffer."Closing Account?" THEN BEGIN
                    GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
                    GenJnlLine."Account No." := BalLineBuffer."Account No.";
                    GenJnlLine."Source Code" := SourceCodeSetup."Close Income Statement";
                    GenJnlLine."Reason Code" := GenJnlBatch."Reason Code";
                    GenJnlLine."Additional-Currency Posting" :=
                      GenJnlLine."Additional-Currency Posting"::None;
                    IF GLSetup."Additional Reporting Currency" <> '' THEN BEGIN
                        GenJnlLine."Source Currency Code" := GLSetup."Additional Reporting Currency";
                        IF (BalLineBuffer.Amount = 0) AND
                           (BalLineBuffer."Additional-Currency Amount" <> 0)
                          THEN BEGIN
                            GenJnlLine.VALIDATE(Amount, BalLineBuffer."Additional-Currency Amount");
                            GenJnlLine.VALIDATE("Source Currency Amount", 0);
                            GenJnlLine."Additional-Currency Posting" :=
                              GenJnlLine."Additional-Currency Posting"::"Additional-Currency Amount Only";
                        END ELSE BEGIN
                            GenJnlLine.VALIDATE(Amount, BalLineBuffer.Amount);
                            GenJnlLine.VALIDATE("Source Currency Amount", BalLineBuffer."Additional-Currency Amount");
                        END;
                    END ELSE
                        GenJnlLine.VALIDATE(Amount, BalLineBuffer.Amount);
                    GenJnlLine."System-Created Entry" := TRUE;
                    GenJnlLine.INSERT;
                    GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
                END

            UNTIL BalLineBuffer.NEXT = 0;
        END;
    end;

    procedure RecoverAssociatedDRFCode()
    begin
        IF NOT TempGLAcc.ISEMPTY THEN BEGIN
            TempGLAcc.FINDSET;
            REPEAT
                "G/L Account".GET(TempGLAcc."No.");
                //A Disponibilizar quando desenvolvido
                //"G/L Account"."Associate DRF Code" := TempGLAcc."Associate DRF Code";
                "G/L Account".MODIFY;
            UNTIL TempGLAcc.NEXT = 0;
        END;
    end;

    procedure UpdateBalAcc()
    var
        GLAcc: Record "G/L Account";
        BalAcc: Code[20];
    begin
        GLSetup.GET;
        IF NOT GLSetup."PTSS Use Dim. for Inc. Balance Acc." THEN BEGIN
            GLAcc.GET(GenJnlLine."Account No.");
            IF NOT BalLineBuffer.GET(0, GLAcc."PTSS Income Stmt. Bal. Acc.") THEN BEGIN
                GLAcc.TESTFIELD("PTSS Income Stmt. Bal. Acc.");
                BalLineBuffer."Entry No." := 0;
                BalLineBuffer."Account No." := GLAcc."PTSS Income Stmt. Bal. Acc.";
                IF GenJnlLine."Additional-Currency Posting" =
                  GenJnlLine."Additional-Currency Posting"::"Additional-Currency Amount Only" THEN BEGIN
                    BalLineBuffer."Additional-Currency Amount" := GenJnlLine.Amount;
                    BalLineBuffer.Amount := 0;
                END ELSE BEGIN
                    BalLineBuffer.Amount := GenJnlLine.Amount;
                    BalLineBuffer."Additional-Currency Amount" := GenJnlLine."Source Currency Amount";
                END;
                BalLineBuffer.INSERT;
            END ELSE BEGIN
                IF GenJnlLine."Additional-Currency Posting" =
                   GenJnlLine."Additional-Currency Posting"::"Additional-Currency Amount Only" THEN
                    BalLineBuffer."Additional-Currency Amount" := GenJnlLine.Amount + BalLineBuffer."Additional-Currency Amount"
                ELSE BEGIN
                    BalLineBuffer.Amount := BalLineBuffer.Amount + GenJnlLine.Amount;
                    BalLineBuffer."Additional-Currency Amount" :=
                      GenJnlLine."Source Currency Amount" + BalLineBuffer."Additional-Currency Amount";
                END;
                BalLineBuffer.MODIFY;
            END;
        END ELSE BEGIN
            GLAcc.GET(GenJnlLine."Account No.");
            GLAcc.TESTFIELD("PTSS Income Stmt. Bal. Acc.");
            IF NOT BalLineBuffer.FIND('+') THEN BEGIN
                BalLineBuffer.INIT;
                BalLineBuffer."Entry No." := 1;
            END ELSE BEGIN
                BalLineBuffer.INIT;
                BalLineBuffer."Entry No." := BalLineBuffer."Entry No." + 1;
            END;
            BalLineBuffer.INIT;
            BalLineBuffer."Entry No." := BalLineBuffer."Entry No." + 1;
            BalLineBuffer."Account No." := GLAcc."PTSS Income Stmt. Bal. Acc.";
            BalLineBuffer."Business Unit Code" := GenJnlLine."Business Unit Code";
            BalLineBuffer."Shortcut Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
            BalLineBuffer."Shortcut Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
            IF GenJnlLine."Additional-Currency Posting" =
              GenJnlLine."Additional-Currency Posting"::"Additional-Currency Amount Only" THEN BEGIN
                BalLineBuffer."Additional-Currency Amount" := GenJnlLine.Amount;
                BalLineBuffer.Amount := 0;
            END ELSE BEGIN
                BalLineBuffer.Amount := GenJnlLine.Amount;
                BalLineBuffer."Additional-Currency Amount" := GenJnlLine."Source Currency Amount";
            END;
            BalLineBuffer.INSERT;
        END;

        BalAcc := GLAcc."PTSS Income Stmt. Bal. Acc.";
        GLAcc.GET(BalAcc);
        IF GLAcc."PTSS Income Stmt. Bal. Acc." <> '' THEN BEGIN
            BalLineBuffer."Closing Account?" := TRUE;
            BalLineBuffer.MODIFY;
            UpdateBalAcc2(BalAcc)
        END
    end;

    procedure UpdateBalAcc2(Account: Code[20])
    var
        GLAcc: Record "G/L Account";
        BalAcc: Code[20];
    begin
        GLSetup.GET;
        IF NOT GLSetup."PTSS Use Dim. for Inc. Balance Acc." THEN BEGIN
            GLAcc.GET(Account);
            IF NOT BalLineBuffer.GET(0, GLAcc."PTSS Income Stmt. Bal. Acc.") THEN BEGIN
                GLAcc.TESTFIELD("PTSS Income Stmt. Bal. Acc.");
                BalLineBuffer."Entry No." := 0;
                BalLineBuffer."Account No." := GLAcc."PTSS Income Stmt. Bal. Acc.";
                IF GenJnlLine."Additional-Currency Posting" =
                  GenJnlLine."Additional-Currency Posting"::"Additional-Currency Amount Only" THEN BEGIN
                    BalLineBuffer."Additional-Currency Amount" := GenJnlLine.Amount;
                    BalLineBuffer.Amount := 0;
                END ELSE BEGIN
                    BalLineBuffer.Amount := GenJnlLine.Amount;
                    BalLineBuffer."Additional-Currency Amount" := GenJnlLine."Source Currency Amount";
                END;
                BalLineBuffer.INSERT;
            END ELSE BEGIN
                IF GenJnlLine."Additional-Currency Posting" =
                   GenJnlLine."Additional-Currency Posting"::"Additional-Currency Amount Only" THEN
                    BalLineBuffer."Additional-Currency Amount" := GenJnlLine.Amount + BalLineBuffer."Additional-Currency Amount"
                ELSE BEGIN
                    BalLineBuffer.Amount := BalLineBuffer.Amount + GenJnlLine.Amount;
                    BalLineBuffer."Additional-Currency Amount" :=
                      GenJnlLine."Source Currency Amount" + BalLineBuffer."Additional-Currency Amount";
                END;
                BalLineBuffer.MODIFY;
            END;
        END ELSE BEGIN
            GLAcc.GET(Account);
            GLAcc.TESTFIELD("PTSS Income Stmt. Bal. Acc.");
            IF BalLineBuffer.FIND('+') THEN;
            BalLineBuffer.INIT;
            BalLineBuffer."Entry No." := BalLineBuffer."Entry No." + 1;
            BalLineBuffer."Account No." := GLAcc."PTSS Income Stmt. Bal. Acc.";
            BalLineBuffer."Business Unit Code" := GenJnlLine."Business Unit Code";
            BalLineBuffer."Shortcut Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
            BalLineBuffer."Shortcut Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
            IF GenJnlLine."Additional-Currency Posting" =
              GenJnlLine."Additional-Currency Posting"::"Additional-Currency Amount Only" THEN BEGIN
                BalLineBuffer."Additional-Currency Amount" := GenJnlLine.Amount;
                BalLineBuffer.Amount := 0;
            END ELSE BEGIN
                BalLineBuffer.Amount := GenJnlLine.Amount;
                BalLineBuffer."Additional-Currency Amount" := GenJnlLine."Source Currency Amount";
            END;
            BalLineBuffer.INSERT;
        END;

        BalAcc := GLAcc."PTSS Income Stmt. Bal. Acc.";
        GLAcc.GET(BalAcc);
        IF GLAcc."PTSS Income Stmt. Bal. Acc." <> '' THEN
            BalLineBuffer."Closing Account?" := TRUE
        ELSE
            BalLineBuffer."Closing Account?" := FALSE;
        BalLineBuffer.MODIFY;
        IF GLAcc."PTSS Income Stmt. Bal. Acc." <> '' THEN
            UpdateBalAcc2(BalAcc)

    end;

    procedure SetHidePrintDialog(NewHidePrintDialog: Boolean)
    begin
        HidePrintDialog := NewHidePrintDialog;
    end;
}

