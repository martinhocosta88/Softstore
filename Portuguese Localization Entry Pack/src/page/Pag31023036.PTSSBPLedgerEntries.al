page 31023036 "PTSS BP Ledger Entries"
{
    // COPE

    Caption = 'BP Ledger Entry';
    InsertAllowed = false;
    PageType = List;
    SourceTable = "PTSS BP Ledger Entry";
    UsageCategory = History;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Year; Year)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Month; Month)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Finance Institution ID"; "Finance Institution ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Company ID"; "Company ID")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Identification Code"; "Identification Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Reference Date"; "Reference Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field("Record Nature"; "Record Nature")
                {
                    ApplicationArea = All;
                }
                field("NPC 2nd Intervener"; "NPC 2nd Intervener")
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Statistic Code"; "Statistic Code")
                {
                    ApplicationArea = All;
                }
                field("Amount Type"; "Amount Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Account Type"; "Account Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = true;
                }
                field("IF Code"; "IF Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = true;
                }
                field("Foreign Country Code"; "Foreign Country Code")
                {
                    ApplicationArea = All;
                }
                field("Counterpart Country Code"; "Counterpart Country Code")
                {
                    ApplicationArea = All;
                }
                field("Active Country Code"; "Active Country Code")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; "Due Date")
                {
                    ApplicationArea = All;
                }
                field("Counterpart ID"; "Counterpart ID")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Generate Ledger Entries")
                {
                    ApplicationArea = All;
                    Caption = 'Generate Ledger Entries';
                    Image = Process;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        TrackingPage: Page "Order Tracking";
                    begin
                        REPORT.RUNMODAL(REPORT::"PTSS BP Process");
                    end;
                }
                action("<Action32>")
                {
                    ApplicationArea = All;
                    Caption = 'Export XML';
                    Image = Export;
                    trigger OnAction()
                    var
                        BPXMLDate: Page "PTSS BP XML Date";

                    begin
                        BPXMLDate.RUNMODAL;
                    end;
                }
                action("Cancel Export")
                {
                    ApplicationArea = All;
                    Caption = 'Cancel Export';
                    Image = ReverseRegister;
                    ToolTip = 'Modifies status for the ledger entry, in order to be able to be exported again.';

                    trigger OnAction()
                    var
                        BPXMLDate: Page "PTSS BP XML Date";
                    begin
                        TESTFIELD(Status, Status::Exported);
                        IF CONFIRM(ConfirmCancelStatusExp, FALSE) THEN BEGIN
                            Status := Status::" ";
                            MODIFY;
                        END;
                    end;
                }
            }
        }
    }

    var
        ConfirmCancelStatusExp: Label 'Do you wish to cancel the ledger entry export?';
}

