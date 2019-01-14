tableextension 31023015 "PTSS Item Ledger Entry" extends "Item Ledger Entry" //MyTargetTableId
{
    //AT Inventory Communication
    fields
    {
        field(31022898; "PTSS Location Type"; Option)
        {
            OptionMembers = ,"Internal","External - Customer","External - Vendor";
            Caption = 'Cash-flow - credit';
            FieldClass = FlowField;
            CalcFormula = Lookup (Location."PTSS Location Type" WHERE (Code = FIELD ("Location Code")));
            Editable = false;
        }
    }

}