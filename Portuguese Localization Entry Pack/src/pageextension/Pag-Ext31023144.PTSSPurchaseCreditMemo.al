pageextension 31023144 "PTSS Purchase Credit Memo" extends "Purchase Credit Memo" //MyTargetPageId
{
    //Comunicação AT
    layout
    {
        addafter("Ship-to Contact")
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