tableextension 50105 "Vendor Bank Account Ext" extends "Vendor Bank Account"
{
    fields
    {

        field(31022898; "CCC Bank Account No."; Text[11])
        {
            Caption = 'CCC Bank Account No.';
            Numeric = true;
            DataClassification = ToBeClassified;
            trigger OnValidate();
            begin
                "CCC Bank Account No." := CompanyInfo.PrePadString("CCC Bank Account No.", MAXSTRLEN("CCC Bank Account No."));
                BuildCCC;
            end;
        }
        field(31022899; "CCC Bank Branch No."; Text[4])
        {
            Caption = 'CCC Bank Branch No.';
            Numeric = true;
            DataClassification = ToBeClassified;
            trigger OnValidate();
            begin
                "CCC Bank Branch No." := CompanyInfo.PrePadString("CCC Bank Branch No.", MAXSTRLEN("CCC Bank Branch No."));
                BuildCCC;
            end;
        }
        field(31022900; "CCC Bank No."; Text[4])
        {
            Caption = 'CCC Bank No.';
            Numeric = true;
            DataClassification = ToBeClassified;
            trigger OnValidate();
            begin
                "CCC Bank No." := CompanyInfo.PrePadString("CCC Bank No.", MAXSTRLEN("CCC Bank No."));
                BuildCCC;
            end;
        }
        field(31022901; "CCC Control Digits"; Text[2])
        {
            Caption = 'CCC Control Digits';
            Numeric = true;
            DataClassification = ToBeClassified;
            trigger OnValidate();
            begin
                "CCC Control Digits" := CompanyInfo.PrePadString("CCC Control Digits", MAXSTRLEN("CCC Control Digits"));
                BuildCCC;
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
                "CCC No." := CompanyInfo.PrePadString("CCC No.", MAXSTRLEN("CCC No."));
                CompanyInfo.CheckCCC("CCC No.");
                IBAN := CompanyInfo.CheckIBANCountryCode("CCC No.", "Country/Region Code");
            end;
        }
        modify(IBAN)
        {
            trigger OnBeforeValidate();
            begin
                IF IBAN <> '' THEN
                    "Country/Region Code" := COPYSTR(IBAN, 1, 2);
                "CCC Bank No." := COPYSTR(IBAN, 5, 4);
                "CCC Bank Branch No." := COPYSTR(IBAN, 9, 4);
                "CCC Bank Account No." := COPYSTR(IBAN, 13, 11);
                "CCC Control Digits" := COPYSTR(IBAN, 24, 2);
                "CCC No." := COPYSTR(IBAN, 5, 21);
            end;
        }
        modify("Country/Region Code")
        {
            trigger OnBeforeValidate();
            var
                Text31022890: label 'Deleting %1 will cause %2 to be deleted. Do you want to continue?';
            begin
                IF ("Country/Region Code" = '') AND (IBAN <> '') THEN BEGIN
                    IF CONFIRM(Text31022890, FALSE, FIELDCAPTION("Country/Region Code"), FIELDCAPTION(IBAN)) THEN
                        CLEAR(IBAN)
                    ELSE
                        ERROR('');
                    EXIT;
                END;
                BuildCCC;
            end;
        }
        modify("Bank Account No.")
        {
            trigger OnAfterValidate();
            begin
                rec.TESTFIELD("CCC Bank Account No.", '');
            end;
        }
    }
    local procedure BuildCCC();
    begin
        "CCC No." := "CCC Bank No." + "CCC Bank Branch No." + "CCC Bank Account No." + "CCC Control Digits";
        IF "CCC No." <> '' THEN
            rec.TESTFIELD("Bank Account No.", '');

        IF ("CCC Bank No." <> '') AND ("CCC Bank Branch No." <> '') AND ("CCC Bank Account No." <> '') AND ("CCC Control Digits" <> '') THEN BEGIN
            CompanyInfo.CheckCCC("CCC No.");
            IBAN := CompanyInfo.CheckIBANCountryCode("CCC No.", "Country/Region Code");
        END;
    end;

    trigger OnAfterRename();

    begin
        IF Vendor.GET("Vendor No.") THEN BEGIN
            Vendor."Preferred Bank Account Code" := Code;
            Vendor.MODIFY;
        END;
    end;

    var
        CompanyInfo: Record "Company Information";
        Vendor: Record Vendor;
}