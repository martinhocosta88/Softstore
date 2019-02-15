tableextension 31023041 "PTSS Service Shipment Header" extends "Service Shipment Header" //MyTargetTableId
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
    trigger OnBeforeDelete()
    var
        Text31022890: Label 'It is not possible to delete Certified Documents.';
    begin
        Error(Text31022890);
    end;

}