pageextension 50119 "Sales Statistics Ext" extends "Sales Statistics"
{
    layout
    {
        addafter("TotalAdjCostLCY - TotalSalesLineLCY.""Unit Cost (LCY)""")
        {
            field("Withholding Tax Amount";TotalSalesLine."Withholding Tax Amount")
            {
                
                Caption = 'Withholding Tax Amount';
                Editable = false;
                ToolTip ='Specifies the Withholding Tax Amount';
            }
            field("Total Withholding Tax Amount";TotalAmount2-TotalSalesLine."Withholding Tax Amount")
            {
                Caption = 'Total Withholding Tax Amount';
                Editable = false;
                ToolTip = 'Specifies the Withholding Tax Amount Total';
            }
            

        }
    }

    actions
    {

    }
    
    var
        TotalSalesLine : Record "Sales Line";
        TotalAmount2: Decimal;
}