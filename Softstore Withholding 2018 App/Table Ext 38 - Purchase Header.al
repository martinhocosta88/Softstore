tableextension 50121 "Purchase Header Ext" extends "Purchase Header"
{
    fields
    {
        modify("Buy-from Vendor No.")
        {
            trigger OnAfterValidate();
            var
                Text31022895:Label 'Vendor %1 is defined for withholding tax.';
                Vendor:Record Vendor;
            begin
                Vendor.GET("Buy-from Vendor No.");
                IF Vendor."Subject to Withholding Tax" THEN
                    MESSAGE(Text31022895,"Buy-from Vendor No.");
            end;
        }
    }
    
}