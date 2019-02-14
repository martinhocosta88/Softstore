xmlport 31022901 "PTSS BP XML Message"
{
    // COPE

    Caption = 'BP XML Message';
    Direction = Export;
    Encoding = UTF8;
    FormatEvaluate = Xml;
    //XMLVersionNo = 1.0;

    schema
    {
        textelement(BOP_CO)
        {
            textelement(controlo)
            {
                textelement(reportante)
                {
                    textelement(npc)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            CompanyInfo.GET;
                            npc := CompanyInfo."VAT Registration No.";
                        end;
                    }
                }
                textelement(periodorep)
                {
                    textelement(ano)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            "PTSS BP Ledger Entry".RESET;
                            "PTSS BP Ledger Entry".SETRANGE(Status, "PTSS BP Ledger Entry".Status::" ");
                            "PTSS BP Ledger Entry".SETRANGE(Month, ExpMonth);
                            "PTSS BP Ledger Entry".SETRANGE(Year, ExpYear);
                            IF "PTSS BP Ledger Entry".FINDSET THEN
                                ano := FORMAT("PTSS BP Ledger Entry".Year);
                        end;
                    }
                    textelement(mes)
                    {

                        trigger OnBeforePassVariable()
                        begin
                            "PTSS BP Ledger Entry".RESET;
                            "PTSS BP Ledger Entry".SETRANGE(Status, "PTSS BP Ledger Entry".Status::" ");
                            "PTSS BP Ledger Entry".SETRANGE(Month, ExpMonth);
                            "PTSS BP Ledger Entry".SETRANGE(Year, ExpYear);

                            IF "PTSS BP Ledger Entry".FINDSET THEN
                                mes := FORMAT("PTSS BP Ledger Entry".Month)
                        end;
                    }
                }
            }
            textelement(reporte)
            {
                tableelement("PTSS BP Ledger Entry"; "PTSS BP Ledger Entry")
                {
                    XmlName = 'registo';
                    SourceTableView = SORTING ("Entry No.")
                                      WHERE (Status = FILTER (''));
                    fieldelement(id_reg; "PTSS BP Ledger Entry"."Entry No.")
                    {
                        MinOccurs = Zero;
                    }
                    fieldelement(data_ref; "PTSS BP Ledger Entry"."Reference Date")
                    {
                        MinOccurs = Zero;
                    }
                    textelement(reg)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                        textelement(cope)
                        {
                            fieldelement(natureza_registo; "PTSS BP Ledger Entry"."Record Nature")
                            {
                                MinOccurs = Zero;
                            }
                            textelement(npc2)
                            {
                                MinOccurs = Zero;

                                trigger OnBeforePassVariable()
                                begin
                                    IF "PTSS BP Ledger Entry"."NPC 2nd Intervener" <> 0 THEN
                                        npc2 := FORMAT("PTSS BP Ledger Entry"."NPC 2nd Intervener")
                                    ELSE
                                        npc2 := '';
                                end;
                            }
                            fieldelement(montante; "PTSS BP Ledger Entry".Amount)
                            {
                                MinOccurs = Zero;
                            }
                            fieldelement(divisa; "PTSS BP Ledger Entry"."Currency Code")
                            {
                                MinOccurs = Zero;
                            }
                            fieldelement(cod_estat; "PTSS BP Ledger Entry"."Statistic Code")
                            {
                                MinOccurs = Zero;
                            }
                            fieldelement(tipo_valor; "PTSS BP Ledger Entry"."Amount Type")
                            {
                                MinOccurs = Zero;
                            }
                            fieldelement(tipo_conta; "PTSS BP Ledger Entry"."Account Type")
                            {
                                MinOccurs = Zero;
                            }
                            fieldelement(pais_conta; "PTSS BP Ledger Entry"."Foreign Country Code")
                            {
                                MinOccurs = Zero;
                            }
                            fieldelement(pais_contraparte; "PTSS BP Ledger Entry"."Counterpart Country Code")
                            {
                                MinOccurs = Zero;
                            }
                            fieldelement(pais_activo; "PTSS BP Ledger Entry"."Active Country Code")
                            {
                                MinOccurs = Zero;
                            }
                            fieldelement(data_vencimento; "PTSS BP Ledger Entry"."Due Date")
                            {
                                MinOccurs = Zero;
                            }
                            fieldelement(contraparte; "PTSS BP Ledger Entry"."Counterpart ID")
                            {
                                MinOccurs = Zero;
                            }
                        }
                    }

                    trigger OnAfterGetRecord()
                    begin
                        "PTSS BP Ledger Entry".Status := "PTSS BP Ledger Entry".Status::Exported;
                        "PTSS BP Ledger Entry".MODIFY;
                    end;
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    var
        CompanyInfo: Record "Company Information";
        ExpMonth: Integer;
        ExpYear: Integer;

    procedure ClearNodes(FileName: Text[1024])
    var
        TierMgt: Codeunit "File Management";
        XMLFile: File;
        XMLFile2: File;
        LineText: Text[1024];
        Line: Text[1024];
        TempFileName: Text[1024];
        ChTab: Char;
        i: Integer;
        TotalTabs: Integer;
        TextTabs: Text[1024];
        Pos1: Integer;
        Pos2: Integer;
    begin
        ChTab := 9;
        // XXX
        // XMLFile.TEXTMODE(TRUE);
        // XMLFile.WRITEMODE(FALSE);
        // XMLFile.OPEN(FileName);
        // XMLFile2.TEXTMODE(TRUE);
        // XMLFile2.WRITEMODE(TRUE);

        // TempFileName := TierMgt.ServerTempFileName('.xml');
        // XMLFile2.CREATE(TempFileName);
        // REPEAT
        //     XMLFile.READ(Line);
        //     LineText := DELCHR(FORMAT(Line), '<', ' ');

        //     CASE LineText OF
        //         '<npc2 />', '<pais_conta />', '<pais_activo />',
        //         '<data_vencimento>0</data_vencimento>',
        //         '<contraparte />', '<id_banco />':
        //             BEGIN
        //             END;

        //         ELSE BEGIN
        //                 XMLFile2.WRITE(Line);
        //             END;
        //     END;
        // UNTIL XMLFile.POS = XMLFile.LEN;
        // XMLFile.CLOSE;
        // XMLFile2.CLOSE;
        // COPY(TempFileName, FileName);


    end;

    procedure InitExport(ExportMonth: Integer; ExportYear: Integer)
    begin
        ExpMonth := ExportMonth;
        ExpYear := ExportYear;
        "PTSS BP Ledger Entry".RESET;
        "PTSS BP Ledger Entry".SETRANGE(Status, "PTSS BP Ledger Entry".Status::" ");
        "PTSS BP Ledger Entry".SETRANGE(Month, ExpMonth);
        "PTSS BP Ledger Entry".SETRANGE(Year, ExpYear);

        currXMLport.EXPORT;
    end;
}

