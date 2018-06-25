pageextension 50101 "G/L Account Card Extension" extends "G/L Account Card"
{
    layout
    {
        addlast(General)
        {
            field("Taxonomy Code"; "Taxonomy Code")
            {
                ToolTip = 'Specifies the Taxonomy Code';
            }
        }
        addlast(Posting)
        {
            field("Cash-flow code assoc."; "Cash-flow code assoc.")
            {
                ToolTip = 'Specifies cash-flow code assoc.';
            }
            field("Cash-flow code"; "Cash-flow code")
            {
                ToolTip = 'Specifies cash-flow code';
            }
        }
    }
}