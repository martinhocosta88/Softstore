xmlport 31022894 "PTSS AT WS Transp. Doc. Resp."
{
    // Comunicacao AT

    Caption = 'WS Documento Transporte AT';
    Encoding = UTF8;
    FormatEvaluate = Xml;
    InlineSchema = true;

    schema
    {
        textelement(Envelope)
        {
            textelement(Header)
            {
                MaxOccurs = Once;
                MinOccurs = Zero;
                textelement(WorkContext)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                }
            }
            textelement(Body)
            {
                MaxOccurs = Once;
                MinOccurs = Zero;
                textelement(Fault)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    textelement(faultcode)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;

                        trigger OnAfterAssignVariable()
                        begin
                            ATReturnCode := faultcode;
                        end;
                    }
                    textelement(faultstring)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;

                        trigger OnAfterAssignVariable()
                        begin
                            IF STRLEN(faultstring) > MAXSTRLEN(ATReturnMessage) THEN
                                ATReturnMessage := COPYSTR(faultstring, 1, MAXSTRLEN(ATReturnMessage))
                            ELSE
                                ATReturnMessage := faultstring;
                        end;
                    }
                    textelement(detail)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                    }
                }
                textelement(envioDocumentoTransporteResponseElem)
                {
                    MaxOccurs = Once;
                    MinOccurs = Zero;
                    textelement(ResponseStatus)
                    {
                        MaxOccurs = Unbounded;
                        MinOccurs = Zero;
                        textelement(ReturnCode)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;

                            trigger OnAfterAssignVariable()
                            begin
                                ATReturnCode := ReturnCode;
                            end;
                        }
                        textelement(ReturnMessage)
                        {
                            MaxOccurs = Once;
                            MinOccurs = Zero;

                            trigger OnAfterAssignVariable()
                            begin
                                IF STRLEN(ReturnMessage) > MAXSTRLEN(ATReturnMessage) THEN
                                    ATReturnMessage := COPYSTR(ReturnMessage, 1, MAXSTRLEN(ATReturnMessage))
                                ELSE
                                    ATReturnMessage := ReturnMessage;
                            end;
                        }
                    }
                    textelement(DocumentNumber)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;
                    }
                    textelement(ATDocCodeID)
                    {
                        MaxOccurs = Once;
                        MinOccurs = Zero;

                        trigger OnAfterAssignVariable()
                        begin
                            ATCode := ATDocCodeID;
                        end;
                    }
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnInitXmlPort()
    begin
        CLEAR(ATCode);
        CLEAR(ATReturnMessage);
        CLEAR(ATReturnCode);
    end;

    var
        ATReturnCode: Code[10];
        ATCode: Text[250];
        ATReturnMessage: Text[250];

    procedure GetATResponse(var ATCode1: Text[30]; var ATReturnCode1: Code[10]; var ATReturnMessage1: Text[250]): Text[30]
    begin
        ATCode1 := ATCode;
        ATReturnCode1 := ATReturnCode;
        ATReturnMessage1 := ATReturnMessage;
    end;
}

