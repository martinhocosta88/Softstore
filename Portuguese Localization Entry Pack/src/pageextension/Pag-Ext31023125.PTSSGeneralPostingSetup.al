pageextension 31023125 "PTSS General Posting Setup" extends "General Posting Setup" //MyTargetPageId
{
    //Campo Conta Liquidação Notas de Crédito
    layout
    {

    }

    actions
    {
        modify("&Copy")
        {
            Visible = false;
        }
        addafter("&Copy")
        {
            action("PTSS &Copy")
            {
                ApplicationArea = Basic, Suite;
                caption = 'Copy';
                ToolTip = 'Copy a record with selected fields or all fields from the general posting setup to a new record. Before you start to copy you have to create the new record.;PTG=Copy a record with selected fields or all fields from the general posting setup to a new record. Before you start to copy you have to create the new record.';
                Promoted = true;
                PromotedCategory = Process;
                Ellipsis = true;
                Image = Copy;

                trigger OnAction()
                begin
                    CurrPage.SAVERECORD;
                    CopyGenPostingSetupPT.SetGenPostingSetup(Rec);
                    CopyGenPostingSetupPT.RUNMODAL;
                    CLEAR(CopyGenPostingSetupPT);
                end;
            }

        }

    }
    var
        CopyGenPostingSetupPT: Report "PTSS Copy - Gen. Posting Setup";
}