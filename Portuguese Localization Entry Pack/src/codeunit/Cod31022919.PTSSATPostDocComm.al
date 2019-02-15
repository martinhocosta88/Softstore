codeunit 31022919 "PTSS AT Post Doc. Comm."
{
    // Comunicação AT


    trigger OnRun()
    begin
        IF (DocumentNo <> '') THEN BEGIN

            CLEAR(ATCommunicationLog);
            IF ATCommunicationLog.FINDLAST THEN
                EntryNo := ATCommunicationLog."Entry No.";

            EntryNo += 1;

            CLEAR(ATCommunicationLog);
            ATCommunicationLog."Entry No." := EntryNo;
            ATCommunicationLog."Date Time" := CURRENTDATETIME;
            ATCommunicationLog."User Id" := USERID;
            ATCommunicationLog."Source No." := DocumentNo;
            ATCommunicationLog."Movement Status" := ATCommunicationLog."Movement Status"::"N - Normal";
            IF UndoDoc THEN
                ATCommunicationLog."Movement Status" := ATCommunicationLog."Movement Status"::"A - Reversed";
            CASE DocumentType OF
                DocumentType::Sales:
                    BEGIN
                        ATCommunicationLog."Source Type" := DATABASE::"Sales Shipment Header";
                        ATCommunicationLog."Source Document" := ATCommunicationLog."Source Document"::"Posted Sales Shipment";
                    END;
                DocumentType::Return:
                    BEGIN
                        ATCommunicationLog."Source Type" := DATABASE::"Return Shipment Header";
                        ATCommunicationLog."Source Document" := ATCommunicationLog."Source Document"::"Posted Return Purchase Shipment";
                    END;
                DocumentType::Transfer:
                    BEGIN
                        ATCommunicationLog."Source Type" := DATABASE::"Transfer Shipment Header";
                        ATCommunicationLog."Source Document" := ATCommunicationLog."Source Document"::"Posted Transfer Shipment";
                    END;
                DocumentType::Service:
                    BEGIN
                        ATCommunicationLog."Source Type" := DATABASE::"Service Shipment Header";
                        ATCommunicationLog."Source Document" := ATCommunicationLog."Source Document"::"Posted Service Shipment";
                    END;
            END;

            ATCommunicationLog.INSERT;

            COMMIT;

            ATConsumeWebService.SetDocumentType(DocumentType);
            ATConsumeWebService.Undo(UndoDoc);
            ATConsumeWebService.RUN(ATCommunicationLog);

            SuccessCounter := ATConsumeWebService.GetCountSuccess;
        END;
    end;

    var
        ATCommunicationLog: Record "PTSS AT Communication Log";
        ATConsumeWebService: Codeunit "PTSS AT Consume Web Service";
        ATSingleInstance: Codeunit "PTSS AT Single Instance Aux";
        EntryNo: BigInteger;
        DocumentNo: Code[20];
        DocumentType: Option Sales,Return,Transfer,Service;
        SuccessCounter: Integer;
        UndoDoc: Boolean;

    procedure SetData(No: Code[20]; Type: Option Sales,Return,Transfer,Service)
    var
        ATCommunicationLog: Record "PTSS AT Communication Log";
        EntryNo: BigInteger;
    begin
        DocumentNo := No;
        DocumentType := Type;
    end;

    procedure GetSuccessCounter(): Integer
    begin
        EXIT(SuccessCounter);
    end;

    procedure Undo(Undo: Boolean)
    begin

        UndoDoc := Undo;
    end;
}

