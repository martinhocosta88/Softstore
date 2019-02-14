pageextension 31023131 "PTSS No. Series" extends "No. Series" //MyTargetPageId
{
    //Notas de Crédito de Acordo com a Fatura
    //Certificação Documentos
    layout
    {
        addafter(LastNoUsed)
        {
            field("PTSS SAF-T Invoice Type"; "PTSS SAF-T Invoice Type")
            {
                ToolTip = 'Specifies the SAF-T Invoice Type';
                ApplicationArea = All;
            }

            field("PTSS GTAT Document Type"; "PTSS GTAT Document Type")
            {
                Tooltip = 'Specifies the GTAT Document Type';
                ApplicationArea = All;
            }

            field("PTSS Credit Invoice"; "PTSS Credit Invoice")
            {
                ToolTip = 'Specifies if the Series Credits an Invoice';
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}