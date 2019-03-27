pageextension 31023110 "PTSS General Journal" extends "General Journal"
{
    //Cash-Flow
    //Transaction No.
    layout
    {
        //Cash-Flow
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

        //Transaction No.
        addafter("Posting Date")
        {
            field("PTSS Transaction No."; "PTSS Transaction No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Transaction No.';
            }
        }
    }
}