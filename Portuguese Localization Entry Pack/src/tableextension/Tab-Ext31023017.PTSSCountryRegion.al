tableextension 31023017 "PTSS Country/Region" extends "Country/Region" //MyTargetTableId
{
    //COPE

    fields
    {
        field(31022950; "PTSS BP Territory Code"; Code[3])
        {
            Caption = 'BP Territory Code';
            TableRelation = "PTSS BP Territory";
            DataClassification = CustomerContent;
        }

    }

}