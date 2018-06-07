// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!


tableextension 50100 ColumnLayoutExt extends "Column Layout"
{
    fields
    {
        field(31022890;"Amount Type 2"; Option)
        {
            //OptionCaption = ENU = 'Net Amount','Debit Amount','Credit Amount',,,,,,'Debit Balance','Credit Balance';
            OptionMembers = "Net Amount","Debit Amount","Credit Amount",,,,,,"Debit Balance","Credit Balance";


            Editable = true;
            DataClassification = CustomerContent;
        }
        field(31022891;"Amount Type 3"; Option)
        {
            //OptionCaption = ENU = "Net Amount","Debit Amount","Credit Amount",,,,,,"Debit Balance","Credit Balance";
            OptionMembers = "Net Amount","Debit Amount","Credit Amount",,,,,,"Debit Balance","Credit Balance";
            Editable = true;
            DataClassification = CustomerContent;
        }
        // modify("Amount Type")
        // {
        //     OptionMembers = "Net Amount","Debit Amount","Credit Amount",,,,,,"Debit Balance","Credit Balance";
        // }

    }
    
    var
        myInt: Integer;


}