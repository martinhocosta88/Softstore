// Welcome to your new AL extension.
// Remember that object names and IDs should be unique across all extensions.
// AL snippets start with t*, like tpageext - give them a try and happy coding!


tableextension 31023034 "Column Layout" extends "Column Layout"
{
    fields
    {
        // modify("Amount Type")
        // {
        //     //Option Extend: Adcionar debit balance e credit balance ao ammount type //MSC
        // }
        field(31022890;"Amount Type 2"; Option)
        {
            OptionMembers = "Net Amount","Debit Amount","Credit Amount",,,,,,"Debit Balance","Credit Balance";
            OptionCaption ='Net Amount,Debit Amount,Credit Amount,,,,,,Debit Balance,Credit Balance';
            DataClassification = CustomerContent;
        }
        field(31022891;"Amount Type 3"; Option)
        {
            OptionMembers = "Net Amount","Debit Amount","Credit Amount",,,,,,"Debit Balance","Credit Balance";
            OptionCaption ='Net Amount,Debit Amount,Credit Amount,,,,,,Debit Balance,Credit Balance';
            DataClassification = CustomerContent;
        }
        field(31022892;"Ref"; Option)
        {
            InitValue="1";
            OptionMembers = "1","2";
            OptionCaption ='1,2';
            DataClassification = CustomerContent;
        }          
    }
    var
}