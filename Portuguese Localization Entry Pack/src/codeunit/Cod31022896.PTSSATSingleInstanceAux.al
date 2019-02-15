codeunit 31022896 "PTSS AT Single Instance Aux"
{
    //Comunicacao AT

    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        SkipMsg: Boolean;

    procedure SkipMessages(SkipMessage: Boolean): Boolean
    begin
        SkipMsg := SkipMessage
    end;

    procedure GetSkipMsg(): Boolean
    begin
        EXIT(SkipMsg);
    end;
}

