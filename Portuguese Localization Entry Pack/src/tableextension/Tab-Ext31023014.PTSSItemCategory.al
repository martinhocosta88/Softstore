tableextension 31023014 "PTSS Item Category" extends "Item Category" //MyTargetTableId
{
    //AT Inventory Communication
    fields
    {
        field(31022890; "PTSS AT Item Category"; Option)
        {
            OptionMembers = ,"M - Goods","P - Raw materials subsidiaries and consumables","A - Finished and intermediate goods","S - By-products waste and scrap","T - Products and work in progress";
            Caption = 'AT Item Category';
            DataClassification = CustomerContent;
        }
    }

}