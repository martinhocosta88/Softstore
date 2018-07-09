tableextension 50102 "G/L Entry" extends "G/L Entry"
{
    //Cash-Flow
    //Taxonomies
    fields
    {
        field(31022975; "Taxonomy Code"; Integer)
        {
            Caption = 'Taxonomy Code';
            FieldClass = FlowField;
            CalcFormula = lookup ("G/L Account"."Taxonomy Code" where ("No." = field ("G/L Account No.")));
        }
    }
}