// tableextension 31023010 "Payment Method" extends "Payment Method"
// {
//     //Cash-Flow
//     fields
//     {
//         modify("Bal. Account No.")
//         {
//             trigger OnAfterValidate()
//             var
//                 CashFlowMgmt: Codeunit "Cash-Flow Management";
//             begin
//                 "Sales Cash-flow code" := CashFlowMgmt.GetCashFlowCode("Bal. Account Type","Bal. Account No.");
//             end;
//         }
//         field(31022818; "Sales Cash-flow code"; Code[10])
//         {
//             caption = 'Sales Cash-flow code';
//             DataClassification = CustomerContent;
//             TableRelation="Cash-Flow Plan"."No." WHERE (Type=CONST(Posting));
//         }
//         field(31022819; "Purch. Cash-flow code"; Code[10])
//         {
//             caption = 'Purch. Cash-flow code';
//             DataClassification = CustomerContent;
//             TableRelation="Cash-Flow Plan"."No." WHERE (Type=CONST(Posting));
//         }
//     }
// }