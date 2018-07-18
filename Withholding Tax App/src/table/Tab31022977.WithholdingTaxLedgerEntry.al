table 31022977 "Withholding Tax Ledger Entry"
{

    Caption ='Withholding Tax Ledger Entry';
    DrillDownPageID = "Withholding Tax Ledger Entries";
    LookupPageID = "Withholding Tax Ledger Entries";

    fields
    {
        field(1;"Entry No.";Integer)
        {
            Caption='Entry No.';
            DataClassification = CustomerContent;
        }
        field(2;"Entity Type";Option)
        {
            Caption='Entity Type';
            OptionCaption =' ,Customer,Vendor';
            OptionMembers = " ",Customer,Vendor;
            DataClassification = CustomerContent;            
        }
        field(3;"Entity No.";Code[20])
        {
            Caption='Entity No.';
            TableRelation = IF ("Entity Type"=CONST(Customer)) "Customer"."No."
                            ELSE IF ("Entity Type"=CONST(Vendor)) "Vendor"."No.";
            DataClassification = CustomerContent;                   
        }
        field(4;"Document Type";Option)
        {
            Caption ='Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
            DataClassification = CustomerContent; 
        }
        field(5;"Document No.";Text[50])
        {
            Caption ='Document No.';
            DataClassification = CustomerContent; 
        }
        field(6;"Document Date";Date)
        {
            Caption ='Document Date';
            DataClassification = CustomerContent; 
        }
        field(7;"Posting Date";Date)
        {
            Caption ='Posting Date';
            DataClassification = CustomerContent; 
        }
        field(8;"Withholding Tax Amount";Decimal)
        {
            Caption = 'Withholding Tax Amount';
            DataClassification = CustomerContent; 
        }
        field(9;"Withholding Tax Code";Code[20])
        {
            Caption ='Withholding Tax Code';
            TableRelation = "Withholding Tax Codes";
            DataClassification = CustomerContent; 
        }
        field(10;"Withholding Tax %";Decimal)
        {
            Caption = '% Retenção na Fonte';
            DataClassification = CustomerContent; 
        }
        field(11;IRC;Boolean)
        {
            Caption ='Is IRC';
            Enabled = false;
            DataClassification = CustomerContent; 
        }
        field(12;"Has Withholding Tax";Boolean)
        {
            Caption ='Has Withholding Tax';
            DataClassification = CustomerContent; 
        }
        field(14;"Withholding Tax Account";Code[20])
        {
            Caption ='Withholding Tax Account';
            DataClassification = CustomerContent; 
        }
        field(16;"VAT Registration No.";Text[50])
        {
            Caption ='VAT Registration No.';
            DataClassification = CustomerContent; 
        }
        field(17;"Income Amount";Decimal)
        {
            Caption ='Income Amount';
            DataClassification = CustomerContent; 
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

