pageextension 31023101 "G/L Account Card" extends "G/L Account Card"
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
        
        addlast(Posting)
        {
            field("Cash-flow code assoc."; "Cash-flow code assoc.")
            {
                ApplicationArea=All;
                ToolTip = 'Specifies cash-flow code assoc.';
            }
            field("Cash-flow code"; "Cash-flow code")
            {
                ApplicationArea=All;
                ToolTip = 'Specifies cash-flow code';
            }
        }
    }
}