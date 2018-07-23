pageextension 31023133 "Account Schedule" extends "Account Schedule"
{
    layout
    {
        addafter("Amount Type")
        {
            field(Type;Type)
            {
                ApplicationArea = Basic,Suite;
                ToolTip='Specifies the Type.';
            }
            field("Positive Only";"Positive Only")
            {
                ApplicationArea = Basic,Suite;
                ToolTip='Specifices Positive Only values.';
            }
            field("Reverse Sign";"Reverse Sign")
            {
                ApplicationArea = Basic,Suite;
                ToolTip='Specifies values in Reverse Sign.';
            } 
        }
        addafter("Show Opposite Sign")
        {
            field("Totaling 2";"Totaling 2")
            {
                ApplicationArea = Basic,Suite;
                ToolTip='Specifies Totaling 2.';
            }
            field("Positive Only 2";"Positive Only 2")
            {
                ApplicationArea = Basic,Suite;
                ToolTip='Specifices Positive Only values.';
            }
            field("Reverse Sign 2";"Reverse Sign 2")
            {
                ApplicationArea = Basic,Suite;
                ToolTip='Specifies values in Reverse Sign.';
            }
        }
    }
    actions
    {
        addafter(Print)
        {
            action(PrintStandardized)
            {
                Promoted=true;
                Ellipsis=true;
                PromotedCategory=Report;
                Image=Print;
                ApplicationArea = Basic,Suite;
                ToolTip='Prepare to print the document. A report request window for the document opens where you can specify what to include on the print-out.';
                Caption='Print';
                Visible=IsStandardized;
                trigger OnAction()
                begin
                  IF IsStandardized THEN BEGIN
                    REPORT.RUN(REPORT::"Normalized Account Schedule",TRUE,FALSE,Rec);
                    EXIT;
                    END;  
                end;
            }
        }
        modify(Print)
        {
           Visible=NOT IsStandardized; 
        }
    }
trigger OnAfterGetRecord()

begin
    CheckStandardized(IsStandardized);    
end;

var
IsStandardized: Boolean;
}