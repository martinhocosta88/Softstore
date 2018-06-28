pageextension 50113 "Cash Receipt Journal Ext" extends "Cash Receipt Journal"
{
    layout
    {
        addafter("Bal. Account No.")
        {
            field("Bal: cash-flow code"; "Bal: cash-flow code")
            {
                ApplicationArea=ALL;
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