tableextension 50101 "G/L Account Extension" extends "G/L Account"
{
    fields
    {

        field(50100; "Taxonomy Code"; Integer)
        {
            Caption = 'Taxonomy Code';
            TableRelation = "Taxonomy Codes"."Taxonomy Code";
            DataClassification = CustomerContent;
            BlankZero = true;
            trigger OnValidate()
            begin
                Rec.TestField("Account Type","Account Type"::Posting);
            end;
        }
        field(31022890; "Income Stmt. Bal. Acc."; Code[20])
        {
            AutoFormatExpression = GetCurrencyCode;
            TableRelation = "G/L Account";
            DataClassification = ToBeClassified;
        }
    }
    local procedure GetCurrencyCode() : Code[10]
    var
        GLSetupRead:Boolean;
        GLSetup:Record "General Ledger Setup";
    begin
        IF NOT GLSetupRead THEN BEGIN
            GLSetup.GET;
            GLSetupRead := TRUE;
        END;
        EXIT(GLSetup."Additional Reporting Currency");
    end;
    procedure CheckChartAcc()
    var
        Text31022897:Label 'Missing group %1 - Account No. %2';
        Text31022896:Label 'This function checks the consistency of and completes the Chart of Accounts:\';
        Text31022895:Label '- Checks that a corresponding balance account exists for every posting account.\';
        Text31022893:Label '- Assigns values to the following fields: Income/Balance, Account Type, Totaling and Debit/Credit.\';
        Text31022892:Label 'Do you want to Check the Chart of Accounts?';
        Text31022891:Label 'Checking the Chart of Accounts #1########## @2@@@@@@@@@@@@@';
        Text31022890:Label 'The Chart of Accounts is correct.';
        HidePrintDialog: Boolean;
        Window: Dialog;
        GLAcc:Record "G/L Account";
        LineCounter:Integer;
        NoOfRecords:Integer;
        FindAcc:Record "G/L Account";


    begin
        IF NOT HidePrintDialog THEN
            IF NOT
                CONFIRM(
                Text31022896 +
                Text31022895 +
                Text31022893 +
                Text31022892,TRUE)
            THEN
                EXIT;

            Window.OPEN(Text31022891);
            WITH GLAcc DO BEGIN
            RESET;
            LineCounter := 0;
            NoOfRecords := COUNT;
            IF NoOfRecords <> 0 THEN BEGIN
                IF FINDSET THEN
                REPEAT
                    Window.UPDATE(1,"No.");
                    TESTFIELD(Name);
                    IF STRLEN("No.") = 1 THEN
                    VALIDATE("Account Type","Account Type"::Total);
                    IF "Account Type" = "Account Type"::Posting THEN BEGIN
                    CLEAR(FindAcc);
                    FindAcc.SETFILTER("No.",'%1 & <> %2',"No."+'*', "No.");
                    IF FindAcc.FINDFIRST THEN
                        VALIDATE("Account Type","Account Type"::Total)
                    ELSE
                        VALIDATE("Account Type","Account Type"::Posting);
                    END;
                    IF "Account Type" = "Account Type"::Total THEN BEGIN
                    Totaling := "No." + '..' + "No.";
                    Totaling := PADSTR(Totaling,20, '9');
                    END ELSE BEGIN
                    FindAcc.SETFILTER("No.",'<>%1 & %2',"No."+'*',COPYSTR("No.",1,1)+'*');
                    IF FindAcc.ISEMPTY THEN
                        ERROR(Text31022897,COPYSTR("No.",1,3),"No.");

                    IF COPYSTR("No.",1,1) IN ['6','7'] THEN
                        "Income/Balance" := "Income/Balance"::"Income Statement"
                    ELSE
                        IF COPYSTR("No.",1,1)<>'8' THEN
                        "Income/Balance" := "Income/Balance"::"Balance Sheet";

                    IF "Income/Balance" = "Income/Balance"::"Income Statement" THEN BEGIN
                        IF (COPYSTR("No.",1,1)<>'8') AND (COPYSTR("No.",1,2)<>'60') AND (COPYSTR("No.",1,2)<>'70') THEN
                        TESTFIELD("Income Stmt. Bal. Acc.");
                    END ELSE
                        "Income Stmt. Bal. Acc." := '';

                    END;
                    MODIFY;
                    LineCounter := LineCounter + 1;
                    Window.UPDATE(2,ROUND(LineCounter / NoOfRecords * 10000,1));
                UNTIL NEXT = 0;
            END;
            END;
            Window.CLOSE;
            IF NOT HidePrintDialog THEN
                MESSAGE(Text31022890);
    end;        
}