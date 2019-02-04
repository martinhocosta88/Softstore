pageextension 31023131 "PTSS No. Series" extends "No. Series" //MyTargetPageId
{
    //Notas de Crédito de Acordo com a Fatura
    layout
    {
        addafter(LastNoUsed)
        {
            field("PTSS Credit Invoice"; "PTSS Credit Invoice")
            {
                Caption = 'Credit Invoice';
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}