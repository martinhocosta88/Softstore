tableextension 31023020 "Sales Line Ext" extends "Sales Line"
{
    fields
    {
        field(31022970; "Withholding Tax Code"; Code[20])
        {
            caption = 'Withholding Tax Code';
            TableRelation = "Withholding Tax Codes";
            DataClassification = CustomerContent;
            trigger OnValidate()
            var

            begin
                Customer.GET("Sell-to Customer No.");
                IF NOT Customer."Subject to Withholding Tax" THEN
                    ERROR(Text31022899,"Sell-to Customer No.");
                CalcWithholdingTax;
            end;
        }
        field(31022971; "Withholding Tax %"; Decimal)
        {
            caption='Withholding Tax %';

            DataClassification = CustomerContent;
        }
        field(31022972; "Withholding Tax Account"; Code[20])
        {
            caption='Withholding Tax Account';
            
            DataClassification = CustomerContent;
        }
        field(31022973; "Withholding Tax Amount"; Decimal)
        {
            caption='Withholding Tax Amount';

            DataClassification = CustomerContent;
            trigger OnValidate()
            var
            begin
                IF "Orig. Withholding Tax Amount" = 0 THEN
                    ERROR(Text31022901);
                IF ("Withholding Tax Amount" > "Orig. Withholding Tax Amount"+"Max. Correction Amount") OR
                    ("Withholding Tax Amount" < "Orig. Withholding Tax Amount"-"Max. Correction Amount") THEN
                    ERROR(Text31022900,"Orig. Withholding Tax Amount"-"Max. Correction Amount","Orig. Withholding Tax Amount"+"Max. Correction Amount");
            end;
        }
        field(31022974; "Orig. Withholding Tax Amount"; Decimal)
        {
            caption='Orig. Withholding Tax Amount';

            DataClassification = CustomerContent;
        }
        field(31022975; "Max. Correction Amount"; Decimal)
        {
            caption='Max. Correction Amount';
            MinValue = 0;
            DataClassification = CustomerContent;
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
        Text31022899:Label'Customer %1 is not defined for Withholding Tax.';
        Text31022900:Label'Withholding tax amount can only in between %1 and %2.';
        Text31022901:Label'Withholding tax amount cannot be null. Please calculate Withholding Tax Amount.';
        Customer: Record Customer;
        WithholdingTaxCodes: Record "Withholding Tax Codes";
        Currency:Record Currency;
}