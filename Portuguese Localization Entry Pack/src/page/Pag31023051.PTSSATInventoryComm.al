page 31023051 "PTSS AT Inventory Comm."
{
    //AT Inventory Communication

    Caption = 'Export AT Inventory';
    PageType = Card;
    SaveValues = true;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = Basic, Suite;
    layout
    {
        area(content)
        {
            group(Options)
            {
                Caption = 'Options';
                field(Month; Month)
                {
                    ApplicationArea = All;
                    Caption = 'Month';
                    OptionCaption = 'January,February,March,April,May,June,July,August,September,October,November,December';
                }
                field(Year; Year)
                {
                    ApplicationArea = All;
                    BlankZero = true;
                    Caption = 'Year';
                }
                field("File Type"; FileType)
                {
                    ApplicationArea = All;
                    Caption = 'File Type';
                    OptionCaption = 'XML,CSV';
                }
                field("File Name"; FileName)
                {
                    ApplicationArea = All;
                    Caption = 'File Name';
                    ShowMandatory = true;
                    Visible = False;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Inventory)
            {
                Caption = 'Inventory';
                action("Export Inventory")
                {
                    Caption = 'Export Inventory';
                    Image = ExportFile;
                    Promoted = true;
                    PromotedCategory = Process;
                    ApplicationArea = All;

                    trigger OnAction();
                    var
                        Text000: Label 'Export to XML File';
                        Text001: Label 'XML Files (*.xml)|*.xml|All Files (*.*)|*.*';
                    begin
                        IF FileType = FileType::CSV THEN
                            FileName := Text31022892
                        ELSE
                            FileName := Text31022897;

                        clear(OutputStream);
                        tmpBlob.Blob.CreateOutStream(OutputStream);

                        IF FileType = FileType::CSV THEN BEGIN
                            ATInvComMgmt.SetData(Month, Year);
                            exportCSV.SETDESTINATION(OutputStream);
                            exportCSV.Export;
                        END ELSE BEGIN
                            ATInvComMgmt.SetData(Month, Year);
                            exportXML.SETDESTINATION(OutputStream);
                            exportXML.Export;
                        END;

                        tmpBlob.Blob.CreateInStream(Inputstream);
                        DownloadFromStream(Inputstream, '', '', '', FileName);

                    END;
                }
            }
        }
    }
    var
        ATInvComMgmt: Codeunit "PTSS AT Inv. Comm. Management";
        Text31022891: Label 'File Name should be specified before exporting.';
        Text31022892: Label 'Inventory AT.csv';
        Text31022897: Label 'Inventory AT.xml';
        exportXML: xmlport "PTSS AT Inventory Comm. XML";
        exportCSV: XMLport "PTSS AT Inventory Comm. CSV";
        tmpBlob: Record TempBlob temporary;
        Year: Integer;
        Month: Option "1","2","3","4","5","6","7","8","9","10","11","12";
        FileType: Option XML,CSV;
        Inputstream: InStream;
        OutputStream: OutStream;
        FileName: Text[1024];
}

