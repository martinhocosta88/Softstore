pageextension 31023153 "PTSS VAT Posting Setup" extends "VAT Posting Setup" //MyTargetPageId
{
    //Configuracao SAFT
    layout
    {
        addafter("Unrealized VAT Type")
        {
            field("PTSS SAF-T PT VAT Type Description"; "PTSS SAF-T PT VAT Type Desc.")
            {
                ToolTip = 'Specifies the SAF-T PT VAT Type Description';
                ApplicationArea = All;
            }
            field("PTSS SAF-T PT VAT Code"; "PTSS SAF-T PT VAT Code")
            {
                ToolTip = 'SAF-T PT VAT Code';
                ApplicationArea = All;
            }

        }

    }

    actions
    {
    }
}