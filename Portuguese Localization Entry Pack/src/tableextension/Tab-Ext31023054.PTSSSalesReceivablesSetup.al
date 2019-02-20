tableextension 31023054 "PTSS Sales & Receivables Setup" extends "Sales & Receivables Setup" //MyTargetTableId
{
    //Intrastat
    fields
    {
        field(31022905; "PTSS Transaction Type"; Code[10])
        {
            Caption = 'Transaction Type';
            DataClassification = CustomerContent;
            TableRelation = "Transaction Type";
        }
        field(31022906; "PTSS Transport Method"; Code[10])
        {
            Caption = 'Transport Method';
            DataClassification = CustomerContent;
            TableRelation = "Transport Method";
        }
        field(31022907; "PTSS Entry/Exit Point"; Code[10])
        {
            Caption = 'Entry/Exit Point';
            DataClassification = CustomerContent;
            TableRelation = "Entry/Exit Point";

        }
        field(31022908; "PTSS Area"; Code[10])
        {
            Caption = 'Area';
            DataClassification = CustomerContent;
            TableRelation = "Area";
        }
        field(31022909; "PTSS Transaction Specification"; Code[10])
        {
            Caption = 'Transaction Specification';
            DataClassification = CustomerContent;
            TableRelation = "Transaction Specification";
        }
        field(31022910; "PTSS Return Transaction Type"; Code[10])
        {
            Caption = 'Return Transaction Type';
            DataClassification = CustomerContent;
            TableRelation = "Transaction Type";
        }
        field(31022911; "PTSS Return Transport Method"; Code[10])
        {
            Caption = 'Return Transport Method';
            DataClassification = CustomerContent;
            TableRelation = "Transport Method";
        }
        field(31022912; "PTSS Return Entry/Exit Point"; Code[10])
        {
            Caption = 'Return Entry/Exit Point';
            DataClassification = CustomerContent;
            TableRelation = "Entry/Exit Point";
        }
        field(31022913; "PTSS Return Area"; Code[10])
        {
            Caption = 'Return Area';
            DataClassification = CustomerContent;
            TableRelation = "Area";
        }
        field(31022914; "PTSS Return Transaction Spec."; Code[10])
        {
            Caption = 'Return Transaction Spec.';
            DataClassification = CustomerContent;
            TableRelation = "Transaction Specification";
        }


    }

}