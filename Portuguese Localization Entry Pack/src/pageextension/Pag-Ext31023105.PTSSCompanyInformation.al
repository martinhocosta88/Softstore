pageextension 31023105 "PTSS Company Information" extends "Company Information"
{
    //IBAN
    //CAE Code
    //IRC Modelo 22
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
        addafter(Shipping)
        {
            group(WebService)
            {
                Caption = 'Tax Authority Document Comunication Web Service';
                field("PTSS Tax Authority WS User ID"; "PTSS Tax Authority WS User ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the User ID to connect to the tax authority transport document comunication web service.';
                }
                field("PTSS Tax Authority WS Password"; "PTSS Tax Authority WS Password")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the password to connect to the tax authority transport document comunication web service.';
                }
                field("PTSS AT Com. File Path"; "PTSS AT Com. File Path")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the path where to save communicated transport document files to the tax authority and tax authority response files.';
                    //Graph API.
                }

            }
        }
        addafter(WebService)
        {
            group(Model22)
            {
                Caption = 'Model 22';
                field("PTSS Tax Authority Code"; "PTSS Tax Authority Code")
                {
                    ToolTip = 'Specifies the code for the local tax authority.';
                    ApplicationArea = All;
                }
                field("PTSS Activity Table Code"; "PTSS Activity Table Code")
                {
                    ToolTip = 'Specifies the code for the table of business activities, according to Portaria n.º 1011/2001, 21/8.';
                    ApplicationArea = All;
                }
                field("PTSS Legal Rep. VAT Reg. No."; "PTSS Legal Rep. VAT Reg. No.")
                {
                    ToolTip = 'Specifies the VAT registration number for the company''s legal reprensentative, for SAFT-PT export purposes.';
                    ApplicationArea = All;
                }
                field("PTSS TOC VAT Reg. No."; "PTSS TOC VAT Reg. No.")
                {
                    ToolTip = 'Specifies the VAT registration number for the company''s accountant, for SAFT-PT export purposes.';
                    ApplicationArea = All;
                }
                field("PTSS Municipality"; "PTSS Municipality")
                {
                    ToolTip = 'Specifies the code of the company''s municipality.';
                    ApplicationArea = All;
                }
            }
        }
    }
}