pageextension 31023140 "PTSS Posted Transfer Shipment" extends "Posted Transfer Shipment" //MyTargetPageId
{
    layout
    {
        addafter("Shortcut Dimension 2 Code")
        {
            field("PTSS Location Type"; "PTSS Location Type")
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the Location Type';
            }
            field("PTSS External Entity No."; "PTSS External Entity No.")
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the External Entity No.';
            }
            field("PTSS Ship-to Code"; "PTSS Ship-to Code")
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the Ship-to Code.';
            }
        }
        addafter("Shipment Date")
        {
            field("PTSS Shipment Start Time"; "PTSS Shipment Start Time")
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the Shipment Start Time.';
                Importance = Promoted;
            }
        }
    }

    actions
    {
    }
}