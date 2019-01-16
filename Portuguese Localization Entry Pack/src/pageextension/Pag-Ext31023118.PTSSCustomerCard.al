pageextension 31023118 "PTSS Customer Card" extends "Customer Card" //MyTargetPageId
{
    //COPE
    layout
    {
        addafter(Shipping)
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
                    ToolTip = 'Specifies the Debit Position Statistic Code';
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