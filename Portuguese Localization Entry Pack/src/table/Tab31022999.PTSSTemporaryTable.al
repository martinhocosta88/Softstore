table 31022999 "PTSS Temporary Table"
{
    // version NAVSS82.00

    // This table should only be use in Temporary Records. New fields/Keys can be added.

    Caption = 'Temporary Table';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            dataclassification = CustomerContent;
        }
        field(101; "Boolean1"; Boolean)
        {
            Caption = 'Boolean1';
            dataclassification = CustomerContent;
        }
        field(102; "Boolean2"; Boolean)
        {
            Caption = 'Boolean2';
            dataclassification = CustomerContent;
        }
        field(103; "Boolean3"; Boolean)
        {
            Caption = 'Boolean3';
            dataclassification = CustomerContent;
        }
        field(104; "Boolean4"; Boolean)
        {
            Caption = 'Boolean4';
            dataclassification = CustomerContent;
        }
        field(105; "Boolean5"; Boolean)
        {
            Caption = 'Boolean5';
            dataclassification = CustomerContent;
        }
        field(201; "Code1"; Code[80])
        {
            Caption = 'Code1';
            dataclassification = CustomerContent;
        }
        field(202; "Code2"; Code[80])
        {
            Caption = 'Code2';
            dataclassification = CustomerContent;
        }
        field(203; "Code3"; Code[80])
        {
            Caption = 'Code3';
            dataclassification = CustomerContent;
        }
        field(204; "Code4"; Code[80])
        {
            Caption = 'Code4';
            dataclassification = CustomerContent;
        }
        field(205; "Code5"; Code[80])
        {
            Caption = 'Code5';
            dataclassification = CustomerContent;
        }
        field(301; "Date1"; Date)
        {
            Caption = 'Date1';
            dataclassification = CustomerContent;
        }
        field(302; "Date2"; Date)
        {
            Caption = 'Date2';
            dataclassification = CustomerContent;
        }
        field(303; "Date3"; Date)
        {
            Caption = 'Date3';
            dataclassification = CustomerContent;
        }
        field(304; "Date4"; Date)
        {
            Caption = 'Date4';
            dataclassification = CustomerContent;
        }
        field(305; "Date5"; Date)
        {
            Caption = 'Date5';
            dataclassification = CustomerContent;
        }
        field(401; "Decimal1"; Decimal)
        {
            Caption = 'Decimal1';
            dataclassification = CustomerContent;
        }
        field(402; "Decimal2"; Decimal)
        {
            Caption = 'Decimal2';
            dataclassification = CustomerContent;
        }
        field(403; "Decimal3"; Decimal)
        {
            Caption = 'Decimal3';
            dataclassification = CustomerContent;
        }
        field(404; "Decimal4"; Decimal)
        {
            Caption = 'Decimal4';
            dataclassification = CustomerContent;
        }
        field(405; "Decimal5"; Decimal)
        {
            Caption = 'Decimal5';
            dataclassification = CustomerContent;
        }
        field(501; "Integer1"; Integer)
        {
            Caption = 'Inteiro1';
            dataclassification = CustomerContent;
        }
        field(502; "Integer2"; Integer)
        {
            Caption = 'Inteiro2';
            dataclassification = CustomerContent;
        }
        field(503; "Integer3"; Integer)
        {
            Caption = 'Inteiro3';
            dataclassification = CustomerContent;
        }
        field(504; "Integer4"; Integer)
        {
            Caption = 'Inteiro4';
            dataclassification = CustomerContent;
        }
        field(505; "Integer5"; Integer)
        {
            Caption = 'Inteiro5';
            dataclassification = CustomerContent;
        }
        field(601; "Text1"; Text[250])
        {
            Caption = 'Text1';
            dataclassification = CustomerContent;
        }
        field(602; "Text2"; Text[50])
        {
            Caption = 'Text2';
            dataclassification = CustomerContent;
        }
        field(603; "Text3"; Text[250])
        {
            Caption = 'Text3';
            dataclassification = CustomerContent;
        }
        field(604; "Text4"; Text[250])
        {
            Caption = 'Text4';
            dataclassification = CustomerContent;
        }
        field(605; "Text5"; Text[250])
        {
            Caption = 'Text5';
            dataclassification = CustomerContent;
        }
        field(701; "Blob1"; BLOB)
        {
            Caption = 'Blob1';
            dataclassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
        key(Key2; Integer1, Text1, Code1)
        {
        }
        key(Key3; Integer1, Code2)
        {
        }
        key(Key4; Text1, Code1, Text2)
        {
        }
    }

    fieldgroups
    {
    }
}

