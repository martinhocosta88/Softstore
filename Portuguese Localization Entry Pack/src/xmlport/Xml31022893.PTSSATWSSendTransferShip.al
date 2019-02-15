xmlport 31022893 "PTSS AT WS Send Transfer Ship."
{
    // Comunicacao AT

    Caption = 'AT WS Send Transfer Shipment';
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
            tableelement("Transfer Shipment Line"; "Transfer Shipment Line")
            {
                XmlName = 'Line';
                textelement(ProductDescription)
                {
                    MaxOccurs = Once;
                }
                fieldelement(Quantity; "Transfer Shipment Line".Quantity)
                {
                    MaxOccurs = Once;
                }
                fieldelement(UnitOfMeasure; "Transfer Shipment Line"."Unit of Measure")
                {
                    MaxOccurs = Once;
                }
                textelement(UnitPrice)
                {
                    MaxOccurs = Once;
                }

                trigger OnAfterGetRecord()
                begin
                    ProductDescription := "Transfer Shipment Line".Description + ' ' + "Transfer Shipment Line"."Description 2";
                    UnitPrice := '0.00';
                end;

                trigger OnPreXmlItem()
                begin
                    "Transfer Shipment Line".SETRANGE("Document No.", TransferDocNo);
                    "Transfer Shipment Line".SETFILTER(Quantity, '<>%1', 0);
                end;
            }

            trigger OnBeforePassVariable()
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

                CLEAR(TransferShipHeader);
                IF TransferShipHeader.GET(TransferDocNo) THEN BEGIN
                    DocumentNumber :=
                      TransferShipHeader."PTSS Hash Doc. Type" + ' ' +
                      TransferShipHeader."PTSS Hash No. Series" + '/' + ATWebService.RemoveChars(TransferShipHeader."PTSS Hash Doc. No.", 1);

                    MovementStatus := Text31022893; //Estado Atual do documento
                    MovementDate := FORMAT(TransferShipHeader."Posting Date", 0, 9);
                    MovementType := TransferShipHeader."PTSS Hash Doc. Type";

                    CustomerTaxID := CompanyInfo."VAT Registration No.";
                    CustomerName := CompanyInfo.Name;
                    CustAddress_Addressdetail := TransferShipHeader."Transfer-to Address" + ' ' + TransferShipHeader."Transfer-to Address 2";
                    IF STRLEN(CustAddress_Addressdetail) > 100 THEN
                        CustAddress_Addressdetail := COPYSTR(CustAddress_Addressdetail, 1, 100);
                    CustAddress_City := TransferShipHeader."Transfer-to City";
                    CustAddress_PostalCode := TransferShipHeader."Transfer-to Post Code";
                    CustAddress_Country := Text31022891;

                    CASE TransferShipHeader."PTSS Location Type" OF
                        TransferShipHeader."PTSS Location Type"::"External - Customer":
                            IF Customer.GET(TransferShipHeader."PTSS External Entity No.") THEN BEGIN
                                CustomerTaxID := Customer."VAT Registration No.";
                                CustomerName := Customer.Name;
                                CustAddress_Addressdetail := Customer.Address + ' ' + Customer."Address 2";
                                IF STRLEN(CustAddress_Addressdetail) > 100 THEN
                                    CustAddress_Addressdetail := COPYSTR(CustAddress_Addressdetail, 1, 100);
                                CustAddress_City := Customer.City;
                                CustAddress_PostalCode := Customer."Post Code";
                                CustAddress_Country := Text31022891;
                            END;
                        TransferShipHeader."PTSS Location Type"::"External - Vendor":
                            IF Vendor.GET(TransferShipHeader."PTSS External Entity No.") THEN BEGIN
                                CustomerTaxID := Vendor."VAT Registration No.";
                                CustomerName := Vendor.Name;
                                CustAddress_Addressdetail := Vendor.Address + ' ' + Vendor."Address 2";
                                IF STRLEN(CustAddress_Addressdetail) > 100 THEN
                                    CustAddress_Addressdetail := COPYSTR(CustAddress_Addressdetail, 1, 100);
                                CustAddress_City := Vendor.City;
                                CustAddress_PostalCode := Vendor."Post Code";
                                CustAddress_Country := Text31022891;
                            END
                    END;


                    IF TransferShipHeader."PTSS Location Type" = TransferShipHeader."PTSS Location Type"::Internal THEN BEGIN
                        CustAddress_Addressdetail := CompanyInfo.Address + ' ' + CompanyInfo."Address 2";
                        IF STRLEN(CustAddress_Addressdetail) > 100 THEN
                            CustAddress_Addressdetail := COPYSTR(CustAddress_Addressdetail, 1, 100);
                        CustAddress_City := CompanyInfo.City;
                        CustAddress_PostalCode := CompanyInfo."Post Code";
                        CustAddress_Country := Text31022891;
                    END;


                    //AddressTo
                    AddressTo_Addressdetail := TransferShipHeader."Transfer-to Address" + ' ' + TransferShipHeader."Transfer-to Address 2";
                    IF STRLEN(AddressTo_Addressdetail) > 100 THEN
                        AddressTo_Addressdetail := COPYSTR(AddressTo_Addressdetail, 1, 100);
                    AddressTo_City := TransferShipHeader."Transfer-to City";
                    AddressTo_PostalCode := TransferShipHeader."Transfer-to Post Code";
                    AddressTo_Country := Text31022891;

                    //AddressFrom
                    AddressFrom_Addressdetail := TransferShipHeader."Transfer-from Address" + ' ' + TransferShipHeader."Transfer-from Address 2";
                    IF STRLEN(AddressFrom_Addressdetail) > 100 THEN
                        AddressFrom_Addressdetail := COPYSTR(AddressFrom_Addressdetail, 1, 100);
                    AddressFrom_City := TransferShipHeader."Transfer-from City";
                    AddressFrom_PostalCode := TransferShipHeader."Transfer-from Post Code";
                    AddressFrom_Country := Text31022891;

                    MovementStartTime :=
                    FORMAT(TransferShipHeader."Shipment Date", 0, 9) + Text31022894 +
                    FORMAT(TransferShipHeader."PTSS Shipment Start Time", 0, Text31022895 +
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
        TransferShipHeader: Record "Transfer Shipment Header";
        CompanyInfo: Record "Company Information";
        ATWebService: Codeunit "PTSS AT Consume Web Service";
        TransferDocNo: Code[20];
        Text31022891: Label 'PT';
        Text31022893: Label 'N';
        Text31022894: Label 'T';
        Text31022895: Label '<Hours24,2>';
        Text31022896: Label '<Filler Character,0>:<Minutes,2>:<Second,2>';
        Location: Record Location;
        Customer: Record Customer;
        Vendor: Record Vendor;

    procedure SetTransferDoc(TransferDocumentNo: Code[20])
    begin
        TransferDocNo := TransferDocumentNo;
    end;
}

