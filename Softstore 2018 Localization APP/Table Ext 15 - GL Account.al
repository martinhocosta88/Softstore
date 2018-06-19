tableextension 50101 "G/L Account Extension" extends "G/L Account"
{
    fields
    {

        field(31022975; "Taxonomy Code"; Integer)
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
        field(31022890; "Income Stmt. Bal. Acc."; Code[20])
        {
            AutoFormatExpression = GetCurrencyCode;
            TableRelation = "G/L Account";
            DataClassification = ToBeClassified;
        }
        field(31022895; "Cash-flow code"; Code[10])
        {
            TableRelation= "Cash-Flow Plan"."No." WHERE (Type=CONST(Posting));
            DataClassification = ToBeClassified;
        }
        field(31022896; "Cash-flow code assoc."; Boolean)
        {

            DataClassification = ToBeClassified;
        }
        field(31022897; "Cash-flow - credit"; Boolean)
        {

            DataClassification = ToBeClassified;
        }
        field(31022898; "Cash-flow - dedit"; Boolean)
        {

            DataClassification = ToBeClassified;
        }
    }
    local procedure GetCurrencyCode() : Code[10]
    var
        GLSetupRead:Boolean;
        GLSetup:Record "General Ledger Setup";
    begin
        IF NOT GLSetupRead THEN BEGIN
            GLSetup.GET;
            GLSetupRead := TRUE;
        END;
        EXIT(GLSetup."Additional Reporting Currency");
    end;
      
}