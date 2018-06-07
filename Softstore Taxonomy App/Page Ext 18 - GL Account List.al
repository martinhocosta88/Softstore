pageextension 50102 "G/L Account List Extension" extends "G/L Account List"
{
    layout
    {
        addlast(Control1){
           field("Taxonomy Code"; "Taxonomy Code")
           {
               ToolTip ='Specifies the Taxonomy Code';
           }
        }

    }
    
    actions
    {
 
    }
    
    var

}