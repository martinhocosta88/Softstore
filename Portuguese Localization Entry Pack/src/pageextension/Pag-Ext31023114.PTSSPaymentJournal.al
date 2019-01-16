pageextension 31023114 "PTSS Payment Journal" extends "Payment Journal"
{
    //Cash-Flow
    //COPE
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
        addlast(Control1)
        {
            field("PTSS BP Statistic Code"; "PTSS BP Statistic Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the BP Statistic Code';
            }
            field("PTSS BP Countrpt. Country Code"; "PTSS BP Countrpt. Country Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the BP Countrpt. Country Code';
            }
            field("PTSS BP Active Country Code"; "PTSS BP Active Country Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the BP Active Country Code';
            }
            field("PTSS BP NPC 2nd Intervener"; "PTSS BP NPC 2nd Intervener")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the BP NPC 2nd Intervener';
            }
        }
    }
}