pageextension 31023119 "PTSS Vendor Card" extends "Vendor Card" //MyTargetPageId
{
    //COPE
    layout
    {
        addafter(Receiving)
        {
            group(PortugalBank)
            {
                Caption = 'Bank of Portugal';
                field("PTSS BP Statistic Code"; "PTSS BP Statistic Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the BP Statistic Code.';
                }
                field("PTSS Debit Pos. Stat. Code"; "PTSS Debit Pos. Stat. Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Debit Position Statistic Code.';
                }
                field("PTSS Credit Pos. Stat. Code"; "PTSS Credit Pos. Stat. Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the Credit Position Statistic Code.';
                }

            }
        }

    }

    actions
    {
    }
}