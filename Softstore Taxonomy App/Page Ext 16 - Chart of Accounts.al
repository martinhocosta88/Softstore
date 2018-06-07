pageextension 50100 "Chart of Accounts Extension" extends "Chart of Accounts"
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