pageextension 50100 "Chart of Accounts Extension" extends "Chart of Accounts"
{
    layout
    {
        addlast(Control1)
        {
            field("Income Stmt. Bal. Acc."; "Income Stmt. Bal. Acc.")
            {
                ToolTip = 'Specifies the adjustment account for the comercial posting accounts.';
                Visible = false;
            }
           field("Taxonomy Code"; "Taxonomy Code")
           {
               ToolTip ='Specifies the Taxonomy Code';
               ApplicationArea = Basic,Suite;
           }
        }

    }
    actions{
        addlast("F&unctions")
        {
            action(CheckChart)
            {
                Image=IndentChartOfAccounts;
                Caption='Check Chart of Accounts';
                Promoted=true;
                PromotedCategory=Process;
                PromotedIsBig=True;
                PromotedOnly=true;
                ApplicationArea=All;
                trigger OnAction()
                var
                    GLAccMgmt:Codeunit "G/L Account Management";
                    GLSetup:Record "General Ledger Setup";
                begin
                    GLSetup.GET;
                    GLSetup.TESTFIELD("Check Chart of Accounts");
                    GLAccMgmt.CheckChartAcc;
                end;
            }
        }
    }
}