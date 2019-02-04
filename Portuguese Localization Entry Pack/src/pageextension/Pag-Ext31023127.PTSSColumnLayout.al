pageextension 31023127 "PTSS Column Layout" extends "Column Layout" //MyTargetPageId
{
    //Esquema de Contas - Valor Coluna
    layout
    {
        addafter("Amount Type")
        {
            field("PTSS Amount Type 2"; "PTSS Amount Type 2")
            {
                ToolTip = 'Specifies the Amount Type 2.';
                ApplicationArea = All;
                trigger Onvalidate()
                begin
                    IF "PTSS Amount Type 2" = "PTSS Amount Type 2"::"Net Amount" THEN begin
                        CLEAR("PTSS Balance 2");
                        IsEditable2 := False;
                    END else
                        IsEditable2 := True;
                end;
            }
            field("PTSS Amount Type 3"; "PTSS Amount Type 3")
            {
                ToolTip = 'Specifies the Amount Type 3.';
                ApplicationArea = All;
                trigger Onvalidate()
                begin
                    IF "PTSS Amount Type 3" = "PTSS Amount Type 3"::"Net Amount" THEN begin
                        CLEAR("PTSS Balance 3");
                        IsEditable3 := False;
                    END else
                        IsEditable3 := True;
                end;
            }
            field("PTSS Balance 1"; "PTSS Balance 1")
            {
                ToolTip = 'Specifies if you pretend the Balance for the Value 1.';
                ApplicationArea = All;
                Editable = IsEditable1;
            }
            field("PTSS Balance 2"; "PTSS Balance 2")
            {
                ToolTip = 'Specifies if you pretend the Balance for the Value 2.';
                ApplicationArea = All;
                Editable = IsEditable2;
            }
            field("PTSS Balance 3"; "PTSS Balance 3")
            {
                ToolTip = 'Specifies if you pretend the Balance for the Value3. ';
                ApplicationArea = All;
                Editable = IsEditable3;
            }
        }
        modify("Amount Type")
        {
            trigger OnAfterValidate()
            begin
                IF "Amount Type" = "Amount Type"::"Net Amount" THEN begin
                    CLEAR("PTSS Balance 1");
                    IsEditable1 := False;
                END else
                    IsEditable1 := True;
            end;
        }
    }
    actions
    {
    }

    var
        IsEditable1: boolean;
        IsEditable2: boolean;
        IsEditable3: boolean;
}