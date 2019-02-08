codeunit 31022933 "PTSS PhysInvManagement"
{
    //Registo Inventário Físico
    [EventSubscriber(ObjectType::Codeunit, 5802, 'OnPostInvtPostBufferOnBeforeFind', '', true, true)]
    local procedure PostInvtPOstBufPT(var GlobalInvtPostBuf: Record "Invt. Posting Buffer")
    var
        GenJnlLine: Record "Gen. Journal Line";
        InvtPostSetup: Record "Inventory Posting Setup";
        GenPostingSetup: Record "General Posting Setup";
        LocationCode: Code[10];
        InventoryPOstGroup: Code[10];
    begin
        With GlobalInvtPostBuf DO begin
            IF NOT FINDSET THEN
                EXIT;

            repeat
                IF SetAmt(GenJnlLine, Amount, "Amount (ACY)") THEN BEGIN
                    IF PhysInventory AND (GlobalInvtPostBuf."Account Type" = GlobalInvtPostBuf."Account Type"::Inventory) THEN BEGIN
                        LocationCode := GlobalInvtPostBuf."Location Code";
                        InventoryPostGroup := GlobalInvtPostBuf."Inventory Posting Group";
                    END;
                    IF PhysInventory AND (GlobalInvtPostBuf."Account Type" = GlobalInvtPostBuf."Account Type"::"Inventory Adjmt.") THEN BEGIN
                        InvtPostSetup.GET(LocationCode, InventoryPostGroup);
                        GenPostingSetup.GET(GlobalInvtPostBuf."Gen. Bus. Posting Group", GlobalInvtPostBuf."Gen. Prod. Posting Group");
                        GenJnlLine."Account No." := GenPostingSetup.GetInventoryAdjmtAccount;
                        SetAmt(GenJnlLine, -Amount, -"Amount (ACY)");
                        IF PostToGLPT THEN
                            GenJnlPostLine.RunWithCheck(GenJnlLine)
                        ELSE
                            GenJnlCheckLine.RunCheck(GenJnlLine);
                        IF PrevAdjustmentAcc <> '' THEN
                            GenJnlLine."Account No." := PrevAdjustmentAcc
                        ELSE BEGIN
                            IF Amount < 0 THEN
                                GenJnlLine."Account No." := InvtPostSetup.GetGainsOnInvAccount
                            ELSE
                                GenJnlLine."Account No." := InvtPostSetup.GetLossesOnInvAccount()
                        END;
                        SetAmt(GenJnlLine, Amount, "Amount (ACY)");
                        IF PostToGLPT THEN
                            GenJnlPostLine.RunWithCheck(GenJnlLine)
                        ELSE
                            GenJnlCheckLine.RunCheck(GenJnlLine);
                    END;
                End;
            Until Next = 0;
        END;

    end;

    [EventSubscriber(ObjectType::Codeunit, 5802, 'OnAfterCalcCostToPostFromBuffer', '', true, true)]
    local procedure BufferInvtPostingPT(var ValueEntry: Record "Value Entry"; var CostToPost: Decimal; var CostToPostACY: Decimal; var ExpCostToPost: Decimal; var ExpCostToPostACY: Decimal)
    begin
        PostToGLPT := FALSE;
        IF (CostToPost <> 0) OR (CostToPostACY <> 0) THEN
            PostToGLPT := TRUE;
    end;

    [EventSubscriber(ObjectType::Codeunit, 22, 'OnBeforeInsertValueEntry', '', true, true)]
    local procedure InsertValueEntryPT(var ValueEntry: Record "Value Entry"; ItemJournalLine: Record "Item Journal Line"; var ItemLedgerEntry: Record "Item Ledger Entry"; var ValueEntryNo: Integer; var InventoryPostingToGL: Codeunit "Inventory Posting To G/L")
    var
        Item: Record Item;
    begin
        IF ValueEntry.Inventoriable AND NOT Item."Inventory Value Zero" THEN
            GetPhysicalInv(ValueEntry);
    end;

    [EventSubscriber(ObjectType::Codeunit, 22, 'OnBeforeInsertCorrValueEntry', '', true, true)]
    local procedure InsertCorrValueEntryPT(var NewValueEntry: Record "Value Entry"; OldValueEntry: Record "Value Entry"; var ItemJournalLine: Record "Item Journal Line")
    var
        Item: Record Item;
    begin
        IF NewValueEntry.Inventoriable AND NOT Item."Inventory Value Zero" THEN
            GetPhysicalInv(NewValueEntry);
    end;

    local procedure SetAmt(VAR GenJnlLine: Record "Gen. Journal Line"; Amt: Decimal; AmtACY: Decimal): Boolean
    begin
        WITH GenJnlLine DO BEGIN
            "Additional-Currency Posting" := "Additional-Currency Posting"::None;
            VALIDATE(Amount, Amt);

            GetGLSetup;
            IF GLSetup."Additional Reporting Currency" <> '' THEN BEGIN
                "Source Currency Code" := GLSetup."Additional Reporting Currency";
                "Source Currency Amount" := AmtACY;
                IF (Amount = 0) AND ("Source Currency Amount" <> 0) THEN BEGIN
                    "Additional-Currency Posting" :=
                        "Additional-Currency Posting"::"Additional-Currency Amount Only";
                    VALIDATE(Amount, "Source Currency Amount");
                    "Source Currency Amount" := 0;
                END;
            END;
        END;

        EXIT((Amt <> 0) OR (AmtACY <> 0));
    end;


    local procedure GetGLSetup()
    var
        GLSetupRead: Boolean;
        Currency: Record Currency;
    begin
        IF NOT GLSetupRead THEN BEGIN
            GLSetup.GET;
            IF GLSetup."Additional Reporting Currency" <> '' THEN
                Currency.GET(GLSetup."Additional Reporting Currency");
        END;
        GLSetupRead := TRUE;

    end;

    local procedure GetPhysicalInventory(PhysicalInventory: Boolean; TempLocation: Code[10]; TempPosting: Code[10]; PrevAdjAcc: Text[20])
    begin
        PhysInventory := PhysicalInventory;
        TempLocationCode := TempLocation;
        TempPostingGroup := TempPosting;
        PrevAdjustmentAcc := PrevAdjAcc;
    end;

    procedure GetPhysicalInv(ValueEntry: Record "Value Entry")
    var
        PhysInvLedgEntry: Record "Phys. Inventory Ledger Entry";
        GLEntry: Record "G/L Entry";
        IsPhysInventory: Boolean;
        PrevAdjAcc: Text;
    begin
        WITH ValueEntry DO BEGIN
            IsPhysInventory := FALSE;
            PhysInvLedgEntry.SETCURRENTKEY("Document No.", "Posting Date");
            PhysInvLedgEntry.SETRANGE(PhysInvLedgEntry."Document No.", "Document No.");
            IF NOT PhysInvLedgEntry.ISEMPTY THEN BEGIN
                PhysInvLedgEntry.FINDSET;
                IsPhysInventory := TRUE;
                GLEntry.SETCURRENTKEY("Document No.", "Posting Date");
                GLEntry.SETRANGE(GLEntry."Document No.", "Document No.");
                IF NOT GLEntry.ISEMPTY THEN BEGIN
                    GLEntry.FINDLAST;
                    //resolver passagem do CalledFromAdjustment
                    // IF CalledFromAdjustment THEN
                    //     PrevAdjAcc := GLEntry."G/L Account No.";
                END;
            END;

            IF (("Item Ledger Entry Type" IN ["Item Ledger Entry Type"::"Negative Adjmt.", "Item Ledger Entry Type"::"Positive Adjmt."]) AND
              ("Entry Type" = "Entry Type"::"Direct Cost") AND Adjustment AND IsPhysInventory) OR ItemJnlLine."Phys. Inventory" THEN
                GetPhysicalInventory(TRUE, ItemJnlLine."Location Code", ItemJnlLine."Inventory Posting Group", PrevAdjAcc)
            ELSE
                GetPhysicalInventory(FALSE, ItemJnlLine."Location Code", ItemJnlLine."Inventory Posting Group", PrevAdjAcc);
        END;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        PhysInventory: Boolean;
        TempLocationCode: Code[10];
        TempPostingGroup: Code[10];
        PrevAdjustmentAcc: Text[20];
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
        PostToGLPT: Boolean;
        ItemJnlLine: Record "Item Journal Line";

}