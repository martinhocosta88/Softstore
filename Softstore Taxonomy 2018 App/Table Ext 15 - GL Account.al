tableextension 50101 "G/L Account Extension" extends "G/L Account"
{
    fields
    {
        field(50100; "Taxonomy Code"; Integer)
        {
            Caption = 'Taxonomy Code';
            TableRelation = "Taxonomy Codes"."Taxomy Code";
            DataClassification = CustomerContent;
            BlankZero = true;
            trigger OnValidate()
            var
                
            begin
                TestField("Account Type","Account Type"::Posting);
            end;
        }
    }
     
    var
        
}