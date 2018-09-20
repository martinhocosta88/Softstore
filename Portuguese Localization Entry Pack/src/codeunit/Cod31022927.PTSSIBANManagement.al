codeunit 31022927 "PTSS IBAN Management"
{
    //IBAN
    trigger OnRun();
    begin
    end;

    procedure CheckCCC(NIB: Text[21]);
    var
        NIB2: Text[19];
        Chk: Integer;
        Total: Integer;
        Sum: Integer;
        ThisOne: Integer;
        Count: Integer;
        Factors: Array[19] of Integer;
        Text31022890: Label 'The number you entered is not a valid NIB.';
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

            NIB2 := COPYSTR(NIB, 1, 19);
            EVALUATE(Chk, COPYSTR(NIB, 20, 2));
            Total := 0;
            Sum := 0;
            ThisOne := 0;
            FOR Count := 1 TO STRLEN(NIB2) DO BEGIN
                EVALUATE(ThisOne, COPYSTR(NIB2, Count, 1));
                Sum := Sum + (ThisOne * Factors[Count]);
            END;

            Total := ROUND(Sum / 97, 1, '<');
            Total := Total * 97;
            Total := Sum - Total;
            Total := 98 - Total;

            IF NOT (FORMAT(Chk, 0) = FORMAT(Total)) THEN
                ERROR(Text31022890);

        END;
    end;

    procedure ConvertionToNumber(Letter: Code[20]) Number: Text[20];
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

    procedure CheckIBANCountryCode(NIB: Text[21]; CountryCode: Text[2]) Send: Code[34];
    var
        Total: BigInteger;
        Letter1: Code[2];
        Letter2: Code[2];
        Modulus97: Integer;
        IBANCode: Code[100];
        IBANInt: Integer;
    begin
        IF (NIB <> '') AND (CountryCode <> '') THEN BEGIN
            Letter1 := COPYSTR(CountryCode, 1, 1);
            Letter1 := ConvertionToNumber(Letter1);

            Letter2 := COPYSTR(CountryCode, 2, 1);
            Letter2 := ConvertionToNumber(Letter2);

            IBANCode := FORMAT(NIB) + Letter1 + Letter2 + '00';
            IBANCode := DELCHR(IBANCode);

            Modulus97 := 97;

            WHILE STRLEN(IBANCode) > 6 DO
                IBANCode := CalcModulus(COPYSTR(IBANCode, 1, 6), Modulus97) + COPYSTR(IBANCode, 7);

            EVALUATE(IBANInt, IBANCode);
            Total := 98 - (IBANInt MOD 97);

            Send := CountryCode + FORMAT(Total) + NIB;
        END;
    end;

    local procedure CalcModulus(Number: Code[10]; Modulus97: Integer): Code[10];
    var
        I: Integer;
    begin
        //SS - Redefinition of the standard function since it's local
        EVALUATE(I, Number);
        I := I MOD Modulus97;
        IF I = 0 THEN
            EXIT('');
        EXIT(FORMAT(I));
    end;

    procedure PrePadString(InString: Text[250]; MaxLen: Integer): Text[250];
    begin
        EXIT(PADSTR('', MaxLen - STRLEN(InString), '0') + InString);
    end;

    procedure BuildCCC(var CCCNo: Text[21]; var IBAN: Code[50]; CCCBankNo: Text[4]; CCCBankBranchNo: text[4]; CCCBankAccountNo: Text[11]; CCCControlDigits: text[2]; CountryRegionCode: Code[10]);
    var
        CompanyInfo: Record "Company Information";
    begin
        CCCNo := CCCBankNo + CCCBankBranchNo + CCCBankAccountNo + CCCControlDigits;
        IF CCCNo <> '' THEN
            CompanyInfo.TESTFIELD("Bank Account No.", '');

        IF (CCCBankNo <> '') AND (CCCBankBranchNo <> '') AND (CCCBankAccountNo <> '') AND (CCCControlDigits <> '') THEN BEGIN
            CheckCCC(CCCNo);
            IBAN := CheckIBANCountryCode(CCCNo, CountryRegionCode);
        END;
    end;

    procedure FillCCCFields(var CCCNo: Text[21]; var IBAN: Code[50]; var CCCBankNo: Text[4]; var CCCBankBranchNo: text[4]; var CCCBankAccountNo: Text[11]; var CCCControlDigits: text[2]; var CountryRegionCode: Code[10])
    begin
        IF IBAN <> '' THEN
            CountryRegionCode := COPYSTR(IBAN, 1, 2);
        CCCBankNo := COPYSTR(IBAN, 5, 4);
        CCCBankBranchNo := COPYSTR(IBAN, 9, 4);
        CCCBankAccountNo := COPYSTR(IBAN, 13, 11);
        CCCControlDigits := COPYSTR(IBAN, 24, 2);
        CCCNo := COPYSTR(IBAN, 5, 21);
    end;
}