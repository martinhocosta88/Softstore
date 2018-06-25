pageextension 50102 "G/L Account List Extension" extends "G/L Account List"
{
    layout
    {
        addlast(Control1)
        {
            field("Cash-flow code assoc."; "Cash-flow code assoc.")
            {
                ToolTip = 'Specifies cash-flow code assoc.';
            }
            field("Cash-flow code"; "Cash-flow code")
            {
                ToolTip = 'Specifies the cash-flow code';
            }
            field("Taxonomy Code"; "Taxonomy Code")
            {
                ToolTip = 'Specifies the Taxonomy Code';
            }
        }
    }
}