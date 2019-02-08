pageextension 31023136 "PTSS Inv. Posting Setup Card" extends "Inventory Posting Setup Card" //MyTargetPageId
{
    //Registo Inventário Físico
    layout
    {

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
                ToolTip = 'Suggest G/L Accounts for selected setup.';
                ApplicationArea = All;
                Promoted = True;
                PromotedCategory = New;
                trigger OnAction()
                begin
                    SuggestSetupAccountsPT();
                end;
            }
        }
    }
}