codeunit 31022918 "PTSS AT Inv. Comm. Management"
{
    //AT Inventory Communication
    procedure GetATProductCategory(CategoryCode: Code[20]): Text
    var
        ItemCategory: Record "Item Category";
    begin
        WITH ItemCategory DO BEGIN
            GET(CategoryCode);
            TESTFIELD("PTSS AT Item Category");
            EXIT(COPYSTR(FORMAT("PTSS AT Item Category"), 1, 1));
        END;
    end;

    procedure GetProductNumberCode(Item: Record Item): Text
    var
        ItemCrossRef: Record "Item Cross Reference";
    begin
        WITH ItemCrossRef DO BEGIN
            SETRANGE("Item No.", Item."No.");
            SETRANGE("Variant Code", Item."Variant Filter");
            SETRANGE("Unit of Measure", Item."Base Unit of Measure");
            SETRANGE("Cross-Reference Type", "Cross-Reference Type"::"Bar Code");
            SETRANGE("Cross-Reference Type No.", '');
            IF FINDFIRST THEN
                EXIT(FORMAT("Cross-Reference No.", 0))
            ELSE
                EXIT(FORMAT(Item."No.", 0));
        END;
    end;

    procedure GetClosingStockQuantity(ItemNo: Code[20]): Text
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        WITH ItemLedgerEntry DO BEGIN
            RESET;
            SETRANGE("Item No.", ItemNo);
            SETRANGE("Posting Date", 0D, EndDate);
            CALCFIELDS("PTSS Location Type");
            SETRANGE("PTSS Location Type", "PTSS Location Type"::Internal);
            CALCSUMS(Quantity);
            EXIT(FORMAT(Quantity, 0, '<Precision,2:2><Standard Format,9>'));
        END;
    end;

    procedure CommATLog()
    var
        ATInvCommLog: Record "PTSS AT Inventory Comm. Log";
        EntryNo: Integer;
    begin
        WITH ATInvCommLog DO BEGIN
            IF FINDLAST THEN
                EntryNo := "Entry No." + 1
            ELSE
                EntryNo := 1;

            CLEAR(ATInvCommLog);
            "Entry No." := EntryNo;
            "Date/Time" := CURRENTDATETIME;
            "User ID" := USERID;
            "Fiscal Year" := FiscalYear;
            "Ending Date" := EndDate;
            "Last Item Ledger Entry No." := LastEntryNo;
            INSERT;
        END;
    end;

    procedure FormatDecimal(Value: Text): Text
    begin
        EXIT(CONVERTSTR(Value, '.', ','));
    end;

    procedure SetData(Month: Integer; Year: Integer)
    var
        Period: Record 50;
        InventoryPeriod: Record "Inventory Period";
        Text31022894: Label 'There are Inventory Periods open in this fiscal year.';
    begin
        Month += 1;
        EndDate := CALCDATE('<CM>', DMY2DATE(1, Month, Year));

        Period.RESET;
        Period.SETRANGE("New Fiscal Year", TRUE);
        Period.SETFILTER("Starting Date", '<=%1', EndDate);
        Period.FINDLAST;

        InventoryPeriod.SETRANGE("Ending Date", Period."Starting Date", EndDate);
        InventoryPeriod.SETRANGE(Closed, FALSE);
        IF NOT InventoryPeriod.ISEMPTY THEN
            ERROR(Text31022894);

        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETRANGE("Posting Date", 0D, EndDate);
        ItemLedgerEntry.FINDLAST;
        LastEntryNo := ItemLedgerEntry."Entry No.";

        FiscalYear := DATE2DMY(Period."Starting Date", 3);
    end;

    var
        EndDate: Date;
        ItemLedgerEntry: Record "Item Ledger Entry";
        LastEntryNo: Integer;
        FiscalYear: Integer;
}