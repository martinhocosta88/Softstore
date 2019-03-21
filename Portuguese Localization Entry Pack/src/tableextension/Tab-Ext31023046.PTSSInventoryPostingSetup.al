tableextension 31023046 "PTSS Inventory Posting Setup" extends "Inventory Posting Setup"
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
            Caption = 'Losses in Inventory';
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

    var
        GLAccountCategoryMgt: Codeunit "G/L Account Category Mgt.";
        GLAccountCategory: Record "G/L Account Category";
        PostingSetupMgt: Codeunit PostingSetupManagement;

}