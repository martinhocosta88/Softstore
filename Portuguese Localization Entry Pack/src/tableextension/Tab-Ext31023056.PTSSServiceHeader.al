tableextension 31023056 "PTSS Service Header" extends "Service Header" //MyTargetTableId
{
    //Comunicacao AT
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

    }
    procedure InitRecordPT(var ServHeader: Record "Service Header")
    begin
        IF ServHeader."Document Type" IN [ServHeader."Document Type"::Order, ServHeader."Document Type"::Invoice, ServHeader."Document Type"::Quote] THEN BEGIN
            ServHeader."PTSS Shipment Start Date" := WORKDATE;
            ServHeader."PTSS Shipment Start Time" := TIME;
        END;

        //Desenvolvimento ainda por Fazer
        // IF NoSeries.GET("No. Series") THEN
        //     "Series Group" := NoSeries."Series Group";
    end;

}