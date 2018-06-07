tableextension 50112 "Gen. Journal Line Ext" extends "Gen. Journal Line"
{
    fields
    {
        field(31022970; "Withholding Tax Code"; Code[20])
        {
            Caption='Withholding Tax Code';
            Editable=False;
            TableRelation="Withholding Tax Codes";
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var

            begin
                IF ("Withholding Tax Code" <> '') AND
                    (NOT ("Account Type" IN ["Account Type"::Customer, "Account Type"::Vendor]) AND
                    NOT ("Bal. Account Type" IN ["Bal. Account Type"::Customer, "Bal. Account Type"::Vendor])) THEN
                    ERROR(Text31022896);

                CASE "Account Type" OF
                    "Account Type"::Vendor: BEGIN
                        Vendor.GET("Account No.");
                        IF NOT Vendor."Subject to Withholding Tax" THEN
                            ERROR(Text31022894,"Account No.");
                    END;
                    "Account Type"::Customer: BEGIN
                        Customer.GET("Account No.");
                        IF NOT Customer."Subject to Withholding Tax" THEN
                            ERROR(Text31022895,"Account No.");
                    END;
                END;

                CASE "Bal. Account Type" OF
                    "Bal. Account Type"::Vendor: BEGIN
                        Vendor.GET("Bal. Account No.");
                        IF NOT Vendor."Subject to Withholding Tax" THEN
                        ERROR(Text31022894,"Bal. Account No.");
                    END;
                    "Bal. Account Type"::Customer: BEGIN
                        Customer.GET("Bal. Account No.");
                        IF NOT Customer."Subject to Withholding Tax" THEN
                        ERROR(Text31022895,"Bal. Account No.");
                    END;
                END;
                CalcWithholdingTax; 
            end;
        }
        field(31022971; "Withholding Tax Autom. Entry"; Boolean)
        {
            Caption='Withholding Tax Autom. Entry';
            Editable=false;
            DataClassification = ToBeClassified;
        }
        field(31022972; "Calc. IRC Withholding Tax"; Boolean)
        {
            Caption='Calc. IRC Withholding Tax';
            Editable=False;
            DataClassification = ToBeClassified;
        }
        field(31022973; "Withholding Tax Account"; Code[20])
        {
            Caption='Withholding Tax Account';
            Editable=false;
            DataClassification = ToBeClassified;
        }
        field(31022974; "Withholding Tax %"; Decimal)
        {
            Caption='Withholding Tax %';
            Editable = False;
            DataClassification = ToBeClassified;
        }
        field(31022975; "Withholding Tax Amount"; Decimal)
        {
            Caption='Withholding Tax Amount';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
            
            begin
                IF "Account Type"="Account Type"::Vendor THEN BEGIN
                    IF "Withholding Tax Amount" > 0 THEN
                        ERROR(Text011,FIELDCAPTION("Withholding Tax Amount"));
                END ELSE BEGIN 
                IF "Account Type"="Account Type"::Customer THEN 
                    IF "Withholding Tax Amount" < 0 THEN
                        ERROR(Text012,FIELDCAPTION("Withholding Tax Amount"));
                    END;
            end;
        }
    }
    local procedure CalcWithholdingTax()
    var

    begin
        "Withholding Tax %" := 0;
        "Withholding Tax Account" := '';
        "Withholding Tax Amount" := 0;

        IF WithholdingTaxCodes.GET(Rec."Withholding Tax Code") THEN BEGIN
            "Withholding Tax %" := WithholdingTaxCodes."Tax %";
            "Withholding Tax Account" := WithholdingTaxCodes."Account No.";
            IF NOT WithholdingTaxCodes."IRC Code" THEN
                "Withholding Tax Amount" := ROUND("VAT Base Amount (LCY)" * (WithholdingTaxCodes."Tax %"/100),Currency."Amount Rounding Precision");
            IF "Bal. Account Type" IN ["Bal. Account Type"::Vendor,"Bal. Account Type"::Customer] THEN
                "Withholding Tax Amount":=-"Withholding Tax Amount";
        END;
    end;

    var
        Text011:Label '%1 must be negative.';
        Text012:Label '%1 must be positive.';
        WithholdingTaxCodes: Record "Withholding Tax Codes";
        Currency:Record Currency;
        Vendor:Record Vendor;
        Customer:Record Customer;
        Text31022894:Label'Vendor is not defined for withholding tax.';
        Text31022895:Label'Customer is not defined for withholding tax.';
        Text31022896:Label'%1 or %2 must be Customer or Vendor.';
}