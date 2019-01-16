page 31023038 "PTSS BP Statistics"
{
    //COPE

    Caption = 'BP Statistics';
    PageType = List;
    SourceTable = "PTSS BP Statistic";
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
                field(Category; Category)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Type; Type)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

