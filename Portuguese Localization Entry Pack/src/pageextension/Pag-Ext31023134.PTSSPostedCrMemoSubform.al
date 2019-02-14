pageextension 31023134 "PTSS Posted Cr. Memo Subform" extends "Posted Sales Cr. Memo Subform" //MyTargetPageId
{
    //Notas de Crédito de Acordo com a Fatura
    layout
    {
        addafter("Shortcut Dimension 2 Code")
        {
            field("PTSS Credit-to Doc. No."; "PTSS Credit-to Doc. No.")
            {
                ToolTip = 'Specifies the Credit-to Doc. No.';
                ApplicationArea = All;
            }
            field("PTSS Credit-to Doc. Line No."; "PTSS Credit-to Doc. Line No.")
            {
                ToolTip = 'Specifies the Credit-to Doc. Line No.';
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}