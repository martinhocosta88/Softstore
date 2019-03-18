// report 31023107 "PTSS Get Source Documents SGRP"
// {
//     // Series Groups
//     Caption = 'Get Source Documents';
//     ProcessingOnly = true;

//     dataset
//     {
//         dataitem("Warehouse Request"; "Warehouse Request")
//         {
//             DataItemTableView = WHERE ("Document Status" = CONST (Released),
//                                       "Completely Handled" = FILTER (false));
//             RequestFilterFields = "Source Document", "Source No.";
//             dataitem("Sales Header"; "Sales Header")
//             {
//                 DataItemLink = "Document Type" = FIELD ("Source Subtype"),
//                                "No." = FIELD ("Source No.");
//                 DataItemTableView = SORTING ("Document Type", "No.");
//                 dataitem("Sales Line"; "Sales Line")
//                 {
//                     DataItemLink = "Document Type" = FIELD ("Document Type"),
//                                    "Document No." = FIELD ("No.");
//                     DataItemTableView = SORTING ("Document Type", "Document No.", "Line No.");

//                     trigger OnAfterGetRecord()
//                     begin
//                         VerifyItemNotBlocked("No.");
//                         IF "Location Code" = "Warehouse Request"."Location Code" THEN
//                             CASE RequestType OF
//                                 RequestType::Receive:
//                                     IF WhseActivityCreate.CheckIfSalesLine2ReceiptLine("Sales Line") THEN BEGIN
//                                         IF NOT OneHeaderCreated AND NOT WhseHeaderCreated THEN
//                                             CreateReceiptHeader;
//                                         IF NOT WhseActivityCreate.SalesLine2ReceiptLine(WhseReceiptHeader, "Sales Line") THEN
//                                             ErrorOccured := TRUE;
//                                         LineCreated := TRUE;
//                                     END;
//                                 RequestType::Ship:
//                                     IF WhseActivityCreate.CheckIfFromSalesLine2ShptLine("Sales Line") THEN BEGIN
//                                         IF Cust.Blocked <> Cust.Blocked::" " THEN BEGIN
//                                             IF NOT SalesHeaderCounted THEN BEGIN
//                                                 SkippedSourceDoc += 1;
//                                                 SalesHeaderCounted := TRUE;
//                                             END;
//                                             CurrReport.SKIP;
//                                         END;

//                                         IF NOT OneHeaderCreated AND NOT WhseHeaderCreated THEN
//                                             CreateShptHeader;
//                                         IF NOT WhseActivityCreate.FromSalesLine2ShptLine(WhseShptHeader, "Sales Line") THEN
//                                             ErrorOccured := TRUE;
//                                         LineCreated := TRUE;
//                                     END;
//                             END;
//                     end;

//                     trigger OnPostDataItem()
//                     begin
//                         IF WhseHeaderCreated THEN BEGIN
//                             UpdateReceiptHeaderStatus;
//                             CheckFillQtyToHandle;
//                         END;

//                         OnAfterProcessDocumentLine(WhseShptHeader, "Warehouse Request", LineCreated);
//                     end;

//                     trigger OnPreDataItem()
//                     begin
//                         SETRANGE(Type, Type::Item);
//                         IF (("Warehouse Request".Type = "Warehouse Request".Type::Outbound) AND
//                             ("Warehouse Request"."Source Document" = "Warehouse Request"."Source Document"::"Sales Order")) OR
//                            (("Warehouse Request".Type = "Warehouse Request".Type::Inbound) AND
//                             ("Warehouse Request"."Source Document" = "Warehouse Request"."Source Document"::"Sales Return Order"))
//                         THEN
//                             SETFILTER("Outstanding Quantity", '>0')
//                         ELSE
//                             SETFILTER("Outstanding Quantity", '<0');
//                         SETRANGE("Drop Shipment", FALSE);
//                         SETRANGE("Job No.", '');
//                     end;
//                 }

//                 trigger OnAfterGetRecord()
//                 begin
//                     TESTFIELD("Sell-to Customer No.");
//                     Cust.GET("Sell-to Customer No.");
//                     IF NOT SkipBlockedCustomer THEN
//                         Cust.CheckBlockedCustOnDocs(Cust, "Document Type", FALSE, FALSE);
//                     SalesHeaderCounted := FALSE;
//                 end;

//                 trigger OnPreDataItem()
//                 begin
//                     IF "Warehouse Request"."Source Type" <> DATABASE::"Sales Line" THEN
//                         CurrReport.BREAK;
//                 end;
//             }
//             dataitem("Purchase Header"; "Purchase Header")
//             {
//                 DataItemLink = "Document Type" = FIELD ("Source Subtype"),
//                                "No." = FIELD ("Source No.");
//                 DataItemTableView = SORTING ("Document Type", "No.");
//                 dataitem("Purchase Line"; "Purchase Line")
//                 {
//                     DataItemLink = "Document Type" = FIELD ("Document Type"),
//                                    "Document No." = FIELD ("No.");
//                     DataItemTableView = SORTING ("Document Type", "Document No.", "Line No.");

//                     trigger OnAfterGetRecord()
//                     begin
//                         VerifyItemNotBlocked("No.");
//                         IF "Location Code" = "Warehouse Request"."Location Code" THEN
//                             CASE RequestType OF
//                                 RequestType::Receive:
//                                     IF WhseActivityCreate.CheckIfPurchLine2ReceiptLine("Purchase Line") THEN BEGIN
//                                         IF NOT OneHeaderCreated AND NOT WhseHeaderCreated THEN
//                                             CreateReceiptHeader;
//                                         IF NOT WhseActivityCreate.PurchLine2ReceiptLine(WhseReceiptHeader, "Purchase Line") THEN
//                                             ErrorOccured := TRUE;
//                                         LineCreated := TRUE;
//                                     END;
//                                 RequestType::Ship:
//                                     IF WhseActivityCreate.CheckIfFromPurchLine2ShptLine("Purchase Line") THEN BEGIN
//                                         IF NOT OneHeaderCreated AND NOT WhseHeaderCreated THEN
//                                             CreateShptHeader;
//                                         IF NOT WhseActivityCreate.FromPurchLine2ShptLine(WhseShptHeader, "Purchase Line") THEN
//                                             ErrorOccured := TRUE;
//                                         LineCreated := TRUE;
//                                     END;
//                             END;
//                     end;

//                     trigger OnPostDataItem()
//                     begin
//                         IF WhseHeaderCreated THEN BEGIN
//                             UpdateReceiptHeaderStatus;
//                             CheckFillQtyToHandle;
//                         END;

//                         OnAfterProcessDocumentLine(WhseShptHeader, "Warehouse Request", LineCreated);
//                     end;

//                     trigger OnPreDataItem()
//                     begin
//                         SETRANGE(Type, Type::Item);
//                         IF (("Warehouse Request".Type = "Warehouse Request".Type::Inbound) AND
//                             ("Warehouse Request"."Source Document" = "Warehouse Request"."Source Document"::"Purchase Order")) OR
//                            (("Warehouse Request".Type = "Warehouse Request".Type::Outbound) AND
//                             ("Warehouse Request"."Source Document" = "Warehouse Request"."Source Document"::"Purchase Return Order"))
//                         THEN
//                             SETFILTER("Outstanding Quantity", '>0')
//                         ELSE
//                             SETFILTER("Outstanding Quantity", '<0');
//                         SETRANGE("Drop Shipment", FALSE);
//                         SETRANGE("Job No.", '');
//                     end;
//                 }

//                 trigger OnPreDataItem()
//                 begin
//                     IF "Warehouse Request"."Source Type" <> DATABASE::"Purchase Line" THEN
//                         CurrReport.BREAK;
//                 end;
//             }
//             dataitem("Transfer Header"; "Transfer Header")
//             {
//                 DataItemLink = "No." = FIELD ("Source No.");
//                 DataItemTableView = SORTING ("No.");
//                 dataitem("Transfer Line"; "Transfer Line")
//                 {
//                     DataItemLink = "Document No." = FIELD ("No.");
//                     DataItemTableView = SORTING ("Document No.", "Line No.");

//                     trigger OnAfterGetRecord()
//                     begin
//                         CASE RequestType OF
//                             RequestType::Receive:
//                                 IF WhseActivityCreate.CheckIfTransLine2ReceiptLine("Transfer Line") THEN BEGIN
//                                     IF NOT OneHeaderCreated AND NOT WhseHeaderCreated THEN
//                                         CreateReceiptHeader;
//                                     IF NOT WhseActivityCreate.TransLine2ReceiptLine(WhseReceiptHeader, "Transfer Line") THEN
//                                         ErrorOccured := TRUE;
//                                     LineCreated := TRUE;
//                                 END;
//                             RequestType::Ship:
//                                 IF WhseActivityCreate.CheckIfFromTransLine2ShptLine("Transfer Line") THEN BEGIN
//                                     IF NOT OneHeaderCreated AND NOT WhseHeaderCreated THEN
//                                         CreateShptHeader;
//                                     IF NOT WhseActivityCreate.FromTransLine2ShptLine(WhseShptHeader, "Transfer Line") THEN
//                                         ErrorOccured := TRUE;
//                                     LineCreated := TRUE;
//                                 END;
//                         END;
//                     end;

//                     trigger OnPostDataItem()
//                     begin
//                         IF WhseHeaderCreated THEN BEGIN
//                             UpdateReceiptHeaderStatus;
//                             CheckFillQtyToHandle;
//                         END;

//                         OnAfterProcessDocumentLine(WhseShptHeader, "Warehouse Request", LineCreated);
//                     end;

//                     trigger OnPreDataItem()
//                     begin
//                         CASE "Warehouse Request"."Source Subtype" OF
//                             0:
//                                 SETFILTER("Outstanding Quantity", '>0');
//                             1:
//                                 SETFILTER("Qty. in Transit", '>0');
//                         END;
//                     end;
//                 }

//                 trigger OnPreDataItem()
//                 begin
//                     IF "Warehouse Request"."Source Type" <> DATABASE::"Transfer Line" THEN
//                         CurrReport.BREAK;
//                 end;
//             }
//             dataitem("Service Header"; "Service Header")
//             {
//                 DataItemLink = "Document Type" = FIELD ("Source Subtype"),
//                                "No." = FIELD ("Source No.");
//                 DataItemTableView = SORTING ("Document Type", "No.");
//                 dataitem("Service Line"; "Service Line")
//                 {
//                     DataItemLink = "Document Type" = FIELD ("Document Type"),
//                                    "Document No." = FIELD ("No.");
//                     DataItemTableView = SORTING ("Document Type", "Document No.", "Line No.");

//                     trigger OnAfterGetRecord()
//                     begin
//                         IF "Location Code" = "Warehouse Request"."Location Code" THEN
//                             CASE RequestType OF
//                                 RequestType::Ship:
//                                     IF WhseActivityCreate.CheckIfFromServiceLine2ShptLin("Service Line") THEN BEGIN
//                                         IF NOT OneHeaderCreated AND NOT WhseHeaderCreated THEN
//                                             CreateShptHeader;
//                                         IF NOT WhseActivityCreate.FromServiceLine2ShptLine(WhseShptHeader, "Service Line") THEN
//                                             ErrorOccured := TRUE;
//                                         LineCreated := TRUE;
//                                     END;
//                             END;
//                     end;

//                     trigger OnPreDataItem()
//                     begin
//                         SETRANGE(Type, Type::Item);
//                         IF (("Warehouse Request".Type = "Warehouse Request".Type::Outbound) AND
//                             ("Warehouse Request"."Source Document" = "Warehouse Request"."Source Document"::"Service Order"))
//                         THEN
//                             SETFILTER("Outstanding Quantity", '>0')
//                         ELSE
//                             SETFILTER("Outstanding Quantity", '<0');
//                         SETRANGE("Job No.", '');
//                     end;
//                 }

//                 trigger OnAfterGetRecord()
//                 begin
//                     TESTFIELD("Bill-to Customer No.");
//                     Cust.GET("Bill-to Customer No.");
//                     IF NOT SkipBlockedCustomer THEN
//                         Cust.CheckBlockedCustOnDocs(Cust, "Document Type", FALSE, FALSE)
//                     ELSE
//                         IF Cust.Blocked <> Cust.Blocked::" " THEN
//                             CurrReport.SKIP;
//                 end;

//                 trigger OnPreDataItem()
//                 begin
//                     IF "Warehouse Request"."Source Type" <> DATABASE::"Service Line" THEN
//                         CurrReport.BREAK;
//                 end;
//             }

//             trigger OnAfterGetRecord()
//             var
//                 WhseSetup: Record "Warehouse Setup";
//             begin
//                 WhseHeaderCreated := FALSE;
//                 CASE Type OF
//                     Type::Inbound:
//                         BEGIN
//                             IF NOT Location.RequireReceive("Location Code") THEN BEGIN
//                                 IF "Location Code" = '' THEN
//                                     WhseSetup.TESTFIELD("Require Receive");
//                                 Location.GET("Location Code");
//                                 Location.TESTFIELD("Require Receive");
//                             END;
//                             IF NOT OneHeaderCreated THEN
//                                 RequestType := RequestType::Receive;
//                         END;
//                     Type::Outbound:
//                         BEGIN
//                             IF NOT Location.RequireShipment("Location Code") THEN BEGIN
//                                 IF "Location Code" = '' THEN
//                                     WhseSetup.TESTFIELD("Require Shipment");
//                                 Location.GET("Location Code");
//                                 Location.TESTFIELD("Require Shipment");
//                             END;
//                             IF NOT OneHeaderCreated THEN
//                                 RequestType := RequestType::Ship;
//                         END;
//                 END;
//             end;

//             trigger OnPostDataItem()
//             begin
//                 IF WhseHeaderCreated OR OneHeaderCreated THEN BEGIN
//                     OnAfterCreateWhseDocuments(WhseReceiptHeader, WhseShptHeader, WhseHeaderCreated);
//                     WhseShptHeader.SortWhseDoc;
//                     WhseReceiptHeader.SortWhseDoc;
//                 END;
//             end;

//             trigger OnPreDataItem()
//             begin
//                 IF OneHeaderCreated THEN BEGIN
//                     CASE RequestType OF
//                         RequestType::Receive:
//                             Type := Type::Inbound;
//                         RequestType::Ship:
//                             Type := Type::Outbound;
//                     END;
//                     SETRANGE(Type, Type);
//                 END;
//             end;
//         }
//     }

//     requestpage
//     {

//         layout
//         {
//             area(content)
//             {
//                 group(Options)
//                 {
//                     Caption = 'Options';
//                     field(DoNotFillQtytoHandle; DoNotFillQtytoHandle)
//                     {
//                         ApplicationArea = Warehouse;
//                         Caption = 'Do Not Fill Qty. to Handle';
//                         ToolTip = 'Specifies if the Quantity to Handle field in the warehouse document is prefilled according to the source document quantities.';
//                     }
//                 }
//             }
//         }

//         actions
//         {
//         }
//     }

//     labels
//     {
//     }

//     trigger OnPostReport()
//     begin
//         IF NOT HideDialog THEN
//             CASE RequestType OF
//                 RequestType::Receive:
//                     ShowReceiptDialog;
//                 RequestType::Ship:
//                     ShowShipmentDialog;
//             END;
//         IF SkippedSourceDoc > 0 THEN
//             MESSAGE(CustomerIsBlockedMsg, SkippedSourceDoc);
//         Completed := TRUE;
//     end;

//     trigger OnPreReport()
//     begin
//         ActivitiesCreated := 0;
//         LineCreated := FALSE;
//     end;

//     var
//         Text000: Label 'There are no Warehouse Receipt Lines created.';
//         Text001: Label '%1 %2 has been created.';
//         WhseReceiptHeader: Record "Warehouse Receipt Header";
//         WhseReceiptLine: Record "Warehouse Receipt Line";
//         WhseShptHeader: Record "Warehouse Shipment Header";
//         WhseShptLine: Record "Warehouse Shipment Line";
//         Location: Record Location;
//         Cust: Record Customer;
//         WhseActivityCreate: Codeunit "Whse.-Create Source Document";
//         ActivitiesCreated: Integer;
//         OneHeaderCreated: Boolean;
//         Completed: Boolean;
//         LineCreated: Boolean;
//         WhseHeaderCreated: Boolean;
//         DoNotFillQtytoHandle: Boolean;
//         HideDialog: Boolean;
//         SkipBlockedCustomer: Boolean;
//         SkipBlockedItem: Boolean;
//         RequestType: Option Receive,Ship;
//         SalesHeaderCounted: Boolean;
//         SkippedSourceDoc: Integer;
//         Text002: Label '%1 Warehouse Receipts have been created.';
//         Text003: Label 'There are no Warehouse Shipment Lines created.';
//         Text004: Label '%1 Warehouse Shipments have been created.';
//         ErrorOccured: Boolean;
//         Text005: Label 'One or more of the lines on this %1 require special warehouse handling. The %2 for such lines has been set to blank.';
//         CustomerIsBlockedMsg: Label '%1 source documents were not included because the customer is blocked.';
//         WhseShptHeaderTemp: Record "Warehouse Shipment Header" temporary;
//         WhseReceiptHeaderTemp: Record "Warehouse Receipt Header" temporary;

//     [Scope('Personalization')]
//     procedure SetHideDialog(NewHideDialog: Boolean)
//     begin
//         HideDialog := NewHideDialog;
//     end;

//     [Scope('Personalization')]
//     procedure SetOneCreatedShptHeader(WhseShptHeader2: Record "Warehouse Shipment Header")
//     begin
//         RequestType := RequestType::Ship;
//         WhseShptHeader := WhseShptHeader2;
//         IF WhseShptHeader.FIND THEN
//             OneHeaderCreated := TRUE;
//     end;

//     [Scope('Personalization')]
//     procedure SetOneCreatedReceiptHeader(WhseReceiptHeader2: Record "Warehouse Receipt Header")
//     begin
//         RequestType := RequestType::Receive;
//         WhseReceiptHeader := WhseReceiptHeader2;
//         IF WhseReceiptHeader.FIND THEN
//             OneHeaderCreated := TRUE;
//     end;

//     [Scope('Personalization')]
//     procedure SetDoNotFillQtytoHandle(DoNotFillQtytoHandle2: Boolean)
//     begin
//         DoNotFillQtytoHandle := DoNotFillQtytoHandle2;
//     end;

//     [Scope('Personalization')]
//     procedure GetLastShptHeader(var WhseShptHeader2: Record "Warehouse Shipment Header")
//     begin
//         RequestType := RequestType::Ship;
//         WhseShptHeader2 := WhseShptHeader;
//     end;

//     [Scope('Personalization')]
//     procedure GetLastReceiptHeader(var WhseReceiptHeader2: Record "Warehouse Receipt Header")
//     begin
//         RequestType := RequestType::Receive;
//         WhseReceiptHeader2 := WhseReceiptHeader;
//     end;

//     [Scope('Personalization')]
//     procedure NotCancelled(): Boolean
//     begin
//         EXIT(Completed);
//     end;

//     local procedure CreateShptHeader()
//     var
//         IsHandled: Boolean;
//     begin
//         IsHandled := FALSE;
//         OnBeforeCreateShptHeader(WhseShptHeader, "Warehouse Request", "Sales Line", IsHandled);
//         IF IsHandled THEN
//             EXIT;

//         WhseShptHeader.INIT;
//         WhseShptHeader."No." := '';
//         WhseShptHeader."Location Code" := "Warehouse Request"."Location Code";
//         ////soft,o SetNoSeries("Purchase Header"."Series Group",TRUE); //soft,n
//         //soft,sn
//         WhseShptHeader."No. Series" := WhseShptHeaderTemp."No. Series";
//         WhseShptHeader."PTSS Series Group SGRP" := WhseShptHeaderTemp."PTSS Series Group SGRP";
//         //soft,en
//         IF Location.Code = WhseShptHeader."Location Code" THEN
//             WhseShptHeader."Bin Code" := Location."Shipment Bin Code";
//         WhseShptHeader."External Document No." := "Warehouse Request"."External Document No.";
//         WhseShptLine.LOCKTABLE;

//         // Habilitar codigo em On prem
//         //WhseShptHeader.SetShipmentStartTime("Sales Header"."Shipment Start Time"); //soft,n
//         WhseShptHeader.INSERT(TRUE);
//         ActivitiesCreated := ActivitiesCreated + 1;
//         WhseHeaderCreated := TRUE;
//     end;

//     local procedure CreateReceiptHeader()
//     begin
//         WhseReceiptHeader.INIT;
//         WhseReceiptHeader."No." := '';
//         WhseReceiptHeader."Location Code" := "Warehouse Request"."Location Code";
//         //soft,o SetNoSeries("Purchase Header"."Series Group",FALSE); //soft,n
//         //soft,sn
//         WhseReceiptHeader."No. Series" := WhseReceiptHeaderTemp."No. Series";
//         WhseReceiptHeader."PTSS Series Group SGRP" := WhseReceiptHeaderTemp."PTSS Series Group SGRP";
//         //soft,en
//         IF Location.Code = WhseReceiptHeader."Location Code" THEN
//             WhseReceiptHeader."Bin Code" := Location."Receipt Bin Code";
//         WhseReceiptHeader."Vendor Shipment No." := "Warehouse Request"."External Document No.";
//         WhseReceiptLine.LOCKTABLE;
//         WhseReceiptHeader.INSERT(TRUE);
//         ActivitiesCreated := ActivitiesCreated + 1;
//         WhseHeaderCreated := TRUE;
//         COMMIT;
//     end;

//     local procedure UpdateReceiptHeaderStatus()
//     begin
//         WITH WhseReceiptHeader DO BEGIN
//             IF "No." = '' THEN
//                 EXIT;
//             VALIDATE("Document Status", GetHeaderStatus(0));
//             MODIFY(TRUE);
//         END;
//     end;

//     [Scope('Personalization')]
//     procedure SetSkipBlocked(Skip: Boolean)
//     begin
//         SkipBlockedCustomer := Skip;
//     end;

//     [Scope('Personalization')]
//     procedure SetSkipBlockedItem(Skip: Boolean)
//     begin
//         SkipBlockedItem := Skip;
//     end;

//     local procedure VerifyItemNotBlocked(ItemNo: Code[20])
//     var
//         Item: Record Item;
//     begin
//         Item.GET(ItemNo);
//         IF SkipBlockedItem AND Item.Blocked THEN
//             CurrReport.SKIP;

//         Item.TESTFIELD(Blocked, FALSE);
//     end;

//     [Scope('Personalization')]
//     procedure ShowReceiptDialog()
//     var
//         SpecialHandlingMessage: Text[1024];
//     begin
//         IF NOT LineCreated THEN
//             ERROR(Text000);

//         IF ErrorOccured THEN
//             SpecialHandlingMessage :=
//               ' ' + STRSUBSTNO(Text005, WhseReceiptHeader.TABLECAPTION, WhseReceiptLine.FIELDCAPTION("Bin Code"));
//         IF (ActivitiesCreated = 0) AND LineCreated AND ErrorOccured THEN
//             MESSAGE(SpecialHandlingMessage);
//         IF ActivitiesCreated = 1 THEN
//             MESSAGE(STRSUBSTNO(Text001, ActivitiesCreated, WhseReceiptHeader.TABLECAPTION) + SpecialHandlingMessage);
//         IF ActivitiesCreated > 1 THEN
//             MESSAGE(STRSUBSTNO(Text002, ActivitiesCreated) + SpecialHandlingMessage);
//     end;

//     [Scope('Personalization')]
//     procedure ShowShipmentDialog()
//     var
//         SpecialHandlingMessage: Text[1024];
//     begin
//         IF NOT LineCreated THEN
//             ERROR(Text003);

//         IF ErrorOccured THEN
//             SpecialHandlingMessage :=
//               ' ' + STRSUBSTNO(Text005, WhseShptHeader.TABLECAPTION, WhseShptLine.FIELDCAPTION("Bin Code"));
//         IF (ActivitiesCreated = 0) AND LineCreated AND ErrorOccured THEN
//             MESSAGE(SpecialHandlingMessage);
//         IF ActivitiesCreated = 1 THEN
//             MESSAGE(STRSUBSTNO(Text001, ActivitiesCreated, WhseShptHeader.TABLECAPTION) + SpecialHandlingMessage);
//         IF ActivitiesCreated > 1 THEN
//             MESSAGE(STRSUBSTNO(Text004, ActivitiesCreated) + SpecialHandlingMessage);
//     end;

//     local procedure CheckFillQtyToHandle()
//     begin
//         IF DoNotFillQtytoHandle AND (RequestType = RequestType::Receive) THEN BEGIN
//             WhseReceiptLine.RESET;
//             WhseReceiptLine.SETRANGE("No.", WhseReceiptHeader."No.");
//             WhseReceiptLine.DeleteQtyToReceive(WhseReceiptLine);
//         END;
//     end;

//     [IntegrationEvent(false, false)]
//     local procedure OnAfterCreateWhseDocuments(var WhseReceiptHeader: Record "Warehouse Receipt Header"; var WhseShipmentHeader: Record "Warehouse Shipment Header"; WhseHeaderCreated: Boolean)
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     local procedure OnAfterProcessDocumentLine(var WarehouseShipmentHeader: Record "Warehouse Shipment Header"; var WarehouseRequest: Record "Warehouse Request"; var LineCreated: Boolean)
//     begin
//     end;

//     [IntegrationEvent(false, false)]
//     local procedure OnBeforeCreateShptHeader(var WarehouseShipmentHeader: Record "Warehouse Shipment Header"; var WarehouseRequest: Record "Warehouse Request"; SalesLine: Record "Sales Line"; var IsHandled: Boolean)
//     begin
//     end;

//     procedure SetNoSeries(var "Code": Code[10]; IsShipment: Boolean)
//     var
//         NoSeries: Record "No. Series";
//         SeriesGroups: Record "PTSS Series Groups SGRP";
//     begin
//         //soft,sn
//         IF SeriesGroups.GET(Code) THEN BEGIN
//             IF IsShipment THEN BEGIN
//                 WhseShptHeaderTemp.INIT;
//                 WhseShptHeaderTemp."No. Series" := SeriesGroups.Shipment;
//                 WhseShptHeaderTemp."PTSS Series Group SGRP" := SeriesGroups.Code;
//                 WhseShptHeaderTemp.INSERT;
//             END ELSE BEGIN
//                 WhseReceiptHeaderTemp.INIT;
//                 WhseReceiptHeaderTemp."No. Series" := SeriesGroups.Receipt;
//                 WhseReceiptHeaderTemp."PTSS Series Group SGRP" := SeriesGroups.Code;
//                 WhseReceiptHeaderTemp.INSERT;
//             END;
//         END;
//         //soft,en
//     end;
// }

