page 31023080 "PTSS Series Groups Card SGRP"
{
    // Series Group

    Caption = 'Series Groups Card';
    PageType = Card;
    SourceTable = "PTSS Series Groups SGRP";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(Code; Code)
                {
                }
                field(Type; Type)
                {
                }
            }
            group(Numeration)
            {
                Caption = 'Numeration';
                field(Quote; Quote)
                {
                    ApplicationArea = All;
                }
                field(Order; Order)
                {
                    ApplicationArea = All;
                }
                field("Blanket Order"; "Blanket Order")
                {
                    ApplicationArea = All;
                }
                field(Invoice; Invoice)
                {
                    ApplicationArea = All;
                }
                field("Credit Memo"; "Credit Memo")
                {
                    ApplicationArea = All;
                }
                field(Return; Return)
                {
                    ApplicationArea = All;
                }
                field(Reminder; Reminder)
                {
                    ApplicationArea = All;
                }
                field("Finance Charge Memo"; "Finance Charge Memo")
                {
                    ApplicationArea = All;
                }
                field("Shipment/Receipts"; "Shipment/Receipts")
                {
                    ApplicationArea = All;
                }
                field(Transfer; Transfer)
                {
                    ApplicationArea = All;
                }
                field("Ship. Transfer"; "Ship. Transfer")
                {
                    ApplicationArea = All;
                }
                field("Receipt Transfer"; "Receipt Transfer")
                {
                    ApplicationArea = All;
                }
                field("Posted Invoice"; "Posted Invoice")
                {
                    ApplicationArea = All;
                }
                field("Posted Credit Memo"; "Posted Credit Memo")
                {
                    ApplicationArea = All;
                }
                field("Posted Ret. Receipts/Ship."; "Posted Ret. Receipts/Ship.")
                {
                    ApplicationArea = All;
                }
                field("Issued Reminder"; "Issued Reminder")
                {
                    ApplicationArea = All;
                }
                field("Issued F. Charge Memo"; "Issued F. Charge Memo")
                {
                    ApplicationArea = All;
                }
                field(Shipment; Shipment)
                {
                    ApplicationArea = All;
                }
                field("Posted Shipment"; "Posted Shipment")
                {
                    ApplicationArea = All;
                }
                field(Receipt; Receipt)
                {
                    ApplicationArea = All;
                }
                field("Posted Receipt"; "Posted Receipt")
                {
                    ApplicationArea = All;
                }
                field("Put-away"; "Put-away")
                {
                    ApplicationArea = All;
                }
                field("Register Put-away"; "Register Put-away")
                {
                    ApplicationArea = All;
                }
                field(Pick; Pick)
                {
                    ApplicationArea = All;
                }
                field("Register Pick"; "Register Pick")
                {
                    ApplicationArea = All;
                }
                field(Contract; Contract)
                {
                    ApplicationArea = All;
                }
                field("Service Quote"; "Service Quote")
                {
                    ApplicationArea = All;
                }
                field("Service Order"; "Service Order")
                {
                    ApplicationArea = All;
                }
                field("<Debit Memo>"; "Debit Memo")
                {
                    ApplicationArea = All;
                    Caption = 'Debit Memo';
                }
                field("<Posted Debit Memo>"; "Posted Debit Memo")
                {
                    ApplicationArea = All;
                    Caption = 'Posted Debit Memo';
                }
                field("Posted F. Charge Memo"; "Posted F. Charge Memo")
                {
                }
                field("Posted Reminder"; "Posted Reminder")
                {
                }
            }
        }
    }

    actions
    {
    }
}

