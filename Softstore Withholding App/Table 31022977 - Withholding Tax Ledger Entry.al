table 31022977 "Withholding Tax Ledger Entry"
{

    Caption ='Withholding Tax Ledger Entry';
    DrillDownPageID = 31023086;
    LookupPageID = 31023086;

    fields
    {
        field(1;"Entry No.";Integer)
        {
            Caption='Entry No.';
        }
        field(2;"Entity Type";Option)
        {
            Caption='Entity Type';
            OptionCaption =' ,Customer,Vendor';
            OptionMembers = " ",Customer,Vendor;
        }
        field(3;"Entity No.";Code[20])
        {
            Caption='Entity No.';
            TableRelation = IF ("Entity Type"=CONST(Customer)) "Customer"."No."
                            ELSE IF ("Entity Type"=CONST(Vendor)) "Vendor"."No.";
        }
        field(4;"Document Type";Option)
        {
            Caption ='Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(5;"Document No.";Text[50])
        {
            Caption ='Document No.';
        }
        field(6;"Document Date";Date)
        {
            Caption ='Document Date';
        }
        field(7;"Posting Date";Date)
        {
            Caption ='Posting Date';
        }
        field(8;"Withholding Tax Amount";Decimal)
        {
            Caption = 'Withholding Tax Amount';
        }
        field(9;"Withholding Tax Code";Code[20])
        {
            Caption ='Withholding Tax Code';
            TableRelation = "Withholding Tax Codes";
        }
        field(10;"Withholding Tax %";Decimal)
        {
            Caption = '% Retenção na Fonte';
        }
        field(11;IRC;Boolean)
        {
            Caption ='Is IRC';
            Enabled = false;
        }
        field(12;"Has Withholding Tax";Boolean)
        {
            Caption ='Has Withholding Tax';
        }
        field(14;"Withholding Tax Account";Code[20])
        {
            Caption ='Withholding Tax Account';
        }
        field(16;"VAT Registration No.";Text[50])
        {
            Caption ='VAT Registration No.';
        }
        field(17;"Income Amount";Decimal)
        {
            Caption ='Income Amount';
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
        }
        key(Key2;"VAT Registration No.","Withholding Tax Code","Document No.")
        {
        }
        key(Key3;"Has Withholding Tax","Entity Type","Entity No.","Document Date")
        {
            SumIndexFields = "Income Amount","Withholding Tax Amount";
        }
    }

    fieldgroups
    {
    }
}

