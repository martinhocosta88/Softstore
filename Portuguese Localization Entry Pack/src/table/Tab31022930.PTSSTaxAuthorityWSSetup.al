table 31022930 "PTSS Tax Authority WS Setup"
{
    // Comunicação AT

    Caption = 'Tax Authority WS Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "URL Endpoint"; Text[250])
        {
            Caption = 'URL Endpoint';
        }
        field(3; "SOAP Action"; Text[250])
        {
            Caption = 'SOAP Action';
        }
        field(6; "XMLNS Doc"; Text[250])
        {
            Caption = 'XMLNS Doc';
        }
        field(7; "XMLNS SoapEnv"; Text[250])
        {
            Caption = 'XMLNS SoapEnv';
        }
        field(8; "XMLNS Wss"; Text[250])
        {
            Caption = 'XMLNS Wss';
        }
        field(9; "Blob"; BLOB)
        {
            Caption = 'Blob';
        }
        field(10; "AT NIF User"; Text[30])
        {
            Caption = 'AT User';
        }
        field(11; "AT Password"; Text[30])
        {
            Caption = 'AT Password';
        }
        field(12; "Certificate Path"; Text[250])
        {
            Caption = 'Certificate Path';
        }
        field(13; "Public Key Path"; Text[250])
        {
            Caption = 'Public Key Path';
        }
        field(14; "Enable AT Communication"; Boolean)
        {
            Caption = 'Enable AT Communication';
            Description = 'V93.00#00027';
        }
    }
    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }

    fieldgroups
    {
    }
    procedure EnableATCommunication()
    var
        Text31022890: Label 'This function enables the communication of shipments to AT. Are you sure you want to continue?';
    begin

        IF DIALOG.CONFIRM(Text31022890, TRUE) THEN
            "Enable AT Communication" := TRUE
        ELSE
            "Enable AT Communication" := FALSE;
        MODIFY;

    end;

    procedure DisableATCommunication()
    var
        Text31022891: Label 'This function disables the communication of shipments to AT. Are you sure you want to continue?';
    begin
        IF DIALOG.CONFIRM(Text31022891, TRUE) THEN
            "Enable AT Communication" := FALSE
        ELSE
            "Enable AT Communication" := TRUE;
        MODIFY;
    end;
}

