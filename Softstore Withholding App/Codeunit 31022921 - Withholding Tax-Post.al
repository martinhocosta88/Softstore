codeunit 31022921 "Withholding Tax-Post"
{

    trigger OnRun();
    begin
    end;

    var
        GLAccounts : Record "G/L Account";
        Currency : Record Currency;
        PurchaseHeader : Record "Purchase Header";
        DimMgt : Codeunit DimensionManagement;

    procedure PostWithholdingTax(GenJnlLine : Record 81;var TaxGenJnlLine : Record 81) : Boolean;
    var
        GenLedgSetup : Record 98;
        WithholdingTaxLedgEntry : Record 31022977;
        WithholdingTaxCodes : Record 31022975;
        Customer : Record 18;
        Vendor : Record 23;
        EntryNo : Integer;
        LineNo : Integer;
    begin

        IF GenJnlLine."Withholding Tax Code" <> '' THEN BEGIN
          WithholdingTaxLedgEntry.RESET;
          IF WithholdingTaxLedgEntry.FINDLAST THEN
            EntryNo := WithholdingTaxLedgEntry."Entry No." + 1
          ELSE
            EntryNo := 1;
          WithholdingTaxLedgEntry.RESET;
          WithholdingTaxLedgEntry."Entry No." := EntryNo;
          IF GenJnlLine."Source Type" = GenJnlLine."Source Type"::Vendor THEN BEGIN
            Vendor.GET(GenJnlLine."Bill-to/Pay-to No.");
            WithholdingTaxLedgEntry."VAT Registration No." := Vendor."VAT Registration No.";
          END;
          IF GenJnlLine."Source Type" = GenJnlLine."Source Type"::Customer THEN BEGIN
            Customer.GET(GenJnlLine."Sell-to/Buy-from No."); 
            WithholdingTaxLedgEntry."VAT Registration No." := Customer."VAT Registration No.";
          END;
          WithholdingTaxLedgEntry."Entity No." := GenJnlLine."Bill-to/Pay-to No.";
          WithholdingTaxLedgEntry."Document No." := GenJnlLine."Document No.";
          WithholdingTaxLedgEntry."Document Type" := GenJnlLine."Document Type";
          WithholdingTaxLedgEntry."Document Date" := GenJnlLine."Document Date";
          WithholdingTaxLedgEntry."Posting Date" := GenJnlLine."Posting Date";
          WithholdingTaxLedgEntry."Income Amount" := GenJnlLine.Amount + GetVATAmount(GenJnlLine);
          WithholdingTaxLedgEntry."Withholding Tax Amount" := GenJnlLine."Withholding Tax Amount";
          WithholdingTaxLedgEntry."Withholding Tax Code" := GenJnlLine."Withholding Tax Code";
          WithholdingTaxLedgEntry."Withholding Tax %" := GenJnlLine."Withholding Tax %";
          WithholdingTaxLedgEntry."Withholding Tax Account" := GenJnlLine."Withholding Tax Account";
          WithholdingTaxLedgEntry."Entity Type" := GenJnlLine."Source Type";
          WithholdingTaxLedgEntry."Has Withholding Tax":= GenJnlLine."Calc. IRC Withholding Tax";
          IF GenJnlLine."Withholding Tax Amount" <> 0 THEN
            WithholdingTaxLedgEntry."Has Withholding Tax" := TRUE
          ELSE BEGIN
            WithholdingTaxLedgEntry."Has Withholding Tax" := FALSE;
          END;
          WithholdingTaxLedgEntry.INSERT;
        END;

        IF (GenJnlLine."Withholding Tax Code" <> '') AND (GenJnlLine."Withholding Tax Amount" <> 0) THEN BEGIN
          TaxGenJnlLine.SETFILTER ("Journal Template Name", GenJnlLine."Journal Template Name");
          TaxGenJnlLine.SETFILTER ("Journal Batch Name", GenJnlLine."Journal Batch Name");
          IF WithholdingTaxCodes.GET(GenJnlLine."Withholding Tax Code") THEN
          IF WithholdingTaxCodes."IRC Code" THEN
            EXIT (FALSE);
           IF TaxGenJnlLine.FINDLAST THEN
            LineNo := TaxGenJnlLine."Line No." + 1
           ELSE
            LineNo := 1;
          TaxGenJnlLine.INIT;
          TaxGenJnlLine."Line No." := LineNo;
          TaxGenJnlLine.VALIDATE("Document Type",GenJnlLine."Document Type");
          TaxGenJnlLine.VALIDATE("Document No.", GenJnlLine."Document No.");
          TaxGenJnlLine.VALIDATE("Posting Date", GenJnlLine."Posting Date");
          TaxGenJnlLine."External Document No." := GenJnlLine."External Document No.";
          TaxGenJnlLine.Description := GenJnlLine.Description;
          TaxGenJnlLine.VALIDATE("System-Created Entry", TRUE);
          GLAccounts.GET(WithholdingTaxCodes."Account No.");
          // IF (GLAccounts."Transfer Account Type" <> GLAccounts."Transfer Account Type"::Vendor) OR (GLAccounts."Transfer Account Type" <> GLAccounts."Transfer Account Type"::Customer) THEN BEGIN
          //   TaxGenJnlLine.VALIDATE("Account Type",GenJnlLine."Account Type"::"G/L Account");
          //   TaxGenJnlLine.VALIDATE("Account No.",WithholdingTaxCodes."Account No.");
          //   TaxGenJnlLine."Source No." := GenJnlLine."Account No.";
          // END ELSE BEGIN
          //   IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor THEN
          //     TaxGenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Vendor)
          //   ELSE
          //     IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::Customer THEN
          //      TaxGenJnlLine.VALIDATE("Account Type", GenJnlLine."Account Type"::Customer);
          //   TaxGenJnlLine.VALIDATE("Account No.", GLAccounts."Transfer Account No.");
          // END;
          IF GenJnlLine."Currency Code" = '' THEN
            Currency.InitRoundingPrecision
          ELSE BEGIN
            Currency.GET(GenJnlLine."Currency Code");
            Currency.TESTFIELD("Amount Rounding Precision");
          END;

          IF GenJnlLine."Account Type" IN [GenJnlLine."Account Type"::Customer,GenJnlLine."Account Type" :: Vendor] THEN BEGIN
            IF GenJnlLine.Amount < 0 THEN
               TaxGenJnlLine.Amount := -ABS(GenJnlLine."Withholding Tax Amount")
            ELSE
               TaxGenJnlLine.Amount := ABS(GenJnlLine."Withholding Tax Amount");
          END ELSE
            TaxGenJnlLine.Amount := -GenJnlLine."Withholding Tax Amount";
          TaxGenJnlLine.VALIDATE(Amount);
          TaxGenJnlLine."Source Code" := GenJnlLine."Source Code";
          TaxGenJnlLine."Withholding Tax Autom. Entry" := TRUE;
          DimMgt.UpdateGenJnlLineDim(TaxGenJnlLine,GenJnlLine."Dimension Set ID");
          EXIT(TRUE);
        END;
        EXIT(FALSE);
    end;

    procedure GetVATAmount(GenJnlLine : Record "Gen. Journal Line") : Decimal;
    var
        VATEntry : Record "VAT Entry";
        VATAmount : Decimal;
        BaseAmount : Decimal;
    begin

        VATEntry.SETFILTER("Document Type",FORMAT(GenJnlLine."Document Type"));
        VATEntry.SETRANGE("Document No.",GenJnlLine."Document No.");
        IF VATEntry.FINDSET THEN REPEAT
          BaseAmount += VATEntry.Base;
          VATAmount += VATEntry.Amount;
        UNTIL VATEntry.NEXT = 0;
        IF ABS(BaseAmount) <> ABS(GenJnlLine.Amount) THEN
          EXIT(VATAmount);
    end;

// [EventSubscriber(ObjectType::Codeunit, 80, 'OnAfterReverseAmount', '', true, true)]
// local procedure ReverseAmountSalesWithholding(Var SalesLine :Record "Sales Line")
// begin
//   With SalesLine Do begin
//     "Withholding Tax Amount" := -"Withholding Tax Amount";
//     end;
  
// end;
// [EventSubscriber(ObjectType::Codeunit, 90, 'OnAfterReverseAmount', '', true, true)]
// local procedure ReverseAmountPurchWithholding(Var PurchLine:Record "Purchase Line")
// begin
//   With PurchLine do begin
//     "Withholding Tax Amount" := -"Withholding Tax Amount";
//   end;
// end;
}


