tableextension 31023027 "PTSS Adjust Exch. Rate Buffer" extends "Adjust Exchange Rate Buffer"
{
    //Ajuste Divisas
    fields
    {
        field(31022890; "PTSS No."; Code[20])
        {
            Caption = 'Nº';
            DataClassification = CustomerContent;
        }
        field(31022891; "PTSS Account No."; Code[20])
        {
            Caption = 'Nº Conta';
            DataClassification = CustomerContent;
        }
    }

}