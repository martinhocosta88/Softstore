report 31022946 "PTSS IRC - Model 22"
{
    // IRC - Modelo 22

    Caption = 'IRC - Model 22';
    ProcessingOnly = true;
    UsageCategory = ReportsAndAnalysis;
    UseRequestPage = true;

    dataset
    {
        dataitem(AccSchdLine; "Acc. Schedule Line")
        {
            DataItemTableView = SORTING ("Schedule Name", "Line No.");

            trigger OnAfterGetRecord()
            var
                AccSchedManagement: Codeunit AccSchedManagement;
                SalarialMass: Decimal;
                Product: Decimal;
                Municipalities: Record "PTSS Municipalities";
                TotalSalarialMass: Decimal;
                TotalProduct: Decimal;
                i: Integer;
            begin
                SplitLineNo(AccSchdLine."Line No.", Value, RegNoInt, ValueBox);

                IF (LineValue <> Value) THEN
                    CASE LineValue OF
                        '04':
                            BEGIN
                                Model22RepBuffer.InsertDet04(ColumnValue);
                            END;
                        '05':
                            Model22RepBuffer.InsertDet05(ColumnValue);
                        '06':
                            Model22RepBuffer.InsertDet06(ColumnValue);
                        '07':
                            Model22RepBuffer.InsertDet07(ColumnValue);
                        '08':
                            Model22RepBuffer.InsertDet08(ColumnValue);
                        '09':
                            Model22RepBuffer.InsertDet09(ColumnValue);
                        '10':
                            Model22RepBuffer.InsertDet10(ColumnValue, ShowBlank);
                        '11':
                            Model22RepBuffer.InsertDet11(ColumnValue);
                        '12':
                            Model22RepBuffer.InsertDet12(ColumnValue);
                        '13':
                            BEGIN
                                IF AnnexB THEN
                                    Model22RepBuffer.InsertDet13(ColumnValue, TRUE, ShowBlank)
                                ELSE
                                    Model22RepBuffer.InsertDet13(ColumnValue, FALSE, ShowBlank);
                            END;
                        '14':
                            Model22RepBuffer.InsertDet14(ColumnValue);
                        '15':
                            BEGIN
                                Model22RepBuffer.InsertDet15(ColumnValue);
                                Model22RepBuffer.InsertMod22Trailer(ShowDet14);
                            END;
                        //ANNEX A
                        '40':
                            BEGIN
                                IF AnnexA THEN BEGIN
                                    Model22RepBuffer.InsertAnexAHeader(M22_Year);
                                    i := 0;
                                    Municipalities.SETCURRENTKEY(Active);
                                    Municipalities.SETRANGE(Active, TRUE);
                                    IF Municipalities.FINDSET THEN BEGIN
                                        REPEAT
                                            i := i + 1;
                                            Model22RepBuffer.InsertAnexADet01(Municipalities."Salary Mass", Municipalities."Municipality Tax",
                                              Municipalities.Product, i);
                                            TotalSalarialMass := TotalSalarialMass + Municipalities."Salary Mass";
                                            TotalProduct := TotalProduct + Municipalities.Product;
                                        UNTIL Municipalities.NEXT = 0;
                                        Model22RepBuffer.InsertAnexATrailer(TotalSalarialMass, TotalProduct, i);
                                    END ELSE BEGIN
                                        Model22RepBuffer.InsertAnexADet01(0, 0, 0, 0);
                                        Model22RepBuffer.InsertAnexATrailer(0, 0, 0);
                                    END;
                                END;
                            END;
                        //ANNEX B
                        '60':
                            BEGIN
                                IF AnnexB THEN
                                    Model22RepBuffer.InsertAnexBHeader(M22_Year);
                            END;
                        '61':
                            BEGIN
                                IF AnnexB THEN
                                    Model22RepBuffer.InsertAnexBDet01(ColumnValue, ShowBlank);
                            END;
                        '62':
                            BEGIN
                                IF AnnexB THEN BEGIN
                                    Model22RepBuffer.InsertAnexBDet02(ColumnValue, ShowBlank);
                                    Model22RepBuffer.InsertAnexBTrailer;
                                END;
                            END;
                        //ANNEX C
                        '70':
                            BEGIN
                                IF AnnexC THEN
                                    Model22RepBuffer.InsertAnexCHeader(M22_Year);
                            END;
                        '71':
                            BEGIN
                                IF AnnexC THEN BEGIN
                                    Model22RepBuffer.InsertAnexCDet01(ColumnValue, ShowBlank, TotalVol);
                                    Model22RepBuffer.InsertAnexCDet02(ColumnValue, ShowBlank, TotalVol);
                                END;
                            END;
                    END;

                IF Totaling = '' THEN BEGIN
                    ColumnValue[RegNoInt] := 0;
                    ShowBlank[RegNoInt] := TRUE;
                END ELSE BEGIN
                    IF AccSchdLine."Line No." = UseClosingDate THEN BEGIN
                        SETFILTER("Date Filter", '%1..%2', StartingDate, CLOSINGDATE(EndingDate));
                        ColumnValue[RegNoInt] := AccSchedManagement.CalcCell(AccSchdLine, ColumnLayout, FALSE);
                    END ELSE BEGIN
                        SETFILTER("Date Filter", '%1..%2', StartingDate, EndingDate);
                        ColumnValue[RegNoInt] := AccSchedManagement.CalcCell(AccSchdLine, ColumnLayout, FALSE);
                    END;
                    IF ColumnValue[RegNoInt] = 0 THEN
                        ShowBlank[RegNoInt] := TRUE
                    ELSE
                        ShowBlank[RegNoInt] := FALSE;
                END;

                IF (Value = '16') AND (ValueBox = '017') AND (ColumnValue[RegNoInt] <> 0) THEN
                    ShowDet14 := TRUE;

                LineValue := Value;
            end;

            trigger OnPreDataItem()
            var
                AccSchedName: Record "Acc. Schedule Name";
                GenLedgSetup: Record "General Ledger Setup";
            begin
                GenLedgSetup.GET();
                AccSchedName.GET(GenLedgSetup."PTSS Model 22 Acc. Sch. Name");
                SETFILTER("Schedule Name", '%1', AccSchedName.Name);
                ColumnLayout.SETRANGE(ColumnLayout."Column Layout Name", AccSchedName."Default Column Layout");
                UseClosingDate := 401201;
                ShowDet14 := FALSE;
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
                    field("Starting Date"; StartingDate)
                    {
                        Caption = 'Starting Date';
                        NotBlank = true;
                    }
                    field(Year; M22_Year)
                    {
                        BlankZero = true;
                        Caption = 'Year';
                        MaxValue = 9999;
                        MinValue = 0;
                        NotBlank = true;
                    }
                    field(FileName; FileName)
                    {
                        Caption = 'File Name';
                        NotBlank = true;

                        // trigger OnAssistEdit()
                        // var
                        //     FileMgt: Codeunit "File Management";
                        // begin
                        //     //soft,o FileName := FileMgt.OpenFileDialog(Text31022892,FileName,'');
                        //     //FileName := FileMgt.SaveFileDialog(Text31022892, FileName, '');//soft,n
                        // end;

                    }
                    field("Ending Date"; EndingDate)
                    {
                        Caption = 'Ending Date';
                        ClosingDates = false;
                        NotBlank = true;

                        trigger OnValidate()
                        begin
                            M22_Year := DATE2DMY(EndingDate, 3);
                        end;
                    }
                    field("Annex A"; AnnexA)
                    {
                        Caption = 'Annex A: "Local tax"';
                    }
                    field("Annex B"; AnnexB)
                    {
                        Caption = 'Annex B: "Simplified Scheme"';
                    }
                    field("Annex C"; AnnexC)
                    {
                        Caption = 'Annex C: "Autonomous Regions"';
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

    trigger OnPostReport()
    var
        I: Integer;
        OutputStream: OutStream;
        InputStream: InStream;
        tmpBlob: Record TempBlob;
    begin
        Model22RepBuffer.InsertMod22DeclarationTrailer;
        // VFile.CLOSE;
        // Model22RepBuffer.SaveFile(FromFile);
        // RBMgt.DownloadToFile(FromFile, FileName);
        // Model22RepBuffer.DELETEALL;
        // MESSAGE(Text31022894, FileName);
        tmpBlob.Blob.CreateOutStream(OutputStream);
        Model22RepBuffer.SaveFile(FileName);
        tmpBlob.Blob.CreateInStream(InputStream);
        DownloadFromStream(InputStream, '', '', '', FileName);
        Model22RepBuffer.DELETEALL;
        MESSAGE(Text31022894, FileName);
    end;

    trigger OnPreReport()
    begin
        CompInf.GET;
        IF (CompInf."PTSS Tax Authority Code" = '') OR (CompInf."VAT Registration No." = '') OR (CompInf."PTSS Legal Rep. VAT Reg. No." = '') OR
          (CompInf."PTSS TOC VAT Reg. No." = '') OR (CompInf."PTSS Municipality" = '')
        THEN
            ERROR(Text31022893);
        Model22RepBuffer.InsertMod22FileHeader(TODAY);
        Model22RepBuffer.InsertMod22DeclarationHeader(StartingDate, EndingDate, M22_Year);
        Model22RepBuffer.InsertMod22Header(CompInf."PTSS Tax Authority Code", CompInf."VAT Registration No.",
          CompInf."PTSS Legal Rep. VAT Reg. No.", CompInf."PTSS TOC VAT Reg. No.", AnnexA,
          AnnexB, AnnexC);

        //FromFile := RBMgt.ServerTempFileName('.txt');
        //VFile.CREATE(FromFile);
    end;

    var
        ColumnLayout: Record "Column Layout";
        CompInf: Record "Company Information";
        Model22RepBuffer: Record "PTSS VAT Report File Buffer";
        RBMgt: Codeunit "File Management";
        VFile: File;
        LineNo: Integer;
        RegNoInt: Integer;
        M22_Year: Integer;
        UseClosingDate: Integer;
        ValueBox: Text[3];
        LineValue: Text[2];
        Value: Text[2];
        FileName: Text[250];
        ColumnValue: array[250] of Decimal;
        Text31022891: Label 'MOD.22';
        StartingDate: Date;
        EndingDate: Date;
        AnnexA: Boolean;
        AnnexB: Boolean;
        AnnexC: Boolean;
        ShowDet14: Boolean;
        Text31022892: Label 'Path Mod. 22 file';
        Text31022893: Label 'Please, all Company Information fields of Model 22 tab must be filled.';
        ShowBlank: array[250] of Boolean;
        TotalVol: Decimal;
        Text31022894: Label 'Model 22 has been exported successfully under %1.';
        Blank: Label ' ';
        HeadingZero: Label '0';


    procedure SplitLineNo(LineNo: Integer; var Value: Text[2]; var RegNoInt: Integer; var ValueBox: Text[3])
    var
        TextLineNo: Text[7];
        RegNo: Text[2];
    begin
        TextLineNo := FORMAT(LineNo);
        IF STRLEN(TextLineNo) = 6 THEN
            Value := HeadingZero + COPYSTR(TextLineNo, 1, 1)
        ELSE
            IF STRLEN(TextLineNo) = 7 THEN
                Value := COPYSTR(TextLineNo, 1, 2);

        ValueBox := COPYSTR(TextLineNo, STRLEN(TextLineNo) - 2, 3);
        RegNo := COPYSTR(TextLineNo, STRLEN(TextLineNo) - 4, 2);
        IF COPYSTR(RegNo, 1, 1) = '0' THEN
            RegNo := DELCHR(RegNo, '=', HeadingZero);
        EVALUATE(RegNoInt, RegNo);
    end;
}

