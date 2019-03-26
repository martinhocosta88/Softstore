codeunit 31022938 "PTSS TransactionNoMgmt"
//Transaction No.
{
    [EventSubscriber(ObjectType::Table, 81, 'OnSetUpNewLineOnBeforeIncrDocNo', '', true, true)]
    local procedure SetUpNewLinePT(VAR GenJournalLine: Record "Gen. Journal Line"; LastGenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."PTSS Transaction No." := LastGenJournalLine."PTSS Transaction No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnBeforeCode', '', true, true)]
    local procedure OnBeforeCodePT(var GenJnlLine: Record "Gen. Journal Line"; CheckLine: Boolean; var IsPosted: Boolean; var GLReg: Record "G/L Register")
    begin
        LastTempTransNo := GenJnlLine."PTSS Transaction No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnBeforeStartPosting', '', true, True)]
    local procedure StartPostingPT(var GenJournalLine: Record "Gen. Journal Line");
    begin
        LastTempTransNo := GenJournalLine."PTSS Transaction No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnBeforeContinuePosting', '', true, true)]
    local procedure ContinuePostingPT(var GenJournalLine: Record "Gen. Journal Line");
    begin
        LastTempTransNo := GenJournalLine."PTSS Transaction No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, 12, 'OnNextTransactionNoNeeded', '', true, true)]
    local procedure NextTransactionNoNeededPT(GenJnlLine: Record "Gen. Journal Line"; LastDocType: Option; LastDocNo: Code[20]; LastDate: Date; CurrentBalance: Decimal; CurrentBalanceACY: Decimal; var NewTransaction: Boolean)
    var
        GenJnlTemplate: Record "Gen. Journal Template";
    begin
        With GenJnlLine do BEGIN
            IF NOT GenJnlTemplate.GET("Journal Template Name") THEN
                GenJnlTemplate.INIT;
            NewTransaction := (LastDate <> "Posting Date") OR GenJnlTemplate."Force Doc. Balance" AND (LastDocNo <> "Document No.") OR
        (LastTempTransNo <> "PTSS Transaction No.") AND (NOT GenJnlTemplate."Force Doc. Balance");
        END;
    end;

    //Pedido de evento para codeunit 13 OnAfterCopyRegister
    // [EventSubscriber(ObjectType::Codeunit, 13, 'OnAfterCopyRegister', '', true, true)]
    // local procedure CopyRegisterPT(Var GenJournalLine: Record "Gen. Journal Line"; GLReg: Record "G/L Register"; GLRegNo: Integer)
    // begin
    //     With GenJournalLine DO BEGIN
    //         IF GLReg.FINDLAST THEN
    //             GLRegNo := GLReg."No."
    //         ELSE
    //             GLRegNo := 0;
    //         INIT;
    //         "Line No." := GLRegNo;
    //     END;
    // end;

    [EventSubscriber(ObjectType::Codeunit, 13, 'OnAfterProcessBalanceOfLines', '', true, true)]
    local procedure SetPTKeys(var GenJournalLine: Record "Gen. Journal Line")
    var
        GenJnlTemplate: Record "Gen. Journal Template";
    begin
        GenJnlTemplate.get(GenJournalLine."Journal Template Name");
        IF GenJnlTemplate."Force Doc. Balance" THEN
            GenJournalLine.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", "Posting Date", "Document No.")
        ELSE
            GenJournalLine.SETCURRENTKEY("Journal Template Name", "Journal Batch Name", "Posting Date", "PTSS Transaction No.");
    end;


    var
        LastTempTransNo: Integer;


}