pageextension 50120 "Purchase Statistics Ext" extends "Purchase Statistics"
{
    layout
    {
        addafter("TotalPurchLine.""Unit Volume""")
        {
            field("Withholding Tax Amount";TotalPurchLine."Withholding Tax Amount")
            {
                Caption = 'Withholding Tax Amount';
            }
            field("Total Withholding Tax Amount";TotalAmount2-TotalPurchLine."Withholding Tax Amount")
            {
                Caption = 'Total Withholding Tax Amount';
            }
        }
    }
    actions
    {

    }
    var
        TotalPurchLine : Record "Purchase Line";
        TotalAmount2: Decimal;
}