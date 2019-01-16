tableextension 31023018 "PTSS Bank Account Ledger Entry" extends "Bank Account Ledger Entry" //MyTargetTableId
{
    //COPE
    //Cash-Flow
    fields
    {
        field(31022900; "PTSS Cash-Flow Code"; Code[10])
        {
            Caption = 'Cash-Flow Code';
            TableRelation = "PTSS Cash-Flow Plan"."No.";
            DataClassification = CustomerContent;
        }

        field(31022949; "PTSS BP Account Type Code"; Code[1])
        {
            Caption = 'BP Account Type Code';
            TableRelation = "PTSS BP Account Type";
            DataClassification = CustomerContent;
        }
        field(31022950; "PTSS BP Statistic Code"; Code[5])
        {
            Caption = 'BP Statistic Code';
            TableRelation = "PTSS BP Statistic";
            DataClassification = CustomerContent;
        }
        field(31022951; "PTSS BP Countrp. Country Code"; Code[3])
        {
            Caption = 'BP Counterpart Country Code';
            TableRelation = "PTSS BP Territory";
            DataClassification = CustomerContent;
        }
        field(31022952; "PTSS BP Active Country Code"; Code[3])
        {
            Caption = 'Active Country Code';
            TableRelation = "PTSS BP Territory";
            DataClassification = CustomerContent;
        }
        field(31022953; "PTSS BP NPC 2nd Intervener"; Integer)
        {
            Caption = 'BP NPC 2nd Intervener';
            DataClassification = CustomerContent;
        }
    }
}