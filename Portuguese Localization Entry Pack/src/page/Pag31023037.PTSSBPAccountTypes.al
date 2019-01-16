page 31023037 "PTSS BP Account Types"
{
    //COPE

    Caption = 'BP Account Type';
    PageType = List;
    SourceTable = "PTSS BP Account Type";
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

