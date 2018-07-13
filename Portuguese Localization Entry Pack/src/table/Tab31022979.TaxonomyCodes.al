
table 31022979 "Taxonomy Codes"
{
    //Taxonomies
    DataClassification = CustomerContent;
    Caption = 'Taxonomy Codes';
    DataPerCompany = False;
    fields
    {
        field(1; "Taxonomy Code"; Integer)
        {
            caption = 'Taxonomy Code';
            DataClassification = CustomerContent;
        }
        field(2; "G/L Account Filter"; Text[100])
        {
            Caption = 'G/L Account Filter';
            DataClassification = CustomerContent;
        }
        field(3; "Description"; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }
    keys
    {
        key(PK; "Taxonomy Code")
        {
            Clustered = true;
        }
    }
}