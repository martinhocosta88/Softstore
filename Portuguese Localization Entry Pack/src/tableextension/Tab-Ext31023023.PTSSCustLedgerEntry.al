tableextension 31023023 "PTSS Cust. Ledger Entry" extends "Cust. Ledger Entry" //MyTargetTableId
{
    //COPE
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