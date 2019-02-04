pageextension 31023128 "PTSS Account Schedule" extends "Account Schedule" //MyTargetPageId
{
    //Esquema de Contas - Valor Coluna
    layout
    {
        addafter("New Page")
        {
            field("PTSS Column Value"; "PTSS Column Value")
            {
                ToolTip = 'Specifies the type of column value that is calculated for this line in the Account Schedule.';
                ApplicationArea = All;
            }
            field("PTSS Balance"; "PTSS Balance")
            {
                ToolTip = 'Specifies if the Value is Balanced.';
                ApplicationArea = All;
                Editable = IsEditable;
            }
        }
        modify("Amount Type")
        {
            trigger OnAfterValidate()
            begin
                IF "Amount Type" = "Amount Type"::"Net Amount" THEN begin
                    CLEAR("PTSS Balance");
                    IsEditable := False;
                END else
                    IsEditable := True;
            end;
        }
    }

    actions
    {
    }
    trigger OnAfterGetRecord()
    begin
        IF "Amount Type" = "Amount Type"::"Net Amount" THEN
            IsEditable := False
        else
            IsEditable := True;
    end;

    var
        IsEditable: Boolean;
}