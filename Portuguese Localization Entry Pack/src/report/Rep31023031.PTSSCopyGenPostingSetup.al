report 31023031 "PTSS Copy - Gen. Posting Setup"
{
    //Campo Conta Liquidação Notas de Crédito

    Caption = 'Copy - General Posting Setup';
    ProcessingOnly = true;

    dataset
    {
        dataitem("General Posting Setup"; "General Posting Setup")
        {
            DataItemTableView = SORTING ("Gen. Bus. Posting Group", "Gen. Prod. Posting Group");

            trigger OnAfterGetRecord()
            begin
                GenPostingSetup.FIND;
                IF CopySales THEN BEGIN
                    "Sales Account" := GenPostingSetup."Sales Account";
                    "Sales Credit Memo Account" := GenPostingSetup."Sales Credit Memo Account";
                    "Sales Line Disc. Account" := GenPostingSetup."Sales Line Disc. Account";
                    "Sales Inv. Disc. Account" := GenPostingSetup."Sales Inv. Disc. Account";
                    "Sales Pmt. Disc. Debit Acc." := GenPostingSetup."Sales Pmt. Disc. Debit Acc.";
                    "Sales Pmt. Disc. Credit Acc." := GenPostingSetup."Sales Pmt. Disc. Credit Acc.";
                    "Sales Pmt. Tol. Debit Acc." := GenPostingSetup."Sales Pmt. Tol. Debit Acc.";
                    "Sales Pmt. Tol. Credit Acc." := GenPostingSetup."Sales Pmt. Tol. Credit Acc.";
                    "Sales Prepayments Account" := GenPostingSetup."Sales Prepayments Account";
                END;

                IF CopyPurchases THEN BEGIN
                    "Purch. Account" := GenPostingSetup."Purch. Account";
                    "Purch. Credit Memo Account" := GenPostingSetup."Purch. Credit Memo Account";
                    "Purch. Line Disc. Account" := GenPostingSetup."Purch. Line Disc. Account";
                    "Purch. Inv. Disc. Account" := GenPostingSetup."Purch. Inv. Disc. Account";
                    "Purch. Pmt. Disc. Debit Acc." := GenPostingSetup."Purch. Pmt. Disc. Debit Acc.";
                    "Purch. Pmt. Disc. Credit Acc." := GenPostingSetup."Purch. Pmt. Disc. Credit Acc.";
                    "Purch. FA Disc. Account" := GenPostingSetup."Purch. FA Disc. Account";
                    "Purch. Pmt. Tol. Debit Acc." := GenPostingSetup."Purch. Pmt. Tol. Debit Acc.";
                    "Purch. Pmt. Tol. Credit Acc." := GenPostingSetup."Purch. Pmt. Tol. Credit Acc.";
                    "Purch. Prepayments Account" := GenPostingSetup."Purch. Prepayments Account";
                END;

                IF CopyInventory THEN BEGIN
                    "COGS Account" := GenPostingSetup."COGS Account";
                    "COGS Account (Interim)" := GenPostingSetup."COGS Account (Interim)";
                    "Inventory Adjmt. Account" := GenPostingSetup."Inventory Adjmt. Account";
                    "Invt. Accrual Acc. (Interim)" := GenPostingSetup."Invt. Accrual Acc. (Interim)";
                    "PTSS Cr.M Dir. Cost Appl. Acc." := GenPostingSetup."PTSS Cr.M Dir. Cost Appl. Acc."; //soft,n
                END;

                IF CopyManufacturing THEN BEGIN
                    "Direct Cost Applied Account" := GenPostingSetup."Direct Cost Applied Account";
                    "Overhead Applied Account" := GenPostingSetup."Overhead Applied Account";
                    "Purchase Variance Account" := GenPostingSetup."Purchase Variance Account";
                END;

                OnAfterCopyGenPostingSetup("General Posting Setup", GenPostingSetup);

                IF CONFIRM(Text000, FALSE) THEN
                    MODIFY;
            end;

            trigger OnPreDataItem()
            begin
                SETRANGE("Gen. Bus. Posting Group", UseGenPostingSetup."Gen. Bus. Posting Group");
                SETRANGE("Gen. Prod. Posting Group", UseGenPostingSetup."Gen. Prod. Posting Group");
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(GenBusPostingGroup; GenPostingSetup."Gen. Bus. Posting Group")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Gen. Bus. Posting Group';
                        TableRelation = "Gen. Business Posting Group";
                        ToolTip = 'Specifies the general business posting group to copy from.';
                    }
                    field(GenProdPostingGroup; GenPostingSetup."Gen. Prod. Posting Group")
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Gen. Prod. Posting Group';
                        TableRelation = "Gen. Product Posting Group";
                        ToolTip = 'Specifies general product posting group to copy from.';
                    }
                    field(Copy; Selection)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Copy';
                        OptionCaption = 'All fields,Selected fields';
                        ToolTip = 'Specifies if all fields or only selected fields are copied.';

                        trigger OnValidate()
                        begin
                            IF Selection = Selection::"All fields" THEN
                                AllFieldsSelectionOnValidate;
                        end;
                    }
                    field(SalesAccounts; CopySales)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Sales Accounts';
                        ToolTip = 'Specifies if you want to copy sales accounts.';

                        trigger OnValidate()
                        begin
                            Selection := Selection::"Selected fields";
                        end;
                    }
                    field(PurchaseAccounts; CopyPurchases)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Purchase Accounts';
                        ToolTip = 'Specifies if you want to copy purchase accounts.';

                        trigger OnValidate()
                        begin
                            Selection := Selection::"Selected fields";
                        end;
                    }
                    field(InventoryAccounts; CopyInventory)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Inventory Accounts';
                        ToolTip = 'Specifies if you want to copy inventory accounts.';

                        trigger OnValidate()
                        begin
                            Selection := Selection::"Selected fields";
                        end;
                    }
                    field(ManufacturingAccounts; CopyManufacturing)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Manufacturing Accounts';
                        ToolTip = 'Specifies if you want to copy manufacturing accounts.';

                        trigger OnValidate()
                        begin
                            Selection := Selection::"Selected fields";
                        end;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            IF Selection = Selection::"All fields" THEN BEGIN
                CopySales := TRUE;
                CopyPurchases := TRUE;
                CopyInventory := TRUE;
                CopyManufacturing := TRUE;
            END;
        end;
    }

    labels
    {
    }

    var
        Text000: Label 'Copy General Posting Setup?';
        UseGenPostingSetup: Record "General Posting Setup";
        GenPostingSetup: Record "General Posting Setup";
        CopySales: Boolean;
        CopyPurchases: Boolean;
        CopyInventory: Boolean;
        CopyManufacturing: Boolean;
        Selection: Option "All fields","Selected fields";

    [Scope('Personalization')]
    procedure SetGenPostingSetup(GenPostingSetup2: Record "General Posting Setup")
    begin
        UseGenPostingSetup := GenPostingSetup2;
    end;

    local procedure AllFieldsSelectionOnPush()
    begin
        CopySales := TRUE;
        CopyPurchases := TRUE;
        CopyInventory := TRUE;
        CopyManufacturing := TRUE;
    end;

    local procedure AllFieldsSelectionOnValidate()
    begin
        AllFieldsSelectionOnPush;
    end;

    [IntegrationEvent(TRUE, TRUE)]
    local procedure OnAfterCopyGenPostingSetup(var ToGeneralPostingSetup: Record "General Posting Setup"; FromGeneralPostingSetup: Record "General Posting Setup")
    begin
    end;
}

