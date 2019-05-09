report 31022995 "PTSS BP Process"
{
    //COPE 

    Caption = 'BP Process';
    ProcessingOnly = true;

    dataset
    {
        dataitem(DataItem1000000000; "Bank Account Ledger Entry")
        {
            DataItemTableView = SORTING ("Entry No.")
                                WHERE ("Document Type" = FILTER (Payment | Refund),
                                      "PTSS BP Statistic Code" = FILTER (<> ''));

            trigger OnAfterGetRecord()
            var
                CustLedgEntry: Record "Cust. Ledger Entry";
                VendLedgEntry: Record "Vendor Ledger Entry";
            begin
                IF ExcludeReversed(BankAccLedgEntry) THEN
                    EXIT;

                LedgerEntryNo := "Entry No.";
                //if - Ex: 0741,0781 - ver seccao 7.4 manual Banco Portugal novo campo
                if_code := GeneralLedgerSetup."PTSS BP IF Code";

                //npc - NPC/NIF empresa
                npc := CompanyInfo."VAT Registration No.";

                //id_reg - Nº Mov ou Nº documento - a voltar a analisar
                id_reg := FORMAT(IntegrationBankPortugal."Entry No.");

                //data_ref
                date_ref := "Posting Date";

                //natureza_registo
                GeneralLedgerSetup.TESTFIELD("PTSS BP Rec Nature Creat. Code");
                natur_reg := GeneralLedgerSetup."PTSS BP Rec Nature Creat. Code";

                //npc2 ex: NPC/NIF de clientes ou entidades a quem se venderam títulos
                npc2 := 0;

                //montante
                amt := Amount;

                //divisa
                //V92.00#00012,sn
                CLEAR(currencycode);
                //IF "Bal. Account Type" = "Bal. Account Type"::Customer THEN BEGIN
                CustLedgEntry.SETRANGE("Document Type", "Document Type");
                CustLedgEntry.SETRANGE("Document No.", "Document No.");
                CustLedgEntry.SETRANGE("Currency Code", '');
                IF NOT CustLedgEntry.ISEMPTY THEN
                    CurrReport.SKIP;
                CustLedgEntry.SETFILTER("Currency Code", '<>%1', '');
                IF CustLedgEntry.FINDSET THEN BEGIN
                    CustLedgEntry.CALCFIELDS(Amount);
                    currencycode := CustLedgEntry."Currency Code";
                    amt := -CustLedgEntry.Amount;
                    Description := CustLedgEntry.Description;
                END;
                //END ELSE

                //IF "Bal. Account Type" = BankAccLedgEntry."Bal. Account Type"::Vendor THEN BEGIN
                VendLedgEntry.SETRANGE("Document Type", "Document Type");
                VendLedgEntry.SETRANGE("Document No.", "Document No.");
                VendLedgEntry.SETRANGE("Currency Code", '');
                IF NOT VendLedgEntry.ISEMPTY THEN
                    CurrReport.SKIP;
                VendLedgEntry.SETFILTER("Currency Code", '<>%1', '');
                IF VendLedgEntry.FINDSET THEN BEGIN
                    VendLedgEntry.CALCFIELDS(Amount);
                    currencycode := VendLedgEntry."Currency Code";
                    amt := -VendLedgEntry.Amount;
                    Description := CustLedgEntry.Description;
                    //END;
                END ELSE
                    //V92.00#00012,en
                    currencycode := "Currency Code";

                //cod_estat  Ex: A | B | C - ver manual seccao 7 nova tabela
                cod_stat := '';
                cod_stat := "PTSS BP Statistic Code";

                //tipo_valor ex: E - Entrada | S - Saída | P - Posição
                amt_type := '';
                IF amt > 0 THEN
                    amt_type := GeneralLedgerSetup."PTSS BP Amount Type Inc. Code"
                ELSE BEGIN
                    amt_type := GeneralLedgerSetup."PTSS BP Amount Type Out. Code";
                    amt := -amt;
                END;

                IF BankAccount.GET(BankAccLedgEntry."Bank Account No.") THEN //SS.10.00.02.01,n
                                                                             //tipo_conta ex: I - conta interna | E - contabancária externa ,...,X - sem movimentação de conta pag 11 manual nova tabela
                    acc_type := BankAccount."PTSS BP Account Type Code";

                //id_banco - só preenchido quando o banco é interno
                id_bank := '';
                IF BankAccount."Country/Region Code" = CompanyInfo."Country/Region Code" THEN
                    id_bank := BankAccount."PTSS CCC Bank No.";

                //pais_conta - so preenchido quando inst financeira(ex: banco) é externa
                acc_country := '';
                IF BankAccount."Country/Region Code" <> CompanyInfo."Country/Region Code" THEN
                    IF Country.GET(BankAccount."Country/Region Code") THEN
                        acc_country := Country."PTSS BP Territory Code";

                //pais_contraparte -
                counterpart_country := '';
                counterpart_country := "PTSS BP Countrp. Country Code";

                //pais_ativo - Preencher quando se vende/compra a uma entidade externa por entermediário de outra.
                active_country := '';
                active_country := "PTSS BP Active Country Code";

                //contraparte  - preenchido sempre excepto quando as empresas são do grupo. Ter em conta a quem se faturou
                counterpart := '';

                //observacoes
                obs := '';

                DocumentNo := "Document No.";

                Descript := Description;

                InsertBankPortugal(2);
            end;

            trigger OnPreDataItem()
            begin
                SETRANGE("Posting Date", FromDate, ToDate);
            end;
        }
        dataitem(CustPosition; Customer)
        {

            trigger OnAfterGetRecord()
            begin
                SETFILTER("PTSS BP Statistic Filter", '<>%1', '');
                CALCFIELDS("PTSS BP Balance at Date (LCY)");

                IF ("Country/Region Code" = CompanyInfo."Country/Region Code") OR ("PTSS BP Balance at Date (LCY)" = 0) THEN
                    CurrReport.SKIP;

                //if - Ex: 0741,0781 - ver seccao 7.4 manual Banco Portugal novo campo
                if_code := GeneralLedgerSetup."PTSS BP IF Code";

                //npc - NPC/NIF empresa
                npc := CompanyInfo."VAT Registration No.";

                //id_reg - Nº Mov ou Nº documento - a voltar a analisar
                id_reg := FORMAT(IntegrationBankPortugal."Entry No.");

                //data_ref
                date_ref := ToDate;

                //natureza_registo
                GeneralLedgerSetup.TESTFIELD("PTSS BP Rec Nature Creat. Code");
                natur_reg := GeneralLedgerSetup."PTSS BP Rec Nature Creat. Code";

                //npc2 ex: NPC/NIF de clientes ou entidades a quem se venderam títulos
                npc2 := 0;

                //tipo_valor ex: E - Entrada | S - Saída | P - Posição
                amt_type := GeneralLedgerSetup."PTSS BP Amount Type Pos. Code";

                //tipo_conta ex: I - conta interna | E - contabancária externa ,...,X - sem movimentação de conta pag 11 manual nova tabela
                acc_type := GeneralLedgerSetup."PTSS BP Account Type Def. Code";

                //id_banco
                id_bank := '';

                //pais_conta - so preenchido quando inst financeira(ex: banco) é externa
                acc_country := '';

                //pais_contraparte -
                counterpart_country := '';
                IF Country.GET("Country/Region Code") THEN
                    counterpart_country := Country."PTSS BP Territory Code";

                //pais_ativo - Preencher quando se vende/compra a uma entidade externa por entermediário de outra.
                active_country := '';

                //contraparte
                counterpart := '';

                //observacoes
                obs := '';

                DocumentNo := '';
                //DocumentNo := "Document No.";
                Descript := Name;

                CalculateCustLines;
            end;

            trigger OnPreDataItem()
            begin
                SETRANGE("Date Filter", ToDate);

                DtldCustLedgEntry.SETCURRENTKEY("Customer No.", "Posting Date", "Currency Code", "PTSS Excluded from calculation", "PTSS Initial BP Statistic Code");
                DtldCustLedgEntry.SETRANGE("PTSS Excluded from calculation", FALSE);
            end;
        }
        dataitem(VendPosition; Vendor)
        {

            trigger OnAfterGetRecord()
            begin
                SETFILTER("PTSS BP Statistic Filter", '<>%1', '');
                CALCFIELDS("PTSS BP Balance at Date (LCY)");

                IF ("Country/Region Code" = CompanyInfo."Country/Region Code") OR ("PTSS BP Balance at Date (LCY)" = 0) THEN
                    CurrReport.SKIP;

                //if - Ex: 0741,0781 - ver seccao 7.4 manual Banco Portugal novo campo
                if_code := GeneralLedgerSetup."PTSS BP IF Code";

                //npc - NPC/NIF empresa
                npc := CompanyInfo."VAT Registration No.";

                //id_reg - Nº Mov ou Nº documento - a voltar a analisar
                id_reg := FORMAT(IntegrationBankPortugal."Entry No.");

                //data_ref
                date_ref := ToDate;

                //natureza_registo
                GeneralLedgerSetup.TESTFIELD("PTSS BP Rec Nature Creat. Code");
                natur_reg := GeneralLedgerSetup."PTSS BP Rec Nature Creat. Code";

                //npc2 ex: NPC/NIF de clientes ou entidades a quem se venderam títulos
                npc2 := 0;

                //tipo_valor ex: E - Entrada | S - Saída | P - Posição
                amt_type := GeneralLedgerSetup."PTSS BP Amount Type Pos. Code";

                //tipo_conta ex: I - conta interna | E - contabancária externa ,...,X - sem movimentação de conta pag 11 manual nova tabela
                acc_type := GeneralLedgerSetup."PTSS BP Account Type Def. Code";

                //id_banco
                id_bank := '';

                //pais_conta - so preenchido quando inst financeira(ex: banco) é externa
                acc_country := '';

                //pais_contraparte -
                counterpart_country := '';
                IF Country.GET("Country/Region Code") THEN
                    counterpart_country := Country."PTSS BP Territory Code";

                //pais_ativo - Preencher quando se vende/compra a uma entidade externa por entermediário de outra.
                active_country := '';

                //contraparte
                counterpart := '';

                //observacoes
                obs := '';

                //DocumentNo := "Document No.";
                DocumentNo := '';
                Descript := Name;

                CalculateVendLines;
            end;

            trigger OnPreDataItem()
            begin
                SETRANGE("Date Filter", ToDate);

                DtldVendLedgEntry.SETCURRENTKEY("Vendor No.", "Posting Date", "Currency Code", "PTSS Excluded from calculation", "PTSS Initial BP Statistic Code");
                DtldVendLedgEntry.SETRANGE("PTSS Excluded from calculation", FALSE);
            end;
        }
        dataitem(DataItem1000000003; "Bank Account")
        {

            trigger OnAfterGetRecord()
            begin
                SETRANGE("Date Filter", 0D, ToDate);
                SETFILTER("PTSS BP Statistic Filter", '<>%1', '');
                CALCFIELDS("PTSS BP Balance at Date (LCY)");

                IF ("Country/Region Code" = CompanyInfo."Country/Region Code") OR ("PTSS BP Balance at Date (LCY)" = 0) THEN
                    CurrReport.SKIP;

                //if - Ex: 0741,0781 - ver seccao 7.4 manual Banco Portugal novo campo
                if_code := GeneralLedgerSetup."PTSS BP IF Code";

                //npc - NPC/NIF empresa
                npc := CompanyInfo."VAT Registration No.";

                //id_reg - Nº Mov ou Nº documento - a voltar a analisar
                id_reg := FORMAT(IntegrationBankPortugal."Entry No.");

                //data_ref
                date_ref := ToDate;

                //natureza_registo
                GeneralLedgerSetup.TESTFIELD("PTSS BP Rec Nature Creat. Code");
                natur_reg := GeneralLedgerSetup."PTSS BP Rec Nature Creat. Code";

                //npc2 ex: NPC/NIF de clientes ou entidades a quem se venderam títulos
                npc2 := 0;

                //tipo_valor ex: E - Entrada | S - Saída | P - Posição
                amt_type := GeneralLedgerSetup."PTSS BP Amount Type Pos. Code";

                //tipo_conta ex: I - conta interna | E - contabancária externa ,...,X - sem movimentação de conta pag 11 manual nova tabela
                acc_type := GeneralLedgerSetup."PTSS BP Account Type Def. Code";

                //id_banco
                id_bank := '';

                //pais_conta - so preenchido quando inst financeira(ex: banco) é externa
                acc_country := '';

                //pais_contraparte -
                counterpart_country := '';
                IF Country.GET("Country/Region Code") THEN
                    counterpart_country := Country."PTSS BP Territory Code";

                //pais_ativo - Preencher quando se vende/compra a uma entidade externa por entermediário de outra.
                active_country := '';

                //contraparte
                counterpart := '';

                //observacoes
                obs := '';

                //DocumentNo := "Document No.";
                DocumentNo := '';
                Descript := Name;

                CalculateBankLines;

                BPStatistic.RESET;
                BPStatistic.SETRANGE(Type, BPStatistic.Type::"Cash Pooling");
                IF BPStatistic.FINDSET THEN BEGIN
                    REPEAT
                        CashPoolingAmt := 0;
                        SETRANGE("Date Filter", FromDate, ToDate);
                        SETFILTER("PTSS BP Statistic Filter", BPStatistic.Code);
                        CALCFIELDS("PTSS BP Balance at Date (LCY)");
                        CashPoolingAmt := "PTSS BP Balance at Date (LCY)";
                        IF CashPoolingAmt <> 0 THEN BEGIN
                            cod_stat := BPStatistic.Code;
                            amt := CashPoolingAmt;
                            //tipo_valor ex: E - Entrada | S - Saída | P - Posição
                            IF amt > 0 THEN
                                amt_type := GeneralLedgerSetup."PTSS BP Amount Type Out. Code"
                            ELSE BEGIN
                                amt := -amt;
                                amt_type := GeneralLedgerSetup."PTSS BP Amount Type Inc. Code";
                            END;

                            //tipo_conta ex: I - conta interna | E - contabancária externa ,...,X - sem movimentação de conta pag 11 manual nova tabela
                            acc_type := "PTSS BP Account Type Code";
                            InsertBankPortugal(2);
                        END;
                    UNTIL BPStatistic.NEXT = 0
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
                field("FromDate"; "FromDate")
                {
                    Caption = 'Start Date';
                }
                field("ToDate"; "ToDate")
                {
                    Caption = 'End Date';
                }
            }
        }
        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        GeneralLedgerSetup.GET;
    end;

    var
        IntegrationBankPortugal: Record "PTSS BP Ledger Entry";
        CompanyInfo: Record "Company Information";
        GeneralLedgerSetup: Record "General Ledger Setup";
        BPStatistic: Record "PTSS BP Statistic";
        BankAccount: Record "Bank Account";
        Country: Record "Country/Region";
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        TempTable: Record "PTSS Temporary Table" temporary;
        currencycode: Code[3];
        cod_stat: Code[5];
        amt_type: Code[1];
        acc_type: Code[1];
        id_bank: Code[10];
        acc_country: Code[3];
        counterpart_country: Code[3];
        active_country: Code[3];
        counterpart: Code[50];
        DocumentNo: Code[20];
        date_ref: Date;
        FromDate: Date;
        ToDate: Date;
        duedate: Date;
        amt: Decimal;
        CashPoolingAmt: Decimal;
        LedgerEntryNo: Integer;
        npc2: Integer;
        EntryNo: Integer;
        if_code: Text[4];
        npc: Text[9];
        id_reg: Text[20];
        natur_reg: Text[1];
        obs: Text[50];
        Descript: Text[50];
        BPStatisticCashPoolingFilter: Text[1024];

    procedure InsertBankPortugal(LedgerEntryType: Option Customer,Vendor,"Bank Account")
    begin
        IntegrationBankPortugal.INIT;
        IntegrationBankPortugal.InitEntry;
        IntegrationBankPortugal."Ledger Entry No." := LedgerEntryNo;
        IntegrationBankPortugal."Ledger Entry Type" := LedgerEntryType;

        //ano
        IntegrationBankPortugal.Year := DATE2DMY(date_ref, 3);

        //mes
        IntegrationBankPortugal.Month := DATE2DMY(date_ref, 2);

        //if - Ex: 0741,0781 - ver seccao 7.4 manual Banco Portugal novo campo?
        IntegrationBankPortugal."Finance Institution ID" := if_code;

        //npc - NIF empresa
        CompanyInfo.RESET;
        CompanyInfo.FINDFIRST;
        IntegrationBankPortugal."Company ID" := npc;

        //id_reg - Nº Mov ou Nº documento - a voltar a analisar
        IntegrationBankPortugal."Identification Code" := id_reg;

        //data_ref
        EVALUATE(IntegrationBankPortugal."Reference Date", FORMAT(date_ref, 0, '<Year4><Month,2><Day,2>'));

        //natureza_registo ex: C - criar | A - Anular | M - Modificar   tabela nova?
        IntegrationBankPortugal."Record Nature" := natur_reg;

        //npc2 ex: NPC/NIF de clientes ou entidades a quem se venderam títulos
        IntegrationBankPortugal."NPC 2nd Intervener" := npc2;

        //montante
        IntegrationBankPortugal.Amount := amt;

        //divisa
        IF currencycode = '' THEN
            currencycode := GeneralLedgerSetup."LCY Code";

        IntegrationBankPortugal."Currency Code" := currencycode;

        //cod_estat  Ex: A1010 | B1100 | C1310 - ver manual seccao 7 nova tabela
        IntegrationBankPortugal."Statistic Code" := cod_stat;

        //tipo_valor ex: E - Entrada | S - Saída | P - Posição
        IntegrationBankPortugal."Amount Type" := amt_type;

        //tipo_conta ex: I - conta interna | E - contabancária externa ,...,X - sem movimentação de conta pag 11 manual nova tabela
        IntegrationBankPortugal."Account Type" := acc_type;

        //id_banco  ex: 0741 | 0781 seccao 7.4 manual  novo campo ?
        IntegrationBankPortugal."IF Code" := id_bank;

        //pais_conta a ser preenchido apenas quando tipo_conta = E ou O. Cods seccao 7.3 manual
        IntegrationBankPortugal."Foreign Country Code" := acc_country;

        //pais_contraparte secao 7.2 manual codigos
        IntegrationBankPortugal."Counterpart Country Code" := counterpart_country;

        //pais_ativo a ser preenchido quando tipo_conta = S ou E e quando cod_estat = G,H,I,J,K
        IF BPStatistic.GET(cod_stat) THEN BEGIN
            IF BPStatistic.Category
              IN [BPStatistic.Category::G, BPStatistic.Category::H, BPStatistic.Category::I, BPStatistic.Category::J, BPStatistic.Category::K]
            THEN BEGIN
                IntegrationBankPortugal."Active Country Code" := active_country;
            END ELSE
                IntegrationBankPortugal."Active Country Code" := '';
        END;

        //data_vencimento
        IF duedate <> 0D THEN
            EVALUATE(IntegrationBankPortugal."Due Date", FORMAT(duedate, 0, '<Year4><Month,2><Day,2>'));

        //contraparte entidade emitora de títulos ou entidade de contraparte de empréstimos, depósitos ou créditos ??
        IntegrationBankPortugal."Counterpart ID" := counterpart;

        //observações
        IntegrationBankPortugal.Observations := obs;
        IntegrationBankPortugal."Document No." := DocumentNo;
        IntegrationBankPortugal.Description := Descript;


        IntegrationBankPortugal.INSERT;
    end;

    procedure CalculateCustLines()
    begin
        DtldCustLedgEntry.SETRANGE("Customer No.", CustPosition."No.");
        DtldCustLedgEntry.SETRANGE("Posting Date", 0D, ToDate);
        //V10.01#00012,o DtldCustLedgEntry.SETRANGE("Initial BP Statistic Code",CustPosition."BP Statistic Code");
        DtldCustLedgEntry.SETFILTER("PTSS Initial BP Statistic Code", '<>%1', ''); //V10.01#00012,n
        IF NOT DtldCustLedgEntry.ISEMPTY THEN BEGIN
            DtldCustLedgEntry.FINDSET;
            EntryNo := 0;
            REPEAT
                FillTempTable(DtldCustLedgEntry."Currency Code",
                              DtldCustLedgEntry."Customer No.",
                              DtldCustLedgEntry.Amount,
                              CustPosition."PTSS Debit Pos. Stat. Code",
                              CustPosition."PTSS Credit Pos. Stat. Code");
            UNTIL DtldCustLedgEntry.NEXT = 0;
        END;

        InsertBP(0);
    end;

    procedure CalculateVendLines()
    begin
        DtldVendLedgEntry.SETRANGE("Vendor No.", VendPosition."No.");
        DtldVendLedgEntry.SETRANGE("Posting Date", 0D, ToDate);
        //V10.01#00012,o DtldVendLedgEntry.SETRANGE("Initial BP Statistic Code",VendPosition."BP Statistic Code");
        DtldVendLedgEntry.SETFILTER("PTSS Initial BP Statistic Code", '<>%1', ''); //V10.01#00012,n
        IF NOT DtldVendLedgEntry.ISEMPTY THEN BEGIN
            DtldVendLedgEntry.FINDSET;
            EntryNo := 0;
            REPEAT
                FillTempTable(DtldVendLedgEntry."Currency Code",
                              DtldVendLedgEntry."Vendor No.",
                              DtldVendLedgEntry.Amount,
                              VendPosition."PTSS Debit Pos. Stat. Code",
                              VendPosition."PTSS Credit Pos. Stat. Code");

            UNTIL DtldVendLedgEntry.NEXT = 0;
        END;

        InsertBP(1);
    end;

    procedure CalculateBankLines()
    begin
        BankAccLedgEntry.SETRANGE("Bank Account No.", BankAccount."No.");
        BankAccLedgEntry.SETRANGE("Posting Date", 0D, ToDate);
        BankAccLedgEntry.SETFILTER("PTSS BP Statistic Code", '<>%1', ''); //V10.01#00012,n
        IF NOT BankAccLedgEntry.ISEMPTY THEN BEGIN
            BankAccLedgEntry.FINDSET;
            EntryNo := 0;
            REPEAT
                FillTempTable(BankAccLedgEntry."Currency Code",
                              BankAccLedgEntry."Bank Account No.",
                              BankAccLedgEntry.Amount,
                              BankAccLedgEntry."PTSS BP Statistic Code",
                              BankAccLedgEntry."PTSS BP Statistic Code");

            UNTIL BankAccLedgEntry.NEXT = 0;
        END;

        InsertBP(2);
    end;

    procedure FillTempTable(CurrCode: Code[20]; SourceNo: Code[20]; Amount: Decimal; BPDebitStatisticCode: Code[20]; BPCreditStatisticCode: Code[20])
    begin
        TempTable.SETRANGE(Code1, CurrCode);
        TempTable.SETRANGE(Code2, SourceNo);
        IF TempTable.FINDFIRST THEN BEGIN
            TempTable.Decimal1 += Amount;
            TempTable.MODIFY;
        END ELSE BEGIN
            TempTable.INIT;
            TempTable."Entry No." := EntryNo;
            TempTable.Code1 := CurrCode;
            TempTable.Code2 := SourceNo;
            TempTable.Code3 := BPDebitStatisticCode;
            TempTable.Code4 := BPCreditStatisticCode;
            TempTable.Decimal1 := Amount;
            TempTable.INSERT;
            EntryNo += 1;
        END;
    end;

    procedure InsertBP(IntMov: Integer)
    begin
        TempTable.RESET;
        TempTable.FINDSET;
        REPEAT
            amt := ABS(TempTable.Decimal1);
            currencycode := TempTable.Code1;
            IF TempTable.Decimal1 > 0 THEN
                cod_stat := TempTable.Code3
            ELSE
                cod_stat := TempTable.Code4;
            InsertBankPortugal(IntMov);
        UNTIL TempTable.NEXT = 0;
        TempTable.DELETEALL;
    end;

    local procedure ExcludeReversed(BankAccLedgEntry: Record "Bank Account Ledger Entry"): Boolean
    var
        BankAccLedgEntry1: Record "Bank Account Ledger Entry";
    begin
        IF BankAccLedgEntry.Reversed THEN BEGIN
            IF BankAccLedgEntry."Reversed by Entry No." <> 0 THEN
                BankAccLedgEntry1.SETRANGE("Entry No.", BankAccLedgEntry."Reversed by Entry No.")
            ELSE
                IF BankAccLedgEntry."Reversed Entry No." <> 0 THEN
                    BankAccLedgEntry1.SETRANGE("Entry No.", BankAccLedgEntry."Reversed Entry No.");

            IF BankAccLedgEntry1.FINDSET AND
               (DATE2DMY(BankAccLedgEntry1."Posting Date", 2) = DATE2DMY(BankAccLedgEntry."Posting Date", 2)) AND (DATE2DMY(BankAccLedgEntry1."Posting Date", 3) = DATE2DMY(BankAccLedgEntry."Posting Date", 3)) THEN
                EXIT(TRUE);
            EXIT(FALSE);
        END;
    end;
}

