tableextension 31023032 "G/L Account Ext" extends "G/L Account"
{
    fields
    {
        field(31022970;"Transfer Account Type";Option)
        {
            OptionMembers =  ,"G/L Account","Customer","Vendor";
            DataClassification =CustomerContent;
            trigger OnValidate();
            begin
                IF xRec."Transfer Account Type"<> "Transfer Account Type" THEN
                    "Transfer Account No.":='';
            end;
        }
        field(31022971;"Transfer Account No.";Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = IF ("Transfer Account Type"=CONST("G/L Account")) "G/L Account"."No." ELSE IF ("Transfer Account Type"=CONST(Customer)) Customer."No." ELSE IF ("Transfer Account Type"=CONST(Vendor)) Vendor."No.";
            trigger OnValidate();
            begin
                rec.TestField("Transfer Account Type");
            end;
        }
    }
}