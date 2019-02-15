table 31022931 "PTSS AT Communication Log"
{
    //Comunicacao AT

    Caption = 'Registo Comunicação AT';

    fields
    {
        field(1; "Entry No."; BigInteger)
        {
            Caption = 'Line No.';
        }
        field(2; "Date Time"; DateTime)
        {
            Caption = 'Date Time';
        }
        field(3; "User Id"; Code[50])
        {
            Caption = 'User Id';
        }
        field(4; "Source Type"; Integer)
        {
            Caption = 'Source Type';
        }
        field(5; "Source No."; Code[20])
        {
            Caption = 'Source No.';
        }
        field(6; "Source Document"; Option)
        {
            Caption = 'Source Document';
            OptionCaption = 'Posted Sales Shipment,Posted Transfer Shipment,Posted Return Purchase Shipment,Posted Service Shipment';
            OptionMembers = "Posted Sales Shipment","Posted Transfer Shipment","Posted Return Purchase Shipment","Posted Service Shipment";
        }
        field(7; "ATDocCodeID"; Text[250])
        {
            Caption = 'ATDocCodeID';
        }
        field(8; "System-Created Entry"; Boolean)
        {
            Caption = 'System-Created Entry';
        }
        field(9; "Comunication Status"; Option)
        {
            Caption = 'Comunication Status';
            OptionCaption = 'Error,Sucess';
            OptionMembers = Error,Sucess;
        }
        field(10; "AT Return Code"; Code[10])
        {
            Caption = 'AT Return Code';
        }
        field(11; "AT Return Message"; Text[250])
        {
            Caption = 'AT Return Message';
        }
        field(12; "Movement Status"; Option)
        {
            Caption = 'Movement Status';
            OptionCaption = 'N - Normal,A - Reversed';
            OptionMembers = "N - Normal","A - Reversed";
        }
        field(13; "Last Change User Id"; Code[50])
        {
            Caption = 'Last Change User Id';
        }
        field(14; "Last Change Date Time"; DateTime)
        {
            Caption = 'Last Change Date Time';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
        key(Key2; "Source Type", "Source No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnModify()
    begin
        TESTFIELD("System-Created Entry", FALSE);

        "Last Change User Id" := USERID;
        "Last Change Date Time" := CURRENTDATETIME;
    end;

    var
        Text31022890: Label 'Document not communicated to AT';
        Text31022891: Label 'Document communicated to AT with number ';

    procedure GetATDocCodeID(SourceType: Integer; SourceNo: Code[20]; var FoundEntry: Boolean; var ATDocCodeID: Text[250])
    var
        ATCommunicationLog: Record "PTSS AT Communication Log";
    begin
        ATCommunicationLog.SETRANGE("Source Type", SourceType);
        ATCommunicationLog.SETRANGE("Source No.", SourceNo);
        ATCommunicationLog.SETFILTER(ATDocCodeID, '<>%1', '');
        IF ATCommunicationLog.FINDLAST THEN BEGIN
            FoundEntry := TRUE;
            ATDocCodeID := Text31022891 + ATCommunicationLog.ATDocCodeID;
        END ELSE BEGIN
            FoundEntry := FALSE;
            ATDocCodeID := Text31022890;
        END;
    end;

    procedure ShowDocument()
    var
        SalesShipmentHeader: Record "Sales Shipment Header";
        TransferShipmentHeader: Record "Transfer Shipment Header";
        ServiceShipmentHeader: Record "Service Shipment Header";
        ReturnShipmentHeader: Record "Return Shipment Header";
    begin
        CASE "Source Type" OF
            DATABASE::"Sales Shipment Header":
                BEGIN
                    IF NOT SalesShipmentHeader.GET("Source No.") THEN
                        EXIT;
                    CASE "Source Document" OF
                        "Source Document"::"Posted Sales Shipment":
                            PAGE.RUN(PAGE::"Posted Sales Shipment", SalesShipmentHeader);
                    END;
                END;
            DATABASE::"Transfer Shipment Header":
                BEGIN
                    IF NOT TransferShipmentHeader.GET("Source No.") THEN
                        EXIT;
                    CASE "Source Document" OF
                        "Source Document"::"Posted Transfer Shipment":
                            PAGE.RUN(PAGE::"Posted Transfer Shipment", TransferShipmentHeader);
                    END;
                END;
            DATABASE::"Service Shipment Header":
                BEGIN
                    IF NOT ServiceShipmentHeader.GET("Source No.") THEN
                        EXIT;
                    CASE "Source Document" OF
                        "Source Document"::"Posted Service Shipment":
                            PAGE.RUN(PAGE::"Posted Service Shipment", ServiceShipmentHeader);
                    END;
                END;
            DATABASE::"Return Shipment Header":
                BEGIN
                    IF NOT ReturnShipmentHeader.GET("Source No.") THEN
                        EXIT;
                    CASE "Source Document" OF
                        "Source Document"::"Posted Return Purchase Shipment":
                            PAGE.RUN(PAGE::"Posted Return Shipment", ReturnShipmentHeader);
                    END;
                END;
            ELSE
                EXIT;
        END;
    end;
}

