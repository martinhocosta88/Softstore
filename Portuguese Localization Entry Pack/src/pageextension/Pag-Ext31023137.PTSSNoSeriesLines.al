pageextension 31023137 "PTSS No. Series Lines" extends "No. Series Lines" //MyTargetPageId
{
    //Certificacao Documentos
    layout
    {
        addafter(Open)
        {
            field("PTSS SAF-T No. Series Del."; "PTSS SAF-T No. Series Del.")
            {
                ToolTip = 'Specifies the SAF-T No. Series Delimenter';
                ApplicationArea = All;
            }
            field("PTSS SAF-T No. Series"; "PTSS SAF-T No. Series")
            {
                ToolTip = 'Specifies the SAF-T No. Series';
                ApplicationArea = All;
            }
            field("PTSS SAF-T Sequential No."; "PTSS SAFT-T Sequential No.")
            {
                ToolTip = 'Specifies the SAF-T No. Series Delimenter';
                ApplicationArea = All;
            }
        }
    }

    actions
    {

    }
}