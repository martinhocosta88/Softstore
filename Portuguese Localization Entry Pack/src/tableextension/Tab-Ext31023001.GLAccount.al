tableextension 31023001 "G/L Account" extends "G/L Account"
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
            DataClassification = CustomerContent;
        }
        field(31022895; "Cash-flow code"; Code[10])
        {
            //Cash-Flow
            Caption = 'Cash-flow code';
            TableRelation = "Cash-Flow Plan"."No." WHERE (Type = CONST (Posting));
            DataClassification = CustomerContent;
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
            //Cash-Flow
            Caption = 'Cash-flow code assoc.';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF NOT "Cash-flow code assoc." THEN
                    "Cash-flow code" := '';
            end;
        }
        field(31022897; "Cash-flow - credit"; Decimal)
        {
            //Cash-Flow
            Caption = 'Cash-flow - credit';
            FieldClass = FlowField;
            CalcFormula = Sum ("G/L Entry"."Credit Amount" WHERE ("G/L Account No." = FIELD ("No."), "Acc: cash-flow code" = FILTER (<> '')));
            Editable = false;
        }
        field(31022898; "Cash-flow - debit"; Decimal)
        {
            //Cash-Flow
            Caption = 'Cash-flow - debit';
            FieldClass = FlowField;
            CalcFormula = Sum ("G/L Entry"."Debit Amount" WHERE ("G/L Account No." = FIELD ("No."), "Acc: cash-flow code" = FILTER (<> '')));
            Editable = false;
        }
    }
}