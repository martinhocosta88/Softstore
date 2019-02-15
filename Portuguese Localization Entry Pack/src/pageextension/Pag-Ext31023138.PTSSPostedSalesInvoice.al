pageextension 31023138 "PTSS Posted Sales Invoice" extends "Posted Sales Invoice" //MyTargetPageId
{
    layout
    {
        addafter("Quote No.")
        {
            //teste para apagar
            field("PTSS Hash"; "PTSS Hash")
            {
                ApplicationArea = All;
                Caption = 'HASH';
            }

        }
    }

    actions
    {
    }
}