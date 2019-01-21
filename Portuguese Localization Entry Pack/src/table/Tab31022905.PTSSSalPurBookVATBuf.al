table 31022905 "PTSS Sal/Pur. Book VAT Buf."
{
    //Livros Faturas emitidas/recebidas

    Caption = 'Sales/Purch. Book VAT Buffer';
    LookupPageID = 315;

    fields
    {
        field(1; "VAT %"; Decimal)
        {
            Caption = 'VAT %';
        }
        field(2; "ND %"; Decimal)
        {
            Caption = 'ND %';
        }
        field(3; "Base"; Decimal)
        {
            Caption = 'Base';
        }
        field(4; "Amount"; Decimal)
        {
            Caption = 'Amount';
        }
    }

    keys
    {
        key(Key1; "VAT %", "ND %")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        VATPostingSetup.GET("ND %", Base);
        //xxx
        // "VAT %" := VATPostingSetup."VAT %";
        // "ND %" := VATPostingSetup."VAT N.D. %";
    end;

    var
        VATPostingSetup: Record "VAT Posting Setup";
}

