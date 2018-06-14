tableextension 50101 "G/L Account Extension" extends "G/L Account"
{
    fields
    {

        field(50100; "Taxonomy Code"; Integer)
        {
            Caption = 'Taxonomy Code';
            TableRelation = "Taxonomy Codes"."Taxonomy Code";
            DataClassification = CustomerContent;
            BlankZero = true;
            trigger OnValidate()
            begin
                Rec.TestField("Account Type","Account Type"::Posting);
            end;
        }
    }
            
}