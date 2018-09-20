table 31022923 "PTSS Cash-Flow Plan"
{
    //Cash-Flow
    DataClassification = CustomerContent;
    Caption = 'Cash-Flow Plan';
    LookupPageId = "PTSS Cash-Flow Plan";
    DataPerCompany = False;
    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'No.';
        }
        field(2; "Description"; Text[100])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(6; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(7; "Net Change"; Decimal)
        {
            Caption = 'Net Change';
            FieldClass = FlowField;
            CalcFormula = Sum ("G/L Entry".Amount WHERE ("PTSS Acc: cash-flow code" = FIELD ("No."), "Posting Date" = FIELD ("Date filter"), "PTSS Acc: cash-flow code" = FIELD (FILTER (Totaling))));
        }
        field(10; "Type"; Option)
        {
            Caption = 'Type';
            OptionMembers = "Posting","Totaling";
            OptionCaption = 'Posting,Totaling';
            DataClassification = CustomerContent;

        }
        field(11; "Totaling"; Text[250])
        {
            Caption = 'Totaling';
            DataClassification = CustomerContent;
            TableRelation = "PTSS Cash-Flow Plan";
            ValidateTableRelation = false;
            trigger OnValidate()
            begin
                IF Type = Type::Posting THEN
                    FIELDERROR(Type);
                CALCFIELDS("Net Change");
            end;
        }
        field(12; "Indentation"; Integer)
        {
            Caption = 'Indentation';
            DataClassification = CustomerContent;
            MinValue = 0;
        }
    }

    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
}