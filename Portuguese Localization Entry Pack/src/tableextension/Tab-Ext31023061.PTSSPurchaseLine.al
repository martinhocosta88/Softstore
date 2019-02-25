tableextension 31023061 "PTSS Purchase Line" extends "Purchase Line" //MyTargetTableId
{
    //Configuracao SAFT
    fields
    {
        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                TestSAFTFields();
            end;
        }
    }
    local procedure TestSAFTFields()
    var
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        IF Type In [Type::Item, Type::"Fixed Asset", Type::"G/L Account"] THEN begin
            VATPostingSetup.get("VAT Bus. Posting Group", "VAT Prod. Posting Group");
            IF VATPostingSetup."VAT %" = 0 then
                VATPostingSetup.TestField("VAT Clause Code");
            VATPostingSetup.TestField("PTSS SAF-T PT VAT Code");
            VATPostingSetup.TestField("PTSS SAF-T PT VAT Type Description");
        END;
    end;

}