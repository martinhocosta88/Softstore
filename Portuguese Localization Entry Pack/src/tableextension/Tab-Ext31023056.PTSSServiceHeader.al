tableextension 31023056 "PTSS Service Header" extends "Service Header" //MyTargetTableId
{
    //Comunicacao AT
    //Regras Negocio
    fields
    {
        field(31022898; "PTSS Shipment Start Date"; Date)
        {
            Caption = 'Shipment Start Date';
            DataClassification = CustomerContent;
        }
        field(31022899; "PTSS Shipment Start Time"; Time)
        {
            Caption = 'Shipment Start Time';
            DataClassification = CustomerContent;
        }

        modify("Bill-to Customer No.")
        {
            trigger OnAfterValidate()
            var
                Cust: Record Customer;
            begin
                Cust.Get("Bill-to Customer No.");
                CheckMasterData(Cust);
            end;
        }

    }
    procedure InitRecordPT(var ServHeader: Record "Service Header")
    begin
        IF ServHeader."Document Type" IN [ServHeader."Document Type"::Order, ServHeader."Document Type"::Invoice, ServHeader."Document Type"::Quote] THEN BEGIN
            ServHeader."PTSS Shipment Start Date" := WORKDATE;
            ServHeader."PTSS Shipment Start Time" := TIME;
        END;
    end;

    local procedure CheckMasterData(Cust: Record Customer)
    begin
        With Cust DO begin
            IF NOT "PTSS End Consumer" THEN BEGIN
                TESTFIELD(Name);
                TESTFIELD("Post Code");
                TESTFIELD("Country/Region Code");
                TESTFIELD(Address);
                TESTFIELD(City);
                TESTFIELD("VAT Registration No.");
                TESTFIELD("Payment Terms Code");
            END;
        END;
    end;
}