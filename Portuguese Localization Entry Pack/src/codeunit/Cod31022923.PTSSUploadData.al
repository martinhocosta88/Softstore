
codeunit 31022923 "PTSS UploadData"
{
    //Taxonomies
    Subtype = Install;
    trigger OnInstallAppPerCompany()
    begin
        NavApp.LoadPackageData(31022979);
        NavApp.LoadPackageData(31022923);
    end;
}