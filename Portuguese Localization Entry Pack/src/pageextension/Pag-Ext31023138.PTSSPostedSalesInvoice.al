pageextension 31023138 "PTSS Posted Sales Invoice" extends "Posted Sales Invoice" //MyTargetPageId
{
    //Comunicacao AT
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

        addafter("Shipment Date")
        {
            field("PTSS Shipment Start Time"; "PTSS Shipment Start Time")
            {
                Importance = Promoted;
                ApplicationArea = All;
                ToolTip = 'Specifies the Shipment Start Time.';
            }
        }
    }

    actions
    {
    }
}