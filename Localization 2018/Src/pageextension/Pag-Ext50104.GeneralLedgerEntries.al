pageextension 50104 "General Ledger Entries" extends "General Ledger Entries"
{
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
        addbefore("Gen. Posting Type")
        {
            field("Acc: cash-flow code"; "Acc: cash-flow code")
            {
                ApplicationArea=All;
                ToolTip = 'Specifies the account cash-flow code.';
            }
        }
        addafter("Bal. Account No.")
        {
            field("Bal: cash-flow code"; "Bal: cash-flow code")
            {
                ApplicationArea=All;
                ToolTip = 'Specifies the balance account cash-flow code.';
            }
        }
    }
}