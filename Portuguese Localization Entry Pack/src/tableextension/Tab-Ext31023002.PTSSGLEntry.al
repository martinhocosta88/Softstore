tableextension 31023002 "PTSS G/L Entry" extends "G/L Entry"
{
    //Cash-Flow
    //Taxonomies
    fields
    {

        field(31022900; "PTSS Acc: cash-flow code"; Code[10])
        {
            Caption = 'Acc: cash-flow code';
            TableRelation = "PTSS Cash-Flow Plan"."No." WHERE (Type = CONST (Posting));
            DataClassification = CustomerContent;
        }
        field(31022902; "PTSS Bal: cash-flow code"; Code[10])
        {
            Caption = 'Bal: cash-flow code';
            TableRelation = "PTSS Cash-Flow Plan"."No." WHERE (Type = CONST (Posting));
            DataClassification = CustomerContent;
        }
        field(31022975; "PTSS Taxonomy Code"; Integer)
        {
            Caption = 'Taxonomy Code';
            FieldClass = FlowField;
            CalcFormula = lookup ("G/L Account"."PTSS Taxonomy Code" where ("No." = field ("G/L Account No.")));
        }
    }
}