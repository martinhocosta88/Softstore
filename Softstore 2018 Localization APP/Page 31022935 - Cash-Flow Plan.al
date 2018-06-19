page 31022935 "Cash-Flow Plan"
{
    PageType = List;
    SourceTable = "Cash-Flow Plan";
    CardPageID = "Cash-Flow Code Card";
    Caption='Cash-Flow Plan';
    var
    NoEmphasize:Boolean;
    NameEmphasize:Boolean;
    NameIndent:Integer;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ToolTip='Specifies the account number.';
                    Style=Strong;
                    StyleExpr=NoEmphasize; 
                }
                field(Description; Description)
                {
                    ToolTip='Specifies the description.';
                    Style=Strong;
                    StyleExpr=NameEmphasize;
                }
                field("Type";"Type")
                {
                    ToolTip='Specifies account type.';
                }
                field("Totaling"; "Totaling")
                {
                    ToolTip='Specifies the totaling amount.';
                }
                field(Indentation; Indentation)
                {
                    ToolTip='Specifies the indentation level.';
                }
                field("Net Change"; "Net Change")
                {
                    ToolTip='Specifies the net change.';
                }
            }
        }
        area(factboxes)
        {
            
        }
    }

    actions
    {
        area(processing)
        {
            action(Indent Cash-Flow Plan)
            Image=IndentChartOfAccounts;
            Promoted=Yes;
            PromotedCategory=Process;
            {
                trigger OnAction();
                begin
                    GLAccMgmt.CashFlowIndent;
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        NoEmphasize := Type <> Type::Posting;
        NameIndent := Indentation;
        NameEmphasize := Type <> Type::Posting;
    end;
}