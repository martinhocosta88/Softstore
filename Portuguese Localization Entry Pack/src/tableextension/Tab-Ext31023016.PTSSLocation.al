tableextension 31023016 "PTSS Location" extends Location //MyTargetTableId
{
    //AT Inventory Communication
    //Comunicacao AT
    fields
    {
        field(31022890; "PTSS Location Type"; Option)
        {
            OptionMembers = ,"Internal","External - Customer","External - Vendor";
            Caption = 'Location Type';
            DataClassification = CustomerContent;
            trigger Onvalidate()
            begin
                "PTSS External Entity No." := '';
            end;
        }
        field(31022891; "PTSS External Entity No."; Code[20])
        {
            Caption = 'PTSS External Entity No.';
            DataClassification = CustomerContent;
            TableRelation = IF ("PTSS Location Type" = CONST ("External - Customer")) Customer."No." ELSE
            IF ("PTSS Location Type" = CONST ("External - Vendor")) Vendor."No.";
        }

    }

}