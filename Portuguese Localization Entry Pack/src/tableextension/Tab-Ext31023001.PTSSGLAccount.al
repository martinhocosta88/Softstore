tableextension 31023001 "PTSS G/L Account" extends "G/L Account"
{
    //Taxonomies
    //Cash-Flow
    fields
    {
        field(31022975; "PTSS Taxonomy Code"; Integer)
        {
            //Taxonomies
            Caption = 'Taxonomy Code';
            TableRelation = "PTSS Taxonomy Codes"."Taxonomy Code";
            DataClassification = CustomerContent;
            BlankZero = true;
            trigger OnValidate()
            begin
                Rec.TestField("Account Type", "Account Type"::Posting);
            end;
        }
        field(31022890; "PTSS Income Stmt. Bal. Acc."; Code[20])
        {
            //Taxonomies
            Caption = 'Income Stmt. Bal. Acc.';
            AutoFormatExpression = GetCurrencyCode;
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;
        }
        field(31022895; "PTSS Cash-flow code"; Code[10])
        {
            //Cash-Flow
            Caption = 'Cash-flow code';
            TableRelation = "PTSS Cash-Flow Plan"."No." WHERE (Type = CONST (Posting));
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF "PTSS Cash-flow code assoc." THEN
                    rec.TESTFIELD("PTSS Cash-flow code");

                IF "PTSS Cash-flow code" <> '' THEN
                    "PTSS Cash-flow code assoc." := TRUE;
            end;
        }
        field(31022896; "PTSS Cash-flow code assoc."; Boolean)
        {
            //Cash-Flow
            Caption = 'Cash-flow code assoc.';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF NOT "PTSS Cash-flow code assoc." THEN
                    "PTSS Cash-flow code" := '';
            end;
        }
        field(31022897; "PTSS Cash-flow - credit"; Decimal)
        {
            //Cash-Flow
            Caption = 'Cash-flow - credit';
            FieldClass = FlowField;
            CalcFormula = Sum ("G/L Entry"."Credit Amount" WHERE ("G/L Account No." = FIELD ("No."), "PTSS Acc: cash-flow code" = FILTER (<> '')));
            Editable = false;
        }
        field(31022898; "PTSS Cash-flow - debit"; Decimal)
        {
            //Cash-Flow
            Caption = 'Cash-flow - debit';
            FieldClass = FlowField;
            CalcFormula = Sum ("G/L Entry"."Debit Amount" WHERE ("G/L Account No." = FIELD ("No."), "PTSS Acc: cash-flow code" = FILTER (<> '')));
            Editable = false;
        }
    }
}