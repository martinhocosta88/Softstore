pageextension 31023113 "PTSS Cash Receipt Journal" extends "Cash Receipt Journal"
{
    //Cash-Flow
    layout
    {
        addafter("Bal. Account No.")
        {
            field("PTSS Bal: cash-flow code"; "PTSS Bal: cash-flow code")
            {
                ApplicationArea = ALL;
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
            field("PTSS BP Account Type Code"; "PTSS BP Account Type Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the BP Account Type Code';
            }
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
            field("PTSS BP Bal. Statistic Code"; "PTSS BP Bal. Statistic Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the BP Bal. Statistic Code';
            }
            field("PTSS BP Bal. Countrpt. Country Code"; "PTSS BP Bal. Count. Ctry. Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the BP Bal. Count. Ctry. Code';
            }
            field("PTSS BP Bal. Active Country Code"; "PTSS BP Bal. Active Ctry. Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the BP Bal. Active Ctry. Code';
            }
            field("PTSS BP Bal. NPC 2nd Intervener"; "PTSS BP Bal. NPC 2nd Interv.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the BP Bal. NPC 2nd Intervener';
            }
        }
    }
}