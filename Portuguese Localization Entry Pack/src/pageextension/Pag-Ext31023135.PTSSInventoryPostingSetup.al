pageextension 31023135 "PTSS Inventory Posting Setup" extends "Inventory Posting Setup" //MyTargetPageId
{
    //Registo Inventário Físico
    layout
    {
        addafter("Mfg. Overhead Variance Account")
        {
            field("PTSS Gains in Inventory"; "PTSS Gains in Inventory")
            {
                ToolTip = 'Specifies the Gains in Inventory.';
                ApplicationArea = All;
            }
            field("PTSS Losses in Inventory"; "PTSS Losses in Inventory")
            {
                ToolTip = 'Specifies the Losses in Inventory.';
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        modify(SuggestAccounts)
        {
            Visible = false;
        }
        addafter(SuggestAccounts)
        {
            action("PTSS SuggestAccountsPT")
            {
                Caption = 'Suggest Accounts';
                ToolTip = 'Set Default Accounts';
                ApplicationArea = All;
                Image = Default;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                begin
                    SuggestSetupAccountsPT();
                end;
            }
        }
    }
}