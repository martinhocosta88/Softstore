pageextension 31023104 "PTSS General Ledger Entries" extends "General Ledger Entries"
{
    //Cash-Flow
    //Taxonomies
    layout
    {

        addlast(Control1)
        {
            field("PTSS Taxonomy Code"; "PTSS Taxonomy Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Taxonomy Code.';
            }
        }
        addbefore("Gen. Posting Type")
        {
            field("PTSS Acc: cash-flow code"; "PTSS Acc: cash-flow code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the account cash-flow code.';
            }
        }
        addafter("Bal. Account No.")
        {
            field("PTSS Bal: cash-flow code"; "PTSS Bal: cash-flow code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the balance account cash-flow code.';
            }
        }
    }
}