codeunit 31022899 "PTSS AT Add XML Namespaces"
{
    // Comunicacao AT


    // trigger OnRun()
    // begin
    //     g_TaxAuthorityWsSetup.GET;

    //     XMLDoc := XMLDoc.XmlDocument;
    //     XMLDoc.Load(InFileName);

    //     NewXMLDoc := NewXMLDoc.XmlDocument;

    //     ProcessingInstrcution := NewXMLDoc.CreateProcessingInstruction('xml', 'version="1.0" encoding="UTF-8"');
    //     NewXMLDoc.AppendChild(ProcessingInstrcution);

    //     XMLNode := NewXMLDoc.CreateNode('element', 'soapenv:Envelope', g_TaxAuthorityWsSetup."XMLNS SoapEnv");
    //     AddAttribute(XMLNode, 'xmlns:doc', g_TaxAuthorityWsSetup."XMLNS Doc");
    //     AddAttribute(XMLNode, 'xmlns:soapenv', g_TaxAuthorityWsSetup."XMLNS SoapEnv");

    //     //soapenv:header
    //     NewNode := NewXMLDoc.CreateNode('element', 'soapenv:Header', XMLNode.NamespaceURI);
    //     XMLNode.AppendChild(NewNode);

    //     XMLNode2 := NewXMLDoc.CreateNode('element', 'wss:Security', g_TaxAuthorityWsSetup."XMLNS Wss");
    //     NewNode.AppendChild(XMLNode2);

    //     NewNode2 := NewXMLDoc.CreateNode('element', 'wss:UsernameToken', g_TaxAuthorityWsSetup."XMLNS Wss");
    //     XMLNode2.AppendChild(NewNode2);

    //     NewSubNode := NewXMLDoc.CreateNode('element', 'wss:Username', g_TaxAuthorityWsSetup."XMLNS Wss");
    //     NewSubNode.InnerText := cuATWebService.GetUserAT;
    //     NewNode2.AppendChild(NewSubNode);

    //     cuATWebService.Credentials(g_Password, g_Nonce, g_Created);

    //     NewSubNode := NewXMLDoc.CreateNode('element', 'wss:Password', g_TaxAuthorityWsSetup."XMLNS Wss");
    //     NewSubNode.InnerText := g_Password;
    //     NewNode2.AppendChild(NewSubNode);

    //     NewSubNode := NewXMLDoc.CreateNode('element', 'wss:Nonce', g_TaxAuthorityWsSetup."XMLNS Wss");
    //     NewSubNode.InnerText := g_Nonce;
    //     NewNode2.AppendChild(NewSubNode);

    //     NewSubNode := NewXMLDoc.CreateNode('element', 'wss:Created', g_TaxAuthorityWsSetup."XMLNS Wss");
    //     NewSubNode.InnerText := g_Created;
    //     NewNode2.AppendChild(NewSubNode);
    //     NewXMLDoc.AppendChild(XMLNode);

    //     // soapenv:Body
    //     NewNode := NewXMLDoc.CreateNode('element', 'soapenv:Body', XMLNode.NamespaceURI);
    //     XMLNode.AppendChild(NewNode);

    //     XMLNode2 := NewXMLDoc.CreateNode('element', 'doc:envioDocumentoTransporteRequestElem', g_TaxAuthorityWsSetup."XMLNS Doc");
    //     NewNode.AppendChild(XMLNode2);

    //     // NAV XMl Port data
    //     NewSubNode2 := XMLDoc.SelectSingleNode('Body');
    //     XMLNodeList := NewSubNode2.ChildNodes;
    //     FOR i := 0 TO XMLNodeList.Count - 1 DO BEGIN
    //         NewSubNode := NewXMLDoc.ImportNode(XMLNodeList.Item(i), TRUE);
    //         NewNode2 := NewSubNode.CloneNode(TRUE);
    //         XMLNode2.AppendChild(NewNode2);
    //     END;

    //     NewXMLDoc.Save(OutFileName);
    // end;

    var
        //     g_TaxAuthorityWsSetup: Record "PTSS Tax Authority WS Setup";
        //     cuATWebService: Codeunit "PTSS AT Consume Web Service";
        //     XMLDoc: DotNet XmlDocument;
        //     ProcessingInstrcution: DotNet XmlProcessingInstruction;
        //     NewXMLDoc: DotNet XmlDocument;
        //     XMLNode: DotNet XmlNode;
        //     XMLNode2: DotNet XmlNode;
        //     NewNode: DotNet XmlNode;
        //     NewNode2: DotNet XmlNode;
        //     NewSubNode: DotNet XmlNode;
        //     NewSubNode2: DotNet XmlNode;
        //     XMLNodeList: DotNet XmlNodeList;
        //     i: Integer;
        InFileName: Text[250];
        OutFileName: Text[250];
        //     g_Password: Text[250];
        //     g_Nonce: Text[400];
        //     g_Created: Text[250];

        // procedure AddAttribute(var XMLAttNode: DotNet XmlNode; AttributeName: Text[180]; AttributeValue: Text[180])
        // var
        //     NewAttributeNode: DotNet XmlAttribute;
        // begin
        //     NewAttributeNode := XMLAttNode.OwnerDocument.CreateAttribute(AttributeName);
        //     IF AttributeValue <> '' THEN
        //         NewAttributeNode.Value := AttributeValue;
        //     XMLAttNode.Attributes.SetNamedItem(NewAttributeNode);

        //     CLEAR(NewAttributeNode);
        // end;

    procedure GetPath(InputXML: Text[250]; OutputXML: Text[250])
    begin
        InFileName := InputXML;
        OutFileName := OutputXML;
    end;
}

