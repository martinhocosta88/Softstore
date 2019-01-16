tableextension 31023025 "PTSS CV Ledger Entry Buffer" extends "CV Ledger Entry Buffer" //MyTargetTableId
{
    fields
    {
        field(31022950; "PTSS BP Statistic Code"; Code[5])
        {
            Caption = 'BP Statistic Code';
            TableRelation = "PTSS BP Statistic";
            DataClassification = CustomerContent;
        }
    }

}