pageextension 31023132 "PTSS Sales Cr. Memo Subform" extends "Sales Cr. Memo Subform" //MyTargetPageId
{
    //Notas de Crédito de Acordo com a Fatura
    layout
    {

        addafter("Shortcut Dimension 2 Code")
        {

            field("PTSS Credit-to Doc. No."; "PTSS Credit-to Doc. No.")
            {
                ApplicationArea = All;
                HideValue = not isCrMemoSerie;
                ToolTip = 'Specifies the Credit-to Doc. No.';
            }
            field("PTSS Credit-to Doc. Line No."; "PTSS Credit-to Doc. Line No.")
            {
                ApplicationArea = All;
                HideValue = not isCrMemoSerie;
                ToolTip = 'Specifies the Credit-to Doc. Line No.';
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
        isCrMemoSerie := NoSeries."PTSS Credit Invoice";
    end;

    var
        isCrMemoSerie: Boolean;
}