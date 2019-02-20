codeunit 31022934 "PTSS NoSeriesManagementPT"
{
    procedure GetAndValidateNoSeriesLine(NoSeries: Code[10]; PostingDate: Date; ModifySeries: Boolean; VAR NoSeriesLine: Record "No. Series Line"; DocType: Integer)
    var
        NoSeries2: Record "No. Series";
    begin
        IF ModifySeries THEN
            NoSeriesLine.LOCKTABLE;
        SetNoSeriesLineFilter(NoSeriesLine, NoSeries, PostingDate);

        NoSeries2.GET(NoSeriesLine."Series Code");

        //Invoices
        IF DocType = 1 THEN
            NoSeries2.TESTFIELD("PTSS SAF-T Invoice Type");

        //GTAT
        //IF NOT NoSeries2."Not Communicated" THEN //SS.10.00.02.03,n
        IF DocType = 2 THEN
            NoSeries2.TESTFIELD("PTSS GTAT Document Type");

        NoSeriesLine.TESTFIELD("PTSS SAF-T No. Series");
    end;

    Local procedure SetNoSeriesLineFilter(VAR NoSeriesLine: Record "No. Series Line"; NoSeriesCode: Code[10]; StartDate: Date)
    begin
        IF StartDate = 0D THEN
            StartDate := WORKDATE;
        NoSeriesLine.RESET;
        NoSeriesLine.SETCURRENTKEY("Series Code", "Starting Date");
        NoSeriesLine.SETRANGE("Series Code", NoSeriesCode);
        NoSeriesLine.SETRANGE("Starting Date", 0D, StartDate);
        IF NoSeriesLine.FINDLAST THEN BEGIN
            NoSeriesLine.SETRANGE("Starting Date", NoSeriesLine."Starting Date");
            NoSeriesLine.SETRANGE(Open, TRUE);
        END;
    end;

    procedure UpdateLastHashandNoPosted(NoSeries: Code[10]; PostingDate: Date; Hash: Text[172]; LastNoPosted: Code[20])
    var
        NoSeriesLine: Record "No. Series Line";
    begin
        SetNoSeriesLineFilter(NoSeriesLine, NoSeries, PostingDate);
        NoSeriesLine."PTSS Last Hash Used" := Hash;
        NoSeriesLine."PTSS Last No. Posted" := LastNoPosted;
        NoSeriesLine.MODIFY;
    end;
}