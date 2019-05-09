tableextension 31023066 "PTSS Service Item" extends "Service Item" //MyTargetTableId
{
    //Regras de Negócio
    fields
    {
        modify(Description)
        {
            trigger OnAfterValidate()
            begin
                IF "Search Description" <> UPPERCASE(xRec.Description) THEN
                    CheckServLedgEntries("No.");
            end;
        }
        modify("Description 2")
        {
            trigger OnAfterValidate()
            begin
                CheckServLedgEntries("No.");
            end;
        }

    }

    local procedure CheckServLedgEntries(ServItemNo: Code[20])
    var
        ServLedgerEntry: Record "Service Ledger Entry";
        Text31022890: Label 'You cannot modify the %1 description because it already has entries.';
    begin
        ServLedgerEntry.RESET;
        ServLedgerEntry.SETRANGE("Service Item No. (Serviced)", ServItemNo);
        IF NOT ServLedgerEntry.ISEMPTY THEN
            ERROR(Text31022890, TABLECAPTION);
    end;
}