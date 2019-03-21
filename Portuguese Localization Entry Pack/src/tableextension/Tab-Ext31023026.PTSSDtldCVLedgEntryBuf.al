tableextension 31023026 "PTSS Dtld. CV Ledg. Entry Buf." extends "Detailed CV Ledg. Entry Buffer" //MyTargetTableId
{
    //COPE
    fields
    {
        field(31022950; "PTSS Initial BP Statistic Code"; Code[5])
        {
            Caption = 'Initial BP Statistic Code';
            DataClassification = CustomerContent;
            TableRelation = "PTSS BP Statistic";
        }
    }

}