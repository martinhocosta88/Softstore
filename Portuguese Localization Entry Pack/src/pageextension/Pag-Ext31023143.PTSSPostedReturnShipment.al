pageextension 31023143 "PTSS Posted Return Shipment" extends "Posted Return Shipment" //MyTargetPageId
{
    //Comunicacao AT
    layout
    {
        addafter("Ship-to Contact")
        {
            field("PTSS Shipment Start Date"; "PTSS Shipment Start Date")
            {
                Importance = Promoted;
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the Shipment Start Date';
            }
            field("PTSS Shipment Start Time"; "PTSS Shipment Start Time")
            {
                Importance = Promoted;
                ApplicationArea = All;
                Editable = false;
                ToolTip = 'Specifies the Shipment Start Time';
            }

        }
    }

    actions
    {
    }
}