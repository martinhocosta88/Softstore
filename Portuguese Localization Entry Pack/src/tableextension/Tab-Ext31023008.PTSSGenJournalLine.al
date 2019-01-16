tableextension 31023008 "PTSS Gen. Journal Line" extends "Gen. Journal Line"
{
    //Cash-Flow
    //COPE
    fields
    {
        modify("Account Type")
        {
            trigger OnAfterValidate()
            begin
                VALIDATE("PTSS Acc: cash-flow code", '');
                "PTSS BP Statistic Code" := '';
            end;
        }
        modify("Bal. Account Type")
        {
            trigger OnAfterValidate()
            begin
                VALIDATE("PTSS Bal: cash-flow code", '');
                "PTSS BP Bal. Statistic Code" := '';
            end;
        }
        modify("Account No.")
        {
            trigger OnbeforeValidate()
            begin
                "PTSS BP Statistic Code" := '';
                "PTSS BP Countrpt. Country Code" := '';
            end;
        }
        modify("Bal. Account No.")
        {
            trigger OnbeforeValidate()
            begin
                "PTSS BP Statistic Code" := '';
                "PTSS BP Countrpt. Country Code" := '';
            end;

            trigger OnAfterValidate()
            begin
                CASE "Account Type" OF
                    "Account Type"::"G/L Account":
                        BEGIN
                            GLAcc.GET("Bal. Account No.");
                            IF GLAcc."PTSS Cash-flow code assoc." THEN
                                "PTSS Bal: cash-flow code" := GLAcc."PTSS Cash-flow code"
                            ELSE
                                "PTSS Bal: cash-flow code" := '';
                        END;
                    "Account Type"::Customer:
                        BEGIN
                            Cust.GET("Bal. Account No.");
                            "PTSS Bal: cash-flow code" := '';
                        END;
                    "Account Type"::Vendor:
                        BEGIN
                            Vend.GET("Bal. Account No.");
                            "PTSS Bal: cash-flow code" := '';
                        END;
                    "Account Type"::"Bank Account":
                        begin
                            BankAcc.GET("Bal. Account No.");
                            IF BankConfig.GET(BankAcc."Bank Acc. Posting Group") AND GLAcc.GET(BankConfig."G/L Bank Account No.") AND GLAcc."PTSS Cash-flow code assoc." THEN
                                "PTSS Bal: cash-flow code" := GLAcc."PTSS Cash-flow code"
                            ELSE
                                "PTSS Bal: cash-flow code" := '';
                        END;
                    "Account Type"::"Fixed Asset":
                        begin
                            FixedAsset.GET("Bal. Account No.");
                            "PTSS Bal: cash-flow code" := '';
                        End;
                end;
            end;
        }
        field(31022900; "PTSS Acc: cash-flow code"; Code[10])
        {
            Caption = 'Acc: cash-flow code';
            TableRelation = "PTSS Cash-Flow Plan"."No." WHERE (Type = CONST (Posting));
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                BankConfig: Record "Bank Account Posting Group";
            begin
                IF ("Account Type" <> "Account Type"::"G/L Account") AND
                    ("Account Type" <> "Account Type"::"Bank Account") THEN
                    "PTSS Acc: cash-flow code" := ''
                ELSE
                    IF "Account No." <> '' THEN
                        CASE "Account Type" OF
                            "Account Type"::"G/L Account":
                                BEGIN
                                    GLAcc.GET("Account No.");
                                    IF NOT (GLAcc."PTSS Cash-flow code assoc.") THEN
                                        "PTSS Acc: cash-flow code" := ''
                                    ELSE
                                        Rec.TESTFIELD("PTSS Acc: cash-flow code");
                                END;
                            "Account Type"::"Bank Account":
                                BEGIN
                                    BankAcc.GET("Account No.");
                                    BankConfig.GET(BankAcc."Bank Acc. Posting Group");
                                    GLAcc.GET(BankConfig."G/L Bank Account No.");
                                    IF NOT (GLAcc."PTSS Cash-flow code assoc.") THEN
                                        Rec."PTSS Acc: cash-flow code" := ''
                                    ELSE
                                        Rec.TESTFIELD("PTSS Acc: cash-flow code");
                                END;
                        END;
            end;
        }
        field(31022902; "PTSS Bal: cash-flow code"; Code[10])
        {
            Caption = 'Bal: cash-flow code';
            TableRelation = "PTSS Cash-Flow Plan"."No." WHERE (Type = CONST (Posting));
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                BankConfig: Record "Bank Account Posting Group";

            begin
                IF ("Bal. Account Type" <> "Bal. Account Type"::"G/L Account") AND
                    ("Bal. Account Type" <> "Bal. Account Type"::"Bank Account") THEN
                    "PTSS Bal: cash-flow code" := ''
                ELSE
                    IF "Bal. Account No." <> '' THEN
                        CASE "Bal. Account Type" OF
                            "Bal. Account Type"::"G/L Account":
                                BEGIN
                                    GLAcc.GET("Bal. Account No.");
                                    IF NOT (GLAcc."PTSS Cash-flow code assoc.") THEN
                                        "PTSS Bal: cash-flow code" := ''
                                    ELSE
                                        Rec.TESTFIELD("PTSS Bal: cash-flow code");
                                END;
                            "Bal. Account Type"::"Bank Account":
                                BEGIN
                                    BankAcc.GET("Bal. Account No.");
                                    BankConfig.GET(BankAcc."Bank Acc. Posting Group");
                                    GLAcc.GET(BankConfig."G/L Bank Account No.");
                                    IF NOT (GLAcc."PTSS Cash-flow code assoc.") THEN
                                        Rec."PTSS Bal: cash-flow code" := ''
                                    ELSE
                                        Rec.TESTFIELD("PTSS Bal: cash-flow code");
                                END;
                        END;
            end;
        }
        field(31022949; "PTSS BP Account Type Code"; Code[1])
        {
            Caption = 'BP Account Type Code';
            TableRelation = "PTSS BP Account Type";
            DataClassification = CustomerContent;
        }

        field(31022950; "PTSS BP Statistic Code"; Code[5])
        {
            Caption = 'BP Statistic Code';
            TableRelation = "PTSS BP Statistic";
            DataClassification = CustomerContent;
        }

        field(31022951; "PTSS BP Countrpt. Country Code"; Code[3])
        {
            Caption = 'BP Counterpart Country Code';
            TableRelation = "PTSS BP Territory";
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TESTFIELD("PTSS BP Statistic Code");
            end;
        }
        field(31022952; "PTSS BP Active Country Code"; Code[3])
        {
            Caption = 'BP Counterpart Country Code';
            TableRelation = "PTSS BP Territory";
            DataClassification = CustomerContent;
            trigger OnValidate()
            var
                BPStatistic: Record "PTSS BP Statistic";
            begin
                TESTFIELD("PTSS BP Statistic Code");
                BPStatistic.GET("PTSS BP Statistic Code");
                IF NOT (BPStatistic.Category IN
                [BPStatistic.Category::G, BPStatistic.Category::H, BPStatistic.Category::I, BPStatistic.Category::J, BPStatistic.Category::K])
                THEN
                    ERROR(Text31022892, FIELDCAPTION("PTSS BP Statistic Code"));
            end;
        }
        field(31022953; "PTSS BP NPC 2nd Intervener"; Integer)
        {
            Caption = 'BP NPC 2nd Intervener';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TESTFIELD("PTSS BP Statistic Code");
            end;
        }
        field(31022954; "PTSS BP Bal. Statistic Code"; Code[5])
        {
            Caption = 'BP Bal. Statistic Code';
            TableRelation = "PTSS BP Statistic";
            DataClassification = CustomerContent;
        }
        field(31022955; "PTSS BP Bal. Count. Ctry. Code"; Code[3])
        {
            Caption = 'BP Bal. Counter. Country Code';
            TableRelation = "PTSS BP Territory";
            DataClassification = CustomerContent;
            trigger OnValidate();
            begin
                TESTFIELD("PTSS BP Bal. Statistic Code");
            end;
        }
        field(31022956; "PTSS BP Bal. Active Ctry. Code"; Code[3])
        {
            Caption = 'BP Bal. Active Country Code';
            TableRelation = "PTSS BP Territory";
            DataClassification = CustomerContent;
            trigger Onvalidate();
            var
                BPStatistic: Record "PTSS BP Statistic";
            begin
                TESTFIELD("PTSS BP Bal. Statistic Code");
                BPStatistic.GET("PTSS BP Bal. Statistic Code");
                IF NOT (BPStatistic.Category IN
                [BPStatistic.Category::G, BPStatistic.Category::H, BPStatistic.Category::I, BPStatistic.Category::J, BPStatistic.Category::K])
                THEN
                    ERROR(Text31022892, FIELDCAPTION("PTSS BP Statistic Code"));
            end;
        }
        field(31022957; "PTSS BP Bal. NPC 2nd Interv."; Integer)
        {
            Caption = 'BP Bal. NPC 2nd Intervener';
            DataClassification = CustomerContent;
            trigger OnValidate();
            begin
                TESTFIELD("PTSS BP Bal. Statistic Code");
            end;
        }

    }
    procedure GetBPInfo(CountryRegionCode: Code[10]; BPStatisticCode: Code[5])
    var
        CompanyInfo: Record "Company Information";
        CountryRegion: Record "Country/Region";
        BankAcc: Record "Bank Account";
    begin
        CompanyInfo.GET;
        IF CompanyInfo."Country/Region Code" <> CountryRegionCode THEN BEGIN
            "PTSS BP Statistic Code" := BPStatisticCode;
            IF CountryRegion.GET(BankAcc."Country/Region Code") THEN
                "PTSS BP Countrpt. Country Code" := CountryRegion."PTSS BP Territory Code";
        END;
    end;

    procedure GetBalBPInfo(CountryRegionCode: Code[10]; BPStatisticCode: Code[5])
    var
        CompanyInfo: Record "Company Information";
        CountryRegion: Record "Country/Region";
        BankAcc: Record "Bank Account";
    begin
        CompanyInfo.GET;
        IF CompanyInfo."Country/Region Code" <> CountryRegionCode THEN BEGIN
            "PTSS BP Bal. Statistic Code" := BPStatisticCode;
            IF CountryRegion.GET(BankAcc."Country/Region Code") THEN
                "PTSS BP Bal. Count. Ctry. Code" := CountryRegion."PTSS BP Territory Code";
        END;
    end;

    var
        GLAcc: Record "G/L Account";
        Cust: Record Customer;
        Vend: Record Vendor;
        BankAcc: Record "Bank Account";
        FixedAsset: Record "Fixed Asset";
        BankConfig: Record "Bank Account Posting Group";
        Text31022892: Label '%1 must be Type G,H,I,J or K.';
}