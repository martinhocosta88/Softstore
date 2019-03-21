tableextension 31023103 "PTSS Gen. Journal Line FCTR" extends "Gen. Journal Line" //MyTargetTableId
{
    //Factoring
    fields
    {
        field(31022980; "PTSS Factoring to Vendor No."; Code[20])
        {
            Caption = 'Factoring to Vendor No.';
            DataClassification = CustomerContent;
            Editable = false;
            TableRelation = vendor."No.";
        }
        modify("Account No.")
        {
            trigger OnAfterValidate()
            begin
                If ("Account Type" = "Account Type"::Vendor) and (xRec."Account No." <> "Account No.") then begin
                    IF Vendor.GET("Account No.") then BEGIN
                        "PTSS Factoring to Vendor No." := Vendor."PTSS Factoring to Vendor No.";
                        IF Vendor.GET("PTSS Factoring to Vendor No.") THEN
                            Description := Vendor.Name;
                    END;
                END;
            end;

        }
        modify("Recipient Bank Account")
        {
            TableRelation = IF ("Account Type" = CONST (Customer)) "Customer Bank Account".Code WHERE ("Customer No." = FIELD ("Account No.")) ELSE
            IF
            ("Account Type" = CONST (Vendor), "PTSS Factoring to Vendor No." = CONST ('')) "Vendor Bank Account".Code WHERE ("Vendor No." = FIELD ("Account No.")) ELSE
            IF
            ("Account Type" = CONST (Vendor), "PTSS Factoring to Vendor No." = FILTER (<> '')) "Vendor Bank Account".Code WHERE ("Vendor No." = FIELD ("PTSS Factoring to Vendor No.")) ELSE
            IF
            ("Account Type" = CONST (Employee)) "Employee"."No." WHERE ("Employee No. Filter" = FIELD ("Account No.")) ELSE
            IF
            ("Bal. Account Type" = CONST (Customer)) "Customer Bank Account".Code WHERE ("Customer No." = FIELD ("Bal. Account No.")) ELSE
            IF
            ("Bal. Account Type" = CONST (Vendor)) "Vendor Bank Account".Code WHERE ("Vendor No." = FIELD ("Bal. Account No.")) ELSE
            IF
            ("Bal. Account Type" = CONST (Employee)) "Employee"."No." WHERE ("Employee No. Filter" = FIELD ("Bal. Account No."));
        }
    }
    var
        Vendor: Record Vendor;

}