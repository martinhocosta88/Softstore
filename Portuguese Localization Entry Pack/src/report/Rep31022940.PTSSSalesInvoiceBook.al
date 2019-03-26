report 31022940 "PTSS Sales Invoice Book"
{
    //Livros Faturas emitidas/recebidas

    DefaultLayout = RDLC;
    RDLCLayout = './Sales Invoice Book Layout.rdl';
    Caption = 'Sales Invoice Book';

    dataset
    {
        dataitem("<Integer3>"; Integer)
        {
            DataItemTableView = SORTING (Number)
                                WHERE (Number = CONST (1));
            column(FORMATTODAY04; FORMAT(TODAY, 0, 4))
            {
            }
            column(USERID; USERID)
            {
            }
            // column(CurrReportPAGENO; CurrReport.PAGENO)
            // {
            // }
            column(CompanyAddr7; CompanyAddr[7])
            {
            }
            column(CompanyAddr4; CompanyAddr[4])
            {
            }
            column(CompanyAddr5; CompanyAddr[5])
            {
            }
            column(CompanyAddr6; CompanyAddr[6])
            {
            }
            column(CompanyAddr3; CompanyAddr[3])
            {
            }
            column(CompanyAddr2; CompanyAddr[2])
            {
            }
            column(CompanyAddr1; CompanyAddr[1])
            {
            }
            column(CompanyInfoVATRegistrationNo; CompanyInfo."VAT Registration No.")
            {
            }
            column(CompanyInfoName; CompanyInfo.Name)
            {
            }
            column(HeaderText; HeaderText)
            {
            }
            column(AuxVatEntry; AuxVatEntry)
            {
            }
            column(Integer3Number; Number)
            {
            }
            column(SortPostDate; SortPostDate)
            {
            }
            column(PrintAmountsInAddCurrency; PrintAmountsInAddCurrency)
            {
            }
            dataitem(VATEntry; "VAT Entry")
            {
                DataItemTableView = SORTING ("No. Series", "Posting Date")
                                    WHERE (Type = CONST (Sale));
                RequestFilterFields = "Posting Date", "Document Type", "Document No.";
                column(Base; -Base)
                {
                }
                column(Amount; -Amount)
                {
                }
                column(BaseAmount; -(Base + Amount))
                {
                }
                column(AdditionalCurrencyBase; -"Additional-Currency Base")
                {
                }
                column(AdditionalCurrencyAmount; -"Additional-Currency Amount")
                {
                }
                column(AdditionalCurrencyBaseAdditionalCurrencyAmount; -("Additional-Currency Base" + "Additional-Currency Amount"))
                {
                }
                column(BaseBase2; -Base + Base2)
                {
                }
                column(AmountAmount2; -Amount + Amount2)
                {
                }
                column(BaseBase2AmountAmount2; (-Base + Base2) + (-Amount + Amount2))
                {
                }
                column(AdditionalCurrencyBaseBase2AdditionalCurrencyAmountAmount2; (-"Additional-Currency Base" + Base2) + (-"Additional-Currency Amount" + Amount2))
                {
                }
                column(AdditionalCurrencyBaseBase2; -"Additional-Currency Base" + Base2)
                {
                }
                column(AdditionalCurrencyAmountAmount2; -"Additional-Currency Amount" + Amount2)
                {
                }
                column(VATEntryNoSeries; "No. Series")
                {
                }
                column(VATEntryEntryNo; "Entry No.")
                {
                }
                column(LineNo; LineNo)
                {
                }
                column(VATEntryPostingDate; "Posting Date")
                {
                }
                dataitem(VATEntry6; "VAT Entry")
                {
                    DataItemTableView = SORTING (Type, "Posting Date", "Document Type", "Document No.", "Bill-to/Pay-to No.")
                                        WHERE (Type = CONST (Purchase));
                    column(VATEntry6EntryNo; VATEntry6."Entry No.")
                    {
                    }
                    dataitem(VATEntry7; "VAT Entry")
                    {
                        DataItemLink = Type = FIELD (Type),
                                       "Posting Date" = FIELD ("Posting Date"),
                                       "Document Type" = FIELD ("Document Type"),
                                       "Document No." = FIELD ("Document No.");
                        DataItemTableView = SORTING (Type, "Posting Date", "Document Type", "Document No.", "Bill-to/Pay-to No.");

                        trigger OnAfterGetRecord()
                        begin
                            // VATBuffer3."VAT %" := "VAT %";
                            // VATBuffer3."ND %" := "ND %";

                            // IF "VAT Calculation Type" = "VAT Calculation Type"::"Reverse Charge VAT" THEN BEGIN
                            //   IF NOT PrintAmountsInAddCurrency THEN
                            //     IF VATBuffer3.FIND THEN BEGIN
                            //       VATBuffer3.Base := VATBuffer3.Base + Base;
                            //       VATBuffer3.Amount := VATBuffer3.Amount + Amount;
                            //       VATBuffer3.MODIFY;
                            //     END ELSE BEGIN
                            //       VATBuffer3.Base := Base;
                            //       VATBuffer3.Amount := Amount;
                            //       VATBuffer3.INSERT;
                            //     END
                            //   ELSE
                            //     IF VATBuffer3.FIND THEN BEGIN
                            //       VATBuffer3.Base := VATBuffer3.Base + "Additional-Currency Base";
                            //       VATBuffer3.Amount := VATBuffer3.Amount + "Additional-Currency Amount";
                            //       VATBuffer3.MODIFY;
                            //     END ELSE BEGIN
                            //       VATBuffer3.Base := "Additional-Currency Base";
                            //       VATBuffer3.Amount := "Additional-Currency Amount";
                            //       VATBuffer3.INSERT;
                            //     END
                            // END;
                            // IF "VAT Calculation Type" = "VAT Calculation Type"::"Reverse Charge VAT" THEN BEGIN
                            //   NotBaseReverse := NotBaseReverse + VATBuffer3.Base;
                            //   NotAmountReverse := NotAmountReverse + VATBuffer3.Amount;
                            // END;
                        end;

                        trigger OnPostDataItem()
                        begin
                            VATEntry6 := VATEntry7;
                        end;

                        trigger OnPreDataItem()
                        begin
                            // CLEAR(PurchCrMemoHeader);
                            // CLEAR(PurchInvHeader);
                            // CLEAR(Vendor);
                            // PurchInvHeader.RESET;
                            // PurchCrMemoHeader.RESET;
                            // Vendor.RESET;
                            // VendLedgEntry.SETCURRENTKEY("Document Type","Document No.","Vendor No.");
                            // CASE VATEntry6."Document Type" OF
                            //   VATEntry6."Document Type"::"Credit Memo":
                            //     IF PurchCrMemoHeader.GET(VATEntry6."Document No.") THEN BEGIN
                            //       Vendor.Name := PurchCrMemoHeader."Pay-to Name";
                            //       Vendor."VAT Registration No." := PurchCrMemoHeader."VAT Registration No.";
                            //       VendLedgEntry.SETRANGE("Document Type","Document Type"::"Credit Memo");
                            //       VendLedgEntry.SETRANGE(VendLedgEntry."Document No.",VATEntry6."Document No.");
                            //       EXIT;

                            //     END;
                            //   VATEntry6."Document Type"::Invoice:
                            //     IF PurchInvHeader.GET(VATEntry6."Document No.") THEN BEGIN
                            //       Vendor.Name := PurchInvHeader."Pay-to Name";
                            //       Vendor."VAT Registration No." := PurchInvHeader."VAT Registration No.";
                            //       VendLedgEntry.SETRANGE("Document Type","Document Type"::Invoice);
                            //       VendLedgEntry.SETRANGE(VendLedgEntry."Document No.",VATEntry6."Document No.");
                            //       EXIT;
                            //     END;
                            // END;

                            // IF NOT Vendor.GET(VATEntry6."Bill-to/Pay-to No.") THEN
                            //   Vendor.Name := Text1110036;
                            // VendLedgEntry.SETCURRENTKEY("Document Type","Document No.","Vendor No.");
                            // VendLedgEntry.SETFILTER("Document Type",Text1110037);
                            // VendLedgEntry.SETRANGE(VendLedgEntry."Document No.",VATEntry6."Document No.");
                            // IF VendLedgEntry.FIND('-') THEN;
                        end;
                    }
                    dataitem("<Integer4>"; Integer)
                    {
                        DataItemTableView = SORTING (Number);
                        column(VATBuffer4BaseVATBuffer4Amount; VATBuffer4.Base + VATBuffer4.Amount)
                        {
                        }
                        column(VATBuffer4Amount; VATBuffer4.Amount)
                        {
                        }
                        column(VATBuffer4ND; VATBuffer4."ND %")
                        {
                        }
                        column(VATBuffer4VAT; VATBuffer4."VAT %")
                        {
                        }
                        column(VATBuffer4Base; VATBuffer4.Base)
                        {
                        }
                        column(VATEntry6DocumentNo; VATEntry6."Document No.")
                        {
                        }
                        column(VATEntry6PostingDate; FORMAT(VATEntry6."Posting Date", 0, 1))
                        {
                        }
                        column(AutoDocNo; AutoDocNo)
                        {
                        }
                        column(VATEntry6DocumentType; VATEntry6."Document Type")
                        {
                        }
                        column(VATBuffer4BaseVATBuffer4AmountControl43; VATBuffer4.Base + VATBuffer4.Amount)
                        {
                        }
                        column(Integer4Number; Number)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            // IF Fin THEN
                            //   CurrReport.BREAK;
                            // VATBuffer4 := VATBuffer3;
                            // Fin := VATBuffer3.NEXT = 0;

                            // //code from OnPreSection
                            // IF VATBuffer4.Amount = 0 THEN BEGIN
                            //   VATBuffer4."VAT %" := 0;
                            //   VATBuffer4."ND %" := 0;
                            // END;

                            // LineNo := LineNo + 1;
                            // Base2 := Base2 + VATBuffer4.Base;
                            // Amount2 := Amount2 + VATBuffer4.Amount;
                        end;

                        trigger OnPreDataItem()
                        begin
                            // VATBuffer3.FIND('-');
                            // CurrReport.CREATETOTALS(VATBuffer4.Base,VATBuffer4.Amount);
                            // Fin := FALSE;
                            // LineNo := 0;
                        end;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        // IF NOT Show THEN
                        //   CurrReport.BREAK;
                        // VATBuffer3.DELETEALL;
                        // NoSeriesAuxPrev := NoSeriesAux;

                        // IF (VATEntry6."Document Type" = VATEntry6."Document Type"::"Credit Memo") THEN BEGIN
                        //     GLSetup.GET;
                        // END;
                        // IF (VATEntry6."Document Type" = VATEntry6."Document Type"::Invoice) THEN BEGIN
                        //     GLSetup.GET;
                        // END;
                        // IF NoSeriesAux <> NoSeriesAuxPrev THEN BEGIN
                        //   NotBaseReverse := 0;
                        //   NotAmountReverse := 0;
                        // END;
                    end;

                    trigger OnPostDataItem()
                    begin
                        // PrevData := VATEntry."Posting Date" + 1;
                    end;

                    trigger OnPreDataItem()
                    begin
                        // IF NOT SortPostDate OR NOT ShowAutoInvCred THEN
                        //   CurrReport.BREAK;
                        // IF FIND('-') THEN;
                        // IF i = 1 THEN BEGIN
                        //   REPEAT
                        //     VatEntryTemporary.INIT;
                        //     VatEntryTemporary.COPY(VATEntry6);
                        //     VatEntryTemporary.INSERT;
                        //     VatEntryTemporary.NEXT;
                        //   UNTIL VATEntry6.NEXT = 0;
                        //   IF FIND('-') THEN;
                        //   i := 0;
                        // END;
                        // VATEntry6.SETFILTER("Posting Date",'%1..%2',PrevData,VATEntry."Posting Date");
                        // VATEntry6.SETFILTER("Document No.",VATEntry.GETFILTER("Document No."));
                        // VATEntry6.SETFILTER("Document Type",VATEntry.GETFILTER("Document Type"));
                        // IF VatEntryTemporary.FIND('-') THEN;
                        // VatEntryTemporary.SETFILTER("Posting Date",'%1..%2',PrevData,VATEntry."Posting Date");
                        // IF VatEntryTemporary.FIND('-') THEN BEGIN
                        //   Show := TRUE;
                        //   VatEntryTemporary.DELETEALL;
                        // END ELSE
                        //   Show := FALSE;
                    end;
                }
                dataitem(VATEntry2; "VAT Entry")
                {
                    DataItemLink = Type = FIELD (Type),
                                   "Posting Date" = FIELD ("Posting Date"),
                                   "Document Type" = FIELD ("Document Type"),
                                   "Document No." = FIELD ("Document No.");
                    DataItemTableView = SORTING ("No. Series", "Posting Date");

                    trigger OnAfterGetRecord()
                    begin
                        //XXX
                        // VATBuffer."VAT %" := "VAT %";
                        // VATBuffer."ND %" := "ND %";

                        IF NOT PrintAmountsInAddCurrency THEN BEGIN
                            //XXX
                            // IF VATEntry2."VAT Calculation Type" = VATEntry2."VAT Calculation Type"::"Full VAT" THEN
                            //     Base := FullVATBaseCalc("VAT %", "ND %", Amount, FALSE);
                            IF VATBuffer.FIND THEN BEGIN
                                VATBuffer.Base := VATBuffer.Base - Base;
                                VATBuffer.Amount := VATBuffer.Amount - Amount;
                                VATBuffer.MODIFY;
                            END ELSE BEGIN
                                VATBuffer.Base := -Base;
                                VATBuffer.Amount := -Amount;
                                VATBuffer.INSERT;
                            END;
                        END ELSE BEGIN
                            //XXX
                            // IF VATEntry2."VAT Calculation Type" = VATEntry2."VAT Calculation Type"::"Full VAT" THEN
                            //     "Additional-Currency Base" := FullVATBaseCalc("VAT %", "ND %", "Additional-Currency Amount", TRUE);
                            IF VATBuffer.FIND THEN BEGIN
                                VATBuffer.Base := VATBuffer.Base - "Additional-Currency Base";
                                VATBuffer.Amount := VATBuffer.Amount - "Additional-Currency Amount";
                                VATBuffer.MODIFY;
                            END ELSE BEGIN
                                VATBuffer.Base := -"Additional-Currency Base";
                                VATBuffer.Amount := -"Additional-Currency Amount";
                                VATBuffer.INSERT;
                            END;
                        END;
                    end;

                    trigger OnPostDataItem()
                    begin
                        IF SortPostDate OR (NOT VATEntry.Reversed) THEN
                            VATEntry := VATEntry2;
                    end;

                    trigger OnPreDataItem()
                    begin
                        CLEAR(SalesCrMemoHeader);
                        CLEAR(SalesInvHeader);
                        CLEAR(Customer);

                        IF NOT PrintAmountsInAddCurrency THEN
                            GLSetup.GET
                        ELSE BEGIN
                            GLSetup.GET;
                            GLSetup.TESTFIELD("Additional Reporting Currency");
                            Currency.GET(GLSetup."Additional Reporting Currency");
                        END;

                        CASE VATEntry."Document Type" OF
                            VATEntry."Document Type"::"Credit Memo":
                                IF SalesCrMemoHeader.GET(VATEntry."Document No.") THEN BEGIN
                                    Customer.Name := SalesCrMemoHeader."Bill-to Name";
                                    IF Customer.GET(VATEntry."Bill-to/Pay-to No.") THEN
                                        Customer."VAT Registration No." := Customer."VAT Registration No.";
                                    EXIT;
                                END;
                            VATEntry."Document Type"::Invoice:
                                IF SalesInvHeader.GET(VATEntry."Document No.") THEN BEGIN
                                    Customer.Name := SalesInvHeader."Bill-to Name";
                                    IF Customer.GET(VATEntry."Bill-to/Pay-to No.") THEN
                                        Customer."VAT Registration No." := Customer."VAT Registration No.";
                                    EXIT;
                                END;
                        END;

                        IF NOT Customer.GET(VATEntry."Bill-to/Pay-to No.") THEN
                            Customer.Name := Text1110036;
                    end;
                }
                dataitem(DataItem5444; Integer)
                {
                    DataItemTableView = SORTING (Number);
                    column(VATEntry2DocumentNo; VATEntry2."Document No.")
                    {
                    }
                    column(VATBuffer2Base; VATBuffer2.Base)
                    {
                    }
                    column(VATBuffer2Amount; VATBuffer2.Amount)
                    {
                    }
                    column(VATBuffer2VAT; VATBuffer2."VAT %")
                    {
                    }
                    column(VATBuffer2ND; VATBuffer2."ND %")
                    {
                    }
                    column(VATEntry2PostingDate; FORMAT(VATEntry2."Posting Date", 0, 1))
                    {
                    }
                    column(CustomerName; Customer.Name)
                    {
                    }
                    column(CustomerVATRegistrationNo; Customer."VAT Registration No.")
                    {
                    }
                    column(VATEntry2DocumentType; VATEntry2."Document Type")
                    {
                    }
                    column(VATBuffer2BaseVATBuffer2Amount; VATBuffer2.Base + VATBuffer2.Amount)
                    {
                    }
                    column(IntegerNumber; Number)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        IF Fin THEN
                            CurrReport.BREAK;
                        VATBuffer2 := VATBuffer;
                        Fin := VATBuffer.NEXT = 0;

                        //code from OnPreSection
                        IF VATBuffer2.Amount = 0 THEN BEGIN
                            VATBuffer2."VAT %" := 0;
                            VATBuffer2."ND %" := 0;
                        END;

                        LineNo := LineNo + 1;
                    end;

                    trigger OnPostDataItem()
                    begin
                        LineNo := 0;
                    end;

                    trigger OnPreDataItem()
                    begin
                        VATBuffer.FIND('-');
                        //CurrReport.CREATETOTALS(VATBuffer2.Base, VATBuffer2.Amount);
                        Fin := FALSE;
                        LineNo := 0;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    VATBuffer.DELETEALL;
                    IF VATEntry.Reversed THEN BEGIN
                        IF VATEntry."Reversed by Entry No." = 0 THEN
                            CurrReport.SKIP;
                        Base := 0;
                        Amount := 0;
                        "Additional-Currency Base" := 0;
                        "Additional-Currency Amount" := 0;
                    END;
                end;

                trigger OnPreDataItem()
                begin
                    IF GETFILTER("Posting Date") = '' THEN
                        PrevData := 0D
                    ELSE
                        PrevData := GETRANGEMIN("Posting Date");
                    i := 1;
                    IF SortPostDate THEN
                        VATEntry.SETCURRENTKEY(Type, "Posting Date", "Document Type", "Document No.", "Bill-to/Pay-to No.")
                    ELSE
                        VATEntry.SETCURRENTKEY("No. Series", "Posting Date");
                end;
            }
            dataitem(VATEntry4; "VAT Entry")
            {
                DataItemTableView = SORTING ("No. Series", "Posting Date")
                                    WHERE (Type = CONST (Purchase));
                column(NotBaseReverse; NotBaseReverse)
                {
                }
                column(NotAmountReverse; NotAmountReverse)
                {
                }
                column(NotBaseReverseNotAmountReverse; NotBaseReverse + NotAmountReverse)
                {
                }
                column(NoSeriesAux; NoSeriesAux)
                {
                }
                column(VATEntry4EntryNo; "Entry No.")
                {
                }
                column(VATEntry4NoSeries; "No. Series")
                {
                }
                dataitem(VATEntry5; "VAT Entry")
                {
                    DataItemLink = Type = FIELD (Type),
                                   "Posting Date" = FIELD ("Posting Date"),
                                   "Document Type" = FIELD ("Document Type"),
                                   "Document No." = FIELD ("Document No.");
                    DataItemTableView = SORTING ("No. Series", "Posting Date");

                    trigger OnAfterGetRecord()
                    begin
                        // Habilitar quando disponível
                        // VATBuffer."VAT %" := "VAT %";
                        // VATBuffer."ND %" := "ND %";

                        IF "VAT Calculation Type" = "VAT Calculation Type"::"Reverse Charge VAT" THEN BEGIN
                            IF NOT PrintAmountsInAddCurrency THEN
                                IF VATBuffer.FIND THEN BEGIN
                                    VATBuffer.Base := VATBuffer.Base + Base;
                                    VATBuffer.Amount := VATBuffer.Amount + Amount;
                                    VATBuffer.MODIFY;
                                END ELSE BEGIN
                                    VATBuffer.Base := Base;
                                    VATBuffer.Amount := Amount;
                                    VATBuffer.INSERT;
                                END ELSE
                                IF VATBuffer.FIND THEN BEGIN
                                    VATBuffer.Base := VATBuffer.Base + "Additional-Currency Base";
                                    VATBuffer.Amount := VATBuffer.Amount + "Additional-Currency Amount";
                                    VATBuffer.MODIFY;
                                END ELSE BEGIN
                                    VATBuffer.Base := "Additional-Currency Base";
                                    VATBuffer.Amount := "Additional-Currency Amount";
                                    VATBuffer.INSERT;
                                END;
                        END;
                    end;

                    trigger OnPostDataItem()
                    begin
                        VATEntry4 := VATEntry5;
                    end;

                    trigger OnPreDataItem()
                    begin
                        CLEAR(PurchCrMemoHeader);
                        CLEAR(PurchInvHeader);
                        CLEAR(Vendor);
                        PurchInvHeader.RESET;
                        PurchCrMemoHeader.RESET;
                        Vendor.RESET;


                        VendLedgEntry.SETCURRENTKEY("Document Type", "Document No.", "Vendor No.");
                        CASE VATEntry4."Document Type" OF
                            VATEntry4."Document Type"::"Credit Memo":

                                IF PurchCrMemoHeader.GET(VATEntry4."Document No.") THEN BEGIN
                                    Vendor.Name := PurchCrMemoHeader."Pay-to Name";
                                    Vendor."VAT Registration No." := PurchCrMemoHeader."VAT Registration No.";
                                    VendLedgEntry.SETRANGE("Document Type", "Document Type"::"Credit Memo");
                                    VendLedgEntry.SETRANGE(VendLedgEntry."Document No.", VATEntry4."Document No.");
                                    EXIT;

                                END;
                            VATEntry4."Document Type"::Invoice:

                                IF PurchInvHeader.GET(VATEntry4."Document No.") THEN BEGIN
                                    Vendor.Name := PurchInvHeader."Pay-to Name";
                                    Vendor."VAT Registration No." := PurchInvHeader."VAT Registration No.";
                                    VendLedgEntry.SETRANGE("Document Type", "Document Type"::Invoice);
                                    VendLedgEntry.SETRANGE(VendLedgEntry."Document No.", VATEntry4."Document No.");
                                    EXIT;
                                END;
                        END;

                        IF NOT Vendor.GET(VATEntry4."Bill-to/Pay-to No.") THEN
                            Vendor.Name := Text1110036;
                        VendLedgEntry.SETCURRENTKEY("Document Type", "Document No.", "Vendor No.");
                        VendLedgEntry.SETFILTER("Document Type", Text1110037);
                        VendLedgEntry.SETRANGE(VendLedgEntry."Document No.", VATEntry4."Document No.");
                        IF VendLedgEntry.FIND('-') THEN;
                    end;
                }
                dataitem("<Integer2>"; Integer)
                {
                    DataItemTableView = SORTING (Number);
                    column(VATBuffer2BaseVATBuffer2AmountControl82; VATBuffer2.Base + VATBuffer2.Amount)
                    {
                    }
                    column(VATBuffer2AmountControl83; VATBuffer2.Amount)
                    {
                    }
                    column(VATBuffer2NDControl84; VATBuffer2."ND %")
                    {
                    }
                    column(VATBuffer2VATControl85; VATBuffer2."VAT %")
                    {
                    }
                    column(VATBuffer2BaseControl86; VATBuffer2.Base)
                    {
                    }
                    column(CompanyInfoVATRegistrationNoControl87; CompanyInfo."VAT Registration No.")
                    {
                    }
                    column(CompanyInfoNameControl88; CompanyInfo.Name)
                    {
                    }
                    column(VATEntry4PostingDate; FORMAT(VATEntry4."Posting Date", 0, 1))
                    {
                    }
                    column(AutoDocNoControl91; AutoDocNo)
                    {
                    }
                    column(VATEntry4DocumentType; VATEntry4."Document Type")
                    {
                    }
                    column(VATEntry4DocumentNo; VATEntry4."Document No.")
                    {
                    }
                    column(Integer2Number; Number)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        IF Fin THEN
                            CurrReport.BREAK;
                        VATBuffer2 := VATBuffer;
                        Fin := VATBuffer.NEXT = 0;
                        NotBaseReverse := NotBaseReverse + VATBuffer.Base;
                        NotAmountReverse := NotAmountReverse + VATBuffer.Amount;

                        //code from OnPreSection
                        IF VATBuffer2.Amount = 0 THEN BEGIN
                            VATBuffer2."VAT %" := 0;
                            VATBuffer2."ND %" := 0;
                        END;

                        LineNo := LineNo + 1;
                    end;

                    trigger OnPostDataItem()
                    begin
                        LineNo := 0;
                    end;

                    trigger OnPreDataItem()
                    begin
                        IF VATBuffer.FIND('-') THEN;
                        //CurrReport.CREATETOTALS(VATBuffer2.Base, VATBuffer2.Amount);
                        Fin := FALSE;
                        LineNo := 0;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    VATBuffer.DELETEALL;
                    NoSeriesAuxPrev := NoSeriesAux;

                    IF (VATEntry4."Document Type" = VATEntry4."Document Type"::"Credit Memo") THEN BEGIN
                        GLSetup.GET;
                    END;
                    IF (VATEntry4."Document Type" = VATEntry4."Document Type"::Invoice) THEN BEGIN
                        GLSetup.GET;
                    END;
                    IF NoSeriesAux <> NoSeriesAuxPrev THEN BEGIN
                        NotBaseReverse := 0;
                        NotAmountReverse := 0;
                    END;
                end;

                trigger OnPreDataItem()
                begin
                    IF SortPostDate OR NOT ShowAutoInvCred THEN
                        CurrReport.BREAK;
                    IF FIND('-') THEN;
                    VATEntry4.SETFILTER("Posting Date", VATEntry.GETFILTER("Posting Date"));
                    VATEntry4.SETFILTER("Document No.", VATEntry.GETFILTER("Document No."));
                    VATEntry4.SETFILTER("Document Type", VATEntry.GETFILTER("Document Type"));
                end;
            }

            trigger OnPreDataItem()
            begin
                CompanyInfo.GET;
                CompanyAddr[1] := CompanyInfo.Name;
                CompanyAddr[2] := CompanyInfo."Name 2";
                CompanyAddr[3] := CompanyInfo.Address;
                CompanyAddr[4] := CompanyInfo."Address 2";
                CompanyAddr[5] := CompanyInfo.City;
                CompanyAddr[6] := CompanyInfo."Post Code" + ' ' + CompanyInfo.County;
                IF CompanyInfo."VAT Registration No." <> '' THEN
                    CompanyAddr[7] := Text1110033 + CompanyInfo."VAT Registration No."
                ELSE
                    ERROR(Text1110034);
                COMPRESSARRAY(CompanyAddr);

                GLSetup.GET;
                IF PrintAmountsInAddCurrency THEN
                    HeaderText := STRSUBSTNO(Text1110035, GLSetup."Additional Reporting Currency")
                ELSE BEGIN
                    GLSetup.TESTFIELD("LCY Code");
                    HeaderText := STRSUBSTNO(Text1110035, GLSetup."LCY Code");
                END;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PrintAmountsInAddCurrency; PrintAmountsInAddCurrency)
                    {
                        Caption = 'Show Amounts in Add. Currency';
                    }
                    field(SortPostDate; SortPostDate)
                    {
                        Caption = 'Order by posting date';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            ShowAutoInvCred := TRUE;
        end;
    }

    labels
    {
        PAGENO = 'Page';
        SalesInvoiceBook = 'Sales Invoice Book';
        DocumentNo = 'Document No.';
        PostingDate = 'Posting Date';
        ExternalDocumentNo = 'External Doc. No.';
        Name = 'Name';
        VATRegistration = 'VAT Registration';
        Base1 = 'Base';
        VAT = 'VAT%';
        ND = 'ND%';
        Amt = 'Amount';
        Total = 'Total';
        Continued = 'Continued';
        Nos_Series = 'Nos Series';
        No_Serie = 'No.Serie';
    }

    trigger OnPreReport()
    begin
        AuxVatEntry := VATEntry.GETFILTERS;

        ShowAutoInvCred := FALSE;
    end;

    var
        Text1110033: Label 'VAT Registration No.: ';
        Text1110034: Label 'Please, specify the VAT Registration Nº of your Company in the Company information Window';
        Text1110035: Label 'All Amounts are in %1';
        Text1110036: Label 'UNKNOWN';
        Text1110037: Label 'Invoice|Credit Memo';
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        Customer: Record Customer;
        CompanyInfo: Record "Company Information";
        VATBuffer: Record "PTSS Sal/Pur. Book VAT Buf." temporary;
        VATBuffer2: Record "PTSS Sal/Pur. Book VAT Buf.";
        VATBuffer3: Record "PTSS Sal/Pur. Book VAT Buf." temporary;
        VATBuffer4: Record "PTSS Sal/Pur. Book VAT Buf." temporary;
        GLSetup: Record "General Ledger Setup";
        Currency: Record Currency;
        HeaderText: Text[250];
        CompanyAddr: array[7] of Text[50];
        LineNo: Decimal;
        Fin: Boolean;
        PrintAmountsInAddCurrency: Boolean;
        NoSeriesAux: Code[10];
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        PurchInvHeader: Record "Purch. Inv. Header";
        Vendor: Record Vendor;
        VendLedgEntry: Record "Vendor Ledger Entry";
        AutoDocNo: Code[10];
        NotBaseReverse: Decimal;
        NotAmountReverse: Decimal;
        NoSeriesAuxPrev: Code[10];
        AuxVatEntry: Text[250];
        PrevData: Date;
        VatEntryTemporary: Record "VAT Entry" temporary;
        SortPostDate: Boolean;
        Show: Boolean;
        i: Integer;
        ShowAutoInvCred: Boolean;
        Base2: Decimal;
        Amount2: Decimal;

    procedure FullVATBaseCalc(VAT: Decimal; EC: Decimal; VATAmt: Decimal; UseAddCurrency: Boolean) VATBase: Decimal
    begin
        IF ((VAT + EC) = 0) THEN
            EXIT;
        IF UseAddCurrency THEN
            EXIT(ROUND(100 * VATAmt / (VAT + EC), Currency."Amount Rounding Precision"))
        ELSE
            EXIT(ROUND(100 * VATAmt / (VAT + EC), GLSetup."Amount Rounding Precision"));
    end;
}

