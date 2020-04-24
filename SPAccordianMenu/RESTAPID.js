<script language="javascript" src="/sites/Regulatory/SiteAssets/JavaScript/jquery-1.11.3.min.js"></script>
<script language="javascript" src="/sites/Regulatory/SiteAssets/JavaScript/jquery.SPServices-2014.02.js"></script>
<script language="javascript">

$(function () {    
    $.ajax({
        url: "/sites/regulatory/_api/web/lists/GetByTitle('Navigation')/items?$orderby=LVL2Sequence",    
        type: "GET",
        headers: {
            "accept": "application/json;odata=verbose"
        },
    }).success(function (data) {
        
        //alert("REST API");
        
        var listItemInfo = '';
        
        listItemInfo += "<nav><ul id='nav'>"        
        
        //Level 1 LVL1Sequence 1
        $.each(data.d.results, function (key, value) {                           
           if(value.Level == 1){            
             if(value.LVL1Sequence == 1){ 
              listItemInfo += "<li><a href='#'>" + value.Title + "</a><ul>";                                 
             }             
           }                           
        });       

             
        //TopItemID 1 Level 2 LVL2Sequence All
        $.each(data.d.results, function (key, value) {
        if(value.Level == 2){        
             if(value.TopItemID == 1){
               listItemInfo += "<li><a href='" + value.Link + "'>" + value.Title + "</a></li>";
             }                                      
           }                       
        });          
                        
        //Level 1 LVL1Sequence 2
        $.each(data.d.results, function (key, value) {                          
           if(value.Level == 1){            
             if(value.LVL1Sequence == 2){  
              listItemInfo += "</ul></li><li><a href='#'>" + value.Title + "</a><ul>";                                 
             }             
           }                           
        }); 
        
        //TopItemID 2 Level 2 LVL2Sequence All
        $.each(data.d.results, function (key, value) {
        if(value.Level == 2){        
             if(value.TopItemID == 2){
               listItemInfo += "<li><a href='" + value.Link + "'>" + value.Title + "</a></li>";
             }                  
           }                       
        }); 
                          
        
        //Level 1 LVL1Sequence 3
        $.each(data.d.results, function (key, value) {                          
           if(value.Level == 1){ 
             if(value.LVL1Sequence == 3){
              listItemInfo += "</ul></li><li><a href='#'>" + value.Title + "</a><ul>";                                 
             }             
           }                           
        }); 
        
        //TopItemID 3 Level 2 LVL2Sequence All
        $.each(data.d.results, function (key, value) {
        if(value.Level == 2){        
             if(value.TopItemID == 3){
               listItemInfo += "<li><a href='" + value.Link + "'>" + value.Title + "</a></li>";
             }                  
           }                       
        });

        //Level 1 LVL1Sequence 4
        $.each(data.d.results, function (key, value) {                          
           if(value.Level == 1){
             if(value.LVL1Sequence == 4){ 
              listItemInfo += "</ul></li><li><a href='#'>" + value.Title + "</a><ul>";                                 
             }             
           }                           
        }); 
            
        //TopItemID 4 Level 2 LVL2Sequence All
        $.each(data.d.results, function (key, value) {
        if(value.Level == 2){        
             if(value.TopItemID == 4){
               listItemInfo += "<li><a href='" + value.Link + "'>" + value.Title + "</a></li>";
             }                  
           }                       
        });

        //Level 1 LVL1Sequence 5
        $.each(data.d.results, function (key, value) {                          
           if(value.Level == 1){            
             if(value.LVL1Sequence == 5){ 
              listItemInfo += "</ul></li><li><a href='#'>" + value.Title + "</a><ul>";                                 
             }             
           }                           
        }); 
           
        //TopItemID 5 Level 2 LVL2Sequence All
        $.each(data.d.results, function (key, value) {
        if(value.Level == 2){       
             if(value.TopItemID == 5){
               listItemInfo += "<li><a href='" + value.Link + "'>" + value.Title + "</a></li>";
             }                  
           }                       
        });

        //Level 1 LVL1Sequence 6
        $.each(data.d.results, function (key, value) {                          
           if(value.Level == 1){            
             if(value.LVL1Sequence == 6){  
              listItemInfo += "</ul></li><li><a href='#'>" + value.Title + "</a><ul>";                                 
             }             
           }                           
        }); 
           
        //TopItemID 6 Level 2 LVL2Sequence All
        $.each(data.d.results, function (key, value) {
        if(value.Level == 2){        
             if(value.TopItemID == 6){
               listItemInfo += "<li><a href='" + value.Link + "'>" + value.Title + "</a></li>";
             }                  
           }                       
        });

        //Level 1 LVL1Sequence 7
        $.each(data.d.results, function (key, value) {                          
           if(value.Level == 1){ 
             if(value.LVL1Sequence == 7){ 
              listItemInfo += "</ul></li><li><a href='#'>" + value.Title + "</a><ul>";                                 
             }             
           }                           
        }); 
           
        //TopItemID 7 Level 2 LVL2Sequence All
        $.each(data.d.results, function (key, value) {
        if(value.Level == 2){        
             if(value.TopItemID == 7){
               listItemInfo += "<li><a href='" + value.Link + "'>" + value.Title + "</a></li>";
             }                  
           }                       
        });                         

       //Level 1 LVL1Sequence 8
        $.each(data.d.results, function (key, value) { 
           if(value.Level == 1){            
             if(value.LVL1Sequence == 8){  
              listItemInfo += "</ul></li><li><a href='#'>" + value.Title + "</a><ul>";                                 
             }             
           }                           
        }); 
           
        //TopItemID 8 Level 2 LVL2Sequence All
        $.each(data.d.results, function (key, value) {
        if(value.Level == 2){        
             if(value.TopItemID == 8){
               listItemInfo += "<li><a href='" + value.Link + "'>" + value.Title + "</a></li>";
               }                  
           }                       
        }); 

        //Level 1 LVL1Sequence 9
        $.each(data.d.results, function (key, value) {   
           if(value.Level == 1){  
             if(value.LVL1Sequence == 9){  
              listItemInfo += "</ul></li><li><a href='#'>" + value.Title + "</a><ul>";                                 
             }             
           }                           
        }); 
           
        //TopItemID 9 Level 2 LVL2Sequence All
        $.each(data.d.results, function (key, value) {
        if(value.Level == 2){        
             if(value.TopItemID == 9){
               listItemInfo += "<li><a href='" + value.Link + "'>" + value.Title + "</a></li>";
              }                  
           }                       
        }); 

       //Level 1 LVL1Sequence 10
        $.each(data.d.results, function (key, value) {                          
           if(value.Level == 1){             
             if(value.LVL1Sequence == 10){  
              listItemInfo += "</ul></li><li><a href='#'>" + value.Title + "</a><ul>";                                 
             }             
           }                           
        }); 

        //TopItemID 10 Level 2 LVL2Sequence All
        $.each(data.d.results, function (key, value) {
        if(value.Level == 2){        
             if(value.TopItemID == 10){
               listItemInfo += "<li><a href='" + value.Link + "'>" + value.Title + "</a></li>";
             }                  
           }                        
        }); 
             
       //Level 1 LVL1Sequence 11
        $.each(data.d.results, function (key, value) {                           
           if(value.Level == 1){            
             if(value.LVL1Sequence == 11){ 
              listItemInfo += "</ul></li><li><a href='#'>" + value.Title + "</a><ul>";                                 
             }             
           }                           
        }); 

        //TopItemID 11 Level 2 LVL2Sequence All
        $.each(data.d.results, function (key, value) {
        if(value.Level == 2){        
             if(value.TopItemID == 11){
               listItemInfo += "<li><a href='" + value.Link + "'>" + value.Title + "</a></li>";
             }                  
           }                        
        }); 

       //Level 1 LVL1Sequence 12
        $.each(data.d.results, function (key, value) {                          
           if(value.Level == 1){            
             if(value.LVL1Sequence == 12){  
              listItemInfo += "</ul></li><li><a href='#'>" + value.Title + "</a><ul>";                                 
             }             
           }                           
        }); 

        //TopItemID 12 Level 2 LVL2Sequence All
        $.each(data.d.results, function (key, value) {
        if(value.Level == 2){        
             if(value.TopItemID == 12){
               listItemInfo += "<li><a href='" + value.Link + "'>" + value.Title + "</a></li>";
             }                  
           }                        
        }); 

       //Level 1 LVL1Sequence 13
        $.each(data.d.results, function (key, value) {                           
           if(value.Level == 1){              
             if(value.LVL1Sequence == 13){  
              listItemInfo += "</ul></li><li><a href='#'>" + value.Title + "</a><ul>";                                 
             }             
           }                           
        }); 

        //TopItemID 13 Level 2 LVL2Sequence All
        $.each(data.d.results, function (key, value) {
        if(value.Level == 2){        
             if(value.TopItemID == 13){
               listItemInfo += "<li><a href='" + value.Link + "'>" + value.Title + "</a></li>";
               }                  
           }                        
        }); 

       //Level 1 LVL1Sequence 14
        $.each(data.d.results, function (key, value) {                          
           if(value.Level == 1){            
             if(value.LVL1Sequence == 14){ 
              listItemInfo += "</ul></li><li><a href='#'>" + value.Title + "</a><ul>";                                 
             }             
           }                           
        }); 

        //TopItemID 14 Level 2 LVL2Sequence All
        $.each(data.d.results, function (key, value) {
        if(value.Level == 2){        
             if(value.TopItemID == 14){
               listItemInfo += "<li><a href='" + value.Link + "'>" + value.Title + "</a></li>";
             }                  
           }                        
        }); 

       //Level 1 LVL1Sequence 15
        $.each(data.d.results, function (key, value) {                          
           if(value.Level == 1){            
             if(value.LVL1Sequence == 15){  
              listItemInfo += "</ul></li><li><a href='#'>" + value.Title + "</a><ul>";                                 
             }             
           }                           
        }); 

        //TopItemID 15 Level 2 LVL2Sequence All
        $.each(data.d.results, function (key, value) {
        if(value.Level == 2){        
             if(value.TopItemID == 15){
               listItemInfo += "<li><a href='" + value.Link + "'>" + value.Title + "</a></li>";
             }                  
           }                        
        }); 

       
        listItemInfo += "</ul></li></ul></nav>"
        return $("#w").html(listItemInfo);;
                   
    }); 

    failure(function (data) {

      alert("Failure");

    });

});


</script>