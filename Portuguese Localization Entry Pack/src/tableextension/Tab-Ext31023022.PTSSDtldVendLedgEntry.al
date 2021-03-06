tableextension 31023022 "PTSS Dtld. Vend. Ledg. Entry" extends "Detailed Vendor Ledg. Entry" //MyTargetTableId
{
    //COPE
    //Extrato Fornecedor
    fields
    {
        field(31022917; "PTSS Excluded From Calculation"; Boolean)
        {
            Caption = 'Excluded From Calculation';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(31022950; "PTSS Initial BP Statistic Code"; Code[5])
        {
            Caption = 'Initial BP Statistic Code';
            TableRelation = "PTSS BP Statistic";
            DataClassification = CustomerContent;
        }
        field(31022951; "PTSS Vendor Posting Group"; Code[10])
        {
            Caption = 'Vendor Posting Group';
            TableRelation = "Vendor Posting Group";
            Editable = false;
            DataClassification = CustomerContent;
        }

    }

}