pageextension 50102 "G/L Account List" extends "G/L Account List"
{
    //Taxonomies
    //Cash-FLow
    layout
    {
        addlast(Control1)
        {
            field("Taxonomy Code"; "Taxonomy Code")
            {
                ApplicationArea=All;
                ToolTip = 'Specifies the Taxonomy Code';
            }
        }
    }
}