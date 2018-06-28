pageextension 50106 "Customer Bank Account Card Ext" extends "Customer Bank Account Card"
{
    layout
    {
        addfirst(Transfer)
        {
            field("CCC Bank No."; "CCC Bank No.")
            {
                ApplicationArea=All;
                ToolTip = 'Specifies the bank number.';
            }
            field("CCC Bank Branch No."; "CCC Bank Branch No.")
            {
                ApplicationArea=All;
                ToolTip = 'Specifies the bank branch number.';
            }
            field("CCC Control Digits"; "CCC Control Digits")
            {
                ApplicationArea=All;
                ToolTip = 'Specifies the control digits for the bank account number';
            }
            field("CCC Bank Account No."; "CCC Bank Account No.")
            {
                ApplicationArea=All;
                ToolTip = 'Specifies the bank account number';
            }
            field("CCC No."; "CCC No.")
            {
                ApplicationArea=All;
                ToolTip = 'Specifies the complete bank number.';
            }
        }
    }
}