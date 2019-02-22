tableextension 31023057 "PTSS Item" extends Item //MyTargetTableId
{
    //Regras Negocio
    fields
    {
        modify(Description)
        {
            trigger OnBeforeValidate()
            begin
                CheckItemLdgEntries(xRec."No.");
            end;
        }
        modify("Description 2")
        {
            trigger OnBeforeValidate()
            begin
                CheckItemLdgEntries(xRec."No.");
            end;
        }
        modify("Item Category Code")
        {
            trigger OnAfterValidate()
            begin
                UpdateATItemCategory;
            end;
        }
    }
    trigger OnBeforeInsert()
    begin
        CheckItemDuplicate();
    end;

    trigger OnBeforeRename()
    begin
        CheckItemDuplicate();
        CheckItemLdgEntries(xRec."No.");
    end;

    local procedure CheckItemDuplicate()
    var
        Resource: Record Resource;
        ItemCharge: Record "Item Charge";
        Text31022892: Label '%1 %2 already exists. You cannot have an %3 with the same name as a %1.';
    begin
        IF Resource.get("No.") then
            Error(Text31022892, Resource.TableCaption, Resource."No.", Rec.TableCaption);
        IF ItemCharge.Get("No.") then
            Error(Text31022892, ItemCharge.TableCaption, ItemCharge."No.", Rec.TableCaption);
    end;

    local procedure CheckItemLdgEntries(ItemNo: Code[20])
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETRANGE("Item No.", ItemNo);
        IF NOT ItemLedgerEntry.ISEMPTY THEN
            ERROR(Text31022891, TABLECAPTION);
    end;

    local procedure UpdateATItemCategory()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ItemCategory: Record "Item Category";
        ATCategory: Option;
    begin
        IF xRec."Item Category Code" <> '' THEN BEGIN
            ItemLedgerEntry.SETCURRENTKEY("Item No.");
            ItemLedgerEntry.SETRANGE("Item No.", "No.");
            IF NOT ItemLedgerEntry.ISEMPTY THEN BEGIN
                ItemCategory.SETRANGE(Code, xRec."Item Category Code");
                IF ItemCategory.FINDFIRST THEN BEGIN
                    ATCategory := ItemCategory."PTSS AT Item Category";
                    ItemCategory.SETRANGE(Code, "Item Category Code");
                    IF ItemCategory.FINDFIRST THEN BEGIN
                        IF ATCategory <> ItemCategory."PTSS AT Item Category" THEN
                            ERROR(Text31022891, "Item Category Code");
                    END ELSE
                        ERROR(Text31022891, "Item Category Code");
                END;
            END;
        END;
    end;

    var
        Text31022891: Label 'You cannot change %1 because this Item has entries.';


}