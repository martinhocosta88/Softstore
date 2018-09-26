pageextension 31023100 "PTSS Chart of Accounts" extends "Chart of Accounts"
{
    //Check Chart of Accounts
    //Taxonomies
    layout
    {
        addlast(Control1)
        {
            field("PTSS Income Stmt. Bal. Acc."; "PTSS Income Stmt. Bal. Acc.")
            {
                ToolTip = 'Specifies the adjustment account for the comercial posting accounts.';
                ApplicationArea = All;
                Visible = false;
            }
            field("PTSS Taxonomy Code"; "PTSS Taxonomy Code")
            {
                ToolTip = 'Specifies the Taxonomy Code';
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addlast("F&unctions")
        {
            action("PTSS CheckChart")
            {
                Image = IndentChartOfAccounts;
                Caption = 'Check Chart of Accounts';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = True;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction()
                var
                    GLAccMgmt: Codeunit "PTSS G/L Account Management";
                    GLSetup: Record "General Ledger Setup";
                begin
                    GLSetup.GET;
                    GLSetup.TESTFIELD("PTSS Check Chart of Accounts");
                    GLAccMgmt.CheckChartAcc;
                end;
            }
        }
    }
}