table 31022960 "PTSS BP Ledger Entry"
{
    //COPE

    Caption = 'BP Ledger Entry';
    DrillDownPageID = "PTSS BP Ledger Entries";
    LookupPageID = "PTSS BP Ledger Entries";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(2; "Ledger Entry No."; Integer)
        {
            Caption = 'Ledger Entry No.';
            TableRelation = IF ("Ledger Entry Type" = FILTER (Customer)) "Cust. Ledger Entry"."Entry No."
            ELSE
            IF ("Ledger Entry Type" = FILTER (Vendor)) "Vendor Ledger Entry"."Entry No."
            ELSE
            IF ("Ledger Entry Type" = FILTER ("Bank Account")) "Bank Account Ledger Entry"."Entry No.";
            DataClassification = CustomerContent;

        }
        field(3; "Year"; Integer)
        {
            Caption = 'Year';
            MaxValue = 9999;
            MinValue = 2011;
            DataClassification = CustomerContent;
        }
        field(4; "Month"; Integer)
        {
            Caption = 'Month';
            MaxValue = 12;
            MinValue = 1;
            DataClassification = CustomerContent;
        }
        field(5; "Finance Institution ID"; Text[4])
        {
            Caption = 'Finance Institution ID';
            DataClassification = CustomerContent;
        }
        field(6; "Company ID"; Text[9])
        {
            Caption = 'Company ID';
            DataClassification = CustomerContent;
        }
        field(7; "Identification Code"; Text[20])
        {
            Caption = 'Identification Code';
            DataClassification = CustomerContent;
        }
        field(8; "Reference Date"; Integer)
        {
            Caption = 'Reference Date';
            MaxValue = 21001231;
            MinValue = 20110101;
            DataClassification = CustomerContent;
        }
        field(9; "Record Nature"; Text[1])
        {
            Caption = 'Record Nature';
            DataClassification = CustomerContent;
        }
        field(10; "NPC 2nd Intervener"; Integer)
        {
            BlankZero = true;
            Caption = 'NPC 2nd Intervener';
            DataClassification = CustomerContent;
        }
        field(11; "Amount"; Decimal)
        {
            Caption = 'Amount';
            DataClassification = CustomerContent;
        }
        field(12; "Currency Code"; Code[3])
        {
            Caption = 'Currency Code';
            DataClassification = CustomerContent;
        }
        field(13; "Statistic Code"; Code[5])
        {
            Caption = 'Statistic Code';
            TableRelation = "PTSS BP Statistic";
            DataClassification = CustomerContent;
        }
        field(14; "Amount Type"; Code[1])
        {
            Caption = 'Amount Type';
        }
        field(15; "Account Type"; Code[1])
        {
            Caption = 'Account Type';
            TableRelation = "PTSS BP Account Type";
            DataClassification = CustomerContent;
        }
        field(16; "IF Code"; Code[10])
        {
            Caption = 'IF Code';
            DataClassification = CustomerContent;
        }
        field(17; "Foreign Country Code"; Code[3])
        {
            Caption = 'Country Code';
            TableRelation = "PTSS BP Territory";
            DataClassification = CustomerContent;
        }
        field(18; "Counterpart Country Code"; Code[3])
        {
            Caption = 'Counterpart Country Code';
            TableRelation = "PTSS BP Territory";
            DataClassification = CustomerContent;
        }
        field(19; "Active Country Code"; Code[3])
        {
            Caption = 'Active Country Code';
            TableRelation = "PTSS BP Territory";
            DataClassification = CustomerContent;
        }
        field(20; "Due Date"; Integer)
        {
            Caption = 'Due Date';
            MaxValue = 21001231;
            MinValue = 20110101;
            DataClassification = CustomerContent;
        }
        field(21; "Counterpart ID"; Text[50])
        {
            Caption = 'Counterpart ID';
            DataClassification = CustomerContent;
        }
        field(22; "Observations"; Text[50])
        {
            Caption = 'Observations';
            DataClassification = CustomerContent;
        }
        field(23; "Ledger Entry Type"; Option)
        {
            Caption = 'Ledger Entry Type';
            OptionCaption = 'Customer,Vendor,Bank Account';
            OptionMembers = Customer,Vendor,"Bank Account";
            DataClassification = CustomerContent;
        }
        field(24; "Status"; Option)
        {
            Caption = 'Status';
            OptionCaption = ' ,Exported';
            OptionMembers = " ",Exported;
            DataClassification = CustomerContent;
        }
        field(25; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            Editable = false;
            DataClassification = CustomerContent;
        }
        field(26; "Description"; Text[50])
        {
            Caption = 'Description';
            Editable = false;
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TESTFIELD(Status, Status::" ");
    end;

    var
        Text31022890: Label 'Export ended: %1.';
        FileName: Text[1024];
        CompanyInfo: Record "Company Information";
        GeneralLedgerSetup: Record "General Ledger Setup";

    procedure InitEntry()
    var
        LastIntegrationBankPortugal: Record "PTSS BP Ledger Entry";
    begin
        LastIntegrationBankPortugal.RESET;
        IF LastIntegrationBankPortugal.FINDLAST THEN
            "Entry No." := LastIntegrationBankPortugal."Entry No." + 1
        ELSE
            "Entry No." := 1;
    end;

    procedure ExportXML(Period: Code[6]; ExportMonth: Integer; ExportYear: Integer)
    var
        IntegrationBankPortugal: Record "PTSS BP Ledger Entry";
        XMLIntegrationBankPortugal: XMLport "PTSS BP XML Message";
        XMLFile: File;
        //XMLStream: OutStream;
        //FileManagement: Codeunit "File Management";
        //ServerFileName: Text;
        tmpBlob: Record TempBlob;
        OutputStream: OutStream;
        InputStream: InStream;
    begin
        CLEAR(XMLIntegrationBankPortugal);
        CLEAR(OutputStream);
        CLEAR(XMLFile);
        CompanyInfo.GET;
        GeneralLedgerSetup.GET;


        //Código de exportação antigo
        // ServerFileName := FileManagement.ServerTempFileName('xml');
        // FileName := GeneralLedgerSetup."BP Folder" + 'BOP_COPE.' + CompanyInfo."VAT Registration No." + '.' + Period + '.' +
        //   FORMAT(CURRENTDATETIME, 0, '<Year4><Month,2><Day,2><Hour,2><Minute,2><Second,2>') + '.xml';
        // XMLFile.CREATE(ServerFileName);
        // XMLFile.CREATEOUTSTREAM(XMLStream);
        // XMLIntegrationBankPortugal.SETDESTINATION(XMLStream);
        // XMLIntegrationBankPortugal.InitExport(ExportMonth, ExportYear);
        // XMLFile.CLOSE;
        // XMLIntegrationBankPortugal.ClearNodes(ServerFileName);
        // FileManagement.DownloadToFile(ServerFileName, FileName);
        // MESSAGE(Text31022890, FileName);

        //Código de exportação refeito
        FileName := GeneralLedgerSetup."PTSS BP Folder" + 'BOP_COPE.' + CompanyInfo."VAT Registration No." + '.' + Period + '.' +
          FORMAT(CURRENTDATETIME, 0, '<Year4><Month,2><Day,2><Hour,2><Minute,2><Second,2>') + '.xml';

        tmpBlob.Blob.CreateOutStream(OutputStream);
        XMLIntegrationBankPortugal.SETDESTINATION(OutputStream);
        XMLIntegrationBankPortugal.InitExport(ExportMonth, ExportYear);
        XMLIntegrationBankPortugal.ClearNodes(FileName);
        tmpBlob.Blob.CreateInStream(InputStream);
        DownloadFromStream(InputStream, '', '', '', FileName);
        MESSAGE(Text31022890, FileName);
        //:::::::::

    end;
}

