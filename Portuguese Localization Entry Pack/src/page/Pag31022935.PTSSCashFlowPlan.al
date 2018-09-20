page 31022935 "PTSS Cash-Flow Plan"
{
    //Cash-Flow
    PageType = List;
    SourceTable = "PTSS Cash-Flow Plan";
    CardPageID = "PTSS Cash-Flow Code Card";
    Caption = 'Cash-Flow Plan';
    UsageCategory = Lists;
    ApplicationArea = Basic, Suite;
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
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Description)
                {
                    ToolTip = 'Specifies the description.';
                    Style = Strong;
                    StyleExpr = NameEmphasize;
                    ApplicationArea = Basic, Suite;
                }
                field("Type"; "Type")
                {
                    ToolTip = 'Specifies account type.';
                    ApplicationArea = Basic, Suite;
                }
                field("Totaling"; "Totaling")
                {
                    ToolTip = 'Specifies the totaling amount.';
                    ApplicationArea = Basic, Suite;
                }
                field(Indentation; Indentation)
                {
                    ToolTip = 'Specifies the indentation level.';
                    ApplicationArea = Basic, Suite;
                }
                field("Net Change"; "Net Change")
                {
                    ToolTip = 'Specifies the net change.';
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("PTSS Indent Cash-Flow Plan")
            {
                Caption = 'Indent Cash-Flow Plan';
                ToolTip = 'Indents Cash-Flow Plan.';
                Image = IndentChartOfAccounts;
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction();

                var
                    GLAccMgmt: Codeunit "PTSS G/L Account Management";
                begin
                    GLAccMgmt.CashFlowIndent;
                end;
            }
            action("PTSS Cash-Flow Report")
            {
                Caption = 'Cash-Flow Report';
                ToolTip = 'Generates de Cash-Flow report.';
                RunObject = report "PTSS Cash-Flow Report";
                Image = Report;
                ApplicationArea = All;
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