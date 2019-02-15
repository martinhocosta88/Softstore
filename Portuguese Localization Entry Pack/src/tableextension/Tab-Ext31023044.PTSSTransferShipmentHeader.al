tableextension 31023044 "PTSS Transfer Shipment Header" extends "Transfer Shipment Header" //MyTargetTableId
{
    // Certificação Documentos
    // Comunicacao AT
    fields
    {
        field(31022892; "PTSS Creation Date"; Date)
        {
            Editable = false;
            Caption = 'Creation Date';
            DataClassification = CustomerContent;
        }
        field(31022893; "PTSS Creation Time"; Time)
        {
            Editable = false;
            Caption = 'Creation Time';
            DataClassification = CustomerContent;
        }
        field(31022896; "PTSS Hash"; Text[172])
        {
            Editable = false;
            Caption = 'Hash';
            DataClassification = CustomerContent;
        }
        field(31022897; "PTSS Private Key Version"; Text[40])
        {
            Editable = false;
            Caption = 'Creation Date';
            DataClassification = CustomerContent;
        }
        field(31022922; "PTSS Hash Doc. Type"; Code[10])
        {
            Editable = false;
            Caption = 'Hash Doc. Type';
            DataClassification = CustomerContent;
        }
        field(31022923; "PTSS Hash Doc. No."; Code[20])
        {
            Editable = false;
            Caption = 'Hash Doc. No.';
            DataClassification = CustomerContent;
        }
        field(31022924; "PTSS Hash No. Series"; Code[10])
        {
            Editable = false;
            Caption = 'Hash No. Series';
            DataClassification = CustomerContent;
        }
        field(31022925; "PTSS Hash Amount Including VAT"; Decimal)
        {
            Editable = false;
            Caption = 'Hash Amount Including VAT';
            DataClassification = CustomerContent;
        }
        field(31022926; "PTSS Hash Last Hash Used"; Text[172])
        {
            Editable = false;
            Caption = 'Hash Last Hash Used';
            DataClassification = CustomerContent;
        }
        field(31022899; "PTSS Shipment Start Time"; Time)
        {
            Caption = 'Shipment Start Time';
            DataClassification = CustomerContent;
        }
        field(31022929; "PTSS Transfer-to VAT Reg. No."; Text[20])
        {
            Editable = false;
            Caption = 'Transfer-to VAT Reg. No.';
            DataClassification = CustomerContent;
        }
        field(31022930; "PTSS Location Type"; Option)
        {
            Editable = false;
            OptionMembers = "Internal","External - Customer","External - Vendor";
            OptionCaption = 'Internal,External - Customer,External - Vendor';
            Caption = 'Location Type';
            DataClassification = CustomerContent;
        }
        field(31022931; "PTSS External Entity No."; Code[20])
        {
            Editable = false;
            Caption = 'External Entity No.';
            DataClassification = CustomerContent;
            TableRelation = IF ("PTSS Location Type" = CONST ("External - Customer")) Customer."No." ELSE
            IF ("PTSS Location Type" = CONST ("External - Vendor")) Vendor."No.";
        }
        field(31022932; "PTSS Ship-to Code"; Code[20])
        {
            Editable = false;
            Caption = 'Ship-to Code';
            DataClassification = CustomerContent;
            TableRelation = "Ship-to Address".Code WHERE ("Customer No." = FIELD ("PTSS External Entity No."));
        }
    }
    trigger OnBeforeDelete()
    var
        Text31022890: Label 'It is not possible to delete Certified Documents.';
    begin
        Error(Text31022890);
    end;


}