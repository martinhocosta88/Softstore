tableextension 50102 "G/L Entry Extension" extends "G/L Entry"
{
    fields
    {
        field(50100; "Taxonomy Code"; Integer)
        {
            Caption = 'Taxonomy Code';
            FieldClass = FlowField;
            CalcFormula=lookup("G/L Account"."Taxonomy Code" where ("No."=field("G/L Account No.")));
        }
    }
    

}