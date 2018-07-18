page 31023085 "Income Type List"
{
    Caption = 'Income Type List';
    PageType = List;
    SourceTable = "Income Type";
    UsageCategory = Lists;
    ApplicationArea = Basic,Suite;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code;Code)
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                }
            }
        }
    }
    actions
    {
    }
}

