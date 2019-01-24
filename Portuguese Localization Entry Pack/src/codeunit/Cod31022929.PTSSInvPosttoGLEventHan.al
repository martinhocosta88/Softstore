codeunit 31022929 "PTSS Inv. Post. to GL EventHan"
//Campo Conta Liquidação Notas de Crédito
{
    [EventSubscriber(ObjectType::Codeunit, 5802, 'OnAfterSetAccNo', '', true, true)]
    local procedure SetAccNo(var InvtPostingBuffer: Record "Invt. Posting Buffer"; ValueEntry: Record "Value Entry")
    var
        GenPostingSetup: Record "General Posting Setup";
    begin
        CASE InvtPostingBuffer."Account Type" OF
            InvtPostingBuffer."Account Type"::"Direct Cost Applied":
                BEGIN
                    //xxx
                    //resolver passagem do SourceIsPurchCrmemo da COD 5802
                    //IF SourceIsPurchCrMemo THEN BEGIN
                    GenPostingSetup.TESTFIELD("PTSS Cr.M Dir. Cost Appl. Acc.");
                    InvtPostingBuffer."Account No." := GenPostingSetup.GetDirectCostAppliedCMAccount;
                    //END;
                END;
        end;
    End;
}