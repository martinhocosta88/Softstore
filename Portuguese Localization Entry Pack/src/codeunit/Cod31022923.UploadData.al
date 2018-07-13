
codeunit 31022923 "UploadData"
{
    //Taxonomies
    Subtype = Install;
    trigger OnInstallAppPerCompany()
    begin
        NavApp.LoadPackageData(31022979);
    end;

}