tableextension 31023029 "PTSS Acc. Schedule Line" extends "Acc. Schedule Line" //MyTargetTableId
{
    //Esquema de Contas - Valor Coluna
    fields
    {
        field(31022890; "PTSS Column Value"; Option)
        {
            Caption = 'Column Value';
            OptionMembers = "1st Value","2nd Value","3rd Value";
            OptionCaption = '1st Value,2nd Value,3rd Value';
            DataClassification = CustomerContent;
        }
        field(310022891; "PTSS Balance"; Boolean)
        {
            Caption = 'Balance';
            DataClassification = CustomerContent;
        }

    }

}