tableextension 31023065 "PTSS Service Cr.Memo Line" extends "Service Cr.Memo Line" //MyTargetTableId
{
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