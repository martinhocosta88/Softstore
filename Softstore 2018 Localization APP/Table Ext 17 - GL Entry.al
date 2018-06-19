tableextension 50102 "G/L Entry Extension" extends "G/L Entry"
{
    fields
    {
        field(31022900; "Acc: cash-flow code"; Code[10])
        {
            Caption='Acc: cash-flow code';
            TableRelation="Cash-Flow Plan"."No." WHERE (Type=CONST(Posting));
            DataClassification = ToBeClassified;
        }
        field(31022902; "Bal: cash-flow code"; Code[10])
        {
            Caption='Bal: cash-flow code';
            TableRelation="Cash-Flow Plan"."No." WHERE (Type=CONST(Posting));
            DataClassification = ToBeClassified;
        }
        field(31022975; "Taxonomy Code"; Integer)
        {
            Caption = 'Taxonomy Code';
            FieldClass = FlowField;
            CalcFormula=lookup("G/L Account"."Taxonomy Code" where ("No."=field("G/L Account No.")));
        }
    } 

}