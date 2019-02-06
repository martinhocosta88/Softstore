table 31022927 "PTSS Municipalities"
{
    // IRC Modelo 22

    Caption = 'Municipalities';
    LookupPageID = "PTSS Municipalities List";

    fields
    {
        field(1; "Municipality"; Code[4])
        {
            Caption = 'Municipality';
        }
        field(2; "Description"; Text[30])
        {
            Caption = 'Description';
        }
        field(3; "Salary Mass"; Decimal)
        {
            Caption = 'Salary Mass';
            MaxValue = 9999999999.99;

            trigger OnValidate()
            begin
                CalcProduct;
            end;
        }
        field(4; "Municipality Tax"; Decimal)
        {
            Caption = 'Municipality Tax';
            DecimalPlaces = 2 : 2;
            MaxValue = 99.99;

            trigger OnValidate()
            begin
                CalcProduct;
            end;
        }
        field(5; "Product"; Decimal)
        {
            Caption = 'Product';
            Editable = false;
            MaxValue = 9999999999.99;
        }
        field(6; "Active"; Boolean)
        {
            Caption = 'Active';
        }
    }

    keys
    {
        key(Key1; "Municipality")
        {
        }
        key(Key2; "Active")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Municipality", "Description", "Salary Mass", "Municipality Tax", "Product", "Active")
        {
        }
    }

    procedure CalcProduct()
    begin
        "Product" := ("Salary Mass" * "Municipality Tax") / 100;
    end;
}

