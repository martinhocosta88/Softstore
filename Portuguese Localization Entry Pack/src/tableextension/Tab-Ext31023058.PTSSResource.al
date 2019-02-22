tableextension 31023058 "PTSS Resource" extends Resource //MyTargetTableId
{
    //Regras Negocio
    fields
    {
        modify(Name)
        {
            trigger OnBeforeValidate()
            begin
                CheckResourceLdgEntries(xRec."No.");
            end;
        }

    }
    trigger OnBeforeInsert()
    begin
        CheckResourceDuplicate();
    end;

    trigger OnBeforeRename()
    begin
        CheckResourceDuplicate();
        CheckResourceLdgEntries(xRec."No.");
    end;

    local procedure CheckResourceDuplicate()
    var
        Item: Record Item;
        ItemCharge: Record "Item Charge";
        Text31022890: Label '%1 %2 already exists. You cannot have an %3 with the same name as a %1.';
    begin
        IF Item.GET("No.") THEN
            ERROR(Text31022890, Item.TABLECAPTION, Item."No.", Rec.TABLECAPTION);
        IF ItemCharge.GET("No.") THEN
            ERROR(Text31022890, ItemCharge.TABLECAPTION, ItemCharge."No.", Rec.TABLECAPTION);
    end;

    local procedure CheckResourceLdgEntries(ResourceNo: Code[20])
    var
        ResLdgEntries: Record "Res. Ledger Entry";
        Text31022891: Label 'You cannot change %1 because this resource has entries.';
    begin
        ResLdgEntries.RESET;
        ResLdgEntries.SETRANGE("Resource No.", ResourceNo);
        IF NOT ResLdgEntries.ISEMPTY THEN
            ERROR(Text31022891, TABLECAPTION);
    end;

}