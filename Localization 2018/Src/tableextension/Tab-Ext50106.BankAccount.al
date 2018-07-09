tableextension 50106 "Bank Account" extends "Bank Account"
{
    //IBAN
    fields
    {
        field(31022898; "CCC Bank Account No."; Text[11])
        {
            Caption = 'CCC Bank Account No.';
            Numeric = true;
            DataClassification = ToBeClassified;
            trigger OnValidate();
            begin
                "CCC Bank Account No." := IBANMgmt.PrePadString("CCC Bank Account No.", MAXSTRLEN("CCC Bank Account No."));
                IBANMgmt.BuildCCC("CCC No.", IBAN, "CCC Bank No.", "CCC Bank Branch No.", "CCC Bank Account No.", "CCC Control Digits", "Country/Region Code");
            end;
        }
        field(31022899; "CCC Bank Branch No."; Text[4])
        {
            Caption = 'CCC Bank Branch No.';
            Numeric = true;
            DataClassification = ToBeClassified;
            trigger OnValidate();
            begin
                "CCC Bank Branch No." := IBANMgmt.PrePadString("CCC Bank Branch No.", MAXSTRLEN("CCC Bank Branch No."));
                IBANMgmt.BuildCCC("CCC No.", IBAN, "CCC Bank No.", "CCC Bank Branch No.", "CCC Bank Account No.", "CCC Control Digits", "Country/Region Code");
            end;
        }
        field(31022900; "CCC Bank No."; Text[4])
        {
            Caption = 'CCC Bank No.';
            Numeric = true;
            DataClassification = ToBeClassified;
            trigger OnValidate();
            begin
                "CCC Bank No." := IBANMgmt.PrePadString("CCC Bank No.", MAXSTRLEN("CCC Bank No."));
                IBANMgmt.BuildCCC("CCC No.", IBAN, "CCC Bank No.", "CCC Bank Branch No.", "CCC Bank Account No.", "CCC Control Digits", "Country/Region Code");
            end;
        }
        field(31022901; "CCC Control Digits"; Text[2])
        {
            Caption = 'CCC Control Digits';
            Numeric = true;
            DataClassification = ToBeClassified;
            trigger OnValidate();
            begin
                "CCC Control Digits" := IBANMgmt.PrePadString("CCC Control Digits", MAXSTRLEN("CCC Control Digits"));
                IBANMgmt.BuildCCC("CCC No.", IBAN, "CCC Bank No.", "CCC Bank Branch No.", "CCC Bank Account No.", "CCC Control Digits", "Country/Region Code");
            end;
        }
        field(31022902; "CCC No."; Text[21])
        {
            Caption = 'CCC No.';
            Numeric = true;
            DataClassification = ToBeClassified;
            trigger OnValidate();
            begin
                "CCC Bank No." := COPYSTR("CCC No.", 1, 4);
                "CCC Bank Branch No." := COPYSTR("CCC No.", 5, 4);
                "CCC Bank Account No." := COPYSTR("CCC No.", 9, 11);
                "CCC Control Digits" := COPYSTR("CCC No.", 20, 2);
                "CCC No." := IBANMgmt.PrePadString("CCC No.", MAXSTRLEN("CCC No."));
                IBANMgmt.CheckCCC("CCC No.");
                IBAN := IBANMgmt.CheckIBANCountryCode("CCC No.", "Country/Region Code");
            end;
        }
        modify("Bank Account No.")
        {
            trigger OnAfterValidate();
            begin
                rec.TESTFIELD("CCC Bank Account No.", '');
            end;
        }
        modify("Country/Region Code")
        {
            trigger OnBeforeValidate();
            var
                Text31022892: label 'Deleting %1 will cause %2 to be deleted. Do you want to continue?';
            begin
                IF("Country/Region Code" = '') AND(IBAN <> '') THEN BEGIN
                    IF CONFIRM(Text31022892, FALSE, FIELDCAPTION("Country/Region Code"), FIELDCAPTION(IBAN)) THEN
                        CLEAR(IBAN)
                    ELSE
                        ERROR('');
                    EXIT;
                END;
                IBANMgmt.BuildCCC("CCC No.", IBAN, "CCC Bank No.", "CCC Bank Branch No.", "CCC Bank Account No.", "CCC Control Digits", "Country/Region Code");
            end;
        }
        modify(IBAN)
        {
            trigger OnBeforeValidate();
            begin
                IBANMgmt.FillCCCFields("CCC No.", IBAN, "CCC Bank No.", "CCC Bank Branch No.", "CCC Bank Account No.", "CCC Control Digits", "Country/Region Code");
            end;
        }
    }
    var
        CompanyInfo: Record "Company Information";
        IBANMgmt: Codeunit "IBAN Management";
}