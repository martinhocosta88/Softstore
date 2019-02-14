tableextension 31023007 "PTSS General Ledger Setup" extends "General Ledger Setup"
{
    //Check Chart of Accounts
    //Check (PT)
    //COPE
    //IRC - Modelo 22
    fields
    {
        field(31022897; "PTSS Check Chart of Accounts"; boolean)
        {
            //Check Chart of Accounts
            Caption = 'Check Chart of Accounts';
            DataClassification = CustomerContent;
        }
        field(31022890; "PTSS Curr. Decimal Unit Text"; Text[30])
        {
            //Check (PT)
            Caption = 'Currency Decimal Unit Text';
            DataClassification = CustomerContent;
        }
        field(31022891; "PTSS Cur. Dec. Unit Dec. Place"; Integer)
        {
            //Check (PT)
            Caption = 'Curr. Dec. Unit Decimal Places';
            DataClassification = CustomerContent;
        }
        field(31022898; "PTSS Currency Text"; Text[30])
        {
            //Check (PT)
            Caption = 'Currency Text';
            DataClassification = CustomerContent;
        }
        //________________COPE_______________
        field(31022950; "PTSS BP Rec Nature Creat. Code"; Code[1])
        {
            Caption = 'BP Record Nature Creation Code';
            DataClassification = CustomerContent;
        }
        field(31022951; "PTSS BP Rec. Nature Mod. Code"; Code[1])
        {
            Caption = 'BP Record Nature Mod. Code';
            DataClassification = CustomerContent;
        }
        field(310229502; "PTSS BP Nature Delete Code"; Code[1])
        {
            Caption = 'BP Nature Delete Code';
            DataClassification = CustomerContent;
        }
        field(31022953; "PTSS BP Amount Type Inc. Code"; Code[1])
        {
            Caption = 'BP Amount Type Income Code';
            DataClassification = CustomerContent;
        }
        field(31022954; "PTSS BP Amount Type Out. Code"; Code[1])
        {
            Caption = 'BP Amount Type Outcome Code';
            DataClassification = CustomerContent;
        }
        field(31022955; "PTSS BP Amount Type Pos. Code"; Code[1])
        {
            Caption = 'BP Amount Type Position Code';
            DataClassification = CustomerContent;
        }
        field(31022956; "PTSS BP Account Type Def. Code"; Code[1])
        {
            Caption = 'BP Account Type Default Code';
            TableRelation = "PTSS BP Account Type";
            DataClassification = CustomerContent;
        }
        field(31022957; "PTSS BP Folder"; Text[250])
        {
            Caption = 'BP Folder';
            DataClassification = CustomerContent;
        }
        field(31022958; "PTSS BP IF Code"; Code[4])
        {
            Caption = 'BP IF Code MyField';
            DataClassification = CustomerContent;
        }
        //___________IRC Model 22_________
        field(31022960; "PTSS Model 22 Acc. Sch. Name"; Code[10])
        {
            Caption = 'Model 22 Acc. Sch. Name';
            TableRelation = "Acc. Schedule Name";
            DataClassification = CustomerContent;
        }
    }
}