pageextension 50101 "G/L Account Card Extension" extends "G/L Account Card"
{
    layout
    {
        addlast(General){
           field("Taxonomy Code"; "Taxonomy Code")
           {
               ToolTip = 'Specifies the Taxonomy Code';
           }
        }

    }
    
    actions
    {

    }
    
    var

}