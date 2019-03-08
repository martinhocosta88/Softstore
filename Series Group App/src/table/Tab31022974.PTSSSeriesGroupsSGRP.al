table 31022974 "PTSS Series Groups SGRP"
{
    // Series Group
    Caption = 'Series Groups';
    DrillDownPageID = 31023081;
    LookupPageID = 31023081;
    fields
    {
        field(10; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(20; "Type"; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Sales,Purchase,Services';
            OptionMembers = Sales,Purchase,Services;
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF Type = Type::Purchase THEN BEGIN
                    Reminder := '';
                    "Issued Reminder" := '';
                    "Finance Charge Memo" := '';
                    "Issued F. Charge Memo" := '';
                END;
            end;
        }
        field(30; "Quote"; Code[20])
        {
            Caption = 'Quote';
            TableRelation = "No. Series" WHERE ("Default Nos." = CONST (true));
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF xRec.Quote <> Quote THEN
                    UpdateGrNoSeries(xRec.Quote, Quote, Code);
            end;
        }
        field(40; "Order"; Code[20])
        {
            Caption = 'Order';
            TableRelation = "No. Series" WHERE ("Default Nos." = CONST (true));
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF xRec.Order <> Order THEN
                    UpdateGrNoSeries(xRec.Order, Order, Code);
            end;
        }
        field(50; "Invoice"; Code[20])
        {
            Caption = 'Invoice';
            TableRelation = "No. Series" WHERE ("Default Nos." = CONST (true));
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF xRec.Invoice <> Invoice THEN
                    UpdateGrNoSeries(xRec.Invoice, Invoice, Code);
            end;
        }
        field(60; "Posted Invoice"; Code[20])
        {
            Caption = 'Posted Invoice';
            TableRelation = "No. Series" WHERE ("Default Nos." = CONST (true));
            DataClassification = CustomerContent;
        }
        field(70; "Credit Memo"; Code[20])
        {
            Caption = 'Credit Memo';
            TableRelation = "No. Series" WHERE ("Default Nos." = CONST (true));
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF xRec."Credit Memo" <> "Credit Memo" THEN
                    UpdateGrNoSeries(xRec."Credit Memo", "Credit Memo", Code);
            end;
        }
        field(80; "Posted Credit Memo"; Code[20])
        {
            Caption = 'Posted Credit Memo';
            TableRelation = "No. Series" WHERE ("Default Nos." = CONST (true));
            DataClassification = CustomerContent;
        }
        field(90; "Return"; Code[20])
        {
            Caption = 'Return';
            TableRelation = "No. Series" WHERE ("Default Nos." = CONST (true));
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF xRec.Return <> Return THEN
                    UpdateGrNoSeries(xRec.Return, Return, Code);
            end;
        }
        field(100; "Shipment/Receipts"; Code[20])
        {
            Caption = 'Shipment/Receipt';
            TableRelation = "No. Series" WHERE ("Default Nos." = CONST (true));
            DataClassification = CustomerContent;
        }
        field(110; "Reminder"; Code[20])
        {
            Caption = 'Reminder';
            TableRelation = "No. Series" WHERE ("Default Nos." = CONST (true));
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TESTFIELD(Type, Type::Sales);
                IF xRec.Reminder <> Reminder THEN
                    UpdateGrNoSeries(xRec.Reminder, Reminder, Code);
            end;
        }
        field(120; "Issued Reminder"; Code[20])
        {
            Caption = 'Issued Reminder';
            TableRelation = "No. Series" WHERE ("Default Nos." = CONST (true));
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TESTFIELD(Type, Type::Sales);
            end;
        }
        field(130; "Finance Charge Memo"; Code[20])
        {
            Caption = 'Finance Charge Memo';
            TableRelation = "No. Series" WHERE ("Default Nos." = CONST (true));
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TESTFIELD(Type, Type::Sales);
                IF xRec."Finance Charge Memo" <> "Finance Charge Memo" THEN
                    UpdateGrNoSeries(xRec."Finance Charge Memo", "Finance Charge Memo", Code);
            end;
        }
        field(140; "Issued F. Charge Memo"; Code[20])
        {
            Caption = 'Issue F. Charge Memo';
            TableRelation = "No. Series" WHERE ("Default Nos." = CONST (true));
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TESTFIELD(Type, Type::Sales);
            end;
        }
        field(150; "Blanket Order"; Code[20])
        {
            Caption = 'Blanket Order';
            TableRelation = "No. Series" WHERE ("Default Nos." = CONST (true));
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF xRec."Blanket Order" <> "Blanket Order" THEN
                    UpdateGrNoSeries(xRec."Blanket Order", "Blanket Order", Code);
            end;
        }
        field(160; "Posted Ret. Receipts/Ship."; Code[20])
        {
            Caption = 'Posted Return Receipt/Shipment';
            TableRelation = "No. Series" WHERE ("Default Nos." = CONST (true));
            DataClassification = CustomerContent;
        }
        field(170; "Customer"; Code[20])
        {
            Caption = 'Customer';
            TableRelation = "No. Series" WHERE ("Default Nos." = CONST (true));
            DataClassification = CustomerContent;
        }
        field(180; "Vendor"; Code[20])
        {
            Caption = 'Vendor';
            TableRelation = "No. Series" WHERE ("Default Nos." = CONST (true));
            DataClassification = CustomerContent;
        }
        field(31022890; "Shipment"; Code[20])
        {
            Caption = 'Shipment';
            TableRelation = "No. Series" WHERE ("Default Nos." = CONST (true));
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF xRec.Shipment <> Shipment THEN
                    UpdateGrNoSeries(xRec.Shipment, Shipment, Code);
            end;
        }
        field(31022891; "Posted Shipment"; Code[20])
        {
            Caption = 'Posted Shipment';
            TableRelation = "No. Series" WHERE ("Default Nos." = CONST (true));
            DataClassification = CustomerContent;
        }
        field(31022892; "Receipt"; Code[20])
        {
            Caption = 'Receipt';
            TableRelation = "No. Series" WHERE ("Default Nos." = CONST (true));
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF xRec.Receipt <> Receipt THEN
                    UpdateGrNoSeries(xRec.Receipt, Receipt, Code);
            end;
        }
        field(31022893; "Posted Receipt"; Code[20])
        {
            Caption = 'Posted Receipt';
            TableRelation = "No. Series" WHERE ("Default Nos." = CONST (false));
            DataClassification = CustomerContent;
        }
        field(31022894; "Put-away"; Code[20])
        {
            Caption = 'Put-away';
            TableRelation = "No. Series" WHERE ("Default Nos." = CONST (false));
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF xRec."Put-away" <> "Put-away" THEN
                    UpdateGrNoSeries(xRec."Put-away", "Put-away", Code);
            end;
        }
        field(31022895; "Register Put-away"; Code[20])
        {
            Caption = 'Register Put-away';
            TableRelation = "No. Series" WHERE ("Default Nos." = CONST (false));
            DataClassification = CustomerContent;
        }
        field(31022896; "Pick"; Code[20])
        {
            Caption = 'Pick';
            TableRelation = "No. Series" WHERE ("Default Nos." = CONST (false));
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF xRec.Pick <> Pick THEN
                    UpdateGrNoSeries(xRec.Pick, Pick, Code);
            end;
        }
        field(31022897; "Register Pick"; Code[20])
        {
            Caption = 'Register Pick';
            TableRelation = "No. Series" WHERE ("Default Nos." = CONST (false));
            DataClassification = CustomerContent;
        }
        field(31022898; "Transfer"; Code[20])
        {
            Caption = 'Transfer';
            TableRelation = "No. Series" WHERE ("Default Nos." = CONST (false));
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF xRec.Transfer <> Transfer THEN
                    UpdateGrNoSeries(xRec.Transfer, Transfer, Code);
            end;
        }
        field(31022899; "Ship. Transfer"; Code[20])
        {
            Caption = 'Transfer Shipment';
            TableRelation = "No. Series" WHERE ("Default Nos." = CONST (true));
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF xRec."Ship. Transfer" <> "Ship. Transfer" THEN
                    UpdateGrNoSeries(xRec."Ship. Transfer", "Ship. Transfer", Code);
            end;
        }
        field(31022900; "Receipt Transfer"; Code[20])
        {
            Caption = 'Transfer Receipt';
            TableRelation = "No. Series" WHERE ("Default Nos." = CONST (true));
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF xRec."Receipt Transfer" <> "Receipt Transfer" THEN
                    UpdateGrNoSeries(xRec."Receipt Transfer", "Receipt Transfer", Code);
            end;
        }
        field(31022901; "Contract"; Code[20])
        {
            Caption = 'Contract';
            TableRelation = "No. Series" WHERE ("Default Nos." = CONST (true));
            DataClassification = CustomerContent;
        }
        field(31022902; "Service Quote"; Code[20])
        {
            Caption = 'Service Quote';
            TableRelation = "No. Series" WHERE ("Default Nos." = CONST (true));
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF xRec."Service Quote" <> "Service Quote" THEN
                    UpdateGrNoSeries(xRec."Service Quote", "Service Quote", Code);
            end;
        }
        field(31022903; "Service Order"; Code[20])
        {
            Caption = 'Service Order';
            TableRelation = "No. Series" WHERE ("Default Nos." = CONST (true));
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF xRec."Service Order" <> "Service Order" THEN
                    UpdateGrNoSeries(xRec."Service Order", "Service Order", Code);
            end;
        }
        field(31022904; "Delivery Order"; Code[20])
        {
            Caption = 'Delivery Order';
            TableRelation = "No. Series" WHERE ("Default Nos." = CONST (true));
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF xRec."Delivery Order" <> "Delivery Order" THEN
                    UpdateGrNoSeries(xRec."Delivery Order", "Delivery Order", Code);
            end;
        }
        field(31022905; "Posted Delivery Order"; Code[20])
        {
            Caption = 'Posted Delivery Order';
            TableRelation = "No. Series" WHERE ("Default Nos." = CONST (true));
            DataClassification = CustomerContent;
        }
        field(31022906; "Receipt Order"; Code[20])
        {
            Caption = 'Receipt Order';
            TableRelation = "No. Series" WHERE ("Default Nos." = CONST (true));
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF xRec."Receipt Order" <> "Receipt Order" THEN
                    UpdateGrNoSeries(xRec."Receipt Order", "Receipt Order", Code);
            end;
        }
        field(31022907; "Posted Receipt Order"; Code[20])
        {
            Caption = 'Posted Receipt Order';
            TableRelation = "No. Series" WHERE ("Default Nos." = CONST (true));
            DataClassification = CustomerContent;
        }
        field(31022908; "Debit Memo"; Code[20])
        {
            Caption = 'Debit Memo';
            TableRelation = "No. Series" WHERE ("Default Nos." = CONST (true));
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF xRec."Debit Memo" <> "Debit Memo" THEN
                    UpdateGrNoSeries(xRec."Debit Memo", "Debit Memo", Code);
            end;
        }
        field(31022909; "Posted Debit Memo"; Code[20])
        {
            Caption = 'Posted Debit Memo';
            TableRelation = "No. Series" WHERE ("Default Nos." = CONST (true));
            DataClassification = CustomerContent;
        }
        field(31022910; "Posted F. Charge Memo"; Code[20])
        {
            Caption = 'Posted Finance Charge Memo';
            TableRelation = "No. Series" WHERE ("Default Nos." = CONST (true));
            DataClassification = CustomerContent;
        }
        field(31022911; "Posted Reminder"; Code[20])
        {
            Caption = 'Posted Reminder';
            TableRelation = "No. Series" WHERE ("Default Nos." = CONST (true));
            DataClassification = CustomerContent;
        }
        field(31022912; "Posted Prepmt. Inv. Nos."; Code[20])
        {
            Caption = 'Posted Prepmt. Inv. Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(31022913; "Posted Prepmt. Cr. Memo Nos."; Code[20])
        {
            Caption = 'Posted Prepmt. Cr. Memo Nos.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        NoSeries.SETRANGE("PTSS Series Group SGRP", xRec.Code);
        IF NoSeries.FINDSET THEN
            REPEAT
                NoSeries."PTSS Series Group SGRP" := '';
                NoSeries.MODIFY;
            UNTIL NoSeries.NEXT = 0;
    end;

    var
        NoSeries: Record "No. Series";
        Text31022890: Label 'Can''t associate Cod. Series ''%1'', because the Cod. Series ''%1'' is already being used in ''%2'' Series Group.';

    procedure UpdateGrNoSeries(OldNoSeries: Code[10]; NewNoSeries: Code[10]; SeriesGroup: Code[10])
    var
        NoSeries1: Record "No. Series";
    begin
        IF NoSeries.GET(OldNoSeries) AND (NoSeries."PTSS Series Group SGRP" = Code) THEN BEGIN
            IF OldNoSeries <> '' THEN BEGIN
                NoSeries1.GET(OldNoSeries);
                NoSeries1."PTSS Series Group SGRP" := '';
                NoSeries1.MODIFY;
            END;
        END ELSE
            IF NewNoSeries <> '' THEN BEGIN
                NoSeries1.GET(NewNoSeries);
                NoSeries1."PTSS Series Group SGRP" := SeriesGroup;
                NoSeries1.MODIFY;
            END;
    end;
}

