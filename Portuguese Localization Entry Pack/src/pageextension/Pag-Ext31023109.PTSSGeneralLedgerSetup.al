pageextension 31023109 "PTSS General Ledger Setup" extends "General Ledger Setup"
{
    //Check Chart of Accounts
    //COPE
    //IRC - Modelo 22
    //Lancamento Regularizacao
    layout
    {
        addlast(General)
        {
            field("PTSS Check Chart of Accounts"; "PTSS Check Chart of Accounts")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies if checks chart of accounts.';
            }
            field("PTSS Use Dim. for Inc. Balance Acc."; "PTSS Use Dim. Inc. Bal. Acc.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Use Dim. for Inc. Balance Acc.';
            }
            field("PTSS Currency Decimal Unit Text"; "PTSS Curr. Decimal Unit Text")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Currency Decimal Unit Text.';
            }
            field("PTSS Curr. Dec. Unit Decimal Places"; "PTSS Cur. Dec. Unit Dec. Place")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Curr. Dec. Unit Decimal Places.';
            }
            field("PTSS Currency Text"; "PTSS Currency Text")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies Currency Text.';
            }
        }
        addafter("VAT Exchange Rate Adjustment")
        {
            group("TaxAuthorityReport")
            {
                Caption = 'Tax Authority Reporting';
                field("PTSS Model 22 Acc. Sch. Name"; "PTSS Model 22 Acc. Sch. Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Account Schedule Name for IRC - Model 22.';
                }

            }
        }
        addafter("Payroll Transaction Import")
        {
            group(PortugalBank)
            {
                Caption = 'Bank of Portugal';
                field("PTSS BP Rec Nature Creat. Code"; "PTSS BP Rec Nature Creat. Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the BP Rec Nature Creat. Code';
                }
                field("PTSS BP Rec. Nature Mod. Code"; "PTSS BP Rec. Nature Mod. Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the BP Rec. Nature Mod. Code';
                }
                field("PTSS BP Nature Delete Code"; "PTSS BP Nature Delete Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the BP Nature Delete Code';
                }
                field("PTSS BP Amount Type Inc. Code"; "PTSS BP Amount Type Inc. Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the BP Amount Type Inc. Code';
                }
                field("PTSS BP Amount Type Out. Code"; "PTSS BP Amount Type Out. Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the BP Amount Type Out. Code';
                }
                field("PTSS BP Amount Type Pos. Code"; "PTSS BP Amount Type Pos. Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the BP Amount Type Pos. Code';
                }
                field("PTSS BP Account Type Def. Code"; "PTSS BP Account Type Def. Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the BP Account Type Def. Code';
                }
                field("PTSS BP Folder"; "PTSS BP Folder")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the BP Folder';
                }
                field("PTSS BP IF Code"; "PTSS BP IF Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the BP IF Code';
                }
            }
        }
    }
}