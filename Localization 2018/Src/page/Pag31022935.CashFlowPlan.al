page 31022935 "Cash-Flow Plan"
{
    //Cash-Flow
    PageType = List;
    SourceTable = "Cash-Flow Plan";
    CardPageID = "Cash-Flow Code Card";
    Caption = 'Cash-Flow Plan';
    UsageCategory = Lists;
    ApplicationArea=Basic, Suite;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ToolTip = 'Specifies the account number.';
                    Style = Strong;
                    StyleExpr = NoEmphasize;
                }
                field(Description; Description)
                {
                    ToolTip = 'Specifies the description.';
                    Style = Strong;
                    StyleExpr = NameEmphasize;
                }
                field("Type"; "Type")
                {
                    ToolTip = 'Specifies account type.';
                }
                field("Totaling"; "Totaling")
                {
                    ToolTip = 'Specifies the totaling amount.';
                }
                field(Indentation; Indentation)
                {
                    ToolTip = 'Specifies the indentation level.';
                }
                field("Net Change"; "Net Change")
                {
                    ToolTip = 'Specifies the net change.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Indent Cash-Flow Plan")
            {
                Caption = 'Indent Cash-Flow Plan';
                ToolTip = 'Indents Cash-Flow Plan.';
                Image = IndentChartOfAccounts;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction();

                var
                    GLAccMgmt: Codeunit "G/L Account Management";
                begin
                    GLAccMgmt.CashFlowIndent;
                end;
            }
            action("Cash-Flow Report")
            {
                Caption = 'Cash-Flow Report';
                ToolTip = 'Generates de Cash-Flow report.';
                RunObject = report "Cash-Flow Report";
                Image = Report;
                trigger OnAction()
                begin

                end;
            }
        }
    }
    var
        NoEmphasize: Boolean;
        NameEmphasize: Boolean;
        NameIndent: Integer;

    trigger OnAfterGetRecord()
    begin
        NoEmphasize := Type <> Type::Posting;
        NameIndent := Indentation;
        NameEmphasize := Type <> Type::Posting;
    end;

}