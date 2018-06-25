page 31022936 "Cash-Flow Code Card"
{
    PageType = Card;
    Caption = 'Cash-Flow Code Card';
    SourceTable = "Cash-Flow Plan";
    DataCaptionFields = "No.", "Description";
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {

                }
                field("Description"; "Description")
                {

                }
                field("Type"; "Type")
                {

                }
                field(Totaling; Totaling)
                {

                }
                field(Indentation; Indentation)
                {

                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ActionName)
            {
                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}