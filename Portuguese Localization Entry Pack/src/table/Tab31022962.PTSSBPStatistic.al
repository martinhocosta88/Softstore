table 31022962 "PTSS BP Statistic"
{
    //COPE

    Caption = 'BP Statistic';
    DrillDownPageID = 31023038;
    LookupPageID = 31023038;
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[5])
        {
            Caption = 'Code';
            DataClassification = CustomerContent;
        }
        field(2; "Description"; Text[150])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(3; "Category"; Option)
        {
            Caption = 'Category';
            OptionCaption = 'A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,Z';
            OptionMembers = A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,Z;
            DataClassification = CustomerContent;
        }
        field(4; "Type"; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Loans,Deposits,Cash Pooling';
            OptionMembers = " ",Loans,Deposits,"Cash Pooling";
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }
}

