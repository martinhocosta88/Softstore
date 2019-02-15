pageextension 31023139 "PTSS Transfer Order" extends "Transfer Order" //MyTargetPageId
{
    //Comunicacao AT
    layout
    {
        modify("Transfer-to Code")
        {
            trigger OnBeforeValidate()
            begin
                SetEntityEnabled;
            end;
        }
        addafter(Status)
        {
            field("PTSS Location Type"; "PTSS Location Type")
            {
                Editable = false;
                ApplicationArea = All;
                ToolTip = 'Specifies the Location Type';
            }
            field("PTSS External Entity No."; "PTSS External Entity No.")
            {
                Editable = SetEnabled;
                ApplicationArea = All;
                ToolTip = 'Specifies the External Entity No.';
            }
            field("PTSS Ship-to Code"; "PTSS Ship-to Code")
            {
                Editable = SetEnabled;
                ApplicationArea = All;
                ToolTip = 'Specifies the Ship-to Code.';
            }
        }
        addafter("Shipment Date")
        {
            field("PTSS Shipment Start Time"; "PTSS Shipment Start Time")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the Shipment Start Time.';
            }

        }
    }

    actions
    {
    }
    trigger OnAfterGetCurrRecord()
    begin
        SetEntityEnabled;
        CurrPage.UPDATE(FALSE);
    end;

    local procedure SetEntityEnabled()
    begin
        SetEnabled := FALSE;
        IF ("PTSS Location Type" <> "PTSS Location Type"::Internal) THEN
            IF Location.GET("Transfer-to Code") AND (Location."PTSS External Entity No." = '') THEN
                SetEnabled := TRUE;
    end;

    var
        SetEnabled: Boolean;
        Location: Record Location;
}