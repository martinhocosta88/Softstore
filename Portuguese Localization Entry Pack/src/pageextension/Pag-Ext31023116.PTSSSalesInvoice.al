pageextension 31023116 "PTSS Sales Invoice" extends "Sales Invoice"
{
    //Cash-Flow
    //Comunicacao AT
    layout
    {

        addlast("Invoice Details")
        {
            field("PTSS Cash-flow code"; "PTSS Cash-flow code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Cash-flow code.';
            }
        }
        addafter("Shipment Date")
        {
            field("PTSS Shipment Start Time"; "PTSS Shipment Start Time")
            {
                ApplicationArea = All;
                Importance = Promoted;
                ToolTip = 'Specifies the time when items on the document are shipped or were shipped.';
            }

        }
    }
}