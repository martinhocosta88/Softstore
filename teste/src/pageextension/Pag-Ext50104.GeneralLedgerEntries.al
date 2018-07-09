pageextension 50104 "General Ledger Entries" extends "General Ledger Entries"
{
    //Cash-Flow
    //Taxonomies
    layout
    {
        addlast(Control1)
        {
            field("Taxonomy Code"; "Taxonomy Code")
            {
                ApplicationArea=All;
                ToolTip = 'Specifies the Taxonomy Code.';
            }
        }
    }
}