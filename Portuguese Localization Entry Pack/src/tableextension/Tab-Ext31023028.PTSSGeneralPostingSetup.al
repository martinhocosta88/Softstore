tableextension 31023028 "PTSS General Posting Setup" extends "General Posting Setup" //MyTargetTableId
//Campo Conta Liquidação Notas de Crédito
{
    fields
    {
        field(31022893; "PTSS Cr.M Dir. Cost Appl. Acc."; Code[20])
        {
            Caption = 'Cr. Memo Direct Cost Applied Account';
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                //XXX
                //CheckGLAcc("Cr.Memo Direct Cost Appl. Acc.");
                //O código comentado substitui o código abaixo. foi pedido para colocar a função external no GIT.
                IF "PTSS Cr.M Dir. Cost Appl. Acc." <> '' THEN BEGIN
                    GLAcc.GET("PTSS Cr.M Dir. Cost Appl. Acc.");
                    GLAcc.CheckGLAcc;
                END;
            end;
        }
    }
    procedure GetDirectCostAppliedCMAccount(): Code[20]
    var
        PostingSetupMgt: Codeunit PostingSetupManagement;
    begin
        IF "PTSS Cr.M Dir. Cost Appl. Acc." = '' THEN
            PostingSetupMgt.SendGenPostingSetupNotification(Rec, FIELDCAPTION("PTSS Cr.M Dir. Cost Appl. Acc."));

        TESTFIELD("PTSS Cr.M Dir. Cost Appl. Acc.");
        EXIT("PTSS Cr.M Dir. Cost Appl. Acc.");
    end;

    var
        GLAcc: Record "G/L Account";
}