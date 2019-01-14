tableextension 31023016 "PTSS Location" extends Location //MyTargetTableId
{
    //AT Inventory Communication
    fields
    {
        field(31022890; "PTSS Location Type"; Option)
        {
            OptionMembers = ,"Internal","External - Customer","External - Vendor";
            Caption = 'Location Type';
            DataClassification = CustomerContent;
        }
    }

}