page 31023086 "Withholding Tax Ledger Entries"
{
    Caption='Withholding Tax Ledger Entries';
    PageType = List;
    SourceTable = "Withholding Tax Ledger Entry";
    UsageCategory = History;
    ApplicationArea=Basic,Suite;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Entity Type";"Entity Type")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Entity No.";"Entity No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Income Amount";"Income Amount")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Withholding Tax Amount";"Withholding Tax Amount")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Withholding Tax Code";"Withholding Tax Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Withholding Tax %";"Withholding Tax %")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Has Withholding Tax";"Has Withholding Tax")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Withholding Tax Account";"Withholding Tax Account")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("VAT Registration No.";"VAT Registration No.")
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

