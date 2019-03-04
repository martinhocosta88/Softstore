tableextension 31023001 "PTSS G/L Account" extends "G/L Account"
{
    //Taxonomies
    //Cash-Flow
    //Balancetes
    fields
    {
        field(31022975; "PTSS Taxonomy Code"; Integer)
        {
            Caption = 'Taxonomy Code';
            TableRelation = "PTSS Taxonomy Codes"."Taxonomy Code";
            DataClassification = CustomerContent;
            BlankZero = true;
            trigger OnValidate()
            begin
                Rec.TestField("Account Type", "Account Type"::Posting);
            end;
        }
        field(31022890; "PTSS Income Stmt. Bal. Acc."; Code[20])
        {
            Caption = 'Income Stmt. Bal. Acc.';
            AutoFormatExpression = GetCurrencyCode;
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;
        }
        field(31022895; "PTSS Cash-flow code"; Code[10])
        {
            Caption = 'Cash-flow code';
            TableRelation = "PTSS Cash-Flow Plan"."No." WHERE (Type = CONST (Posting));
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF "PTSS Cash-flow code assoc." THEN
                    rec.TESTFIELD("PTSS Cash-flow code");

                IF "PTSS Cash-flow code" <> '' THEN
                    "PTSS Cash-flow code assoc." := TRUE;
            end;
        }
        field(31022896; "PTSS Cash-flow code assoc."; Boolean)
        {
            Caption = 'Cash-flow code assoc.';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF NOT "PTSS Cash-flow code assoc." THEN
                    "PTSS Cash-flow code" := '';
            end;
        }
        field(31022897; "PTSS Cash-flow - credit"; Decimal)
        {

            Caption = 'Cash-flow - credit';
            FieldClass = FlowField;
            CalcFormula = Sum ("G/L Entry"."Credit Amount" WHERE ("G/L Account No." = FIELD ("No."), "PTSS Acc: cash-flow code" = FILTER (<> '')));
            Editable = false;
        }
        field(31022898; "PTSS Cash-flow - debit"; Decimal)
        {
            Caption = 'Cash-flow - debit';
            FieldClass = FlowField;
            CalcFormula = Sum ("G/L Entry"."Debit Amount" WHERE ("G/L Account No." = FIELD ("No."), "PTSS Acc: cash-flow code" = FILTER (<> '')));
            Editable = false;
        }
        //Regras de Negocio/Check Chart of Accounts
        modify("No.")
        {
            trigger OnBeforeValidate()
            begin
                FillDefaultValues();
            end;
        }
        //Regras de Negocio
        modify("Direct Posting")
        {
            trigger OnBeforeValidate()
            begin
                If "Account Type" = "Account Type"::Total then
                    "Direct Posting" := false;
            end;
        }

    }
    //Regras de Negocio
    trigger OnBeforeDelete()
    begin
        ValidateAccDeletion();
    end;
    //Balancetes
    procedure GetBalance(IsDebit: Boolean; Account: Text[250]; StartDate: Date; EndDate: Date; AddCurrency: Boolean) Amount: Decimal
    var
        GLAcc: Record "G/L Account";
    begin
        IF Account <> '' THEN
            GLAcc.SETFILTER("No.", Account)
        ELSE
            GLAcc.SETFILTER("No.", "No.");
        GLAcc.SETFILTER("Date Filter", '%1..%2', StartDate, EndDate);
        GLAcc.SETFILTER("Account Type", '%1', GLAcc."Account Type"::Posting);
        IF GLAcc.FINDSET THEN
            REPEAT
                GLAcc.CALCFIELDS("Net Change", "Additional-Currency Net Change");
                IF NOT AddCurrency THEN BEGIN
                    IF IsDebit AND (GLAcc."Net Change" > 0) THEN
                        Amount += GLAcc."Net Change";
                    IF NOT IsDebit AND (GLAcc."Net Change" < 0) THEN
                        Amount += GLAcc."Net Change";
                END ELSE BEGIN
                    IF IsDebit AND (GLAcc."Additional-Currency Net Change" > 0) THEN
                        Amount += GLAcc."Additional-Currency Net Change";
                    IF NOT IsDebit AND (GLAcc."Additional-Currency Net Change" < 0) THEN
                        Amount += GLAcc."Additional-Currency Net Change";
                END;
            UNTIL GLAcc.NEXT = 0;
    end;

    //Regras de Negocio
    local procedure ValidateAccDeletion()
    var
        GLAcc: Record "G/L Account";
    begin
        IF "Account Type" = "Account Type"::Total then begin
            GLAcc := Rec;
            IF GLAcc.NEXT <> 0 then
                IF CopyStr(GLAcc."No.", 1, StrLen("No.")) = "No." then
                    Error(Text31022892);

        end;
    end;

    //Regras de Negocio/Check Chart of Accounts
    local procedure FillDefaultValues()
    var
        AccFirstDigit: Integer;
    begin
        GLSetup.GET;
        IF GLSetup."PTSS Check Chart of Accounts" THEN
            IF xRec."No." <> '' THEN BEGIN
                EVALUATE(AccFirstDigit, COPYSTR("No.", 1, 1));
                CASE AccFirstDigit OF
                    6:
                        BEGIN
                            "Income/Balance" := "Income/Balance"::"Income Statement";
                            "Gen. Posting Type" := "Gen. Posting Type"::Purchase;
                        END;
                    7:
                        BEGIN
                            "Income/Balance" := "Income/Balance"::"Income Statement";
                            "Gen. Posting Type" := "Gen. Posting Type"::Sale;
                        END;
                    ELSE BEGIN
                            "Income/Balance" := "Income/Balance"::"Balance Sheet";
                            "Gen. Posting Type" := 0;
                        END;
                END;
            END;
    end;

    var
        Text31022892: Label 'A Total Account with related accounts cannot be deleted.';
        GLSetup: Record "General Ledger Setup";
}