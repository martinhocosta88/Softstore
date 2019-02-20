pageextension 31023141 "PTSS Sales Order" extends "Sales Order" //MyTargetPageId
{
    //Comunicacao AT
    layout
    {
        addafter("Shipment Date")
        {
            field("PTSS Shipment Start Time"; "PTSS Shipment Start Time")
            {
                Importance = Promoted;
                ToolTip = 'Especifica a hora em que os produtos do documento são ou vão ser enviados.';
                ApplicationArea = All;
            }

        }
    }

    actions
    {
    }
}