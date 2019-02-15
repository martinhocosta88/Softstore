xmlport 31022895 "PTSS AT WS Send Sales Shipment"
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
                MaxOccurs = Once;
                MinOccurs = Zero;
            }
            tableelement("Sales Shipment Line"; "Sales Shipment Line")
            {
                XmlName = 'Line';
                textelement(ProductDescription)
                {
                    MaxOccurs = Once;
                }
                fieldelement(Quantity; "Sales Shipment Line".Quantity)
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
                    ProductDescription := "Sales Shipment Line".Description + ' ' + "Sales Shipment Line"."Description 2";
                    UnitPrice := '0.00';

                    IF ("Sales Shipment Line"."Unit of Measure Code" = '') AND ("Sales Shipment Line".Type = "Sales Shipment Line".Type::"G/L Account") THEN
                        UnitOfMeasure := Text31022890
                    ELSE
                        UnitOfMeasure := "Sales Shipment Line"."Unit of Measure";
                end;

                trigger OnPreXmlItem()
                begin
                    "Sales Shipment Line".SETRANGE("Document No.", SalesDocNo);
                    "Sales Shipment Line".SETFILTER(Quantity, '>%1', 0);
                    "Sales Shipment Line".SETRANGE(Type, "Sales Shipment Line".Type::Item);
                    "Sales Shipment Line".SETRANGE("Appl.-from Item Entry", 0);
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
                Country := CompanyInfo."Country/Region Code";

                CLEAR(SalesShipmentHeader);
                IF SalesShipmentHeader.GET(SalesDocNo) THEN BEGIN
                    IF CompanyInfo."Country/Region Code" <> SalesShipmentHeader."Bill-to Country/Region Code" THEN
                        currXMLport.SKIP;
                    DocumentNumber :=
                     SalesShipmentHeader."PTSS Hash Doc. Type" + ' ' +
                     SalesShipmentHeader."PTSS Hash No. Series" + '/' + ATWebService.RemoveChars(SalesShipmentHeader."PTSS Hash Doc. No.", 1);

                    IF Undo THEN BEGIN
                        MovementStatus := Text31022892;
                        CLEAR(ATCommunicationLog);
                        ATCommunicationLog.SETRANGE("Source Type", DATABASE::"Sales Shipment Header");
                        ATCommunicationLog.SETRANGE("Source No.", SalesShipmentHeader."No.");
                        ATCommunicationLog.SETRANGE("Movement Status", ATCommunicationLog."Movement Status"::"N - Normal");
                        ATCommunicationLog.SETRANGE("Comunication Status", ATCommunicationLog."Comunication Status"::Sucess);
                        IF ATCommunicationLog.FINDFIRST THEN
                            ATDocCodeID := ATCommunicationLog.ATDocCodeID;
                    END ELSE
                        MovementStatus := Text31022893;

                    MovementDate := FORMAT(SalesShipmentHeader."Posting Date", 0, 9);
                    MovementType := SalesShipmentHeader."PTSS Hash Doc. Type";

                    CustomerTaxID := SalesShipmentHeader."VAT Registration No.";

                    CustomerName := SalesShipmentHeader."Bill-to Name";
                    CustAddress_Addressdetail := SalesShipmentHeader."Bill-to Address" + ' ' + SalesShipmentHeader."Bill-to Address 2";
                    IF STRLEN(CustAddress_Addressdetail) > 100 THEN
                        CustAddress_Addressdetail := COPYSTR(CustAddress_Addressdetail, 1, 100);
                    CustAddress_City := SalesShipmentHeader."Bill-to City";
                    CustAddress_PostalCode := SalesShipmentHeader."Bill-to Post Code";
                    CustAddress_Country := SalesShipmentHeader."Bill-to Country/Region Code";

                    //AddressTo
                    AddressTo_Addressdetail := SalesShipmentHeader."Ship-to Address" + ' ' + SalesShipmentHeader."Ship-to Address 2";
                    IF STRLEN(AddressTo_Addressdetail) > 100 THEN
                        AddressTo_Addressdetail := COPYSTR(AddressTo_Addressdetail, 1, 100);
                    AddressTo_City := SalesShipmentHeader."Ship-to City";
                    AddressTo_PostalCode := SalesShipmentHeader."Ship-to Post Code";
                    AddressTo_Country := SalesShipmentHeader."Ship-to Country/Region Code";
                    //AddressFrom
                    IF Location.GET(SalesShipmentHeader."Location Code") THEN BEGIN
                        AddressFrom_Addressdetail := Location.Address + ' ' + Location."Address 2";
                        IF STRLEN(AddressFrom_Addressdetail) > 100 THEN
                            AddressFrom_Addressdetail := COPYSTR(AddressFrom_Addressdetail, 1, 100);
                        AddressFrom_City := Location.City;
                        AddressFrom_PostalCode := Location."Post Code";
                        AddressFrom_Country := Location."Country/Region Code";
                    END ELSE BEGIN
                        AddressFrom_Addressdetail := CompanyInfo.Address + ' ' + CompanyInfo."Address 2";
                        IF STRLEN(AddressFrom_Addressdetail) > 100 THEN
                            AddressFrom_Addressdetail := COPYSTR(AddressFrom_Addressdetail, 1, 100);
                        AddressFrom_City := CompanyInfo.City;
                        AddressFrom_PostalCode := CompanyInfo."Post Code";
                        AddressFrom_Country := CompanyInfo."Country/Region Code";
                    END;

                    MovementStartTime :=
                    FORMAT(SalesShipmentHeader."Shipment Date", 0, 9) + Text31022894 +
                    FORMAT(SalesShipmentHeader."PTSS Shipment Start Time", 0, Text31022895 +
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
        SalesShipmentHeader: Record "Sales Shipment Header";
        CompanyInfo: Record "Company Information";
        ATCommunicationLog: Record "PTSS AT Communication Log";
        ATWebService: Codeunit "PTSS AT Consume Web Service";
        Undo: Boolean;
        SalesDocNo: Code[20];
        Text31022890: Label 'UN';
        Text31022891: Label 'PT';
        Text31022892: Label 'A';
        Text31022893: Label 'N';
        Text31022894: Label 'T';
        Text31022895: Label '<Hours24,2>';
        Text31022896: Label '<Filler Character,0>:<Minutes,2>:<Second,2>';
        Location: Record Location;

    procedure SetSalesDoc(SalesDocumentNo: Code[20])
    begin
        SalesDocNo := SalesDocumentNo;
    end;

    procedure SetUndo(pUndo: Boolean)
    begin
        Undo := pUndo;
    end;
}

