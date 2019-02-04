tableextension 31023032 "PTSS No. Series" extends "No. Series" //MyTargetTableId
{
    //Notas de Crédito de Acordo com a Fatura
    fields
    {
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
        Text31022894: Label 'You cannot modify %1 on %2 because there are records in this series.';
}