xmlport 31022896 "PTSS AT WS Send Service Shi"
{
    // Comunicacao AT

    Caption = 'AT WS Send Sales Shipment';
    Encoding = UTF8;
    FormatEvaluate = Xml;

    schema
    {
        textelement(Body)
        {
            textelement(TaxRegistrationNumber)
            {
                MaxOccurs = Once;
            }
            textelement(companyname1)
            {
                MaxOccurs = Once;
                XmlName = 'CompanyName';
            }
            textelement(CompanyAddress)
            {
                textelement(Addressdetail)
                {
                    MaxOccurs = Once;
                }
                textelement(City)
                {
                    MaxOccurs = Once;
                }
                textelement(PostalCode)
                {
                    MaxOccurs = Once;
                }
                textelement(Country)
                {
                    MaxOccurs = Once;
                }
            }
            textelement(DocumentNumber)
            {
                MaxOccurs = Once;
            }
            textelement(ATDocCodeID)
            {
            }
            textelement(MovementStatus)
            {
                MaxOccurs = Once;
            }
            textelement(MovementDate)
            {
                MaxOccurs = Once;
            }
            textelement(MovementType)
            {
                MaxOccurs = Once;
            }
            textelement(CustomerTaxID)
            {
                MaxOccurs = Once;
            }
            textelement(CustomerAddress)
            {
                MaxOccurs = Once;
                textelement(custaddress_addressdetail)
                {
                    MaxOccurs = Once;
                    XmlName = 'Addressdetail';
                }
                textelement(custaddress_city)
                {
                    MaxOccurs = Once;
                    XmlName = 'City';
                }
                textelement(custaddress_postalcode)
                {
                    MaxOccurs = Once;
                    XmlName = 'PostalCode';
                }
                textelement(custaddress_country)
                {
                    MaxOccurs = Once;
                    XmlName = 'Country';
                }
            }
            textelement(CustomerName)
            {
            }
            textelement(AddressTo)
            {
                MaxOccurs = Once;
                textelement(addressto_addressdetail)
                {
                    MaxOccurs = Once;
                    XmlName = 'Addressdetail';
                }
                textelement(addressto_city)
                {
                    MaxOccurs = Once;
                    XmlName = 'City';
                }
                textelement(addressto_postalcode)
                {
                    MaxOccurs = Once;
                    XmlName = 'PostalCode';
                }
                textelement(addressto_country)
                {
                    MaxOccurs = Once;
                    XmlName = 'Country';
                }
            }
            textelement(AddressFrom)
            {
                MaxOccurs = Once;
                textelement(addressfrom_addressdetail)
                {
                    MaxOccurs = Once;
                    XmlName = 'Addressdetail';
                }
                textelement(addressfrom_city)
                {
                    MaxOccurs = Once;
                    XmlName = 'City';
                }
                textelement(addressfrom_postalcode)
                {
                    MaxOccurs = Once;
                    XmlName = 'PostalCode';
                }
                textelement(addressfrom_country)
                {
                    MaxOccurs = Once;
                    XmlName = 'Country';
                }
            }
            textelement(MovementEndTime)
            {
                MaxOccurs = Once;
                MinOccurs = Zero;
            }
            textelement(MovementStartTime)
            {
                MaxOccurs = Once;
            }
            textelement(VehicleID)
            {
            }
            tableelement("Service Shipment Line"; "Service Shipment Line")
            {
                XmlName = 'Line';
                textelement(ProductDescription)
                {
                    MaxOccurs = Once;
                }
                fieldelement(Quantity; "Service Shipment Line".Quantity)
                {
                    MaxOccurs = Once;
                }
                textelement(UnitOfMeasure)
                {
                    MaxOccurs = Once;
                }
                textelement(UnitPrice)
                {
                    MaxOccurs = Once;
                }

                trigger OnAfterGetRecord()
                begin
                    ProductDescription := "Service Shipment Line".Description + ' ' + "Service Shipment Line"."Description 2";
                    UnitPrice := '0.00';

                    IF ("Service Shipment Line"."Unit of Measure Code" = '') AND ("Service Shipment Line".Type = "Service Shipment Line".Type::"G/L Account") THEN
                        UnitOfMeasure := Text31022890
                    ELSE
                        UnitOfMeasure := "Service Shipment Line"."Unit of Measure";
                end;

                trigger OnPreXmlItem()
                begin
                    "Service Shipment Line".SETRANGE("Document No.", ServDocNo);
                    "Service Shipment Line".SETFILTER(Quantity, '>%1', 0);
                end;
            }

            trigger OnBeforePassVariable()
            var
                RespCenter: Record "Responsibility Center";
            begin
                CompanyInfo.GET;
                TaxRegistrationNumber := CompanyInfo."VAT Registration No.";
                CompanyName1 := CompanyInfo.Name;
                Addressdetail := CompanyInfo.Address + ' ' + CompanyInfo."Address 2";
                IF STRLEN(Addressdetail) > 100 THEN
                    Addressdetail := COPYSTR(Addressdetail, 1, 100);
                City := CompanyInfo.City;
                PostalCode := CompanyInfo."Post Code";
                Country := Text31022891;

                CLEAR(ServShipmentHeader);
                IF ServShipmentHeader.GET(ServDocNo) THEN BEGIN
                    IF CompanyInfo."Country/Region Code" <> ServShipmentHeader."Bill-to Country/Region Code" THEN
                        currXMLport.SKIP;
                    DocumentNumber :=
                      ServShipmentHeader."PTSS Hash Doc. Type" + ' ' +
                      ServShipmentHeader."PTSS Hash No. Series" + '/' + ATWebService.RemoveChars(ServShipmentHeader."PTSS Hash Doc. No.", 1);

                    IF Undo THEN BEGIN
                        MovementStatus := Text31022892;
                        CLEAR(ATCommunicationLog);
                        ATCommunicationLog.SETRANGE("Source Type", DATABASE::"Service Shipment Header");
                        ATCommunicationLog.SETRANGE("Source No.", ServShipmentHeader."No.");
                        ATCommunicationLog.SETRANGE("Movement Status", ATCommunicationLog."Movement Status"::"N - Normal");
                        ATCommunicationLog.SETRANGE("Comunication Status", ATCommunicationLog."Comunication Status"::Sucess);
                        IF ATCommunicationLog.FINDFIRST THEN
                            ATDocCodeID := ATCommunicationLog.ATDocCodeID;
                    END ELSE
                        MovementStatus := Text31022893;

                    MovementDate := FORMAT(ServShipmentHeader."Posting Date", 0, 9);
                    MovementType := ServShipmentHeader."PTSS Hash Doc. Type";

                    CustomerTaxID := ServShipmentHeader."VAT Registration No.";

                    CustomerName := ServShipmentHeader."Bill-to Name";
                    CustAddress_Addressdetail := ServShipmentHeader."Bill-to Address" + ' ' + ServShipmentHeader."Bill-to Address 2";
                    IF STRLEN(CustAddress_Addressdetail) > 100 THEN
                        CustAddress_Addressdetail := COPYSTR(CustAddress_Addressdetail, 1, 100);
                    CustAddress_City := ServShipmentHeader."Bill-to City";
                    CustAddress_PostalCode := ServShipmentHeader."Bill-to Post Code";
                    CustAddress_Country := Text31022891;

                    //AddressTo
                    AddressTo_Addressdetail := ServShipmentHeader."Ship-to Address" + ' ' + ServShipmentHeader."Ship-to Address 2";
                    IF STRLEN(AddressTo_Addressdetail) > 100 THEN
                        AddressTo_Addressdetail := COPYSTR(AddressTo_Addressdetail, 1, 100);
                    AddressTo_City := ServShipmentHeader."Ship-to City";
                    AddressTo_PostalCode := ServShipmentHeader."Ship-to Post Code";
                    AddressTo_Country := Text31022891;

                    //AddressFrom
                    IF Location.GET(ServShipmentHeader."Location Code") THEN BEGIN
                        AddressFrom_Addressdetail := Location.Address + ' ' + Location."Address 2";
                        IF STRLEN(AddressFrom_Addressdetail) > 100 THEN
                            AddressFrom_Addressdetail := COPYSTR(AddressFrom_Addressdetail, 1, 100);
                        AddressFrom_City := Location.City;
                        AddressFrom_PostalCode := Location."Post Code";
                        AddressFrom_Country := Text31022891;
                    END ELSE BEGIN
                        AddressFrom_Addressdetail := CompanyInfo.Address + ' ' + CompanyInfo."Address 2";
                        IF STRLEN(AddressFrom_Addressdetail) > 100 THEN
                            AddressFrom_Addressdetail := COPYSTR(AddressFrom_Addressdetail, 1, 100);
                        AddressFrom_City := CompanyInfo.City;
                        AddressFrom_PostalCode := CompanyInfo."Post Code";
                        AddressFrom_Country := Text31022891;
                    END;

                    MovementStartTime :=
                    FORMAT(ServShipmentHeader."PTSS Shipment Start Date", 0, 9) + Text31022894 +
                    FORMAT(ServShipmentHeader."PTSS Shipment Start Time", 0, Text31022895 +
                    Text31022896); //'YYYY-MM-DDTHH:MM:SS';

                END;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    var
        ServShipmentHeader: Record "Service Shipment Header";
        CompanyInfo: Record "Company Information";
        ATCommunicationLog: Record "PTSS AT Communication Log";
        ATWebService: Codeunit "PTSS AT Consume Web Service";
        Undo: Boolean;
        ServDocNo: Code[20];
        Text31022890: Label 'UN';
        Text31022891: Label 'PT';
        Text31022892: Label 'A';
        Text31022893: Label 'N';
        Text31022894: Label 'T';
        Text31022895: Label '<Hours24,2>';
        Text31022896: Label '<Filler Character,0>:<Minutes,2>:<Second,2>';
        Location: Record Location;

    procedure SetServiceDoc(ServiceDocNo: Code[20])
    begin
        ServDocNo := ServiceDocNo;
    end;

    procedure SetUndo(Undo: Boolean)
    begin
        Undo := Undo;
    end;
}

