tableextension 31023047 "PTSS No. Series Line" extends "No. Series Line" //MyTargetTableId
//Certificação Documentos
{
    fields
    {
        field(31022890; "PTSS Last No. Posted"; Code[20])
        {
            Caption = 'Last No. Posted';
            Description = 'soft';
            DataClassification = CustomerContent;
        }
        field(31022891; "PTSS Previous Last Date Used"; Date)
        {
            Caption = 'Previous Last Date Used';
            Description = 'soft';
            DataClassification = CustomerContent;
        }
        field(31022892; "PTSS Last Hash Used"; Text[172])
        {
            Caption = 'Last Hash Used';
            Description = 'soft';
            DataClassification = CustomerContent;
        }
        field(31022893; "PTSS SAF-T No. Series Del."; Integer)
        {
            BlankZero = true;
            Caption = 'SAF-T No. Series Delimiter';
            Description = 'soft';
            MaxValue = 10;
            MinValue = 0;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                UpdateSAFTFields;
            end;
        }
        field(31022894; "PTSS SAF-T No. Series"; Text[10])
        {
            Caption = 'SAF-T No. Series';
            Description = 'soft';
            Editable = false;
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                TESTFIELD("Last No. Used", '');
                TESTFIELD("PTSS Last No. Posted", '');
                TESTFIELD("PTSS Last Hash Used", '');

                IF NOT ValidateDigitsAndLetters("PTSS SAF-T No. Series", 1) THEN
                    ERROR(Text31022891, FIELDCAPTION("PTSS SAF-T No. Series"));

            end;
        }
        field(31022895; "PTSS SAFT-T Sequential No."; Text[20])
        {
            Caption = 'SAFT-T Sequential No.';
            Description = 'soft';
            Editable = false;
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                TESTFIELD("Last No. Used", '');
                TESTFIELD("PTSS Last No. Posted", '');
                TESTFIELD("PTSS Last Hash Used", '');

                IF NOT ValidateDigitsAndLetters("PTSS SAFT-T Sequential No.", 0) THEN
                    ERROR(Text31022892, FIELDCAPTION("PTSS SAFT-T Sequential No."));

                ValidateSAFTSequenceNo("PTSS SAFT-T Sequential No.");
            end;
        }

    }

    local procedure UpdateSAFTFields()
    var
        NoSeries: Record "No. Series";
    begin
        TESTFIELD("Last No. Used", '');
        TESTFIELD("PTSS Last No. Posted", '');
        TESTFIELD("PTSS Last Hash Used", '');

        CLEAR(NoSeries);

        IF STRLEN("Starting No.") < "PTSS SAF-T No. Series Del." THEN
            ERROR(Text31022890, FIELDCAPTION("PTSS SAF-T No. Series Del."), FIELDCAPTION("Starting No."));

        IF ("PTSS SAF-T No. Series Del." = 0) OR ("Starting No." = '') THEN BEGIN
            "PTSS SAF-T No. Series" := '';
            "PTSS SAFT-T Sequential No." := '';
        END ELSE BEGIN
            VALIDATE("PTSS SAF-T No. Series", COPYSTR("Starting No.", 1, "PTSS SAF-T No. Series Del."));
            VALIDATE("PTSS SAFT-T Sequential No.", COPYSTR("Starting No.", "PTSS SAF-T No. Series Del." + 1, STRLEN("Starting No.")));
        END;
    end;

    local procedure ValidateDigitsAndLetters(pCodSAFTNoSeries: Code[20]; pTypeOfChar: Integer): Boolean
    var
        IntPosition: Integer;
    begin
        IF pCodSAFTNoSeries = '' THEN
            EXIT(TRUE);

        IntPosition := 1;

        CASE pTypeOfChar OF
            0:
                BEGIN
                    WHILE ((pCodSAFTNoSeries[IntPosition] IN ['0' .. '9'])) AND (IntPosition <= STRLEN(pCodSAFTNoSeries)) DO
                        IntPosition := IntPosition + 1;
                END;

            1:
                BEGIN
                    WHILE ((pCodSAFTNoSeries[IntPosition] IN ['0' .. '9']) OR
                        (UPPERCASE(FORMAT(pCodSAFTNoSeries[IntPosition])) IN ['A' .. 'Z'])) AND
                        (IntPosition <= STRLEN(pCodSAFTNoSeries)) DO
                        IntPosition := IntPosition + 1;
                END;
        END;


        IF IntPosition > STRLEN(pCodSAFTNoSeries) THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE)
    end;

    local procedure ValidateSAFTSequenceNo(pCodSAFTSequenceNo: Code[20])
    var
        TxtLastDigit: Text[1];
        IntPosition: Integer;
    begin
        IF pCodSAFTSequenceNo = '' THEN
            EXIT;
        TxtLastDigit := COPYSTR(pCodSAFTSequenceNo, STRLEN(pCodSAFTSequenceNo), 1);
        IF TxtLastDigit <> '1' THEN
            IF NOT CONFIRM(STRSUBSTNO(Text31022898, FIELDCAPTION("PTSS SAFT-T Sequential No.")), FALSE) THEN
                ERROR(Text31022893, FIELDCAPTION("PTSS SAFT-T Sequential No."));

        IntPosition := 1;

        WHILE ((pCodSAFTSequenceNo[IntPosition] IN ['0'])) AND (IntPosition <= (STRLEN(pCodSAFTSequenceNo) - 1)) DO
            IntPosition := IntPosition + 1;

        IF IntPosition <= (STRLEN(pCodSAFTSequenceNo) - 1) THEN
            IF NOT CONFIRM(STRSUBSTNO(Text31022898, FIELDCAPTION("PTSS SAFT-T Sequential No.")), FALSE) THEN
                ERROR(Text31022893, FIELDCAPTION("PTSS SAFT-T Sequential No."));
    end;

    var
        Text31022890: Label 'Length of field %1 can not be higher than %2.';
        Text31022891: Label '%1 can only have letters and digits.';
        Text31022892: Label '%1 can only have digits.';
        Text31022893: Label '%1 must have only zeros and end with digit 1.';
        Text31022898: Label '%1 must end with the digit 1. Are you sure you want to continue?';

}