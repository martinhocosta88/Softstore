tableextension 31023031 "PTSS Intrastat Jnl. Line" extends "Intrastat Jnl. Line" //MyTargetTableId
{
    //Intrastat
    fields
    {
        field(31022890; "PTSS Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionMembers = "","Item entry","Job entry","FA Entry";
            OptionCaption = ',Item entry,Job entry,FA Entry';
            DataClassification = ToBeClassified;
            BlankZero = true;
        }

    }

}