codeunit 31022898 "PTSS AT Consume Web Service"
{
    // Comunicação AT

    TableNo = 31022931;

    trigger OnRun()
    var
        XMLFile: File;
        strInStream: InStream;
        ATCode: Text[30];
        ReturnCode: Code[10];
        ReturnMessage: Text[250];
        ATCallResponse: Text;
        ReturnLogPath: Text;
    begin
        TaxAuthorityWsSetup.GET;
        CompanyInfo.GET;

        XMLDoc := XMLDoc.XmlDocument;
        XMLDoc2 := XMLDoc2.XmlDocument;

        CLEAR(TaxAuthorityWsSetup.Blob);

        TaxAuthorityWsSetup.Blob.CREATEOUTSTREAM(OutStr);

        CASE DocumentType OF
            DocumentType::Sales:
                BEGIN
                    CLEAR(AtSendSalesShipmentDoc);
                    AtSendSalesShipmentDoc.SetSalesDoc(Rec."Source No.");
                    AtSendSalesShipmentDoc.SetUndo(boolUndo);
                    AtSendSalesShipmentDoc.SETDESTINATION(OutStr);
                    AtSendSalesShipmentDoc.EXPORT;
                END;
            DocumentType::Return:
                BEGIN
                    CLEAR(AtSendReturnShipmentDoc);
                    AtSendReturnShipmentDoc.SetReturnDoc(Rec."Source No.");
                    AtSendReturnShipmentDoc.SetUndo(boolUndo);
                    AtSendReturnShipmentDoc.SETDESTINATION(OutStr);
                    AtSendReturnShipmentDoc.EXPORT;
                END;
            DocumentType::Transfer:
                BEGIN
                    CLEAR(AtSendTransportDoc);
                    AtSendTransportDoc.SetTransferDoc(Rec."Source No.");
                    AtSendTransportDoc.SETDESTINATION(OutStr);
                    AtSendTransportDoc.EXPORT;
                END;
            DocumentType::Service:
                BEGIN
                    CLEAR(AtSendServiceShipmentDoc);
                    AtSendServiceShipmentDoc.SetServiceDoc(Rec."Source No.");
                    AtSendServiceShipmentDoc.SetUndo(boolUndo);
                    AtSendServiceShipmentDoc.SETDESTINATION(OutStr);
                    AtSendServiceShipmentDoc.EXPORT;
                END;
        END;

        TaxAuthorityWsSetup.Blob.CREATEINSTREAM(InStr);

        XMLDoc.Load(InStr);

        CLEAR(TempFileName);
        IF boolUndo THEN
            TempFileName := Rec."Source No." + txtMovStatus_Reversed + FileExt
        ELSE
            TempFileName := Rec."Source No." + txtMovStatus + FileExt;
        // IF boolUndo THEN
        //     TempFileName := TEMPORARYPATH + Rec."Source No." + txtMovStatus_Reversed + FileExt
        // ELSE
        //     TempFileName := TEMPORARYPATH + Rec."Source No." + txtMovStatus + FileExt;


        XMLDoc.Save(TempFileName);

        ClearNodes(TempFileName);

        //AddHeaderNamespaces
        AddXMLNamespaces.GetPath(TempFileName, TempFileName);
        AddXMLNamespaces.RUN;

        XMLFile.OPEN(TempFileName);
        XMLFile.CREATEINSTREAM(strInStream);

        XMLDoc := XMLDoc.XmlDocument;
        XMLDoc.Load(strInStream);

        IF CompanyInfo."PTSS AT Com. File Path" <> '' THEN
            IF boolUndo THEN BEGIN
                XMLDoc.Save(CompanyInfo."PTSS AT Com. File Path" + Rec."Source No." + txtMovStatus_Reversed + FileExt);
                ReturnLogPath := CompanyInfo."PTSS AT Com. File Path" + Rec."Source No." + txtMovStatus + FileExt;
            END ELSE BEGIN
                XMLDoc.Save(CompanyInfo."PTSS AT Com. File Path" + Rec."Source No." + txtMovStatus + FileExt);
                ReturnLogPath := CompanyInfo."PTSS AT Com. File Path" + Rec."Source No." + txtMovStatus + txtReturn + FileExt;
            END;
        SecurityProviderPTNET := SecurityProviderPTNET.PTlocalizationSecurityProvider();

        ATResponse := SecurityProviderPTNET.ATCall(TaxAuthorityWsSetup."URL Endpoint", XMLDoc.OuterXml, TaxAuthorityWsSetup."SOAP Action", TaxAuthorityWsSetup."Certificate Path", 10000, 10000, ReturnLogPath, FALSE);

        InsertATComLog(Rec, ATResponse.ATCode, ATResponse.ReturnCode, ATResponse.ReturnMessage);
    end;

    var
        TaxAuthorityWsSetup: Record "PTSS Tax Authority WS Setup";
        CompanyInfo: Record "Company Information";
        AddXMLNamespaces: Codeunit "31022899";
        AtSendTransportDoc: XMLport "31022893";
        AtTransporDocResponse: XMLport "31022894";
        AtSendSalesShipmentDoc: XMLport "31022895";
        AtSendServiceShipmentDoc: XMLport "31022896";
        AtSendReturnShipmentDoc: XMLport "31022897";
        strQuery: BigText;
        ResponseStatus: Boolean;
        booSkipMsg: Boolean;
        boolUndo: Boolean;
        chr0: Char;
        No: Code[40];
        Par1: Code[20];
        Par2: Code[20];
        ToDate: Date;
        XMLHttp: DotNet XMLHTTPRequestClass;
        XMLDoc: DotNet XmlDocument;
        XMLDoc2: DotNet XmlDocument;
        SecurityProviderPTNET: DotNet PTlocalizationSecurityProvider;
        Fich: File;
        No_Aux: Integer;
        NoInt: Integer;
        SuccessCounter: Integer;
        InStr: InStream;
        DocumentType: Option Sales,Return,Transfer,Service;
        InterfaceType: Option " ",,,"Customer Prize","Stocks Movements Receipt","Pending Prescriptions","RH Dimensions","Stocks Movements Return Receipt";
        OutStr: OutStream;
        FileOutS: OutStream;
        separator: Text[30];
        TextLog: Text[1024];
        LogDescription: Text[250];
        myString: Text[1024];
        txtReturn: Label '_Return';
        txtMovStatus: Label '_N';
        txtMovStatus_Reversed: Label '_A';
        FileExt: Label '.xml';
        TempFileName: Text[1024];
        Text31022890: Label 'Document successfully sent to AT.';
        Text31022891: Label 'Document sent to AT with error.';
        ATResponse: DotNet ATResponse;

    procedure RemoveNamespace(XMLSource: DotNet XmlDocument; var XMLDestination: DotNet XmlDocument)
    var
        StyleOutStr: OutStream;
        StyleInStr: InStream;
        XMLStyleSheet: DotNet XmlDocument;
        TempTable: Record "PTSS Tax Authority WS Setup";
        XslTransform: DotNet XslTransform;
        nullXsltArgumentList: DotNet XsltArgumentList;
        Writer: DotNet StringWriter;
    begin
        TempTable.Blob.CREATEOUTSTREAM(StyleOutStr);
        TempTable.Blob.CREATEINSTREAM(StyleInStr);
        StyleOutStr.WRITETEXT('<?xml version="1.0" encoding="UTF-8"?>');
        StyleOutStr.WRITETEXT('<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">');
        StyleOutStr.WRITETEXT('<xsl:output method="xml" encoding="UTF-8" />');
        StyleOutStr.WRITETEXT('<xsl:template match="/">');
        StyleOutStr.WRITETEXT('<xsl:copy>');
        StyleOutStr.WRITETEXT('<xsl:apply-templates />');
        StyleOutStr.WRITETEXT('</xsl:copy>');
        StyleOutStr.WRITETEXT('</xsl:template>');
        StyleOutStr.WRITETEXT('<xsl:template match="*">');
        StyleOutStr.WRITETEXT('<xsl:element name="{local-name()}">');
        StyleOutStr.WRITETEXT('<xsl:apply-templates select="@* | node()" />');
        StyleOutStr.WRITETEXT('</xsl:element>');
        StyleOutStr.WRITETEXT('</xsl:template>');
        StyleOutStr.WRITETEXT('<xsl:template match="@*">');
        StyleOutStr.WRITETEXT('<xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>');
        StyleOutStr.WRITETEXT('</xsl:template>');
        StyleOutStr.WRITETEXT('<xsl:template match="text() | processing-instruction() | comment()">');
        StyleOutStr.WRITETEXT('<xsl:copy />');
        StyleOutStr.WRITETEXT('</xsl:template>');
        StyleOutStr.WRITETEXT('</xsl:stylesheet>');

        XMLStyleSheet := XMLStyleSheet.XmlDocument;
        XMLStyleSheet.Load(StyleInStr);

        XslTransform := XslTransform.XslTransform;
        XslTransform.Load(XMLStyleSheet);

        Writer := Writer.StringWriter();
        XslTransform.Transform(XMLSource, nullXsltArgumentList, Writer);

        XMLDestination := XMLDestination.XmlDocument;
        XMLDestination.InnerXml(Writer.ToString());
    end;

    procedure EncryptCreationDate(): Code[50]
    begin
        SecurityProviderPTNET.InternetTimeServerURL := 'ntp04.oal.ul.pt';
        EXIT(SecurityProviderPTNET.ATCreateData(FALSE));
    end;

    procedure EncryptKey(): Code[50]
    var
        UserSetup: Record "User Setup";
        CompanyInformation: Record "Company Information";
        PFPassword: Text[50];
    begin
        CLEAR(PFPassword);
        CLEAR(UserSetup);
        IF PFPassword = '' THEN BEGIN
            CompanyInformation.GET;
            CompanyInformation.TESTFIELD("PTSS Tax Authority WS Password");
            PFPassword := CompanyInformation."PTSS Tax Authority WS Password";
        END;

        SecurityProviderPTNET := SecurityProviderPTNET.PTlocalizationSecurityProvider();

        EXIT(SecurityProviderPTNET.ATFinancialKey(PFPassword));
    end;

    procedure EncryptSimetricKey(): Code[1024]
    var
        TaxAuthorityWSSetup: Record "PTSS Tax Authority WS Setup";
    begin
        CLEAR(TaxAuthorityWSSetup);
        TaxAuthorityWSSetup.GET();
        TaxAuthorityWSSetup.TESTFIELD("Public Key Path");

        SecurityProviderPTNET := SecurityProviderPTNET.PTlocalizationSecurityProvider();

        EXIT(SecurityProviderPTNET.ATSimetricEncrKey(TaxAuthorityWSSetup."Public Key Path"));
    end;

    procedure GetUserAT(): Code[50]
    var
        UserSetup: Record "User Setup";
        CompanyInformation: Record "Company Information";
        ATUser: Code[50];
    begin
        CLEAR(ATUser);
        CLEAR(UserSetup);
        IF ATUser = '' THEN BEGIN
            CompanyInformation.GET;
            CompanyInformation.TESTFIELD("PTSS Tax Authority WS User ID");
            ATUser := CompanyInformation."PTSS Tax Authority WS User ID";
        END;

        EXIT(ATUser);
    end;

    procedure InsertATComLog(var ATCommunicationLog: Record "PTSS AT Communication Log"; ATCode: Text[30]; ATReturnCode: Code[10]; ATReturnMessage: Text[250])
    var
        ATSingleInst: Codeunit "PTSS AT Single Instance Aux";
    begin
        CLEAR(SuccessCounter);
        ATCommunicationLog.ATDocCodeID := ATCode;
        IF ATCode <> '' THEN BEGIN
            ATCommunicationLog."Comunication Status" := ATCommunicationLog."Comunication Status"::Sucess;
            ATCommunicationLog."System-Created Entry" := TRUE;
            SuccessCounter := 1;
        END ELSE BEGIN
            ATCommunicationLog."Comunication Status" := ATCommunicationLog."Comunication Status"::Error;
            ATCommunicationLog."System-Created Entry" := FALSE;
        END;
        ATCommunicationLog."AT Return Code" := ATReturnCode;
        ATCommunicationLog."AT Return Message" := ATReturnMessage;
        ATCommunicationLog."Last Change User Id" := USERID;
        ATCommunicationLog."Last Change Date Time" := CURRENTDATETIME;
        ATCommunicationLog.MODIFY;

        IF NOT ATSingleInst.GetSkipMsg THEN
            IF ATCode <> '' THEN
                MESSAGE(Text31022890)
            ELSE
                MESSAGE(Text31022891);

        CLEAR(ATCode);
        CLEAR(ATReturnCode);
        CLEAR(ATReturnMessage);
    end;

    procedure GetCountSuccess(): Integer
    begin
        EXIT(SuccessCounter);
    end;

    procedure Undo(pUndo: Boolean)
    begin
        boolUndo := pUndo;
    end;

    procedure Credentials(var Password: Text[250]; var Nonce: Text[400]; var Created: Text[250])
    var
        TaxAuthorityWSSetup: Record "PTSS Tax Authority WS Setup";
        UserSetup: Record "User Setup";
        CompanyInformation: Record "Company Information";
        PFPassword: Text[50];
        ReturnText: Text[1024];
    begin
        CLEAR(PFPassword);
        CLEAR(UserSetup);
        IF PFPassword = '' THEN BEGIN
            CompanyInformation.GET;
            CompanyInformation.TESTFIELD("PTSS Tax Authority WS Password");
            PFPassword := CompanyInformation."PTSS Tax Authority WS Password";
        END;

        CLEAR(TaxAuthorityWSSetup);
        TaxAuthorityWSSetup.GET;
        TaxAuthorityWSSetup.TESTFIELD("Public Key Path");

        SecurityProviderPTNET := SecurityProviderPTNET.PTlocalizationSecurityProvider();
        ReturnText := SecurityProviderPTNET.GenerateCredentials(TaxAuthorityWSSetup."Public Key Path", PFPassword);

        IF ReturnText <> '' THEN BEGIN
            Password := COPYSTR(ReturnText, 1, 24);
            Nonce := COPYSTR(ReturnText, 71, STRLEN(ReturnText));
            Created := COPYSTR(ReturnText, 26, 44);
        END;
    end;

    procedure ClearNodes(FileName: Text[1024])
    var
        TierMgt: Codeunit "File Management";
        XMLFile: File;
        XMLFile2: File;
        LineText: Text[1024];
        Line: Text[1024];
        TempFileName: Text[1024];
        ChTab: Char;
        ChTabUTF: Char;
        i: Integer;
        TotalTabs: Integer;
        TextTabs: Text[1024];
        Pos1: Integer;
        Pos2: Integer;
        booRemoveReference: Boolean;
    begin
        ChTab := 9;
        ChTabUTF := 32;
        XMLFile.TEXTMODE(TRUE);
        XMLFile.WRITEMODE(FALSE);
        XMLFile.OPEN(FileName);
        XMLFile2.TEXTMODE(TRUE);
        XMLFile2.WRITEMODE(TRUE);

        CLEAR(booRemoveReference);

        TempFileName := TierMgt.ServerTempFileName('.xml');
        XMLFile2.CREATE(TempFileName);
        REPEAT
            XMLFile.READ(Line);
            LineText := DELCHR(FORMAT(Line), '<', FORMAT(ChTabUTF));
            CASE LineText OF
                '<MovementEndTime/>', '<VehicleID/>',
                '<MovementEndTime />', '<VehicleID />',
                '<ATDocCodeID />', '<ATDocCodeID/>',
                '<CustomerTaxID />', '<CustomerTaxID/>',
                '<SupplierTaxID />', '<SupplierTaxID/>':
                    BEGIN
                        //SKIP
                    END;
                '<OriginatingON/>', '<OriginatingON />':
                    BEGIN
                        booRemoveReference := TRUE;
                    END;
                ELSE BEGIN
                        XMLFile2.WRITE(Line);
                    END;
            END;
        UNTIL XMLFile.POS = XMLFile.LEN;


        XMLFile.CLOSE;
        XMLFile2.CLOSE;
        COPY(TempFileName, FileName);

        XMLFile.TEXTMODE(TRUE);
        XMLFile.WRITEMODE(FALSE);
        XMLFile.OPEN(FileName);
        XMLFile2.TEXTMODE(TRUE);
        XMLFile2.WRITEMODE(TRUE);

        TempFileName := TierMgt.ServerTempFileName('.xml');
        XMLFile2.CREATE(TempFileName);
        REPEAT
            XMLFile.READ(Line);
            LineText := DELCHR(FORMAT(Line), '<', FORMAT(ChTab));

            CASE LineText OF
                '<OrderReferences>':
                    BEGIN
                        IF NOT booRemoveReference THEN
                            XMLFile2.WRITE(Line);
                    END;
                ELSE BEGIN
                        XMLFile2.WRITE(Line);
                    END;

            END;
        UNTIL XMLFile.POS = XMLFile.LEN;

        XMLFile.CLOSE;
        XMLFile2.CLOSE;
        COPY(TempFileName, FileName);
    end;

    procedure RemoveChars(CodDocNo: Code[20]; TypeOfChars: Integer): Code[20]
    var
        ch: Char;
        CodDocumentNo: Code[20];
    begin
        // Types of chars to remove:
        //   1 - Remove all chars to leave digits, Used in InvoiceNo
        //   2 - Remove all chars to leave letters, digits and underscore, Used in TransactionID

        CASE TypeOfChars OF
            1:
                BEGIN
                    CodDocumentNo := CodDocNo;
                    FOR ch := 0 TO 47 DO BEGIN
                        CodDocumentNo := DELCHR(CodDocumentNo, '=', FORMAT(ch));
                    END;
                    //Digit
                    FOR ch := 58 TO 255 DO BEGIN
                        CodDocumentNo := DELCHR(CodDocumentNo, '=', FORMAT(ch));
                    END;
                END;
            2:
                BEGIN
                    CodDocumentNo := CodDocNo;
                    FOR ch := 0 TO 47 DO BEGIN
                        CodDocumentNo := DELCHR(CodDocumentNo, '=', FORMAT(ch));
                    END;

                    FOR ch := 58 TO 64 DO BEGIN
                        CodDocumentNo := DELCHR(CodDocumentNo, '=', FORMAT(ch));
                    END;

                    FOR ch := 91 TO 95 DO BEGIN
                        CodDocumentNo := DELCHR(CodDocumentNo, '=', FORMAT(ch));
                    END;

                    //ch = 95 = _ - Retirado

                    ch := 96;
                    CodDocumentNo := DELCHR(CodDocumentNo, '=', FORMAT(ch));

                    FOR ch := 123 TO 255 DO BEGIN
                        CodDocumentNo := DELCHR(CodDocumentNo, '=', FORMAT(ch));
                    END;
                END;
        END;

        EXIT(CodDocumentNo);
    end;

    procedure ForceATCommunication(var ATCommunicationLog: Record "PTSS AT Communication Log")
    var
        ATConsumeWebService: Codeunit "PTSS AT Consume Web Service";
        ATSingleInstance: Codeunit "PTSS AT Single Instance Aux";
    begin
        ATCommunicationLog.SETRANGE(ATCommunicationLog.ATDocCodeID, '');
        ATCommunicationLog.SETRANGE(ATCommunicationLog."System-Created Entry", FALSE);
        CLEAR(ATSingleInstance);
        ATSingleInstance.SkipMessages(FALSE);
        IF ATCommunicationLog.FINDSET THEN
            REPEAT
                CLEAR(ATConsumeWebService);
                CASE ATCommunicationLog."Source Document" OF
                    ATCommunicationLog."Source Document"::"Posted Sales Shipment":
                        ATConsumeWebService.SetDocumentType(0);

                    ATCommunicationLog."Source Document"::"Posted Return Purchase Shipment":
                        ATConsumeWebService.SetDocumentType(1);

                    ATCommunicationLog."Source Document"::"Posted Transfer Shipment":
                        ATConsumeWebService.SetDocumentType(2);

                    ATCommunicationLog."Source Document"::"Posted Service Shipment":
                        ATConsumeWebService.SetDocumentType(3);
                END;

                ATConsumeWebService.Undo(ATCommunicationLog."Movement Status" = ATCommunicationLog."Movement Status"::"A - Reversed");
                ATConsumeWebService.RUN(ATCommunicationLog);
            UNTIL ATCommunicationLog.NEXT = 0;
    end;

    procedure SetDocumentType(Type: Option Sales,Return,Transfer,Service)
    begin
        DocumentType := Type;
    end;

    // trigger XMLDoc2::NodeInserting(sender: Variant; e: DotNet XmlNodeChangedEventArgs)
    // begin
    // end;

    // trigger XMLDoc2::NodeInserted(sender: Variant; e: DotNet XmlNodeChangedEventArgs)
    // begin
    // end;

    // trigger XMLDoc2::NodeRemoving(sender: Variant; e: DotNet XmlNodeChangedEventArgs)
    // begin
    // end;

    // trigger XMLDoc2::NodeRemoved(sender: Variant; e: DotNet XmlNodeChangedEventArgs)
    // begin
    // end;

    // trigger XMLDoc2::NodeChanging(sender: Variant; e: DotNet XmlNodeChangedEventArgs)
    // begin
    // end;

    // trigger XMLDoc2::NodeChanged(sender: Variant; e: DotNet XmlNodeChangedEventArgs)
    // begin
    // end;

    // trigger XMLDoc::NodeInserting(sender: Variant; e: DotNet XmlNodeChangedEventArgs)
    // begin
    // end;

    // trigger XMLDoc::NodeInserted(sender: Variant; e: DotNet XmlNodeChangedEventArgs)
    // begin
    // end;

    // trigger XMLDoc::NodeRemoving(sender: Variant; e: DotNet XmlNodeChangedEventArgs)
    // begin
    // end;

    // trigger XMLDoc::NodeRemoved(sender: Variant; e: DotNet XmlNodeChangedEventArgs)
    // begin
    // end;

    // trigger XMLDoc::NodeChanging(sender: Variant; e: DotNet XmlNodeChangedEventArgs)
    // begin
    // end;

    // trigger XMLDoc::NodeChanged(sender: Variant; e: DotNet XmlNodeChangedEventArgs)
    // begin
    // end;
}

