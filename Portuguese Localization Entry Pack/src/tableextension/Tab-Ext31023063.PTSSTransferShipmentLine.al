tableextension 31023063 "PTSS Transfer Shipment Line" extends "Transfer Shipment Line" //MyTargetTableId
{
    //Comunicação AT
    fields
    {
        field(31022890; "PTSS Posting Date"; Date)
        {
            FieldClass = FlowField;
            CalcFormula = Lookup ("Transfer Shipment Header"."Posting Date" WHERE ("No." = FIELD ("Document No.")));
            Caption = 'Posting Date';
        }

    }

}