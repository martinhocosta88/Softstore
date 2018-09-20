page 31022936 "PTSS Cash-Flow Code Card"
{
    //Cash-Flow
    PageType = Card;
    Caption = 'Cash-Flow Code Card';
    SourceTable = "PTSS Cash-Flow Plan";
    DataCaptionFields = "No.", "Description";
    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                    ToolTip = 'Specificies the Cash-Flow Code No.';
                    ApplicationArea = Basic, Suite;
                }
                field("Description"; "Description")
                {
                    ToolTip = 'Specificies the Cash-FLow Description';
                    ApplicationArea = Basic, Suite;
                }
                field("Type"; "Type")
                {
                    ToolTip = 'Specificies the Cash-Flow Type';
                    ApplicationArea = Basic, Suite;
                }
                field(Totaling; Totaling)
                {
                    ToolTip = 'Specificies the Cash-Flow Code Totaling';
                    ApplicationArea = Basic, Suite;
                }
                field(Indentation; Indentation)
                {
                    ToolTip = 'Specificies the Cash-Flow Indentation';
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }
}