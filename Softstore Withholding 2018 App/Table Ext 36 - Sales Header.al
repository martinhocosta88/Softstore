tableextension 50120 "Sales Header Ext" extends "Sales Header"
{
    fields
    {
        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate();
            var
                Text31022895:Label 'Customer %1 is defined for withholding tax.';
                Customer:Record Customer;
            begin
                Customer.GET("Sell-to Customer No.");
                IF Customer."Subject to Withholding Tax" THEN
                    MESSAGE(Text31022895,"Sell-to Customer No.");
            end;
        }
    }
    
}