pageextension 31023145 "PTSS Service Order" extends "Service Order" //MyTargetPageId
{
    //Comunicacao AT
    layout
    {
        addafter("Shipping Time")
        {
            field("PTSS Shipment Start Date"; "PTSS Shipment Start Date")
            {
                Importance = Promoted;
                ApplicationArea = All;
                ToolTip = 'Specifies the Shipment Start Date.';
            }
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