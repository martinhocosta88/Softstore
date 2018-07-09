pageextension 50101 "G/L Account Card" extends "G/L Account Card"
{
    //Cash-Flow
    //Taxonomies
    layout
    {
        addlast(General)
        {
            field("Taxonomy Code"; "Taxonomy Code")
            {
                ApplicationArea=All;
                ToolTip = 'Specifies the Taxonomy Code';
            }
        }
    }
}