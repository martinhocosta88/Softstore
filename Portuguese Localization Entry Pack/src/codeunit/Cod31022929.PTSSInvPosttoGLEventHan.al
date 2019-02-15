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

                    //IF SourceIsPurchCrMemo THEN BEGIN //Deixou de ser usar o booleano para usar o document type da Value Entry.
                    IF ValueEntry."Document Type" = ValueEntry."Document Type"::"Purchase Credit Memo" THEN BEGIN
                        GenPostingSetup.TESTFIELD("PTSS Cr.M Dir. Cost Appl. Acc.");
                        InvtPostingBuffer."Account No." := GenPostingSetup.GetDirectCostAppliedCMAccount;
                    END;
                END;
        end;
    End;
}