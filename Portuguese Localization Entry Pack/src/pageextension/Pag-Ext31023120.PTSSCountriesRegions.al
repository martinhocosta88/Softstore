pageextension 31023120 "PTSS Countries/Regions" extends "Countries/Regions" //MyTargetPageId
{
    //COPE
    layout
    {
        addlast(Control1)
        {
            field("PTSS BP Territory Code"; "PTSS BP Territory Code")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the territory code for the Bank of Portugal';
            }
        }

    }
}