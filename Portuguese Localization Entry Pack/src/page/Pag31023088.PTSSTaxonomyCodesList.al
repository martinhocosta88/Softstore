page 31023088 "PTSS Taxonomy Codes List"
{
    //Taxonomies
    PageType = List;
    SourceTable = "PTSS Taxonomy Codes";
    UsageCategory = Lists;
    Caption = 'Taxonomy Codes List';
    ApplicationArea = Basic, Suite;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Taxomy Code"; "Taxonomy Code")
                {
                    ToolTip = 'Specify the Taxonomy Code';
                    ApplicationArea = Basic, Suite;
                }
                field(Description; Description)
                {
                    ToolTip = 'Specify the Description of the Taxonomy Code';
                    ApplicationArea = Basic, Suite;
                }
            }
        }
    }
}