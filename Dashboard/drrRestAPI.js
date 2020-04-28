<script language="javascript" src="https://ben.blackhillscorp.com/sites/Regulatory/SiteAssets/JavaScript/jquery-1.11.3.min.js"></script>
<script language="javascript" src="https://ben.blackhillscorp.com/sites/Regulatory/SiteAssets/JavaScript/jquery.SPServices-2014.02.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-dateFormat/1.0/jquery.dateFormat.min.js" type="text/javascript"></script>
<script language="javascript">

$(function () {    
    $.ajax({
        url: "/sites/Regulatory/nebraska/2020NEGRR/_api/web/lists/GetByTitle('Data Requests 2020 NEG RR')/items?$orderby=Party_x0020_Name asc", 
        type: "GET",
        headers: {
            "accept": "application/json;odata=verbose"
        },
    }).success(function (data) {        
      
      var listItemInfo = '';
      var arrayPartyName = []; // An Array to Hold All the Party Names
      var uniquePartyName = []; // An Array to Hold All the Unique Party Names
      var arrayPartySet = []; 
      var uniquePartyNameLength = "";
      
      $.each(data.d.results, function (key, value) {

         //*** Set All the Field Values to Variables ***//
         var ID = value.ID;         
         var txtTitle = value.Title;         
         var partyName = value.Party_x0020_Name; 
		 //alert("partyName " + partyName); // For Testing Only
         var partySet = value.Party_x0020_Set; 
	     //alert("partySet " + partySet); // For Testing Only
         var drNumber = value.DR_x0020_Number; 
		 //alert("drNumber " + drNumber); // For Testing Only
         var subParts = value.Subparts; 
		 //alert("subParts " + subParts); // For Testing Only
         
         //Party Sets
         if (partySet != null){
		 arrayPartySet.push(partySet); }         
         //alert("arrayPartySet " + arrayPartySet); // For Testing Only      
                  
         //*** Create an Array with All Party Names 
         if (partyName != null){	 
         arrayPartyName.push(partyName); }
         
         //*** Use the Array with All Party Names to Create an Array of Unique Party Names
         uniquePartyName = getUnique(arrayPartyName);
		 //alert("uniquePartyName " + uniquePartyName[0].toString());  // For Testing Only
         uniquePartyNameLength = uniquePartyName.length; 
		 //alert("uniquePartyNameLength " + uniquePartyNameLength); // For Testing Only
                
         //*** Function to Trim an Arrray to Unique Items
         function getUnique(array){
           var uniqueArray = [];
        
           // Loop through array values
           for(i=0; i < array.length; i++){
              if(uniqueArray.indexOf(array[i]) === -1) {
                uniqueArray.push(array[i]);
              }
           }
             return uniqueArray;
         }                 
      }); 
      
      //Headers, Questions, Party Sets, Questions Served
      var partyNameHeaders = ""; 
      var partyNameQuestions = "";
      var questionTotals = "";
      var partySets = ""; 
      var totalSets = ""; 
      var questionsServed = ""; 
      var totalsServed = "";
      var rowArray = [];
      
      //Row Variables
      var rowL1200 = "";
      var rowL1100 = "";
      var rowL1000 = "";
      var rowL900 = "";
      var rowL800 = "";
      var rowL700 = "";
      var rowL600 = "";
      var rowL500 = "";
      var rowL400 = "";
      var rowL300 = "";
      var rowL200 = "";
      var rowL100 = "";
      var rowL000 = "";
      
      //Create All Blue Columns
      function blueColumn(number){
         
        if (number >= 0){
         rowL000 += "<td class='blue'>&nbsp;</td>";
         //alert("0"); // For Testing Only
        } else {
         rowL000 += "<td class='blank'>&nbsp;</td>";
        }
        
        if (number >= 100){
         rowL100 += "<td class='blue'>&nbsp;</td>";
         //alert("100"); // For Testing Only
        } else {
         rowL100 += "<td class='blank'>&nbsp;</td>";
        }

        if (number >= 200){
          rowL200 += "<td class='blue'>&nbsp;</td>";
          //alert("200"); // For Testing Only
        } else {
         rowL200 += "<td class='blank'>&nbsp;</td>";
        }

        if (number >= 300){
         rowL300 += "<td class='blue'>&nbsp;</td>";
         //alert("300"); // For Testing Only
        } else {
         rowL300 += "<td class='blank'>&nbsp;</td>";
        }

        if (number >= 400){
         rowL400 += "<td class='blue'>&nbsp;</td>";
         //alert("400"); // For Testing Only
        } else {
         rowL400 += "<td class='blank'>&nbsp;</td>";
        }

        if (number >= 500){
         rowL500 += "<td class='blue'>&nbsp;</td>";
         //alert("500"); // For Testing Only
        } else {
         rowL500 += "<td class='blank'></td>";
        }

        if (number >= 600){
         rowL600 += "<td class='blue'>&nbsp;</td>";
         //alert("600"); // For Testing Only
        } else {
         rowL600 += "<td class='blank'>&nbsp;</td>";
        }

        if (number >= 700){
         rowL700 += "<td class='blue'>&nbsp;</td>";
         //alert("700"); // For Testing Only
        } else {
         rowL700 += "<td class='blank'>&nbsp;</td>";
        }

        if (number >= 800){
         rowL800 += "<td class='blue'>&nbsp;</td>";
         //alert("800"); // For Testing Only
        } else {
         rowL800 += "<td class='blank'>&nbsp;</td>";
        }

        if (number >= 900){
         rowL900 += "<td class='blue'>&nbsp;</td>";
         //alert("900"); // For Testing Only
        } else {
         rowL900 += "<td class='blank'>&nbsp;</td>";
        }

        if (number >= 1000){
         rowL1000 += "<td class='blue'>&nbsp;</td>";
         //alert("1000"); // For Testing Only
        } else {
         rowL1000 += "<td class='blank'>&nbsp;</td>";
        }

        if (number >= 1100){
         rowL1100 += "<td class='blue'>&nbsp;</td>";
         //alert("1100"); // For Testing Only
        } else {
         rowL1100 += "<td class='blank'>&nbsp;</td>";
        }

        if (number >= 1200){
         rowL1200 += "<td class='blue'>&nbsp;</td>";
         //alert("1200"); // For Testing Only
        } else {
         rowL1200 += "<td class='blank'>&nbsp;</td>";
        }         
      }
      
      //Create All Orange Columns
      function orangeColumn(number){
         
        if (number >= 0){
         rowL000 += "<td class='orange'>&nbsp;</td>";
         //alert("0"); // For Testing Only
        } else {
         rowL000 += "<td class='blank'>&nbsp;</td>";
        }

        if (number >= 100){
         rowL100 += "<td class='orange'>&nbsp;</td>";
         //alert("100"); // For Testing Only
        } else {
         rowL100 += "<td class='blank'>&nbsp;</td>";
        }

        if (number >= 200){
          rowL200 += "<td class='orange'>&nbsp;</td>";
          //alert("200"); // For Testing Only
        } else {
         rowL200 += "<td class='blank'>&nbsp;</td>";
        }

        if (number >= 300){
         rowL300 += "<td class='orange'>&nbsp;</td>";
         //alert("300"); // For Testing Only
        } else {
         rowL300 += "<td class='blank'>&nbsp;</td>";
        }

        if (number >= 400){
         rowL400 += "<td class='orange'>&nbsp;</td>";
         //alert("400"); // For Testing Only
        } else {
         rowL400 += "<td class='blank'>&nbsp;</td>";
        }

        if (number >= 500){
         rowL500 += "<td class='orange'>&nbsp;</td>";
         //alert("500"); // For Testing Only
        } else {
         rowL500 += "<td>&nbsp;</td>";
        }

        if (number >= 600){
         rowL600 += "<td class='orange'>&nbsp;</td>";
         //alert("600"); // For Testing Only
        } else {
         rowL600 += "<td class='blank'>&nbsp;</td>";
        }

        if (number >= 700){
         rowL700 += "<td class='orange'>&nbsp;</td>";
         //alert("700"); // For Testing Only
        } else {
         rowL700 += "<td class='blank'>&nbsp;</td>";
        }

        if (number >= 800){
         rowL800 += "<td class='orange'>&nbsp;</td>";
         //alert("800"); // For Testing Only
        } else {
         rowL800 += "<td class='blank'>&nbsp;</td>";
        }

        if (number >= 900){
         rowL900 += "<td class='orange'>&nbsp;</td>";
         //alert("900"); // For Testing Only
        } else {
         rowL900 += "<td class='blank'>&nbsp;</td>";
        }

        if (number >= 1000){
         rowL1000 += "<td class='orange'>&nbsp;</td>";
         //alert("1000"); // For Testing Only
        } else {
         rowL1000 += "<td class='blank'>&nbsp;</td>";
        }

        if (number >= 1100){
         rowL1100 += "<td class='orange'>&nbsp;</td>";
         //alert("1100"); // For Testing Only
        } else {
         rowL1100 += "<td class='blank'>&nbsp;</td>";
        }

        if (number >= 1200){
         rowL1200 += "<td class='orange'>&nbsp;</td>";
         //alert("1200"); // For Testing Only
        } else {
         rowL1200 += "<td class='blank'>&nbsp;</td>";
        }         
      }
      
      //Create All Grey Columns
      function greyColumn(number){
         
        if (number >= 0){
         rowL000 += "<td class='grey'>&nbsp;</td><td></td>";
         //alert("0"); // For Testing Only
        } else {
         rowL000 += "<td class='blank'>&nbsp;</td><td></td>";
        }

        if (number >= 100){
         rowL100 += "<td class='grey'>&nbsp;</td><td></td>";
         //alert("100"); // For Testing Only
        } else {
         rowL100 += "<td class='blank'>&nbsp;</td><td></td>";
        }

        if (number >= 200){
          rowL200 += "<td class='grey'>&nbsp;</td><td></td>";
          //alert("200"); // For Testing Only
        } else {
         rowL200 += "<td class='blank'>&nbsp;</td><td></td>";
        }

        if (number >= 300){
         rowL300 += "<td class='grey'>&nbsp;</td><td></td>";
         //alert("300"); // For Testing Only
        } else {
         rowL300 += "<td class='blank'>&nbsp;</td><td></td>";
        }

        if (number >= 400){
         rowL400 += "<td class='grey'>&nbsp;</td><td></td>";
         //alert("400"); // For Testing Only
        } else {
         rowL400 += "<td class='blank'>&nbsp;</td><td></td>";
        }

        if (number >= 500){
         rowL500 += "<td class='grey'>&nbsp;</td><td></td>";
         //alert("500"); // For Testing Only
        } else {
         rowL500 += "<td class='blank'>&nbsp;</td><td></td>";
        }

        if (number >= 600){
         rowL600 += "<td class='grey'>&nbsp;</td><td></td>";
         //alert("600"); // For Testing Only
        } else {
         rowL600 += "<td class='blank'>&nbsp;</td><td></td>";
        }

        if (number >= 700){
         rowL700 += "<td class='grey'>&nbsp;</td><td></td>";
         //alert("700"); // For Testing Only
        } else {
         rowL700 += "<td class='blank'>&nbsp;</td><td></td>";
        }

        if (number >= 800){
         rowL800 += "<td class='grey'>&nbsp;</td><td></td>";
         //alert("800"); // For Testing Only
        } else {
         rowL800 += "<td class='blank'>&nbsp;</td><td></td>";
        }

        if (number >= 900){
         rowL900 += "<td class='grey'>&nbsp;</td><td></td>";
         //alert("900"); // For Testing Only
        } else {
         rowL900 += "<td class='blank'>&nbsp;</td><td></td>";
        }

        if (number >= 1000){
         rowL1000 += "<td class='grey'>&nbsp;</td><td></td>";
         //alert("1000"); // For Testing Only
        } else {
         rowL1000 += "<td class='blank'>&nbsp;</td><td></td>";
        }

        if (number >= 1100){
         rowL1100 += "<td class='grey'>&nbsp;</td><td></td>";
         //alert("1100"); // For Testing Only
        } else {
         rowL1100 += "<td class='blank'>&nbsp;</td><td></td>";
        }

        if (number >= 1200){
         rowL1200 += "<td class='grey'>&nbsp;</td><td></td>";
         //alert("1200"); // For Testing Only
        } else {
         rowL1200 += "<td class='blank'>&nbsp;</td><td></td>";
        }         
      }
               
      //Party Name 1      
      if (uniquePartyNameLength >= 1){
       
         var iNum1 = " ";
         var iNumAdd1 = parseInt(0);
         var qsNum1 = " ";
         var qsNumAdd1 = parseInt(0);
		 //var subparts1 = value.Subparts;
         
         //Headers 1 
         partyNameHeaders += "<td class='questions' colspan='3'>" + uniquePartyName[0] + "</td>";
       
         //Questions and Questions Served Calc 1
         $.each(data.d.results, function (key, value) {
           
           var servedQuestion1 = value.Questions_x0020_Served;
		   //alert("servedQuestion1 " + servedQuestion1); // For Testing Only
           
           //Questions Calc 1
           if(value.Party_x0020_Name == uniquePartyName[0]){ 
              var subparts1 = value.Subparts;
              if (subparts1 == null){ subparts1 = 0; } else { subparts1 = value.Subparts; }
			  //alert("subparts1 " + subparts1);
			  
              iNum1 = parseInt(subparts1);
			  //alert("iNum1 " + iNum1);
              iNumAdd1 = iNumAdd1 + iNum1;               
           } 
           
           //Questions Served Calc 1
           if(value.Party_x0020_Name == uniquePartyName[0]){ 
              if (servedQuestion1 != null){                           
                 qsNum1 = parseInt(servedQuestion1);
                 qsNumAdd1 = qsNumAdd1 + qsNum1; 
                 //alert("qsNumAdd1 " + qsNumAdd1); // For Testing Only
              }              
           }                                                                      
         }); 
         
         //Questions Total 1
         partyNameQuestions += "<td class='questions' colspan='3'>" + iNumAdd1 + "</td>";
         rowArray.push(iNumAdd1); 
         
         //Set Blue Column
         blueColumn(iNumAdd1);          
         
         //Sets Total 1
         var count1 = arrayPartySet.filter(str => str.includes(uniquePartyName[0])).length; 
         partySets += "<td class='questions' colspan='3'>" + count1 + "</td><td></td>"; 
		 totalSets = count1;
		 //alert("totalSets " + totalSets);	// For Testing Only	 
         
         //Set Orange Column
         orangeColumn(count1);
         
         //Questions Served Total 1
         questionsServed +=  "<td class='questions' colspan='3'>" + qsNumAdd1 + "</td><td></td>";
         
         //Set Grey Column
         greyColumn(qsNumAdd1);                                   
           
      } else {         
         alert("conditions not met 1");         
      }      
      
      //Totals 1
	  if (uniquePartyNameLength >= 1){
		  
		questionTotals = iNumAdd1;
		//alert("questionTotals 1 " + questionTotals); // For Testing Only
		totalsServed = qsNumAdd1;
		//alert("totalsServed 1 " + totalsServed); // For Testing Only
	  
	  }
       
      //Party Name 2      
      if (uniquePartyNameLength >= 2){
       
         var iNum = " ";
         var iNumAdd2 = parseInt(0); 
         var qsNum2 = " ";
         var qsNumAdd2 = parseInt(0);
         
         //Headers 2
         partyNameHeaders += "<td></td><td class='questions' colspan='3'>" + uniquePartyName[1] + "</td>";
       
         //Questions and Questions Served Calc 2
         $.each(data.d.results, function (key, value) { 
         
           var servedQuestion2 = value.Questions_x0020_Served;
           //alert("servedQuestion2 " + servedQuestion2); // For Testing Only	   
           
           //Questions Calc 2
           if(value.Party_x0020_Name == uniquePartyName[1]){ 
              var subparts2 = value.Subparts;
              if (subparts2 == null){ subparts2 = 0; } else { subparts2 = value.Subparts; }
			  //alert("subparts2 " + subparts2 + " " + value.Party_x0020_Name);
			  
              iNum2 = parseInt(subparts2);
			  //alert("iNum2 " + iNum2);	
              iNumAdd2 = iNumAdd2 + iNum2;       
           } 
           
           //Questions Served Calc 2
           if(value.Party_x0020_Name == uniquePartyName[1]){ 
              if (servedQuestion2 != null){                           
                 qsNum2 = parseInt(servedQuestion2);
                 qsNumAdd2 = qsNumAdd2 + qsNum2; 
                 //alert("qsNumAdd2 " + qsNumAdd2); // For Testing Only
              }              
           }                                                         
         });       
         
         //Questions Total 2
         partyNameQuestions += "<td></td><td class='questions' colspan='3'>" + iNumAdd2 + "</td>";
         rowArray.push(iNumAdd2); 

         //Set Blue Column
         blueColumn(iNumAdd2); 
         
         //Sets Total 2
         var count2 = arrayPartySet.filter(str => str.includes(uniquePartyName[1])).length;         
         partySets += "<td class='questions' colspan='3'>" + count2 + "</td><td></td>";
         
         //Set Orange Column
         orangeColumn(count2); 
         
         //Served Total 2
         questionsServed +=  "<td class='questions' colspan='3'>" + qsNumAdd2 + "</td><td></td>";
         
         //Set Grey Column
         greyColumn(qsNumAdd2);              
           
      } else {         
         //alert("conditions not met 2"); // For Testing Only         
      }    
    
      //Totals 2
	  if (uniquePartyNameLength >= 2){
		  
		questionTotals = questionTotals + iNumAdd2;
		//alert("questionTotals 2 " + questionTotals); // For Testing Only
		totalSets = totalSets + count2;
		totalsServed = totalsServed + qsNumAdd2;
		//alert("totalsServed 2 " + totalsServed); // For Testing Only

	 }

      //Party Name 3
      if (uniquePartyNameLength >= 3){
       
         var iNum3 = " ";
         var iNumAdd3 = parseInt(0);
         var qsNum3 = " ";
         var qsNumAdd3 = parseInt(0); 
         
         //Headers 3 
         partyNameHeaders += "<td></td><td class='questions' colspan='3'>" + uniquePartyName[2] + "</td>"; 
       
         //Questions and Questions Served Calc 3
         $.each(data.d.results, function (key, value) {  
         
		   var servedQuestion3 = value.Questions_x0020_Served;
		   //alert("servedQuestion3 " + servedQuestion3); // For Testing Only
           
           //Questions Calc 3
           if(value.Party_x0020_Name == uniquePartyName[2]){  

              var subparts3 = value.Subparts;
              if (subparts3 == null){ subparts3 = 0; } else { subparts3 = value.Subparts; }
			  //alert("subparts3 " + subparts3 + " " + value.Party_x0020_Name);
              		  
              iNum3 = parseInt(subparts3);
			  //alert("iNum3 " + iNum3);	
              iNumAdd3 = iNumAdd3 + iNum3;
			  
           } 
           
           //Questions Served Calc 3
           if(value.Party_x0020_Name == uniquePartyName[2]){ 
              if (servedQuestion3 != null){                           
                 qsNum3 = parseInt(servedQuestion3);
                 qsNumAdd3 = qsNumAdd3 + qsNum3; 
                 //alert("qsNumAdd3 " + qsNumAdd3); // For Testing Only
              }              
           }                          
         });         
         
         //Questions Total 3
         partyNameQuestions += "<td></td><td class='questions' colspan='3'>" + iNumAdd3 + "</td>";
         rowArray.push(iNumAdd3); 

         //Set Blue Column
         blueColumn(iNumAdd3); 
         
         //Sets Total 3
         var count3 = arrayPartySet.filter(str => str.includes(uniquePartyName[2])).length;         
         partySets += "<td class='questions' colspan='3'>" + count3 + "</td><td></td>";
         
         //Set Orange Column
         orangeColumn(count3);
         
         //Served Total 3
         questionsServed +=  "<td class='questions' colspan='3'>" + qsNumAdd3 + "</td><td></td>";
         
         //Set Grey Column
         greyColumn(qsNumAdd3);                
           
      } else {         
         //alert("conditions not met 3"); // For Testing Only        
      }           
      
      //Totals 3
	  if (uniquePartyNameLength >= 3){
		  
		questionTotals = questionTotals + iNumAdd3;
		//alert("questionTotals 3 " + questionTotals); // For Testing Only
		totalSets = totalSets + count3;
		totalsServed = totalsServed + qsNumAdd3;
		//alert("totalsServed 3 " + totalsServed); // For Testing Only
	  
	  }

      //Party Name 4
      if (uniquePartyNameLength >= 4){
       
         var iNum4 = " ";
         var iNumAdd4 = parseInt(0); 
         var qsNum4 = " ";
         var qsNumAdd4 = parseInt(0);
         
         //Headers     
         partyNameHeaders += "<td></td><td class='questions' colspan='3'>" + uniquePartyName[3] + "</td>";
       
         //Questions and Questions Served Calc 4
         $.each(data.d.results, function (key, value) { 
         
           var servedQuestion4 = value.Questions_x0020_Served; 
		   //alert("servedQuestion4 " + servedQuestion4); // For Testing Only
           
           //Questions Calc 4
           if(value.Party_x0020_Name == uniquePartyName[3]){  

              var subparts4 = value.Subparts;
              if (subparts4 == null){ subparts4 = 0; } else { subparts4 = value.Subparts; }
			  //alert("subparts4 " + subparts4 + " " + value.Party_x0020_Name);
              		  
              iNum4 = parseInt(subparts4);
			  //alert("iNum4 " + iNum4);	
              iNumAdd4 = iNumAdd4 + iNum4;      
           } 
           
           //Questions Served Calc 4
           if(value.Party_x0020_Name == uniquePartyName[3]){ 
              if (servedQuestion4 != null){                           
                 qsNum4 = parseInt(servedQuestion4);
                 qsNumAdd4 = qsNumAdd4 + qsNum4; 
                 //alert("qsNumAdd4 " + qsNumAdd4); // For Testing Only
              }              
           }                           
         });      
         
         //Questions Total 4
         partyNameQuestions += "<td></td><td class='questions' colspan='3'>" + iNumAdd4 + "</td>";
         rowArray.push(iNumAdd4); 

         //Set Blue Column
         blueColumn(iNumAdd4); 
         
         //Sets Total 4
         var count4 = arrayPartySet.filter(str => str.includes(uniquePartyName[3])).length;         
         partySets += "<td class='questions' colspan='3'>" + count4 + "</td><td></td>";
         
         //Set Orange Column
         orangeColumn(count4);
         
         //Served Total 4
         questionsServed +=  "<td class='questions' colspan='3'>" + qsNumAdd4 + "</td><td></td>"; 
         
         //Set Grey Column
         greyColumn(qsNumAdd4);     
           
      } else {         
         //alert("conditions not met 4");         
      }   
      
      //Totals 4
	  if (uniquePartyNameLength >= 4){
		  
		questionTotals = questionTotals + iNumAdd4;
		//alert("questionTotals 4 " + questionTotals); // For Testing Only
		totalSets = totalSets + count4;
		totalsServed = totalsServed + qsNumAdd4;
		//alert("totalsServed 4 " + totalsServed); // For Testing Only
	  
	  }
    
      //Party Name 5
      if (uniquePartyNameLength >= 5){
       
         var iNum5 = " ";
         var iNumAdd5 = parseInt(0);
         var qsNum5 = " ";
         var qsNumAdd5 = parseInt(0); 
         
         //Headers 5   
         partyNameHeaders += "<td></td><td class='questions' colspan='3'>" + uniquePartyName[4] + "</td>";
       
         //Questions and Questions Served Calc 5
         $.each(data.d.results, function (key, value) { 
         
           var servedQuestion5 = value.Questions_x0020_Served; 
		   //alert("servedQuestion5 " + servedQuestion5); // For Testing Only
           
           //Questions Calc 5
           if(value.Party_x0020_Name == uniquePartyName[4]){   

              var subparts5 = value.Subparts;
              if (subparts5 == null){ subparts5 = 0; } else { subparts5 = value.Subparts; }
			  //alert("subparts5 " + subparts5 + " " + value.Party_x0020_Name);
              		  
              iNum5 = parseInt(subparts5);
			  //alert("iNum5 " + iNum5);	
              iNumAdd5 = iNumAdd5 + iNum5;      
           } 
           
           //Questions Served Calc 5
           if(value.Party_x0020_Name == uniquePartyName[4]){ 
              if (servedQuestion5 != null){                           
                 qsNum5 = parseInt(servedQuestion5);
                 qsNumAdd5 = qsNumAdd5 + qsNum5; 
                 //alert("qsNumAdd5 " + qsNumAdd5); // For Testing Only
              }              
           }      
         });      
        
         //Questions Total 5
         partyNameQuestions += "<td></td><td class='questions' colspan='3'>" + iNumAdd5 + "</td>";
         rowArray.push(iNumAdd5); 

         //Set Blue Column
         blueColumn(iNumAdd5); 
         
         //Sets Total 5
         var count5 = arrayPartySet.filter(str => str.includes(uniquePartyName[4])).length;         
         partySets += "<td class='questions' colspan='3'>" + count5 + "</td><td></td>";
         
         //Set Orange Column
         orangeColumn(count5);
         
         //Questions Served Total 5
         questionsServed +=  "<td class='questions' colspan='3'>" + qsNumAdd5 + "</td><td></td>";
         
         //Set Grey Column
         greyColumn(qsNumAdd5);     
           
      } else {         
         //alert("conditions not met 5"); // For Testing Only        
      }      
      
      //Totals 5
	  if (uniquePartyNameLength >= 5){
		  
		questionTotals = questionTotals + iNumAdd5;
		//alert("questionTotals 5 " + questionTotals); // For Testing Only
		totalSets = totalSets + count5;
		totalsServed = totalsServed + qsNumAdd5;
		//alert("totalsServed 5 " + totalsServed); // For Testing Only
		
	  }
      
      //Party Name 6
      if (uniquePartyNameLength >= 6){
       
         var iNum6 = " ";
         var iNumAdd6 = parseInt(0);
         var qsNum6 = " ";
         var qsNumAdd6 = parseInt(0); 
         
         //Headers 6   
         partyNameHeaders += "<td></td><td class='questions' colspan='3'>" + uniquePartyName[5] + "</td>";
         //alert("partyName6 " + partyName6);
          
         //Questions and Qquestions Served Calc 6
         $.each(data.d.results, function (key, value) {  
         
            var servedQuestion6 = value.Questions_x0020_Served;
			//alert("servedQuestion6 " + servedQuestion6); //For testing Only
           
           //Questions Calc 6
           if(value.Party_x0020_Name == uniquePartyName[5]){ 

              var subparts6 = value.Subparts;
              if (subparts6 == null){ subparts6 = 0; } else { subparts6 = value.Subparts; }
			  //alert("subparts6 " + subparts6 + " " + value.Party_x0020_Name);
              		  
              iNum6 = parseInt(subparts6);
			  //alert("iNum6 " + iNum6);	
              iNumAdd6 = iNumAdd6 + iNum6;      
           }
           
           //Questions Served Calc 6
           if(value.Party_x0020_Name == uniquePartyName[5]){ 
              if (servedQuestion6 != null){                           
                 qsNum6 = parseInt(servedQuestion6);
                 qsNumAdd6 = qsNumAdd6 + qsNum6; 
                 //alert("qsNumAdd6 " + qsNumAdd6); // For Testing Only
              }              
           }                              
         });      

         //Questions Total 6
         partyNameQuestions += "<td></td><td class='questions' colspan='3'>" + iNumAdd6 + "</td>";
         rowArray.push(iNumAdd6);
         
         //Set Blue Column
         blueColumn(iNumAdd6);  
         
         //Sets Total 6
         var count6 = arrayPartySet.filter(str => str.includes(uniquePartyName[5])).length;         
         partySets += "<td class='questions' colspan='3'>" + count6 + "</td>"; 
         
         //Set Orange Column
         orangeColumn(count6);
         
         //Served Questions Total 6
         questionsServed +=  "<td class='questions' colspan='3'>" + qsNumAdd6 + "</td><td></td>";
         
         //Set Grey Column
         greyColumn(qsNumAdd6);     
           
      } else {         
         //alert("conditions not met 6"); // For Testing Only        
      }   
      
      //Totals 6
	  if (uniquePartyNameLength >= 6){
		  
		questionTotals = questionTotals + iNumAdd6; 
		//alert("questionTotals 6 " + questionTotals); // For Testing Only
		totalSets = totalSets + count6;
		totalsServed = totalsServed + qsNumAdd6;
		
	  }
      
      //Grand Totals - Questions, Sets, Questions Served                                                                  
      questionTotals = "<td></td><td class='questionstotal' colspan='3'>" + questionTotals + "</td>"; 
      totalSets = "<td></td><td class='questionstotal' colspan='3'>" + totalSets + "</td>";
      totalsServed = "<td class='questionstotal' colspan='3'>" + totalsServed + "</td>";
         
      var rowCount = Math.max.apply(null,rowArray);
      
      makeTable(uniquePartyNameLength,rowCount);
      
      function makeTable(columns,rows) {
      
         columnNumbers = columns * 4;
         columnNumbers = columnNumbers + 4;
         //alert("columnNumbers " + columnNumbers);//For Testing Only
      
         listItemInfo += "<table id='DiscoveryRequestsRisks' style='cellpadding:10';><tbody><tr class='title header1' id='Header2'><td width='100%' colspan='" + columnNumbers + "'>Discovery Requests: Number of Sets, Total Data Requests (Including Subparts), Number of Data Requests Served (Including Subparts)</td></tr>";
         listItemInfo += "<tr id='r1200'><td id='L1200' class='scale' width='10%'>1200</td><td></td>" + rowL1200 + "<td>&nbsp;</td></tr>";
         listItemInfo += "<tr id='r1100'><td id='L1100'></td><td></td>" + rowL1100 + "<td>&nbsp;</td></tr>";
         listItemInfo += "<tr id='r1000'><td id='L1000' class='scale'>1000</td><td></td>" + rowL1000 + "<td>&nbsp;</td></tr>";
         listItemInfo += "<tr id='r900'><td id='L900'></td><td></td>" + rowL900 + "<td>&nbsp;</td></tr>";
         listItemInfo += "<tr id='r800'><td id='L800' class='scale'>800</td><td></td>" + rowL800 + "<td>&nbsp;</td></tr>";
         listItemInfo += "<tr id='r700'><td id='L700'></td><td></td>" + rowL700 + "<td>&nbsp;</td></tr>";
         listItemInfo += "<tr id='r600'><td id='L600' class='scale'>600</td><td></td>" + rowL600 + "<td>&nbsp;</td></tr>";
         listItemInfo += "<tr id='r500'><td id='L500'></td><td></td>" + rowL500 + "<td>&nbsp;</td></tr>";
         listItemInfo += "<tr id='r400'><td id='L400' class='scale'>400</td><td></td>" + rowL400 + "<td>&nbsp;</td></tr>";
         listItemInfo += "<tr id='r300'><td id='L300'></td><td></td>" + rowL300 + "<td>&nbsp;</td></tr>";
         listItemInfo += "<tr id='r200'><td id='L200' class='scale'>200</td><td></td>" + rowL200 + "<td>&nbsp;</td></tr>";
         listItemInfo += "<tr id='r100'><td id='L100'></td><td></td>" + rowL100 + "<td>&nbsp;</td></tr>";
         listItemInfo += "<tr id='r000'><td id='L000' class='scale'>0</td><td></td>" + rowL000 + "<td>&nbsp;</td></tr>";
         
         //Party Name Headers
         listItemInfo += "<tr><td colspan='2'></td>" + partyNameHeaders + "<td></td><td class='questionstotal'>TOTAL</td></tr>";
         
         //Total Questions
         listItemInfo += "<tr id='LTQ'><td colspan='2'><img alt='Blue' src='/sites/Regulatory/nebraska/2020NEGRR/Site%20Assets/Dashboard/Colors/Blue2.png' class='legendImage2'/> Total Questions</td>" + partyNameQuestions + questionTotals + "</tr>";
		          
         //Total Sets
         listItemInfo += "<tr id='LTS'><td colspan='2'><img alt='Orange' src='/sites/Regulatory/nebraska/2020NEGRR/Site%20Assets/Dashboard/Colors/Orange2.png' class='legendImage2'/> Total Sets </td>" + partySets + totalSets + "</tr>";
		          
         //Total Questions Served
         listItemInfo += "<tr id='LQS'><td colspan='2'><img alt='Grey' src='/sites/Regulatory/nebraska/2020NEGRR/Site%20Assets/Dashboard/Colors/Grey2.png' class='legendImage2'/> Questions Served </td>" + questionsServed + totalsServed + "</tr>";
		          
         listItemInfo += "<tr><td colspan='" + columnNumbers + "></td></tr></tbody></table></p>";       
      } 
   
      return $("#drr").html(listItemInfo);
      //alert("Success"); // For Testing Only     
     
    }); 

    failure(function (data) {

      alert("Failure");

    });
});    

</script>