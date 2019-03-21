tableextension 31023035 "PTSS Return Receipt Line" extends "Return Receipt Line" //MyTargetTableId
{
    //Notas de Crédito de Acordo com a Fatura
    fields
    {
        field(31022898; "PTSS Credit-to Doc. No."; Code[20])
        {
            Caption = 'Credit-to Doc. No.';
            DataClassification = CustomerContent;
        }
        field(31022899; "PTSS Credit-to Doc. Line No."; Integer)
        {
            Caption = 'Credit-to Doc. Line No.';
            DataClassification = CustomerContent;
        }
    }

}