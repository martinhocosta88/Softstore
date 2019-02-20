pageextension 31023142 "PTSS Sales Return Ord" extends "Sales Return Order"  //MyTargetPageId
{
    //Comunicacao AT
    layout
    {
        addafter("Shipment Date")
        {
            field("PTSS Shipment Start Time"; "PTSS Shipment Start Time")
            {
                ToolTip = '=Especifica a hora em que os produtos do documento são ou vão ser enviados.';
                ApplicationArea = All;
                Importance = Promoted;
            }

        }
    }

    actions
    {
    }
}