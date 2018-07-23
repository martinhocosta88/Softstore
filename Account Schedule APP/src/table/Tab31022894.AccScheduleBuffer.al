table 31022894 "Acc. Schedule Buffer"
{
    Caption ='Acc. Schedule Buffer';
    fields
    {
        field(1;"Line No.";Integer)
        {
            Caption ='Line No.';
        }
        field(2;"Balance (Curr. Year)";Decimal)
        {
            Caption ='Balance (Curr. Year)';
        }
        field(3;"Balance (Prev. Year)";Decimal)
        {
            Caption ='Balance (Prev. Year)';
        }
    }
    keys
    {
        key(Key1;"Line No.")
        {
        }
    }
}

