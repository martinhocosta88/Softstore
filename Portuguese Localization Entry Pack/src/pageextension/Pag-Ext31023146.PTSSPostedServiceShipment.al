pageextension 31023146 "PTSS Posted Service Shipment" extends "Posted Service Shipment" //MyTargetPageId
{
    //Comunicação AT
    layout
    {
        addafter("Document Date")
        {
            field("PTSS Shipment Start Date"; "PTSS Shipment Start Date")
            {
                Importance = Promoted;
                ApplicationArea = All;
                ToolTip = 'Specifies the Shipment Start Date';
            }
            field("PTSS Shipment Start Time"; "PTSS Shipment Start Time")
            {
                Importance = Promoted;
                ApplicationArea = All;
                ToolTip = 'Specifies the Shipment Start Time';
            }
        }
    }

    actions
    {
    }
}