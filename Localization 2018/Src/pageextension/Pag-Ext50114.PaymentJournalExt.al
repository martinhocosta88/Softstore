pageextension 50114 "Payment Journal Ext" extends "Payment Journal"
{
    layout
    {
        addafter("Bal. Account No.")
        {
            field("Bal: cash-flow code"; "Bal: cash-flow code")
            {
                ApplicationArea=All;
                ToolTip = 'Specifies the balance account cash-flow code.';
            }
        }
        addafter(Description)
        {
            field("Acc: cash-flow code"; "Acc: cash-flow code")
            {
                ApplicationArea=All;
                ToolTip = 'Specifies the account cash-flow code.';
            }
        }
    }
}