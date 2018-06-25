pageextension 50108 "Bank Account Card Ext" extends "Bank Account Card"
{
    layout
    {
        addfirst(Transfer)
        {
            field("CCC Bank No."; "CCC Bank No.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the bank number.';
            }
            field("CCC Bank Branch No."; "CCC Bank Branch No.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the bank branch number.';
            }
            field("CCC Control Digits"; "CCC Control Digits")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the control digits for the bank account number';
            }
            field("CCC Bank Account No."; "CCC Bank Account No.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the bank account number';
            }
            field("CCC No."; "CCC No.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the complete bank number.';
            }
        }
    }

    var
        myInt: Integer;
}