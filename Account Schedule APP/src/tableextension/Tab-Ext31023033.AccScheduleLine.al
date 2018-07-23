tableextension 31023033 "Acc. Schedule Line" extends "Acc. Schedule Line"
{
    fields
    {
        // Add changes to table fields here
        field(31022890;"Column Value"; Option)
        {
            caption = 'Column Value';
            OptionMembers = "1st Value","2nd Value","3rd Value";
            OptionCaption = '1st Value,2nd Value,3rd Value';
            DataClassification = CustomerContent;
        }
        field(31022891; "Positive Only"; boolean)
        {
            caption = 'Positive Only';
            DataClassification = CustomerContent;
        }
        field(31022892; "Positive Only 2"; boolean)
        {
            caption = 'Positive Only 2';
            DataClassification = CustomerContent;
        }
        field(31022893; "Reverse Sign"; boolean)
        {
            caption = 'Reverse Sign';
            DataClassification = CustomerContent;
        }
        field(31022894; "Reverse Sign 2"; boolean)
        {
            caption = 'Reverse Sign 2';
            DataClassification = CustomerContent;
        }
        field(31022895; "Totaling 2"; Text[250])
        {
            caption = 'Totaling 2';
            DataClassification = CustomerContent;
            TableRelation = IF ("Totaling Type"=CONST("Posting Accounts")) "G/L Account" ELSE IF ("Totaling Type"=CONST("Total Accounts")) "G/L Account";
            ValidateTableRelation = false;
            trigger OnValidate()
            begin
                CASE "Totaling Type" OF
                    "Totaling Type"::"Posting Accounts","Totaling Type"::"Total Accounts":
                        BEGIN
                            GLAcc.SETFILTER("No.","Totaling 2");
                            GLAcc.CALCFIELDS(Balance);
                        //Reeng.
                        // IF AccSchedName."Acc. No. Referred to old Acc." THEN BEGIN
                        //     HistoricGLAcc.SETFILTER("No.","Totaling 2");
                        //     HistoricGLAcc.CALCFIELDS(Balance);
                        // END ELSE BEGIN
                        //    GLAcc.SETFILTER("No.","Totaling 2");
                        //    GLAcc.CALCFIELDS(Balance);
                        // END;
                        END;
                    "Totaling Type"::Formula:
                        BEGIN
                        "Totaling 2" := UPPERCASE("Totaling 2");
                        CheckFormula("Totaling 2");
                        END;
                    END;
            end;
        }
        field(31022896;"Type"; Option)
        {
            caption = 'Type';
            OptionMembers =  "","Debit","Credit","Assets","Liabilities";
            OptionCaption = ' ,Debit,Credit,Assets,Liabilities';
            DataClassification = CustomerContent;
            trigger OnValidate()
            begin
                IF "Totaling Type" IN ["Totaling Type"::"Posting Accounts", "Totaling Type"::"Total Accounts"] THEN
                    "Reverse Sign" := Type IN [Type::Assets,Type::Credit];
            end;
        }
        modify(Description)
        {
            Width=250;
        }
    }
    procedure CheckStandardized(var IsStandardized:Boolean)
    var
    AccScheduleName:Record "Acc. Schedule Name";
    begin
        AccScheduleName.Get("Schedule Name");
        If AccScheduleName.Standardized = true then
            IsStandardized:=true;
    end;
    
    var
        AccSchedName: Record "Acc. Schedule Name";
        GLAcc:Record "G/L Account";

}