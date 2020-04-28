<script language="javascript" src="https://ben.blackhillscorp.com/sites/Regulatory/SiteAssets/JavaScript/jquery-1.11.3.min.js"></script>
<script language="javascript" src="https://ben.blackhillscorp.com/sites/Regulatory/SiteAssets/JavaScript/jquery.SPServices-2014.02.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-dateFormat/1.0/jquery.dateFormat.min.js" type="text/javascript"></script>
<script src="https://ben.blackhillscorp.com/sites/Regulatory/SiteAssets/JavaScript/moment.js" type="text/javascript"></script>
<script language="javascript">

$(function () {    
    $.ajax({
        url: "/sites/Regulatory/nebraska/2020NEGRR/_api/web/lists/GetByTitle('Contacts 2020 NEG RR')/items?"
        + "$Select=ID,Witness,Attorney,Created,OData__x0031_st_x0020_Draft_x0020_Test,OData__x0032_nd_x0020_Draft_x0020_Test,"
        + "Final_x0020_Testimony_x0020_Due,RegulatoryPartner/Title,Completed1,Task_x0020_Complete,"
        + "RegulatoryPartner/ID,RegulatoryPartner/FirstName,RegulatoryPartner/LastName&$expand=RegulatoryPartner/ID&$orderby=ID asc",
        type: "GET",
        headers: {
            "accept": "application/json;odata=verbose"
        },
    }).success(function (data) {    
  
      var d = new Date();
      var month = d.getMonth() + 1;
      var date = month + "/" + d.getDate() + "/" + d.getFullYear() + "&nbsp;";      
      
      var listItemInfo = '';
       
      listItemInfo += "<table id='WitnessTestimonySummary'><tbody><tr class='title header1' id='Header2'>";
      listItemInfo += "<td width='800' colspan='8'>Witness Testimony Summary - As of: " + date + "</td></tr><tr>";
      listItemInfo += "<td class='columns2'>Witness</td>"; 
      listItemInfo += "<td class='columns2'>Attorney</td>"; 
      listItemInfo += "<td class='columns2'>Regulatory Partner</td>"; 
      listItemInfo += "<td class='columns2'>Outline:</td>"; 
      listItemInfo += "<td class='columns2'>1st Draft:</td>"; 
      listItemInfo += "<td class='columns2'>2nd Draft:</td>"; 
      listItemInfo += "<td class='columns2'>Final:</td></tr><tr>";
      
      $.each(data.d.results, function (key, value) { 
        
        var completedTasks = '';		
          
        for(i=0; i < this.Task_x0020_Complete.results.length; i++) {
           
           completedTasks += this.Task_x0020_Complete.results[i]; 
                                   
        }
        
        var nothingCompleted = completedTasks.search("Nothing Completed");
        var outlineCompleted =  completedTasks.search("Outline Completed");         
        var firstDraftCompleted = completedTasks.search("1st Draft Completed");                
        var secondDraftCompleted = completedTasks.search("2nd Draft Completed");                 
        var finalDraftCompleted = completedTasks.search("Final Draft Completed");
                
        if (nothingCompleted == -1){ //Nothing Completed is not Chosen 
              
           if (outlineCompleted != -1) { //Outline Completed is Chosen
              
             //alert("Outline Completed is Chosen " + outlineCompleted);//For Testing Only 
             var completedCreated = true;
                          
              if (firstDraftCompleted != -1){ //First Draft is Chosen
           
                //alert("First Draft Completed is Chosen " + firstDraftCompleted);//For Testing Only 
                var completed1DueDate = true;
            
                if (secondDraftCompleted != -1) { //Second Draft is Chosen
              
                  //alert("Second Draft Completed is Chosen " + secondDraftCompleted);//For Testing Only 
                  var completed2DueDate = true;
              
                   if (finalDraftCompleted != -1) { //Final Draft Completed
                 
                     //alert("Final Draft Completed is Chosen " + finalDraftCompleted);//For Testing Only 
                     var completedFinalTestDate = true;
              
                   }           
                }              
              }              
           }              
        } else {        
          //alert("Nothing Completed is Chosen " + nothingCompleted);//For Testing Only       
        }  
                
        //*** Today Date ***//
        var today = new Date();
        var dd = today.getDate();
        var mm = today.getMonth()+1; //Add 1 Because Jan is 0
        var yyyy = today.getFullYear();
        todayString = mm + "/" + dd + "/" + yyyy;
        todayDate = new Date(todayString);
        
        ////*** Created Date - Outline Date ***////
        var createdDate1 = $.format.date(value.Created, 'MM/dd/yyyy');
        var createdDate2 = createdDate1.toString();
        var createdDate3 = new Date(createdDate2);          
        
        //*** Created - Outline vs Today Difference
        var timeDiffCreated = Math.abs(todayDate.getTime() - createdDate3.getTime());
        var diffDaysCreated = Math.ceil(timeDiffCreated / (1000 * 3600 * 24));      
         
        //*** Run checkDate     
        createdColor = checkDate(createdDate3,diffDaysCreated,completedCreated);
        //alert("createdColor " + createdColor); //For Testing Only       
         
		if( value.OData__x0031_st_x0020_Draft_x0020_Test != null){
			
        ////*** 1st Due Date ***////
        var firstDueDate1 = $.format.date(value.OData__x0031_st_x0020_Draft_x0020_Test, 'MM/dd/yyyy');         
        var firstDueDate2 = firstDueDate1.toString();
        var firstDueDate3 = new Date(firstDueDate2);		
		        
        //*** 1st Due Date vs Today Difference 
        var timeDiff1DueDate = Math.abs(todayDate.getTime() - firstDueDate3.getTime());
        var diffDays1DueDate = Math.ceil(timeDiff1DueDate / (1000 * 3600 * 24));
        
        //*** Run checkDate
        dueDateColor1 = checkDate(firstDueDate3,diffDays1DueDate,completed1DueDate);
        //alert("dueDateColor1 " + dueDateColor1); //For Testing Only
		
        } else {
			
			dueDateColor1 = "<img alt='Grey' src='/sites/Regulatory/SiteAssets/Images/Grey2.png' style='width: 15px; border-radius: 50%;'/>";			
		}
		
		if( value.OData__x0032_nd_x0020_Draft_x0020_Test != null){
			
        ////*** 2nd Due Date ***////
        var secondDueDate1 = $.format.date(value.OData__x0032_nd_x0020_Draft_x0020_Test, 'MM/dd/yyyy');         
        var secondDueDate2 = secondDueDate1.toString();
        var secondDueDate3 = new Date(secondDueDate2);
        
        //*** 2nd Due Date vs Today Difference
        var timeDiff2DueDate = Math.abs(todayDate.getTime() - secondDueDate3.getTime());
        var diffDays2DueDate = Math.ceil(timeDiff2DueDate / (1000 * 3600 * 24));
        
        //*** Run checkDate
        dueDateColor2 = checkDate(secondDueDate3,diffDays2DueDate,completed2DueDate);
        //alert("dueDateColor2 " + dueDateColor2);//For Testing Only 
		
        } else {
			
			dueDateColor2 = "<img alt='Grey' src='/sites/Regulatory/SiteAssets/Images/Grey2.png' style='width: 15px; border-radius: 50%;'/>";		
		}
		
		if( value.Final_x0020_Testimony_x0020_Due != null){
			
        //*** Final Testimony Date ***
        var finalTestimonyDate1 = $.format.date(value.Final_x0020_Testimony_x0020_Due, 'MM/dd/yyyy');         
        var finalTestimonyDate2 = finalTestimonyDate1.toString();
        var finalTestimonyDate3 = new Date(finalTestimonyDate2);
        
        ////*** Final Testimony Date vs Today Difference ***////
        var timeDiffFinalTestimonyDate = Math.abs(todayDate.getTime() - finalTestimonyDate3.getTime());
        var diffDaysFinalTestimonyDate = Math.ceil(timeDiffFinalTestimonyDate / (1000 * 3600 * 24));
        
        //*** Run checkDate
        finalTestimonyDateColor = checkDate(finalTestimonyDate3,diffDaysFinalTestimonyDate,completedFinalTestDate);
        //alert("finalTestimonyDateColor " + finalTestimonyDateColor);//For Testing Only  
		
		} else {
		
			finalTestimonyDateColor = "<img alt='Grey' src='/sites/Regulatory/SiteAssets/Images/Grey2.png' style='width: 15px; border-radius: 50%;'/>";		
		}
           
        ////*** checkDate ***////
        function checkDate(date,dateDiff,completed){
        
           var color = "";        
                                
           if (completed == true) {            
        
             color = "<img alt='Green' src='/sites/Regulatory/SiteAssets/Images/Green2.png' style='width: 15px; border-radius: 50%;'/>";
             return color;
                
           } else {        
             //alert("Not completed " + completed); //For Testing Only       
           }
           
           //*** Check if Date is in the Past ***
           if (date < todayDate){
        
              //alert("Date in Past"); //For Testing Only
              dateDiff = -Math.abs(dateDiff);
        
           } else {        
              //alert("Date in Future"); //For Testing Only                      
           }                  
              
           //*** Check Date Difference and Complete             
           if (dateDiff <= 1){ //Past Due Date
              
              //alert("Past Due " + date + " " + dateDiff);//For Testing Only
              color = "<img alt='Red' src='/sites/Regulatory/SiteAssets/Images/Red2.png' style='width: 15px; border-radius: 50%;'/>";
              return color;              
        
           } else if (dateDiff >= 1 && dateDiff <= 5) { //Due Within 5 Days Date
        
              //alert("Due Within 5 Days " + date + " " + dateDiff);//For Testing Only
              color = "<img alt='Yellow' src='/sites/Regulatory/SiteAssets/Images/Yellow2.png' style='width: 15px; border-radius: 50%;'/>";
              return color;
        
           } else if (dateDiff > 5) { //Not Due Yet Date
           
              //alert("Not Due Yet " + date + " " + dateDiff);//For Testing Only 
              color = "<img alt='Grey' src='/sites/Regulatory/SiteAssets/Images/Grey2.png' style='width: 15px; border-radius: 50%;'/>";
              return color;      
           
           } else {        
             //alert("Conditions Not Met");//For Testing Only        
           }         
                                
        }     
        
		//Assign Value to Regulatory Partner First Name
		if( value.RegulatoryPartner.FirstName != null) {			
			var rpFirstName = value.RegulatoryPartner.FirstName;		
		} else {		
			var rpFirstName = "None";		
		}
		
		//Assign Value to Regulatory Partner Last Name
		if ( value.RegulatoryPartner.LastName != null) {			
			var rpLastName = value.RegulatoryPartner.LastName;
		} else {
			rpLastName = " Assigned";
		}
		
		if ( value.Attorney != null ) {			
			var vAttorney = value.Attorney;		
		} else {
			var vAttorney = "Not Assigned";
		}
		
		//alert("value.Witness " + value.Witness);
		
	  if (value.Witness == "Yes"){
		
        listItemInfo += "<tr><td class='columns1'>" + value.Witness + "</td><td class='columns1'>" + vAttorney + "</td>"
		+ "<td class='columns1'>" + rpFirstName + " " + rpLastName + "</td>"
		+ "<td class='columns1'>" + createdColor + "</td>"
        + "<td class='columns1'>" + dueDateColor1 + "</td>"
        + "<td class='columns1'>" + dueDateColor2 + "</td>"
        + "<td class='columns1'>" + finalTestimonyDateColor + "</td>"
        + "</tr>";  
		
	  }
                       
      });    
      
      listItemInfo += "<td class='legend' colspan='8'>"; 
      listItemInfo += "<img alt='Green' src='/sites/Regulatory/SiteAssets/Images/Green2.png' style='width: 15px; border-radius: 50%;'/> Completed &nbsp;"; 
      listItemInfo += "<img alt='Yellow' src='/sites/Regulatory/SiteAssets/Images/Yellow2.png' style='width: 15px; border-radius: 50%;'/> Due Within 5 Days &nbsp;"; 
      listItemInfo += "<img alt='Red' src='/sites/Regulatory/SiteAssets/Images/Red2.png' style='width: 15px; border-radius: 50%;'/> Past Due &nbsp;"; 
      listItemInfo += "<img alt='Grey' src='/sites/Regulatory/SiteAssets/Images/Grey2.png' style='width: 15px; border-radius: 50%;'/> Not Due Yet &nbsp;";
      listItemInfo += "</td></tr></tbody></table>"; 
    
      return $("#wts").html(listItemInfo);
      alert("Success");
     
    }); 

    failure(function (data) {

      alert("Failure");

    });
});    

</script>