tableextension 31023005 "PTSS Vendor Bank Account" extends "Vendor Bank Account"
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
                "PTSS CCC Bank Account No." := IBANMgmt.PrePadString("PTSS CCC Bank Account No.", MAXSTRLEN("PTSS CCC Bank Account No."));
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
                "PTSS CCC Bank Branch No." := IBANMgmt.PrePadString("PTSS CCC Bank Branch No.", MAXSTRLEN("PTSS CCC Bank Branch No."));
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
                "PTSS CCC Bank No." := IBANMgmt.PrePadString("PTSS CCC Bank No.", MAXSTRLEN("PTSS CCC Bank No."));
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
                "PTSS CCC Control Digits" := IBANMgmt.PrePadString("PTSS CCC Control Digits", MAXSTRLEN("PTSS CCC Control Digits"));
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
                "PTSS CCC Bank No." := COPYSTR("PTSS CCC No.", 1, 4);
                "PTSS CCC Bank Branch No." := COPYSTR("PTSS CCC No.", 5, 4);
                "PTSS CCC Bank Account No." := COPYSTR("PTSS CCC No.", 9, 11);
                "PTSS CCC Control Digits" := COPYSTR("PTSS CCC No.", 20, 2);
                "PTSS CCC No." := IBANMgmt.PrePadString("PTSS CCC No.", MAXSTRLEN("PTSS CCC No."));
                IBANMgmt.CheckCCC("PTSS CCC No.");
                IBAN := IBANMgmt.CheckIBANCountryCode("PTSS CCC No.", "Country/Region Code");
            end;
        }
        modify(IBAN)
        {
            trigger OnBeforeValidate();
            begin
                IBANMgmt.FillCCCFields("PTSS CCC No.", IBAN, "PTSS CCC Bank No.", "PTSS CCC Bank Branch No.", "PTSS CCC Bank Account No.", "PTSS CCC Control Digits", "Country/Region Code");
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
                IBANMgmt.BuildCCC("PTSS CCC No.", IBAN, "PTSS CCC Bank No.", "PTSS CCC Bank Branch No.", "PTSS CCC Bank Account No.", "PTSS CCC Control Digits", "Country/Region Code");
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
        IF Vendor.GET("Vendor No.") THEN BEGIN
            Vendor."Preferred Bank Account Code" := Code;
            Vendor.MODIFY;
        END;
    end;

    var
        CompanyInfo: Record "Company Information";
        Vendor: Record Vendor;
        IBANMgmt: Codeunit "PTSS IBAN Management";
}