pageextension 31023147 "PTSS Sales & Receivables Setup" extends "Sales & Receivables Setup" //MyTargetPageId
{
    //Intrastat
    layout
    {
        addafter("Dynamics 365 for Sales")
        {
            group(Intrastat)
            {
                Caption = 'Intrastat';
                group(Standard)
                {
                    Caption = 'Standard';
                    field("PTSS Transaction Type"; "PTSS Transaction Type")
                    {
                        ToolTip = 'Specifies the Transaction Type.';
                        ApplicationArea = All;
                    }
                    field("PTSS Transport Method"; "PTSS Transport Method")
                    {
                        ToolTip = 'Specifies the Transport Method.';
                        ApplicationArea = All;
                    }
                    field("PTSS Entry/Exit Point"; "PTSS Entry/Exit Point")
                    {
                        ToolTip = 'Specifies the Entry/Exit Point.';
                        ApplicationArea = All;
                    }
                    field("PTSS Area"; "PTSS Area")
                    {
                        ToolTip = 'Specifies the Area.';
                        ApplicationArea = All;
                    }
                    field("PTSS Transaction Specification"; "PTSS Transaction Specification")
                    {
                        ToolTip = 'Specifies the Transaction Specification.';
                        ApplicationArea = All;
                    }
                }
                group(Return)
                {
                    Caption = 'Return';
                    field("PTSS Return Transaction Type"; "PTSS Return Transaction Type")
                    {
                        ToolTip = 'Specifies the Transaction Type.';
                        ApplicationArea = All;
                    }
                    field("PTSS Return Transport Method"; "PTSS Return Transport Method")
                    {
                        ToolTip = 'Specifies the Transport Method.';
                        ApplicationArea = All;
                    }
                    field("PTSS Return Entry/Exit Point"; "PTSS Entry/Exit Point")
                    {
                        ToolTip = 'Specifies the Entry/Exit Point.';
                        ApplicationArea = All;
                    }
                    field("PTSS Return Area"; "PTSS Return Area")
                    {
                        ToolTip = 'Specifies the Area.';
                        ApplicationArea = All;
                    }
                    field("PTSS Return Transaction Specification"; "PTSS Return Transaction Spec.")
                    {
                        ToolTip = 'Specifies the Transaction Specification.';
                        ApplicationArea = All;
                    }
                }
            }
        }
    }
}