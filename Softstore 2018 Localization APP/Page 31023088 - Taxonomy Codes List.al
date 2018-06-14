page 31023088 "Taxonomy Codes List"
{
    PageType = List;
    SourceTable = "Taxonomy Codes";
    UsageCategory = Lists;
    Caption ='Taxonomy Codes List';
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Taxomy Code"; "Taxonomy Code")
                {
                    ToolTip = 'Specify the Taxonomy Code';
                    ApplicationArea = Basic,Suite;
                }
                field(Description; Description)
                {
                    ToolTip = 'Specify the Description of the Taxonomy Code';
                    ApplicationArea = Basic,Suite;
                }
            }
        }
    }
    
}