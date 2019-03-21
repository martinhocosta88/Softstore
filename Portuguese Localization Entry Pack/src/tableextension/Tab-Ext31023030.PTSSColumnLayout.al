tableextension 31023030 "PTSS Column Layout" extends "Column Layout" //MyTargetTableId
{
    //Esquema de Contas - Valor Coluna
    fields
    {
        field(31022890; "PTSS Amount Type 2"; Option)
        {
            Caption = 'Amount Type 2';
            OptionMembers = "Net Amount","Debit Amount","Credit Amount";
            OptionCaption = 'Net Amount,Debit Amount,Credit Amount';
            DataClassification = CustomerContent;
        }
        field(31022891; "PTSS Amount Type 3"; Option)
        {
            Caption = 'Amount Type 3';
            OptionMembers = "Net Amount","Debit Amount","Credit Amount";
            OptionCaption = 'Net Amount,Debit Amount,Credit Amount';
            DataClassification = CustomerContent;
        }
        field(31022893; "PTSS Balance 1"; Boolean)
        {
            Caption = 'Balance 1';
            DataClassification = CustomerContent;
        }
        field(31022894; "PTSS Balance 2"; Boolean)
        {
            Caption = 'Balance 2';
            DataClassification = CustomerContent;
        }
        field(31022895; "PTSS Balance 3"; Boolean)
        {
            Caption = 'Balance 3';
            DataClassification = CustomerContent;
        }
    }
}