pageextension 31023107 "PTSS Vendor Bank Account Card" extends "Vendor Bank Account Card"
{
    //IBAN
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
    }
}