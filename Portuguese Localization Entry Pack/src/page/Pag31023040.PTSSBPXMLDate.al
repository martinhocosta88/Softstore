page 31023040 "PTSS BP XML Date"
{
    //COPE

    Caption = 'BP XML Date';
    PageType = Worksheet;
    SourceTable = "PTSS BP Ledger Entry";

    layout
    {
        area(content)
        {
            field(ExportMonth; ExportMonth)
            {
                ApplicationArea = All;
                Caption = 'Month';
            }
            field(ExportYear; ExportYear)
            {
                ApplicationArea = All;
                Caption = 'Year';
            }
        }
    }
    actions
    {
        area(processing)
        {
            action("Export XML")
            {
                ApplicationArea = All;
                Caption = 'Export XML';
                Image = Export;
                Promoted = true;

                trigger OnAction()
                var
                    BPLedgerEntry: Record "PTSS BP Ledger Entry";
                begin
                    BPLedgerEntry.RESET;
                    BPLedgerEntry.SETFILTER(Status, '<>%1', BPLedgerEntry.Status::Exported);
                    BPLedgerEntry.SETRANGE(Month, ExportMonth);
                    BPLedgerEntry.SETRANGE(Year, ExportYear);

                    IF BPLedgerEntry.FINDFIRST THEN
                        ExportXML(COPYSTR(FORMAT(BPLedgerEntry."Reference Date"), 1, 6), ExportMonth, ExportYear)
                    ELSE
                        ERROR(Text31022980);
                end;
            }
        }
    }

    var
        Text31022980: Label 'Unable to generate the XML. The XML has been generated already or there are no records for the month/year selected.';
        ExportMonth: Integer;
        ExportYear: Integer;
}

