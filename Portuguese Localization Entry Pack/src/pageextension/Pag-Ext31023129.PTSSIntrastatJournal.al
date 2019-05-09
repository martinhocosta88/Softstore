pageextension 31023129 "PTSS Intrastat Journal" extends "Intrastat Journal" //MyTargetPageId
{
    //Intrastat
    layout
    {

    }

    actions
    {
        modify(CreateFile)
        {
            Visible = false;
        }
        addafter(CreateFile)
        {
            action("PTSS CreateFile")
            {
                ApplicationArea = All;
                Caption = 'Create File';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Ellipsis = true;
                Image = MakeDiskette;

                trigger OnAction()
                var
                    VATReportsConfiguration: Record "VAT Reports Configuration";
                begin
                    VATReportsConfiguration.SETRANGE("VAT Report Type", VATReportsConfiguration."VAT Report Type"::"Intrastat Report");
                    IF VATReportsConfiguration.FINDFIRST AND (VATReportsConfiguration."Validate Codeunit ID" <> 0) AND
                    (VATReportsConfiguration."Content Codeunit ID" <> 0)
                    THEN BEGIN
                        CODEUNIT.RUN(VATReportsConfiguration."Validate Codeunit ID", Rec);
                        IF ErrorsExistOnCurrentBatch(TRUE) THEN
                            ERROR('');
                        COMMIT;

                        CODEUNIT.RUN(VATReportsConfiguration."Content Codeunit ID", Rec);
                        EXIT;
                    END;

                    //não se pode usar a funcao PrintIntrastatJnlLine em extensões
                    //ReportPrint.PrintIntrastatJnlLine(Rec);

                    IF ErrorsExistOnCurrentBatch(TRUE) THEN
                        ERROR('');
                    COMMIT;

                    IntrastatJnlLine.COPYFILTERS(Rec);
                    IntrastatJnlLine.SETRANGE("Journal Template Name", "Journal Template Name");
                    IntrastatJnlLine.SETRANGE("Journal Batch Name", "Journal Batch Name");
                    REPORT.RUN(REPORT::"PTSS Intrastat Export", TRUE, FALSE, IntrastatJnlLine);
                end;
            }
        }
    }
    local procedure ErrorsExistOnCurrentBatch(ShowError: Boolean): Boolean
    var
        ErrorMessage: Record "Error Message";
        IntrastatJnlBatch: Record "Intrastat Jnl. Batch";
    begin
        IntrastatJnlBatch.GET("Journal Template Name", "Journal Batch Name");
        ErrorMessage.SetContext(IntrastatJnlBatch);
        EXIT(ErrorMessage.HasErrors(ShowError));
    end;

    var
        IntrastatJnlLine: Record "Intrastat Jnl. Line";
        ReportPrint: Codeunit "Test Report-Print";
}