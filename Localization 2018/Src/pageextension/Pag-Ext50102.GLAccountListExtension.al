pageextension 50102 "G/L Account List Extension" extends "G/L Account List"
{
    layout
    {
        addlast(Control1)
        {
            field("Cash-flow code assoc."; "Cash-flow code assoc.")
            {
                ApplicationArea=All;
                ToolTip = 'Specifies cash-flow code assoc.';
            }
            field("Cash-flow code"; "Cash-flow code")
            {
                ApplicationArea=All;
                ToolTip = 'Specifies the cash-flow code';
            }
            field("Taxonomy Code"; "Taxonomy Code")
            {
                ApplicationArea=All;
                ToolTip = 'Specifies the Taxonomy Code';
            }
        }
    }
}