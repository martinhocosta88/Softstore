
table 31022979 "Taxonomy Codes"
{
    DataClassification = ToBeClassified;
    Caption = 'Taxonomy Codes';
    DataPerCompany = False;
    fields
    {
        field(1;"Taxomy Code"; Integer)
        {
            caption = 'Taxonomy Code';
            DataClassification = CustomerContent;
        }
        field(2; "G/L Account Filter"; Text[100])
        {
            Caption = 'G/L Account Filter';
            DataClassification = CustomerContent;
        }
        field(3; "Description"; Text[250])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
    }
    
    keys
    {
        key(PK; "Taxomy Code")
        {
            Clustered = true;
        }
    }
    
    var
        myInt: Integer;
    
    trigger OnInsert()
    begin
        
    end;
    
    trigger OnModify()
    begin
        
    end;
    
    trigger OnDelete()
    begin
        
    end;
    
    trigger OnRename()
    begin
        
    end;
    
}