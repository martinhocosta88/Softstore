pageextension 31023112 "PTSS Purchase Journal" extends "Purchase Journal"
{
    //Cash-Flow
    layout
    {
        addafter("Bal. Account No.")
        {
            field("PTSS Bal: cash-flow code"; "PTSS Bal: cash-flow code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the balance account cash-flow code.';
            }
        }

        addafter(Description)
        {
            field("PTSS Acc: cash-flow code"; "PTSS Acc: cash-flow code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the account cash-flow code.';
            }
        }
    }


}