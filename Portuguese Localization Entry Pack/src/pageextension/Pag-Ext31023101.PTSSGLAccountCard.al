pageextension 31023101 "PTSS G/L Account Card" extends "G/L Account Card"
{
    //Cash-Flow
    //Taxonomies
    layout
    {
        addlast(General)
        {
            field("PTSS Taxonomy Code"; "PTSS Taxonomy Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Taxonomy Code';
            }
        }

        addlast(Posting)
        {
            field("PTSS Cash-flow code assoc."; "PTSS Cash-flow code assoc.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies cash-flow code assoc.';
            }
            field("PTSS Cash-flow code"; "PTSS Cash-flow code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies cash-flow code';
            }

        }
        addafter("Default IC Partner G/L Acc. No")
        {
            field("PTSS Income Stmt. Bal. Acc."; "PTSS Income Stmt. Bal. Acc.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Income Stmt. Bal. Acc.';
            }

        }
    }
}