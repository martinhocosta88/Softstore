pageextension 31023105 "PTSS Company Information" extends "Company Information"
{
    //IBAN
    //CAE Code
    layout
    {
        addafter("Bank Account No.")
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
        addafter("VAT Registration No.")
        {
            field("PTSS CAE Code"; "PTSS CAE Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the CAE Code.';

            }
            field("PTSS CAE Description"; "PTSS CAE Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the CAE Description';
            }
        }
    }
}