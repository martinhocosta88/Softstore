tableextension 31023046 "PTSS Inventory Posting Setup" extends "Inventory Posting Setup" //MyTargetTableId
{
    //Registo Inventário Físico
    fields
    {
        field(31022890; "PTSS Gains in Inventory"; Code[20])
        {
            Caption = 'Gains in Inventory';
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                GLAccountCategoryMgt.CheckGLAccount("PTSS Gains in Inventory", FALSE, FALSE, GLAccountCategory."Account Category"::Assets, GLAccountCategoryMgt.GetInventory);
            end;
        }
        field(31022891; "PTSS Losses in Inventory"; Code[20])
        {
            Caption = 'Gains in Inventory';
            TableRelation = "G/L Account";
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                GLAccountCategoryMgt.CheckGLAccount("PTSS Losses in Inventory", FALSE, FALSE, GLAccountCategory."Account Category"::Assets, GLAccountCategoryMgt.GetInventory);
            end;
        }
    }
    procedure GetGainsOnInvAccount(): Code[20]
    begin
        IF "PTSS Losses in Inventory" = '' THEN
            PostingSetupMgt.SendInvtPostingSetupNotification(Rec, FIELDCAPTION("PTSS Losses in Inventory"));
        TESTFIELD("PTSS Losses in Inventory");
        EXIT("PTSS Losses in Inventory");
    end;

    procedure GetLossesOnInvAccount(): Code[20]
    begin
        IF "PTSS Losses in Inventory" = '' THEN
            PostingSetupMgt.SendInvtPostingSetupNotification(Rec, FIELDCAPTION("PTSS Losses in Inventory"));
        TESTFIELD("PTSS Losses in Inventory");
        EXIT("PTSS Losses in Inventory");
    end;

    procedure SuggestSetupAccountsPT()
    var
        RecRef: RecordRef;
    begin
        RecRef.GETTABLE(Rec);
        IF "Inventory Account" = '' THEN
            SuggestAccountPT(RecRef, FIELDNO("Inventory Account"));
        IF "Inventory Account" = '' THEN
            SuggestAccountPT(RecRef, FIELDNO("Inventory Account (Interim)"));
        IF "WIP Account" = '' THEN
            SuggestAccountPT(RecRef, FIELDNO("WIP Account"));
        IF "Material Variance Account" = '' THEN
            SuggestAccountPT(RecRef, FIELDNO("Material Variance Account"));
        IF "Capacity Variance Account" = '' THEN
            SuggestAccountPT(RecRef, FIELDNO("Capacity Variance Account"));
        IF "Mfg. Overhead Variance Account" = '' THEN
            SuggestAccountPT(RecRef, FIELDNO("Mfg. Overhead Variance Account"));
        IF "Cap. Overhead Variance Account" = '' THEN
            SuggestAccountPT(RecRef, FIELDNO("Cap. Overhead Variance Account"));
        IF "Subcontracted Variance Account" = '' THEN
            SuggestAccountPT(RecRef, FIELDNO("Subcontracted Variance Account"));
        //Contas de perdas e ganhos PT
        IF "PTSS Gains in Inventory" = '' THEN
            SuggestAccountPT(RecRef, FIELDNO("PTSS Gains in Inventory"));
        IF "PTSS Losses in Inventory" = '' THEN
            SuggestAccountPT(RecRef, FIELDNO("PTSS Losses in Inventory"));
    end;


    Local procedure SuggestAccountPT(Var RecRef: RecordRef; AccountFieldNo: Integer)
    Var
        TempAccountUseBuffer: Record "Account Use Buffer";
        RecFieldRef: FieldRef;
        InvtPostingSetupRecRef: RecordRef;
        InvtPostingSetupFieldRef: FieldRef;
    begin
        InvtPostingSetupRecRef.OPEN(DATABASE::"Inventory Posting Setup");
        InvtPostingSetupRecRef.RESET;
        InvtPostingSetupFieldRef := InvtPostingSetupRecRef.FIELD(FIELDNO("Invt. Posting Group Code"));
        InvtPostingSetupFieldRef.SETFILTER('<>%1', "Invt. Posting Group Code");
        InvtPostingSetupFieldRef := InvtPostingSetupRecRef.FIELD(FIELDNO("Location Code"));
        InvtPostingSetupFieldRef.SETRANGE("Location Code");
        TempAccountUseBuffer.UpdateBuffer(InvtPostingSetupRecRef, AccountFieldNo);

        InvtPostingSetupRecRef.CLOSE;

        TempAccountUseBuffer.RESET;
        TempAccountUseBuffer.SETCURRENTKEY("No. of Use");
        IF TempAccountUseBuffer.FINDLAST THEN BEGIN
            RecFieldRef := RecRef.FIELD(AccountFieldNo);
            RecFieldRef.VALUE(TempAccountUseBuffer."Account No.");
        END;
    end;

    var
        GLAccountCategoryMgt: Codeunit "G/L Account Category Mgt.";
        GLAccountCategory: Record "G/L Account Category";
        PostingSetupMgt: Codeunit PostingSetupManagement;

}