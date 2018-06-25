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
                Rec.TestField("Account Type", "Account Type"::Posting);
            end;
        }
        field(31022890; "Income Stmt. Bal. Acc."; Code[20])
        {
            Caption = 'Income Stmt. Bal. Acc.';
            AutoFormatExpression = GetCurrencyCode;
            TableRelation = "G/L Account";
            DataClassification = ToBeClassified;
        }
        field(31022895; "Cash-flow code"; Code[10])
        {
            Caption = 'Cash-flow code';
            TableRelation = "Cash-Flow Plan"."No." WHERE (Type = CONST (Posting));
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                IF "Cash-flow code assoc." THEN
                    rec.TESTFIELD("Cash-flow code");

                IF "Cash-flow code" <> '' THEN
                    "Cash-flow code assoc." := TRUE;
            end;
        }
        field(31022896; "Cash-flow code assoc."; Boolean)
        {
            Caption = 'Cash-flow code assoc.';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                IF NOT "Cash-flow code assoc." THEN
                    "Cash-flow code" := '';
            end;
        }
        field(31022897; "Cash-flow - credit"; Decimal)
        {
            Caption = 'Cash-flow - credit';
            FieldClass = FlowField;
            CalcFormula = Sum ("G/L Entry"."Credit Amount" WHERE ("G/L Account No." = FIELD ("No."), "Acc: cash-flow code" = FILTER (<> '')));
            Editable = false;
        }
        field(31022898; "Cash-flow - debit"; Decimal)
        {
            Caption = 'Cash-flow - debit';
            FieldClass = FlowField;
            CalcFormula = Sum ("G/L Entry"."Debit Amount" WHERE ("G/L Account No." = FIELD ("No."), "Acc: cash-flow code" = FILTER (<> '')));
            Editable = false;
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