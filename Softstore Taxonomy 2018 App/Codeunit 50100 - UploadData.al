codeunit 50100 UploadData
{
    Subtype = Install;
    trigger OnInstallAppPerCompany()
    begin
        NavApp.LoadPackageData(31022979);
        
    end;

}