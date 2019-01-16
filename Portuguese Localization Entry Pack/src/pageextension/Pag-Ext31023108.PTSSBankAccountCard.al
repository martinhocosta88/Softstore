pageextension 31023108 "PTSS Bank Account Card" extends "Bank Account Card"
{
    //IBAN
    //COPE
    layout
    {
        addfirst(Transfer)
        {
            field("PTSS CCC Bank No."; "PTSS CCC Bank No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the bank number.';
            }
            field("PTSS CCC Bank Branch No."; "PTSS CCC Bank Branch No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the bank branch number.';
            }
            field("PTSS CCC Control Digits"; "PTSS CCC Control Digits")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the control digits for the bank account number';
            }
            field("PTSS CCC Bank Account No."; "PTSS CCC Bank Account No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the bank account number';
            }
            field("PTSS CCC No."; "PTSS CCC No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the complete bank number.';
            }
        }
        addafter(Transfer)
        {
            group(PortugalBank)
            {
                Caption = 'Bank of Portugal';
                field("PTSS BP Statistic Code"; "PTSS BP Statistic Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the BP Statistic Code';
                }
                field("PTSS BP Account Type Code"; "PTSS BP Account Type Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the BP Account Type Code';
                }
            }

        }
    }
}