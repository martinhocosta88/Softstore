tableextension 31023003 "PTSS Gen. Journal Line FCTR" extends "Gen. Journal Line" //MyTargetTableId
{
    //Factoring
    fields
    {
        field(50100; "PTSS Factoring to Vendor No."; Code[20])
        {
            Caption = 'Facotring to Vendor No.';
            DataClassification = CustomerContent;
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

    }
    var
        Vendor: Record Vendor;

}