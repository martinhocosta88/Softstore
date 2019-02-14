xmlport 31022902 "PTSS AT Inventory Comm. CSV"
{
    //AT Inventory Communication
    Caption = 'AT Inventory Communication';
    Direction = Export;
    FieldDelimiter = '<None>';
    FieldSeparator = ';';
    Format = VariableText;
    TableSeparator = '<NewLine>';
    TextEncoding = UTF8;

    schema
    {
        textelement(root)
        {
            tableelement(Integer; Integer)
            {
                XmlName = 'Header';
                SourceTableView = SORTING (Number)
                                  ORDER(Ascending)
                                  WHERE (Number = CONST (1));
                textelement(ProductCategory)
                {

                    trigger OnBeforePassVariable()
                    begin
                        ProductCategory := 'ProductCategory';
                    end;
                }
                textelement(ProductCode)
                {

                    trigger OnBeforePassVariable()
                    begin
                        ProductCode := 'ProductCode';
                    end;
                }
                textelement(ProductDescription)
                {

                    trigger OnBeforePassVariable()
                    begin
                        ProductDescription := 'ProductDescription';
                    end;
                }
                textelement(ProductNumberCode)
                {

                    trigger OnBeforePassVariable()
                    begin
                        ProductNumberCode := 'ProductNumberCode';
                    end;
                }
                textelement(ClosingStockQuantity)
                {

                    trigger OnBeforePassVariable()
                    begin
                        ClosingStockQuantity := 'ClosingStockQuantity';
                    end;
                }
                textelement(UnitOfMeasure)
                {

                    trigger OnBeforePassVariable()
                    begin
                        UnitOfMeasure := 'UnitOfMeasure';
                    end;
                }
            }
            tableelement(Item; Item)
            {
                XmlName = 'Linhas';
                SourceTableView = SORTING ("No.")
                                  ORDER(Ascending)
                                  WHERE ("Type" = CONST (Inventory),
                                  "Inventory Value Zero" = CONST (False));
                textelement(ProductCategoryVal)
                {
                    trigger OnBeforePassVariable()
                    begin
                        ProductCategoryVal := ATInvComMgmt.GetATProductCategory(Item."Item Category Code");
                    end;
                }
                fieldelement(ProductCodeVal; Item."No.")
                {
                }
                textelement(ProductDescriptionVal)
                {

                    trigger OnBeforePassVariable()
                    begin
                        Str := Item.Description;

                        Len := STRLEN(Str);
                        Len2 := STRLEN(Str);
                        i := 1;

                        REPEAT //percorre a descrição da esquerda para a direita
                            IF Str[i] = '"' THEN BEGIN
                                j := Len;
                                REPEAT //percorre a descrição da direita para a esquerda, e move uma posição para a direita.
                                    Str[j + 1] := Str[j];
                                    j := j - 1;
                                UNTIL j = i - 1;
                                Len := Len + 1; //o len cresceu
                                i := i + 1; // se não incrementar vou apanhar as aspas que acabei de acrescentar
                            END;
                            i := i + 1;
                        UNTIL (i > Len) OR (Len = 0);

                        IF Len <> Len2 THEN
                            Str := '"' + Str + '"';

                        IF (Str[1] <> '"') AND (STRPOS(Str, ';') <> 0) THEN
                            Str := '"' + Str + '"';

                        ProductDescriptionVal := Str;
                    end;
                }
                textelement(ProductNumberCodeVal)
                {

                    trigger OnBeforePassVariable()
                    begin
                        ProductNumberCodeVal := ATInvComMgmt.GetProductNumberCode(Item);
                    end;
                }
                textelement(ClosingStockQuantityVal)
                {

                    trigger OnBeforePassVariable()
                    begin
                        ClosingStockQuantityVal := ClosingStockQuantity;
                    end;
                }
                fieldelement(UnitOfMeasureVal; Item."Base Unit of Measure")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Window.UPDATE(2, Item."No.");
                    ClosingStockQuantity := ATInvComMgmt.FormatDecimal(ATInvComMgmt.GetClosingStockQuantity(Item."No."));

                    IF ClosingStockQuantity = '0,00' THEN
                        currXMLport.SKIP;
                end;

                trigger OnPreXmlItem()
                begin
                    Window.UPDATE(1, Text31022892);
                end;
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

    trigger OnPostXmlPort()
    begin
        Window.UPDATE(1, Text31022893);
        Window.CLOSE;
        ATInvComMgmt.CommATLog();
    end;

    trigger OnPreXmlPort()
    begin
        Window.OPEN(Text31022890 + '\\' + Text31022891);
    end;

    var
        ATInvComMgmt: Codeunit "PTSS AT Inv. Comm. Management";
        Window: Dialog;
        Text31022890: Label 'Block: #1##############';
        Text31022891: Label 'Record: #2##########################';
        Text31022892: Label 'Stock';
        Text31022893: Label 'Saving File.';
        i: Integer;
        j: Integer;
        Len: Integer;
        Len2: Integer;
        Str: Text;


}