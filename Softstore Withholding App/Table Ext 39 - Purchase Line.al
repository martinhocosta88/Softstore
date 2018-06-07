tableextension 50111 "Purchase Line Ext" extends "Purchase Line"
{
    fields
    {
        field(31022970; "Withholding Tax Code"; Code[20])
        {
            caption = 'Withholding Tax Code';
            TableRelation = "Withholding Tax Codes";
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var

            begin
               IF Vendor.GET("Buy-from Vendor No.") THEN BEGIN
                    IF NOT Vendor."Subject to Withholding Tax" THEN
                        ERROR(Text31022893,"Buy-from Vendor No.");
                    CalcWithholdingTax;
                END; 
            end;
        }
        field(31022971; "Withholding Tax %"; Decimal)
        {
            caption='Witholding Tax %';
            DataClassification = ToBeClassified;
        }
        field(31022972; "Withholding Tax Account"; Code[20])
        {
            caption='Witholding Tax Account';
            DataClassification = ToBeClassified;
        }
        field(31022973; "Withholding Tax Amount"; Decimal)
        {
            caption='Witholding Tax Amount';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var

            begin
                IF "Orig. Withholding Tax Amount" = 0 THEN
                    ERROR(Text31022895);
                IF ("Withholding Tax Amount" > "Orig. Withholding Tax Amount"+"Max. Correction Amount") OR
                    ("Withholding Tax Amount" < "Orig. Withholding Tax Amount"-"Max. Correction Amount") THEN
                    ERROR(Text31022894,"Orig. Withholding Tax Amount"-"Max. Correction Amount","Orig. Withholding Tax Amount"+"Max. Correction Amount");
            end;
        }
        field(31022974; "Orig. Withholding Tax Amount"; Decimal)
        {
            caption='Orig. Witholding Tax Amount';
            DataClassification = ToBeClassified;
        }
        field(31022975; "Max. Correction Amount"; Decimal)
        {
            caption='Max. Correction Amount';
            MinValue = 0;
            DataClassification = ToBeClassified;
        }
    }
    local procedure CalcWithholdingTax()
    var  
    begin
        "Withholding Tax %" := 0;
        "Withholding Tax Account" := '';
        "Withholding Tax Amount" := 0;
        "Orig. Withholding Tax Amount" := 0;
        "Max. Correction Amount" := 0;

        IF WithholdingTaxCodes.GET(Rec."Withholding Tax Code") THEN BEGIN
            "Withholding Tax %" := WithholdingTaxCodes."Tax %";
            "Withholding Tax Account" := WithholdingTaxCodes."Account No.";
            "Max. Correction Amount" := WithholdingTaxCodes."Max. Correction Amount";
            IF NOT WithholdingTaxCodes."IRC Code" THEN BEGIN
                "Withholding Tax Amount" := ROUND(Rec.Amount * (WithholdingTaxCodes."Tax %"/100),Currency."Amount Rounding Precision");
                "Orig. Withholding Tax Amount" := "Withholding Tax Amount";
            END;

        END;       
    end;
    var
        Text31022893:Label'Vendor %1 is not defined for withholding tax.';
        Text31022894:Label'Withholding tax amount can only in between %1 and %2.';
        Text31022895:Label'Withholding tax amount cannot be null. Please calculate withholding tax amount.';
        vendor:Record Vendor;
        WithholdingTaxCodes: Record "Withholding Tax Codes";
        Currency:Record Currency;
}