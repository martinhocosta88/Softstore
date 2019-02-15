tableextension 31023053 "PTSS Transfer Header" extends "Transfer Header"  //MyTargetTableId
{
    //Comunicação AT
    fields
    {
        field(31022899; "PTSS Shipment Start Time"; Time)
        {
            Caption = 'Shipment Start Time';
            DataClassification = CustomerContent;
        }
        field(31022901; "PTSS Transfer-to VAT Reg. No."; Text[20])
        {
            Caption = 'Transfer-to VAT Reg. No.';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(31022902; "PTSS Location Type"; Option)
        {
            OptionMembers = "Internal","External - Customer","External - Vendor";
            OptionCaption = 'Internal,External - Customer,External - Vendor';
            Caption = 'Location Type';
            DataClassification = CustomerContent;
            Editable = false;
        }
        field(31022903; "PTSS External Entity No."; Code[20])
        {
            Caption = 'External Entity No.';
            DataClassification = CustomerContent;
            TableRelation = IF ("PTSS Location Type" = CONST ("External - Customer")) Customer."No." ELSE
            IF ("PTSS Location Type" = CONST ("External - Vendor")) Vendor."No.";
            trigger OnValidate()
            begin
                CLEAR("PTSS Ship-to Code");
                UpdateTransferToInfo;
            end;
        }
        field(31022904; "PTSS Ship-to Code"; Code[20])
        {
            Caption = 'External Entity No.';
            DataClassification = CustomerContent;
            TableRelation = "Ship-to Address".Code WHERE ("Customer No." = FIELD ("PTSS External Entity No."));
            trigger OnValidate()
            begin
                UpdateTransferToInfo;
            end;
        }
    }

    local procedure UpdateTransferToInfo()
    begin
        IF "PTSS Ship-to Code" <> '' THEN BEGIN
            IF ShipToAddress.GET("PTSS External Entity No.", "PTSS Ship-to Code") THEN
                IF "PTSS Location Type" = "PTSS Location Type"::"External - Customer" THEN BEGIN
                    Customer.GET("PTSS External Entity No.");
                    SetAddressDetails(ShipToAddress.Name, ShipToAddress."Name 2", ShipToAddress.Address, ShipToAddress."Address 2", ShipToAddress.City, ShipToAddress.Contact,
                                      ShipToAddress.County, ShipToAddress."Post Code", ShipToAddress."Country/Region Code", Customer."VAT Registration No.");
                END;
            IF "PTSS Location Type" = "PTSS Location Type"::"External - Vendor" THEN BEGIN
                Vendor.GET("PTSS External Entity No.");
                SetAddressDetails(ShipToAddress.Name, ShipToAddress."Name 2", ShipToAddress.Address, ShipToAddress."Address 2", ShipToAddress.City, ShipToAddress.Contact,
                                    ShipToAddress.County, ShipToAddress."Post Code", ShipToAddress."Country/Region Code", Vendor."VAT Registration No.");
            END;
        END ELSE
            IF "PTSS External Entity No." <> '' THEN BEGIN
                IF "PTSS Location Type" = "PTSS Location Type"::"External - Customer" THEN BEGIN
                    Customer.GET("PTSS External Entity No.");
                    SetAddressDetails(Customer.Name, Customer."Name 2", Customer.Address, Customer."Address 2", Customer.City, Customer.Contact,
                                      Customer.County, Customer."Post Code", Customer."Country/Region Code", Customer."VAT Registration No.");
                END ELSE
                    IF "PTSS Location Type" = "PTSS Location Type"::"External - Vendor" THEN
                        Vendor.GET("PTSS External Entity No.");
                SetAddressDetails(Vendor.Name, Vendor."Name 2", Vendor.Address, Vendor."Address 2", Vendor.City, Vendor.Contact,
                                  Vendor.County, Vendor."Post Code", Vendor."Country/Region Code", Vendor."VAT Registration No.");
            END ELSE
                IF Location.GET("Transfer-to Code") THEN
                    WITH Location DO BEGIN
                        CompanyInfo.GET;
                        SetAddressDetails(Location.Name, Location."Name 2", Location.Address, Location."Address 2", Location.City, Location.Contact,
                                          Location.County, Location."Post Code", Location."Country/Region Code", CompanyInfo."VAT Registration No.");
                    END;
    end;

    local procedure SetAddressDetails(Name: Text[50]; Name2: Text[50]; Address: Text[50]; Address2: Text[50]; City: Text[30]; Contact: Text[50]; County: Text[30]; PostCode: Code[20]; CountryRegion: Code[10]; VATRegNo: Text[20])
    begin
        "Transfer-to Name" := Name;
        "Transfer-to Name 2" := Name2;
        "Transfer-to Address" := Address;
        "Transfer-to Address 2" := Address2;
        "Transfer-to City" := City;
        "Transfer-to Contact" := Contact;
        "Transfer-to County" := County;
        "Transfer-to Post Code" := PostCode;
        "Trsf.-to Country/Region Code" := CountryRegion;
        "PTSS Transfer-to VAT Reg. No." := VATRegNo;
    end;

    var
        CompanyInfo: Record "Company Information";
        ShipToAddress: Record "Ship-to Address";
        Customer: Record Customer;
        Vendor: Record Vendor;
        Location: Record Location;

}