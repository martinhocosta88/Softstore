page 31022938 "PTSS Municipalities List"
{
    // IRC Modelo 22

    Caption = 'Municipalities List';
    PageType = List;
    SourceTable = "PTSS Municipalities";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Municipality"; "Municipality")
                {
                    ToolTip = 'Specifies the Municipality.';
                    ApplicationArea = All;
                }
                field("Description"; "Description")
                {
                    ToolTip = 'Specifies the Description.';
                    ApplicationArea = All;
                }
                field("Salary Mass"; "Salary Mass")
                {
                    ToolTip = 'Specifies the Salary Mass.';
                    ApplicationArea = All;
                }
                field("Municipality Tax"; "Municipality Tax")
                {
                    ToolTip = 'Specifies the Municipality Tax.';
                    ApplicationArea = All;
                }
                field("Product"; "Product")
                {
                    ToolTip = 'Specifies the Product.';
                    ApplicationArea = All;
                }
                field("Active"; "Active")
                {
                    ToolTip = 'Specifies if Active.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

