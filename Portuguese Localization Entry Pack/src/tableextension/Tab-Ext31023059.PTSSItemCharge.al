tableextension 31023059 "PTSS Item Charge" extends "Item Charge" //MyTargetTableId
{
    //Regras Negocio
    fields
    {

    }
    trigger OnBeforeInsert()
    begin
        CheckItemChargeDuplicate();
    end;

    trigger OnBeforeRename()
    begin
        CheckItemChargeDuplicate();
        CheckItemChargeLdgEntries(xRec."No.");
    end;

    local procedure CheckItemChargeDuplicate()
    var
        Resource: Record Resource;
        Item: Record Item;
        Text31022890: Label '%1 %2 already exists. You cannot have an %3 with the same name as a %1.';
    begin
        IF Resource.GET("No.") THEN
            ERROR(Text31022890, Resource.TABLECAPTION, Resource."No.", TABLECAPTION);
        IF Item.GET("No.") THEN
            ERROR(Text31022890, Item.TABLECAPTION, Item."No.", TABLECAPTION);
    end;

    local procedure CheckItemChargeLdgEntries(ItemNo: Code[20])
    var
        ItemChargeLedgEntries: Record "Value Entry";
        Text31022891: Label 'You cannot change %1 because this Item has entries.';
    begin
        ItemChargeLedgEntries.RESET;
        ItemChargeLedgEntries.SETRANGE("Item Charge No.", ItemNo);
        IF NOT ItemChargeLedgEntries.ISEMPTY THEN
            ERROR(Text31022891, TABLECAPTION);
    end;

}