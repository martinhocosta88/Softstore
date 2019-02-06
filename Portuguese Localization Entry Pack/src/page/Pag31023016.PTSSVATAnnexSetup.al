page 31023016 "PTSS VAT Annex Setup"
{
    // IRC Modelo 22

    Caption = 'VAT Annex Setup';
    PageType = List;
    SourceTable = "PTSS VAT Annex Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Annex; Annex)
                {

                    ApplicationArea = All;
                    Tooltip = 'Specifies the Annex;';
                }
                field("Record Type"; "Record Type")
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the Specifies the Record Type.';
                }
                field(Frame; Frame)
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the Frame.';
                }
                field(Article; Article)
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the Article.';
                }
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the No.';
                }
                field(SubSection; SubSection)
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the SubSection.';
                }
                field("Reason Code"; "Reason Code")
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the Reason Code.';
                }
                field("Tax Authority Code"; "Tax Authority Code")
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the Tax Authority Code.';
                }
                field("Group By Doc. No."; "Group By Doc. No.")
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the Group By. Doc. No.';
                }
                field("Group by Reason Code"; "Group by Reason Code")
                {
                    ApplicationArea = All;
                    Tooltip = 'Specifies the Group by Reason Code.';
                }
            }
        }
    }

    actions
    {
    }
}

