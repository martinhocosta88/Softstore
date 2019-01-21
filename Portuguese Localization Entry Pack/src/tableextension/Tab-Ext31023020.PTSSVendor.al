tableextension 31023020 "PTSS Vendor" extends Vendor //MyTargetTableId
{
    //COPE
    //Vendor Statement
    fields
    {
        field(31022950; "PTSS BP Statistic Code"; Code[5])
        {
            Caption = 'BP Statistic Code';
            TableRelation = "PTSS BP Statistic";
            DataClassification = CustomerContent;
        }
        field(31022951; "PTSS Debit Pos. Stat. Code"; Code[5])
        {
            Caption = 'Debit Pos. Statistic Code';
            TableRelation = "PTSS BP Statistic";
            DataClassification = CustomerContent;
        }
        field(31022952; "PTSS Credit Pos. Stat. Code"; Code[5])
        {
            Caption = 'BP Credit Pos. Statistic Code';
            TableRelation = "PTSS BP Statistic";
            DataClassification = CustomerContent;
        }
        field(31022953; "PTSS BP Balance at Date (LCY)"; Decimal)
        {
            Caption = 'BP Balance at Date (LCY)';
            Editable = False;
            FieldClass = FlowField;
            CalcFormula = Sum ("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE ("Vendor No." = FIELD ("No."), "Currency Code" = FIELD ("Currency Filter"), "PTSS Excluded From Calculation" = CONST (false), "PTSS Initial BP Statistic Code" = FIELD ("PTSS BP Statistic Filter"), "Posting Date" = FIELD (UPPERLIMIT ("Date Filter"))));
        }
        field(31022954; "PTSS BP Statistic Filter"; Code[5])
        {
            Caption = 'BP Statistic Filter';
            TableRelation = "PTSS BP Statistic";
            FieldClass = FlowFilter;
        }
        field(31022955; "PTSS Vendor Post. Group Filter"; Code[10])
        {
            Caption = 'MyField';
            FieldClass = FlowFilter;
            TableRelation = "Vendor Posting Group".Code;
        }


    }

}