page 31023084 "Withholding Tax Codes List"
{
    Caption = 'Withholding Tax Codes List';
    PageType = List;
    SourceTable = "Withholding Tax Codes";
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
                field("Tax %";"Tax %")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Account No.";"Account No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("IRC Code";"IRC Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Max. Correction Amount";"Max. Correction Amount")
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

