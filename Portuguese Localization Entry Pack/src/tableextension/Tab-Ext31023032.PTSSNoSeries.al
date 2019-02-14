tableextension 31023032 "PTSS No. Series" extends "No. Series" //MyTargetTableId
{
    //Notas de Crédito de Acordo com a Fatura
    //Certificação Documentos
    fields
    {
        field(31022890; "PTSS SAF-T Invoice Type"; Option)
        {
            OptionMembers = " ","FT","FS","ND","NC",,"TV","TD","AA","DA","RP","RE","CS","LD","RA","FR";
            Caption = 'SAF-T Invoice Type';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF (xRec."PTSS SAF-T Invoice Type" <> xRec."PTSS SAF-T Invoice Type"::" ") AND (Rec."PTSS SAF-T Invoice Type" = Rec."PTSS SAF-T Invoice Type"::" ") THEN
                    MESSAGE(Text31022890);

                TESTFIELD("PTSS GTAT Document Type", "PTSS GTAT Document Type"::" ");
            end;
        }
        field(31022891; "PTSS GTAT Document Type"; Option)
        {
            OptionMembers = " ","GR","GT","GA","GC","GD";
            Caption = 'GTAT Document Type';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF NOT ("PTSS GTAT Document Type" IN ["PTSS GTAT Document Type"::" ", "PTSS GTAT Document Type"::GR, "PTSS GTAT Document Type"::GT,
                    "PTSS GTAT Document Type"::GA, "PTSS GTAT Document Type"::GC, "PTSS GTAT Document Type"::GD]) THEN
                    FIELDERROR("PTSS GTAT Document Type");
                TESTFIELD("PTSS SAF-T Invoice Type", "PTSS SAF-T Invoice Type"::" ");
            end;
        }

        field(31022892; "PTSS Credit Invoice"; Boolean)
        {
            Caption = 'Credit Invoice';
            DataClassification = CustomerContent;
            trigger Onvalidate()
            begin
                NoSeriesMgt.SetNoSeriesLineFilter(NoSeriesLine, Code, TODAY);
                IF NoSeriesLine."Last No. Used" <> '' THEN
                    ERROR(Text31022894, FIELDCAPTION("PTSS Credit Invoice"), Code)
            end;
        }

    }
    var
        NoSeriesLine: Record "No. Series Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Text31022890: Label 'This configuration as impact on SAFT extraction. Confirm this setup.';
        Text31022894: Label 'You cannot modify %1 on %2 because there are records in this series.';

}