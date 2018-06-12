page 50103 "Taxonomy Codes List"
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
                field("Taxomy Code"; "Taxomy Code")
                {
                    ToolTip = 'Specify the Taxonomy Code';
                }
                field(Description; Description)
                {
                    ToolTip = 'Specify the Description of the Taxonomy Code';
                }
            }
        }
        area(factboxes)
        {
            
        }
    }
    
    actions
    {
        area(processing)
        {
            
        }
    }
}