pageextension 31023151 "PTSS Serv. Credit Memo Subform" extends "Service Credit Memo Subform" //MyTargetPageId
{
    //Nota de Crédito de acordo com a Fatura
    layout
    {
        addafter("ShortcutDimCode[8]")
        {
            field("PTSS Credit-to Doc. No."; "PTSS Credit-to Doc. No.")
            {
                ToolTip = 'Specifies the Credit-to Doc. No.';
                ApplicationArea = All;
                HideValue = not isCrMemoSerie;
            }
            field("PTSS Credit-to Doc. Line No."; "PTSS Credit-to Doc. Line No.")
            {
                ToolTip = 'Specifies the Credit-to Doc. Line No.';
                ApplicationArea = All;
                HideValue = not isCrMemoSerie;
            }
        }
    }

    actions
    {
    }
    procedure ControlCreditInvoice(NoSeriesCode: Code[20])
    var
        NoSeries: Record "No. Series";
    begin
        NoSeries.GET(NoSeriesCode);
        IF NoSeries."PTSS Credit Invoice" THEN
            isCrMemoSerie := TRUE
        ELSE
            isCrMemoSerie := FALSE;
    end;

    var
        isCrMemoSerie: Boolean;
}