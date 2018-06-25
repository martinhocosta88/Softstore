tableextension 50103 "Company Information Ext" extends "Company Information"
{
    fields
    {
        field(31022898;"CCC Bank Account No.";Text[11])
        {
            Caption='CCC Bank Account No.';
            Numeric=true;
            DataClassification = ToBeClassified;
            trigger OnValidate();
            begin
                "CCC Bank Account No." := PrePadString("CCC Bank Account No.",MAXSTRLEN("CCC Bank Account No."));
                BuildCCC;
            end;
        }
        field(31022899;"CCC Bank Branch No.";Text[4])
        {
            Caption='CCC Bank Branch No.';
            Numeric=true;
            DataClassification = ToBeClassified;
            trigger OnValidate();
            begin
                "CCC Bank Branch No." := PrePadString("CCC Bank Branch No.",MAXSTRLEN("CCC Bank Branch No."));
                BuildCCC;
            end;
        }
        field(31022900;"CCC Bank No.";Text[4])
        {
            Caption='CCC Bank No.';
            Numeric=true;            
            DataClassification = ToBeClassified;
            trigger OnValidate();
            begin
                "CCC Bank No." := PrePadString("CCC Bank No.",MAXSTRLEN("CCC Bank No."));
                BuildCCC;
            end;
        }
        field(31022901;"CCC Control Digits";Text[2])
        {
            Caption='CCC Control Digits';
            Numeric=true;
            DataClassification = ToBeClassified;
            trigger OnValidate();
            begin
                "CCC Control Digits" := PrePadString("CCC Control Digits",MAXSTRLEN("CCC Control Digits"));
                BuildCCC;
            end;
        }
        field(31022902;"CCC No.";Text[21])
        {
            Caption='CCC No.';
            Numeric=true;
            DataClassification = ToBeClassified;
            trigger OnValidate();
            begin
                "CCC Bank No." := COPYSTR("CCC No.",1,4);
                "CCC Bank Branch No." := COPYSTR("CCC No.",5,4);
                "CCC Bank Account No." := COPYSTR("CCC No.",9,11);
                "CCC Control Digits" := COPYSTR("CCC No.",20,2);
                "CCC No." := PrePadString("CCC No.",MAXSTRLEN("CCC No."));
                CheckCCC("CCC No.");
                IBAN := CheckIBANCountryCode("CCC No.","Country/Region Code");
            end;
        }
        modify(IBAN)
        {
            trigger OnBeforeValidate();
            begin
                IF IBAN <> '' THEN
                    "Country/Region Code" := COPYSTR(IBAN,1,2);
                "CCC Bank No." := COPYSTR(IBAN,5,4);
                "CCC Bank Branch No." := COPYSTR(IBAN,9,4);
                "CCC Bank Account No." := COPYSTR(IBAN,13,11);
                "CCC Control Digits" := COPYSTR(IBAN,24,2);
                "CCC No." := COPYSTR(IBAN,5,21);
            end;
        }
        modify("Country/Region Code")
        {
            trigger OnBeforeValidate();
            var
            Text31022890:label 'Deleting %1 will cause %2 to be deleted. Do you want to continue?';
            begin
                IF ("Country/Region Code" = '') AND (IBAN <> '') THEN BEGIN
                    IF CONFIRM(Text31022890,FALSE,FIELDCAPTION("Country/Region Code"),FIELDCAPTION(IBAN)) THEN
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
                rec.TESTFIELD("CCC Bank Account No.",'');
            end;
        }
    }
    procedure PrePadString(InString : Text[250];MaxLen : Integer) : Text[250];
    begin
        EXIT(PADSTR('', MaxLen - STRLEN(InString),'0') + InString);
    end;
    local procedure BuildCCC();
    begin
        "CCC No." := "CCC Bank No." + "CCC Bank Branch No." + "CCC Bank Account No." + "CCC Control Digits";
        IF "CCC No." <> '' THEN
            rec.TESTFIELD("Bank Account No.",'');

        IF ("CCC Bank No." <> '') AND ("CCC Bank Branch No." <> '') AND ("CCC Bank Account No." <> '') AND ("CCC Control Digits" <> '') THEN BEGIN
            CheckCCC("CCC No.");
            IBAN := CheckIBANCountryCode("CCC No.","Country/Region Code");
        END;
    end;
    procedure CheckCCC(NIB : Text[21]);
    var
        NIB2:Text[19];
        Chk:Integer;
        Total:Integer;
        Sum:Integer;
        ThisOne:Integer;
        Count:Integer;
        Factors:Array [19] of Integer;
        Text31022890:Label 'The number you entered is not a valid NIB.';
    begin
        IF NIB <> '' THEN BEGIN
            Factors[1] := 73;
            Factors[2] := 17;
            Factors[3] := 89;
            Factors[4] := 38;
            Factors[5] := 62;
            Factors[6] := 45;
            Factors[7] := 53;
            Factors[8] := 15;
            Factors[9] := 50;
            Factors[10] := 5;
            Factors[11] := 49;
            Factors[12] := 34;
            Factors[13] := 81;
            Factors[14] := 76;
            Factors[15] := 27;
            Factors[16] := 90;
            Factors[17] := 9;
            Factors[18] := 30;
            Factors[19] := 3;

            NIB2 := COPYSTR(NIB,1,19);
            EVALUATE(Chk,COPYSTR(NIB,20,2));
            Total := 0;
            Sum := 0;
            ThisOne := 0;
            FOR Count := 1 TO STRLEN(NIB2) DO BEGIN
                EVALUATE(ThisOne,COPYSTR(NIB2,Count,1));
                Sum := Sum + (ThisOne * Factors[Count]);
            END;

            Total := ROUND(Sum/97,1,'<');
            Total := Total * 97;
            Total := Sum - Total;
            Total := 98 - Total;

            IF NOT (FORMAT(Chk,0) = FORMAT(Total)) THEN
                ERROR(Text31022890);

        END;
    end;

    procedure CheckIBANCountryCode(NIB : Text[21];CountryCode : Text[2]) Send : Code[34];
    var
        Total:BigInteger;
        Letter1:Code[2];
        Letter2:Code[2];
        Modulus97:Integer;
        IBANCode:Code[100];
        IBANInt:Integer;
    begin
        IF (NIB <> '') AND (CountryCode <> '') THEN BEGIN
            Letter1 := COPYSTR(CountryCode,1,1);
            Letter1 := ConvertionToNumber(Letter1);

            Letter2 := COPYSTR(CountryCode,2,1);
            Letter2 := ConvertionToNumber(Letter2);

            IBANCode := FORMAT(NIB) + Letter1 + Letter2 + '00';
            IBANCode := DELCHR(IBANCode);

            Modulus97 := 97;

            WHILE STRLEN(IBANCode) > 6 DO
                IBANCode := CalcModulus(COPYSTR(IBANCode,1,6),Modulus97) + COPYSTR(IBANCode,7);

            EVALUATE(IBANInt, IBANCode);
            Total := 98 - (IBANInt MOD 97);

            Send := CountryCode + FORMAT(Total) + NIB;
        END;
    end;
    
    local procedure ConvertionToNumber(Letter : Code[20])Number : Text[20];
    begin
        IF (Letter >= 'A') AND (Letter <= 'Z') THEN BEGIN
            CASE Letter OF
            'A':
                Number := '10';
            'B':
                Number := '11';
            'C':
                Number := '12';
            'D':
                Number := '13';
            'E':
                Number := '14';
            'F':
                Number := '15';
            'G':
                Number := '16';
            'H':
                Number := '17';
            'I':
                Number := '18';
            'J':
                Number := '19';
            'K':
                Number := '20';
            'L':
                Number := '21';
            'M':
                Number := '22';
            'N':
                Number := '23';
            'O':
                Number := '24';
            'P':
                Number := '25';
            'Q':
                Number := '26';
            'R':
                Number := '27';
            'S':
                Number := '28';
            'T':
                Number := '29';
            'U':
                Number := '30';
            'V':
                Number := '31';
            'W':
                Number := '32';
            'X':
                Number := '33';
            'Y':
                Number := '34';
            'Z':
                Number := '35';
            END;
        end;
    end; 
    local procedure CalcModulus(Number : Code[10];Modulus97 : Integer) : Code[10];
    var
        I : Integer;
    begin
        EVALUATE(I,Number);
        I := I MOD Modulus97;
        IF I = 0 THEN
            EXIT('');
        EXIT(FORMAT(I));
    end;
        
}