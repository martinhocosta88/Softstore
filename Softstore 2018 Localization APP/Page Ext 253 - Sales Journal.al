pageextension 50111 "Sales Journal Ext" extends "Sales Journal"
{
    layout
    {
        addafter("Bal. Account No.")
        {
            field("Bal: cash-flow code";"Bal: cash-flow code")
            {
                ToolTip='Specifies the balance account cash-flow code.';
            }
        }
        addafter(Description)
        {
            field("Acc: cash-flow code"; "Acc: cash-flow code")
            {
                ToolTip='Specifies the account cash-flow code.';
            }
        }
    }
    
    actions
    {
        // Add changes to page actions here
    }
    

}