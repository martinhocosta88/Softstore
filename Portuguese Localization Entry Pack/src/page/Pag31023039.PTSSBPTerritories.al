page 31023039 "PTSS BP Territories"
{
    //COPE

    Caption = 'BP Territories';
    PageType = List;
    SourceTable = "PTSS BP Territory";
    UsageCategory = Lists;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

