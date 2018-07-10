
codeunit 50100 "UploadData"
{
    //Taxonomies
    Subtype = Install;
    trigger OnInstallAppPerCompany()
    begin
        NavApp.LoadPackageData(31022979);
    end;

}