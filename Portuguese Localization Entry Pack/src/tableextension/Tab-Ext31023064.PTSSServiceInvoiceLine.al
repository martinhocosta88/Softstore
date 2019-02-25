tableextension 31023064 "PTSS Service Invoice Line" extends "Service Invoice Line" //MyTargetTableId
{
    //Nota de Credito de acordo com a Fatura
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