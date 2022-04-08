$site = Get-SPSite "http://atlas-uat.westlake.com/sites/mdm"

# loop through webs

foreach ($web in $site.AllWebs)

{

  <# These properties are on the content type with a customized Nintex Form

        DisplayFormTemplateName     : NFListDisplayForm

        EditFormTemplateName          : NFListEditForm

        NewFormTemplateName         : NFListEditForm

        NewFormUrl                             :

        MobileNewFormUrl                  : _layouts/15/NintexForms/Mobile/NewForm.aspx

        EditFormUrl                              :

        MobileEditFormUrl                   : _layouts/15/NintexForms/Mobile/EditForm.aspx

        DisplayFormUrl                        :

        MobileDisplayFormUrl             : _layouts/15/NintexForms/Mobile/DispForm.aspx

    #>

# Loop through the lists and content types    

    foreach ($list in $web.Lists) {

        foreach ($ct in $list.ContentTypes){

            if ($ct.NewFormTemplateName -eq "NFListEditForm")

            {

                write-host "List Name: " $list.Title" - "$web.Url"/"$list.RootFolder.Url

                write-host "Content Type Name: " $ct.Name

                write-host ---------------------------

            }

        }

    }

    $web.Dispose()

}

$site.Dispose()