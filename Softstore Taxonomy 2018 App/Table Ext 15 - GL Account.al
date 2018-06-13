tableextension 50101 "G/L Account Extension" extends "G/L Account"
{
    fields
    {

        field(50100;"Transfer Account Type";Option)
        {
            OptionMembers =  ,"G/L Account","Customer","Vendor";
            DataClassification =CustomerContent;
            trigger OnValidate();
            begin
                IF xRec."Transfer Account Type"<> "Transfer Account Type" THEN
                    "Transfer Account No.":='';
            end;
        }
        field(50101;"Transfer Account No.";Code[20])
        {
            
            DataClassification = CustomerContent;
            TableRelation = IF ("Transfer Account Type"=CONST("G/L Account")) "G/L Account"."No." ELSE IF ("Transfer Account Type"=CONST(Customer)) Customer."No." ELSE IF ("Transfer Account Type"=CONST(Vendor)) Vendor."No.";
            trigger OnValidate();
            begin
                Rec.TestField("Transfer Account Type");
            end;
        }
        field(50102; "Taxonomy Code"; Integer)
        {
            Caption = 'Taxonomy Code';
            TableRelation = "Taxonomy Codes"."Taxomy Code";
            DataClassification = CustomerContent;
            BlankZero = true;
            trigger OnValidate()

            begin
                Rec.TestField("Account Type","Account Type"::Posting);
            end;
        }
    }
     
    var
        
}