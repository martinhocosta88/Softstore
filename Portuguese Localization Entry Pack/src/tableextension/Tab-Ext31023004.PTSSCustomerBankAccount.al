tableextension 31023004 "PTSS Customer Bank Account" extends "Customer Bank Account"
{
    //IBAN
    fields
    {
        field(31022898; "PTSS CCC Bank Account No."; Text[11])
        {
            Caption = 'CCC Bank Account No.';
            Numeric = true;
            DataClassification = CustomerContent;
            trigger OnValidate();
            begin
                If "PTSS CCC Bank Account No." <> '' then
                    "PTSS CCC Bank Account No." := IBANMgmt.PrePadString("PTSS CCC Bank Account No.", MAXSTRLEN("PTSS CCC Bank Account No."))
                Else
                    IBANMgmt.ClearIBANNIB(IBAN, "PTSS CCC No.");
                IBANMgmt.BuildCCC("PTSS CCC No.", IBAN, "PTSS CCC Bank No.", "PTSS CCC Bank Branch No.", "PTSS CCC Bank Account No.", "PTSS CCC Control Digits", "Country/Region Code");
            end;
        }
        field(31022899; "PTSS CCC Bank Branch No."; Text[4])
        {
            Caption = 'CCC Bank Branch No.';
            Numeric = true;
            DataClassification = CustomerContent;
            trigger OnValidate();
            begin
                if "PTSS CCC Bank Branch No." <> '' then
                    "PTSS CCC Bank Branch No." := IBANMgmt.PrePadString("PTSS CCC Bank Branch No.", MAXSTRLEN("PTSS CCC Bank Branch No."))
                else
                    IBANMgmt.ClearIBANNIB(IBAN, "PTSS CCC No.");
                IBANMgmt.BuildCCC("PTSS CCC No.", IBAN, "PTSS CCC Bank No.", "PTSS CCC Bank Branch No.", "PTSS CCC Bank Account No.", "PTSS CCC Control Digits", "Country/Region Code");
            end;
        }
        field(31022900; "PTSS CCC Bank No."; Text[4])
        {
            Caption = 'CCC Bank No.';
            Numeric = true;
            DataClassification = CustomerContent;
            trigger OnValidate();
            begin
                if "PTSS CCC Bank No." <> '' then
                    "PTSS CCC Bank No." := IBANMgmt.PrePadString("PTSS CCC Bank No.", MAXSTRLEN("PTSS CCC Bank No."))
                else
                    IBANMgmt.ClearIBANNIB(IBAN, "PTSS CCC No.");
                IBANMgmt.BuildCCC("PTSS CCC No.", IBAN, "PTSS CCC Bank No.", "PTSS CCC Bank Branch No.", "PTSS CCC Bank Account No.", "PTSS CCC Control Digits", "Country/Region Code");
            end;
        }
        field(31022901; "PTSS CCC Control Digits"; Text[2])
        {
            Caption = 'CCC Control Digits';
            Numeric = true;
            DataClassification = CustomerContent;
            trigger OnValidate();
            begin
                If "PTSS CCC Control Digits" <> '' then
                    "PTSS CCC Control Digits" := IBANMgmt.PrePadString("PTSS CCC Control Digits", MAXSTRLEN("PTSS CCC Control Digits"))
                else
                    IBANMgmt.ClearIBANNIB(IBAN, "PTSS CCC No.");
                IBANMgmt.BuildCCC("PTSS CCC No.", IBAN, "PTSS CCC Bank No.", "PTSS CCC Bank Branch No.", "PTSS CCC Bank Account No.", "PTSS CCC Control Digits", "Country/Region Code");
            end;
        }
        field(31022902; "PTSS CCC No."; Text[21])
        {
            Caption = 'CCC No.';
            Numeric = true;
            DataClassification = CustomerContent;
            trigger OnValidate();

            begin
                ValidateNIB();
            end;
        }
        modify(IBAN)
        {
            trigger OnBeforeValidate();
            begin
                ValidateIBAN();
            end;
            
        }
        modify("Country/Region Code")
        {
            trigger OnBeforeValidate();

            begin
                SetIBAN();
            end;
        }
        modify("Bank Account No.")
        {
            trigger OnAfterValidate();
            begin
                rec.TESTFIELD("PTSS CCC Bank Account No.", '');
            end;
        }
    }
    trigger OnAfterRename();

    begin
        IF Customer.GET("Customer No.") THEN BEGIN
            Customer."Preferred Bank Account Code" := Code;
            Customer.MODIFY;
        END;
    end;

    local procedure SetIBAN()

    var
        Text31022890: label 'Deleting %1 will cause %2 to be deleted. Do you want to continue?';
    begin
        IF ("Country/Region Code" = '') AND (IBAN <> '') THEN BEGIN
            IF NOT CONFIRM(Text31022890, FALSE, FIELDCAPTION("Country/Region Code"), FIELDCAPTION(IBAN)) THEN
                ERROR('');
            IBANMgmt.ClearIBANNIB(IBAN, "PTSS CCC No.");
            EXIT;
        END;
        IBANMgmt.BuildCCC("PTSS CCC No.", IBAN, "PTSS CCC Bank No.", "PTSS CCC Bank Branch No.", "PTSS CCC Bank Account No.", "PTSS CCC Control Digits", "Country/Region Code");
    end;

    local procedure ValidateIBAN()
    begin
        IF IBAN <> '' THEN
            VALIDATE("Country/Region Code", COPYSTR(IBAN, 1, 2));

        "PTSS CCC Bank No." := COPYSTR(IBAN, 5, 4);
        "PTSS CCC Bank Branch No." := COPYSTR(IBAN, 9, 4);
        "PTSS CCC Bank Account No." := COPYSTR(IBAN, 13, 11);
        "PTSS CCC Control Digits" := COPYSTR(IBAN, 24, 2);
        "PTSS CCC No." := COPYSTR(IBAN, 5, 21);
        "Bank Account No." := "PTSS CCC Bank Account No.";
        "Bank Branch No." := "PTSS CCC Bank Branch No.";
    end;

    local procedure ValidateNIB()
    begin
        "PTSS CCC Bank No." := COPYSTR("PTSS CCC No.", 1, 4);
        "PTSS CCC Bank Branch No." := COPYSTR("PTSS CCC No.", 5, 4);
        "PTSS CCC Bank Account No." := COPYSTR("PTSS CCC No.", 9, 11);
        "PTSS CCC Control Digits" := COPYSTR("PTSS CCC No.", 20, 2);
        "PTSS CCC No." := IBANMgmt.PrePadString("PTSS CCC No.", MAXSTRLEN("PTSS CCC No."));

        IBANMgmt.CheckCCC("PTSS CCC No.");
        IBAN := IBANMgmt.CheckIBANCountryCode("PTSS CCC No.", "Country/Region Code");
    end;

    var
        CompanyInfo: Record "Company Information";
        Customer: Record Customer;
        IBANMgmt: Codeunit "PTSS IBAN Management";
}