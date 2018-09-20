pageextension 31023103 "PTSS G/L Account List" extends "G/L Account List"
{
    //Taxonomies
    //Cash-FLow
    layout
    {

        addlast(Control1)
        {
            field("PTSS Cash-flow code assoc."; "PTSS Cash-flow code assoc.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies cash-flow code assoc.';
            }
            field("PTSS Cash-flow code"; "PTSS Cash-flow code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the cash-flow code';
            }
            field("PTSS Taxonomy Code"; "PTSS Taxonomy Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Taxonomy Code';
            }
        }
    }
}