$databases = get-spcontentdatabase
foreach ($database in $databases)
   {
      #$database | select URl, WebTemplate , WebTemplateID
      $database | select Name, Sites
   }