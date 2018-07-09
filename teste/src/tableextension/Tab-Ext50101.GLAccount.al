tableextension 50101 "G/L Account" extends "G/L Account"
{
    //Taxonomies
    //Cash-Flow
    fields
    {

        field(31022975; "Taxonomy Code"; Integer)
        {
            //Taxonomies
            Caption = 'Taxonomy Code';
            TableRelation = "Taxonomy Codes"."Taxonomy Code";
            DataClassification = CustomerContent;
            BlankZero = true;
            trigger OnValidate()
            begin
                Rec.TestField("Account Type", "Account Type"::Posting);
            end;
        }
        field(31022890; "Income Stmt. Bal. Acc."; Code[20])
        {
            //Taxonomies
            Caption = 'Income Stmt. Bal. Acc.';
            AutoFormatExpression = GetCurrencyCode;
            TableRelation = "G/L Account";
            DataClassification = ToBeClassified;
        }
    }
    local procedure GetCurrencyCode(): Code[10]
    var
        GLSetupRead: Boolean;
        GLSetup: Record "General Ledger Setup";
    begin
        IF NOT GLSetupRead THEN BEGIN
            GLSetup.GET;
            GLSetupRead := TRUE;
        END;
        EXIT(GLSetup."Additional Reporting Currency");
    end;
}