table 31022923 "Cash-Flow Plan"
{
    DataClassification = ToBeClassified;
    Caption = 'Cash-Flow Plan';
    LookupPageId = "Cash-Flow Plan";

    fields
    {
        field(1; "No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'No.';
        }
        field(2; "Description"; Text[100])
        {
            DataClassification = ToBeClassified;
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
            CalcFormula = Sum ("G/L Entry".Amount WHERE ("Acc: cash-flow code" = FIELD ("No."), "Posting Date" = FIELD ("Date filter"), "Acc: cash-flow code" = FIELD (FILTER (Totaling))));
        }
        field(10; "Type"; Option)
        {
            Caption = 'Type';
            OptionMembers = "Posting","Totaling";
            OptionCaption = 'Posting,Totaling';
            DataClassification = ToBeClassified;
        }
        field(11; "Totaling"; Text[250])
        {
            Caption = 'Totaling';
            DataClassification = ToBeClassified;
            TableRelation = "Cash-Flow Plan";
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
            DataClassification = ToBeClassified;
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

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}