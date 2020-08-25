<script language="javascript" src="https://ben.blackhillscorp.com/sites/Regulatory/SiteAssets/JavaScript/jquery-1.11.3.min.js"></script>
<script language="javascript" src="https://ben.blackhillscorp.com/sites/Regulatory/SiteAssets/JavaScript/jquery.SPServices-2014.02.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-dateFormat/1.0/jquery.dateFormat.min.js" type="text/javascript"></script>
<script language="javascript">

$(function () {    
    $.ajax({
        url: "/sites/Regulatory/nebraska/2020NEGRR/_api/web/lists/GetByTitle('Data Requests 2020 NEG RR')/items?$Select=ID,Party_x0020_Name,"
		+ "Party_x0020_Set,DR_x0020_Number,Subparts,Questions_x0020_Served,Served_x0020_Date,calcPartySet"
		+ "&$top=5000&$filter=Type_x0020_of_x0020_Document eq 'Data Request'&$orderby=Party_x0020_Set asc", 
        type: "GET",
        headers: {
            "accept": "application/json;odata=verbose"
        },
    }).success(function (data) {        
      
	  var listItemInfo = ''; // A Variable for Holding All Display Code
      var arrayPartyName = []; // An Array to Hold All the Party Names
      var uniquePartyName = []; // An Array to Hold All the Unique Party Names
      var uniquePartyNameLength = ""; // A Variable  Representing the Length of the uniquePartyArray 
	  var arrayPartySet = []; // An Array to Hold All the Party Sets
	  var arrayQuestions = []; // An Array to Hold All Questions Served
      
      $.each(data.d.results, function (key, value) {		  

         //*** Set All the Field Values to Variables ***//
         var ID = value.ID;         
         var txtTitle = value.Title; 
		 var typeDocument = value.Type_x0020_of_x0020_Document;
		 //alert("typeDocument " + typeDocument); // For Testing Only
         var partyName = value.Party_x0020_Name; 
		 //alert("partyName " + partyName); // For Testing Only
         var partySet = value.Party_x0020_Set; 
	     //alert("partySet " + partySet); // For Testing Only	 
         var drNumber = value.DR_x0020_Number; 
		 //alert("drNumber " + drNumber); // For Testing Only
         var subParts = value.Subparts; 
		 //alert("subParts " + subParts); // For Testing Only
		 var servedDate = value.Served_x0020_Date;  
		 //alert("Served Date 2 " + servedDate); // For Testing Only
                  
         //*** Create an Array with All Party Names 
         if (partyName != null){	 
         arrayPartyName.push(partyName); }
		 //alert("arrayPartyName " + arrayPartyName); // For Testing Only  
         
         //*** Use the Array with All Party Names to Create an Array of Unique Party Names
         uniquePartyName = getUnique(arrayPartyName);
		 //alert("uniquePartyName " + uniquePartyName[0].toString());  // For Testing Only
		 		 
		 //*** Get the Length of the UniquePartyName Array
         uniquePartyNameLength = uniquePartyName.length; 
		 //alert("uniquePartyNameLength " + uniquePartyNameLength); // For Testing Only
                
         //*** Function to Trim an Arrray to Unique Items
         function getUnique(array){
           var uniqueArray = [];
        
           // Loop through array values
           for(i=0; i < array.length; i++){			   
              if(uniqueArray.indexOf(array[i]) == -1) {				  
                uniqueArray.push(array[i]);
				//alert("uniqueArray"); // For Testing Only
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
	  var rowL1600 = "";
	  var rowL1500 = "";
	  var rowL1400 = "";
	  var rowL1300 = "";
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
      
      //Create All Blue Columns - Total Questions
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

        if (number >= 1300){
         rowL1300 += "<td class='blue'>&nbsp;</td>";
         //alert("1300"); // For Testing Only
        } else {
         rowL1300 += "<td class='blank'>&nbsp;</td>";
        }
		
		if (number >= 1400){
         rowL1400 += "<td class='blue'>&nbsp;</td>";
         //alert("1400"); // For Testing Only
        } else {
         rowL1400 += "<td class='blank'>&nbsp;</td>";
        }
		
		if (number >= 1500){
         rowL1500 += "<td class='blue'>&nbsp;</td>";
         //alert("1500"); // For Testing Only
        } else {
         rowL1500 += "<td class='blank'>&nbsp;</td>";
        }
		
		if (number >= 1600){
         rowL1600 += "<td class='blue'>&nbsp;</td>";
         //alert("1600"); // For Testing Only
        } else {
         rowL1600 += "<td class='blank'>&nbsp;</td>";
        }
		
      }
      
      //Create All Orange Columns - Total Sets
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
         rowL500 += "<td class='blank'>&nbsp;</td>";
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

		if (number >= 1300){
         rowL1300 += "<td class='orange'>&nbsp;</td>";
         //alert("1300"); // For Testing Only
        } else {
         rowL1300 += "<td class='blank'>&nbsp;</td>";
        }
		
		if (number >= 1400){
         rowL1400 += "<td class='orange'>&nbsp;</td>"; 
         //alert("1400"); // For Testing Only
        } else {
         rowL1400 += "<td class='blank'>&nbsp;</td>";
        }
		
		if (number >= 1500){
         rowL1500 += "<td class='orange'>&nbsp;</td>";
         //alert("1500"); // For Testing Only
        } else {
         rowL1500 += "<td class='blank'>&nbsp;</td>";
        }
		
		if (number >= 1600){
         rowL1600 += "<td class='orange'>&nbsp;</td>";
         //alert("1600"); // For Testing Only
        } else {
         rowL1600 += "<td class='blank'>&nbsp;</td>";
        }
        
      }
      
      //Create All Grey Columns - Questions Served
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

		if (number >= 1300){
         rowL1300 += "<td class='grey'>&nbsp;</td><td></td>";
         //alert("1300"); // For Testing Only
        } else {
         rowL1300 += "<td class='blank'>&nbsp;</td><td></td>";
        }
		
		if (number >= 1400){
         rowL1400 += "<td class='grey'>&nbsp;</td><td></td>";
         //alert("1400"); // For Testing Only
        } else {
         rowL1400 += "<td class='blank'>&nbsp;</td><td></td>";
        }
		
		if (number >= 1500){
         rowL1500 += "<td class='grey'>&nbsp;</td><td></td>";
         //alert("1500"); // For Testing Only
        } else {
         rowL1500 += "<td class='blank'>&nbsp;</td><td></td>";
        }
		
		if (number >= 1600){
         rowL1600 += "<td class='grey'>&nbsp;</td><td></td>";
         //alert("1600"); // For Testing Only
        } else {
         rowL1600 += "<td class='blank'>&nbsp;</td><td></td>";
        }
        
      }
   			   
      //Party Name 1      
      if (uniquePartyNameLength >= 1){
       
         var iNum1 = " ";
         var iNumAdd1 = parseInt(0);
         var qsNum1 = parseInt(0);
         var qsNumAdd1 = parseInt(0);
		 var psNum1 = parseInt(0);
         var psNumAdd1 = parseInt(0);
		 var calcCount1 = parseInt(0);		  
		 var lastElement1 = " ";
		 var strLastElement1 = " ";
		 		         
         //Headers 1 
         partyNameHeaders += "<td class='questionHeaders' colspan='3'>" + uniquePartyName[0] + "</td>";
       
	     var count = parseInt(0);
		 var calcArrayPartySet1 = []; // An Array to Hold All the Party Sets
		 var loopCount1 = parseInt(0);
	   
         //Questions and Questions Served
         $.each(data.d.results, function (key, value) {  
		 
           //Create partyName1 Variable
           var partyName1 = value.Party_x0020_Name;
		   //alert("partyName1 " + partyName1);

		   //Create arrayPartyName1 Variable
           var arrayPartyName1 = uniquePartyName[0].toString();
		   //alert("arrayPartyName1 " + arrayPartyName1);
		   
		   //Create Party Set Variable
		   var varCalcPartySet1 = parseInt(value.calcPartySet);
		   //alert("varCalcPartySet1 " + varCalcPartySet1); // For Testing Only  
		   
		   //Add Items to calcArrayPartySet
			   if (arrayPartyName1 == partyName1) {		   
				   calcArrayPartySet1.push([varCalcPartySet1,partyName1]);
			   }
		   
		   //Determine the calcArrayPartySet Length
		   var calcArrayPartySetLength1 = calcArrayPartySet1.length;
		   //alert("calcArrayPartySetLength1 " + calcArrayPartySetLength1); // For Testing Only 
		   
		   //Get the Last Element in the Array
		   if (calcArrayPartySetLength1 > 1){
			   
		      lastElement1 = calcArrayPartySet1[calcArrayPartySetLength1 - 1];
		      //alert("lastElement1 " + lastElement1);

              strLastElement1 = lastElement1.toString();
              //alert("strLastElement1 " + strLastElement1);			  
		   
		      var count1 = strLastElement1.split(',')[0]; 
		      //alert("count1 " + count1);
		   
		   }
			 
		   count = count + parseInt(1);
           //alert("count " + count);	
           
           var servedQuestion1 = value.Questions_x0020_Served;
		   //alert("servedQuestion1 " + servedQuestion1); // For Testing Only
		   var partySet1 = value.Party_x0020_Set;
		   //alert("partySet1 " + partySet1); // For Testing Only
		   var servedDate1 = value.Served_x0020_Date;
		   //alert("servedDate1 " + servedDate1); // For Testing Only 
		   var calcPartySet1 = parseInt(value.calcPartySet);
		   //alert("calcPartySet1 " + calcPartySet1); // For Testing Only 
           
           //Questions Calc
           if(value.Party_x0020_Name == uniquePartyName[0]){ 
			  
              iNumAdd1 = iNumAdd1 + parseInt(1);   
              //alert("iNumAdd1 " + iNumAdd1); // For Testing Only 			  
           } 
           
           //Questions Served
           if(value.Party_x0020_Name == uniquePartyName[0]){ 
              if (servedDate1 != null){    
                 qsNumAdd1 = qsNumAdd1 + parseInt(1); 
                 //alert("qsNumAdd1 " + qsNumAdd1); // For Testing Only
              }              
           }

           //Party Sets
           if(value.Party_x0020_Name == uniquePartyName[0]){ 	   
		         calcCount1 = calcCount1 + calcPartySet1;
		         //alert("calcCount1 " + calcCount1); // For Testing Only         
           }
		   
         }); 
         
         //Questions Total 1
         partyNameQuestions += "<td class='questions' colspan='3'>" + iNumAdd1 + "</td>";
         rowArray.push(iNumAdd1); 
         
         //*** Set Blue Column - Total Questions ***
         //blueColumn(iNumAdd1);          
         
         //Sets Total 1 	 
		 var count1 = strLastElement1.split(',')[0];
		 //alert("count1 " + count1);		 
         partySets += "<td class='questions' colspan='3'>" + count1 + "</td><td></td>"; 
		 
		 totalSets = count1;
		 //alert("totalSets " + totalSets);	// For Testing Only	 
         
         //*** Set Orange Column - Total Sets ***
         //orangeColumn(count1);
         
         //Questions Served Total 1
         questionsServed +=  "<td class='questions' colspan='3'>" + qsNumAdd1 + "</td><td></td>";
         
         //*** Set Grey Column - Questions Served ***
         //greyColumn(qsNumAdd1);                                   
           
      } else {         
         //alert("The Data Request Library Does Not Contain Data"); // For Testing Only        
      }      
      
      //Totals 1
	  if (uniquePartyNameLength >= 1){
		  
		questionTotals = iNumAdd1;
		//alert("questionTotals 1 " + questionTotals); // For Testing Only
		totalSets = parseInt(count1);
		//alert("totalSets 1 " + totalSets); // For Testing Only 
		totalsServed = qsNumAdd1;
		//alert("totalsServed 1 " + totalsServed); // For Testing Only
	  
	  }
       
      //Party Name 2      
      if (uniquePartyNameLength >= 2){
       
         var iNum = " ";
         var iNumAdd2 = parseInt(0); 
         var qsNum2 = parseInt(0);
         var qsNumAdd2 = parseInt(0);
		 var psNum2 = parseInt(0);
         var psNumAdd2 = parseInt(0);
		 var calcCount2 = parseInt(0);
		 var lastElement2 = " ";
		 var strLastElement2 = " ";
         
         //Headers 2
         partyNameHeaders += "<td></td><td class='questionHeaders' colspan='3'>" + uniquePartyName[1] + "</td>";
		 
		 var count = parseInt(0);
		 var calcArrayPartySet2 = []; // An Array to Hold All the Party Sets		 		   
		 var loopCount2 = parseInt(0);
       
         //Questions and Questions Served Calc 2
         $.each(data.d.results, function (key, value) { 
		 //Will Loop 348 Times

		   //Create partyName2 Variable
           var partyName2 = value.Party_x0020_Name;
		   //alert("partyName2 " + partyName2);

           //Create arrayPartyName2 Variable
           var arrayPartyName2 = uniquePartyName[1].toString();
		   //alert("arrayPartyName2 " + arrayPartyName2);
		 
		   //Create Party Set Variable
		   var varCalcPartySet2 = parseInt(value.calcPartySet);
		   //alert("varCalcPartySet2 " + varCalcPartySet2); // For Testing Only  
		   
		   //Add Items to calcArrayPartySet
			   if (arrayPartyName2 == partyName2) {		   
					calcArrayPartySet2.push([varCalcPartySet2,partyName2]);
			   }		   
		   		   
		   //Determine the calcArrayPartySet Length
		   var calcArrayPartySetLength2 = calcArrayPartySet2.length;
		   //alert("calcArrayPartySetLength2 " + calcArrayPartySetLength2); // For Testing Only 
		   		   
		   //Get the Last Element in the Array
		   if (calcArrayPartySetLength2 > 1){
			   
		      lastElement2 = calcArrayPartySet2[calcArrayPartySetLength2 - 1];
			  //alert("lastElement2 " + lastElement2);
			  
			  strLastElement2 = lastElement2.toString();
              //alert("strLastElement2 " + strLastElement2);		   
		   
		      var count2 = strLastElement2.split(',')[0]; 
		      //alert("count2 " + count2);
			  			  
		   }
		 
		   count = count + parseInt(1);
           //alert("count " + count);
         
           var servedQuestion2 = value.Questions_x0020_Served;
           //alert("servedQuestion2 " + servedQuestion2); // For Testing Only
           var partySet2 = value.Party_x0020_Set;
	       //alert("partySet1 " + partySet1); // For Testing Only 
	       var servedDate2 = value.Served_x0020_Date;
           //alert("servedDate2 " + servedDate2); // For Testing Only 
		   var calcPartySet2 = parseInt(value.calcPartySet);
		   //alert("calcPartySet2 " + calcPartySet2); // For Testing Only 	   
           
           //Questions Calc 2
           if(value.Party_x0020_Name == uniquePartyName[1]){ 
              			  
              iNumAdd2 = iNumAdd2 + parseInt(1); 
			  //alert("iNumAdd2 " + iNumAdd2); // For Testing Only 
           } 
           
           //Questions Served Calc 2
           if(value.Party_x0020_Name == uniquePartyName[1]){ 
              if (servedDate2 != null){                           
                 qsNumAdd2 = qsNumAdd2 + parseInt(1);  
                 //alert("qsNumAdd2 " + qsNumAdd2); // For Testing Only
              }              
           } 

           //Total Sets
           if(value.Party_x0020_Name == uniquePartyName[1]){			   
                 calcCount2 = calcCount2 + calcPartySet2;
		         //alert("calcCount2 " + calcCount2); // For Testing Only            
           }		   
         });       
         
         //Questions Total 2
         partyNameQuestions += "<td></td><td class='questions' colspan='3'>" + iNumAdd2 + "</td>";
         rowArray.push(iNumAdd2); 

         //*** Set Blue Column - Total Questions ***
         //blueColumn(iNumAdd2); 
         
         //Sets Total 2
		 
		 var count2 = strLastElement2.split(',')[0];
		 //alert("count2 " + count2);		 
         partySets += "<td class='questions' colspan='3'>" + count2 + "</td><td></td>"; 
		 
		 //totalSets2 = count2;
		 //alert("totalSets " + totalSets);	// For Testing Only	
         
         //*** Set Orange Column - Total Questions ***
         //orangeColumn(count2); 
         
         //Served Total 2
         questionsServed +=  "<td class='questions' colspan='3'>" + qsNumAdd2 + "</td><td></td>";
         
         //*** Set Grey Column - Total Questions ***
         //greyColumn(qsNumAdd2);              
           
      } else {         
         //alert("conditions not met 2"); // For Testing Only         
      }    
    
      //Totals 2
	  if (uniquePartyNameLength >= 2){
		  
		questionTotals = questionTotals + iNumAdd2;
		//alert("questionTotals 2 " + questionTotals); // For Testing Only
		// *** Start Here Tuesday *** //
		totalSets = parseInt(totalSets) + parseInt(count2);
		//alert("totalSets 2 " + totalSets); // For Testing Only
		totalsServed = totalsServed + qsNumAdd2;
		//alert("totalsServed 2 " + totalsServed); // For Testing Only

	 }

      //Party Name 3
      if (uniquePartyNameLength >= 3){
       
         var iNum3 = " ";
         var iNumAdd3 = parseInt(0);
         var qsNum3 = parseInt(0);
         var qsNumAdd3 = parseInt(0);
         var psNum3 = parseInt(0);
         var psNumAdd3 = parseInt(0);
		 var calcCount3 = parseInt(0);
		 var lastElement3 = " ";
		 var strLastElement3 = " ";
         
         //Headers 3 
         partyNameHeaders += "<td></td><td class='questionHeaders' colspan='3'>" + uniquePartyName[2] + "</td>"; 
		 
		 var count = parseInt(0);
		 var calcArrayPartySet3 = []; // An Array to Hold All the Party Sets
		 var loopCount = parseInt(0);
       
         //Questions and Questions Served
         $.each(data.d.results, function (key, value) { 
		 
           //Create partyName3 Variable		 
           var partyName3 = value.Party_x0020_Name;
		   //alert("partyName3 " + partyName3);
           
		   //Create arrayPartyName3 Variable
           var arrayPartyName3 = uniquePartyName[2].toString();
		   //alert("arrayPartyName3 " + arrayPartyName3);
		   
		   //Create Party Set Variable
		   var varCalcPartySet3 = parseInt(value.calcPartySet);
		   //alert("varCalcPartySet2 " + varCalcPartySet2); // For Testing Only
		   
		   //Add Items to calcArrayPartySet
			 if (arrayPartyName3 == partyName3) {		   
				   calcArrayPartySet3.push([varCalcPartySet3,partyName3]);
			   }
		   
		   //Determine the calcArrayPartySet Length
		   var calcArrayPartySetLength3 = calcArrayPartySet3.length;
		   //alert("calcArrayPartySetLength3 " + calcArrayPartySetLength3); // For Testing Only		   
           		   
		   //Get the Last Element in the Array
		   if (calcArrayPartySetLength3 > 1){
			   
		      lastElement3 = calcArrayPartySet3[calcArrayPartySetLength3 - 1];
		      //alert("lastElement3 " + lastElement3);

              strLastElement3 = lastElement3.toString();
              //alert("strLastElement3 " + strLastElement3);		   
		   		   
		      var count3 = strLastElement3.split(',')[0]; 
		      //alert("count3 " + count3);

           }		   
		   			 
		   count = count + parseInt(1);
           //alert("count " + count);	
         
		   var servedQuestion3 = value.Questions_x0020_Served;
		   //alert("servedQuestion3 " + servedQuestion3); // For Testing Only
		   var partySet3 = value.Party_x0020_Set;
	       //alert("partySet1 " + partySet1); // For Testing Only
	       var servedDate3 = value.Served_x0020_Date;
		   //alert("servedDate3 " + servedDate3); // For Testing Only
		   var calcPartySet3 = parseInt(value.calcPartySet);
		   //alert("calcPartySet3 " + calcPartySet3); // For Testing Only
           
           //Questions Calc 3
           if(value.Party_x0020_Name == uniquePartyName[2]){  
			  
              iNumAdd3 = iNumAdd3 + parseInt(0);
			  //alert("iNumAdd3 " + iNumAdd3); // For Testing Only		  
           } 
           
           //Questions Served Calc 3
           if(value.Party_x0020_Name == uniquePartyName[2]){ 
              if (servedDate3 != null){                           

                 qsNumAdd3 = qsNumAdd3 + parseInt(1); 
                 //alert("qsNumAdd3 " + qsNumAdd3); // For Testing Only
              }              
           }   

           //Total Sets
           if(value.Party_x0020_Name == uniquePartyName[2]){ 		   
		         calcCount3 = calcCount3 + calcPartySet3;            
           }
		   
         });         
         
         //Questions Total 3
         partyNameQuestions += "<td></td><td class='questions' colspan='3'>" + iNumAdd3 + "</td>";
         rowArray.push(iNumAdd3); 

         //*** Set Blue Column - Total Questions ***
         //blueColumn(iNumAdd3); 
         
         //Sets Total 3		 	 
		 var count3 = strLastElement1.split(',')[2];
		 //alert("count3 " + count3); // For Testing Only 
		 partySets += "<td class='questions' colspan='3'>" + count3 + "</td><td></td>";
		 
		 totalSets = count3;
		 //alert("totalSets " + totalSets);	// For Testing Only	
         
         //*** Set Orange Column - Total Questions ***
         //orangeColumn(count3);
         
         //Served Total 3
         questionsServed +=  "<td class='questions' colspan='3'>" + qsNumAdd3 + "</td><td></td>";
         
         //*** Set Grey Column - Total Questions ***
         //greyColumn(qsNumAdd3);                
           
      } else {         
         //alert("conditions not met 3"); // For Testing Only        
      }           
      
      //Totals 3
	  if (uniquePartyNameLength >= 3){
		  
		questionTotals = questionTotals + iNumAdd3;
		//alert("questionTotals 3 " + questionTotals); // For Testing Only
		totalSets = parseInt(totalSets) + parseInt(count3);
		//alert("totalSets 3 " + totalSets); // For Testing Only 
		totalsServed = totalsServed + qsNumAdd3;
		//alert("totalsServed 3 " + totalsServed); // For Testing Only
	  
	  }

      //Party Name 4
      if (uniquePartyNameLength >= 4){
       
         var iNum4 = " ";
         var iNumAdd4 = parseInt(0); 
         var qsNum4 = parseInt(0); 
         var qsNumAdd4 = parseInt(0);
		 var psNum4 = parseInt(0);
         var psNumAdd4 = parseInt(0);
		 var calcCount4 = parseInt(0);
		 var lastElement4 = " ";
		 var strLastElement4 = " ";
         
         //Headers     
         partyNameHeaders += "<td></td><td class='questionHeaders' colspan='3'>" + uniquePartyName[3] + "</td>";
		 
		 var count = parseInt(0);
		 var calcArrayPartySet4 = []; // An Array to Hold All the Party Sets
		 var loopCount = parseInt(0);
       
         //Questions and Questions Served
         $.each(data.d.results, function (key, value) { 
		 
		   //Create partyName4 Variable
           var partyName4 = value.Party_x0020_Name;
		   //alert("partyName4 " + partyName4);

           //Create arrayPartyName4 Variable
           var arrayPartyName4 = uniquePartyName[3].toString();
		   //alert("arrayPartyName1 " + arrayPartyName1);
		   
		   //Create Party Set Variable
		   var varCalcPartySet4 = parseInt(value.calcPartySet);
		   //alert("varCalcPartySet4 " + varCalcPartySet4); // For Testing Only
		   
		   //Add Items to calcArrayPartySet
			 if (arrayPartyName4 == partyName4) {				   		   
				   calcArrayPartySet4.push([varCalcPartySet4,partyName4]); 
			 }
		   
		   //Determine the calcArrayPartySet Length
		   var calcArrayPartySetLength4 = calcArrayPartySet4.length;
		   //alert("calcArrayPartySetLength4 " + calcArrayPartySetLength4); // For Testing Only
		   		   
		   //Get the Last Element in the Array		   
		   if (calcArrayPartySetLength4 > 1){
			   
		      lastElement4 = calcArrayPartySet4[calcArrayPartySetLength4 - 1];
		      //alert("lastElement4 " + lastElement4);

              strLastElement4 = lastElement4.toString();
              //alert("strLastElement4 " + strLastElement4);			  
		   		   
		      var count4 = strLastElement4.split(',')[0]; 
		      //alert("count4 " + count4);
			  
		   }
			 
		   count = count + parseInt(1);
           //alert("count " + count);   
         
           var servedQuestion4 = value.Questions_x0020_Served; 
		   //alert("servedQuestion4 " + servedQuestion4); // For Testing Only
		   var partySet4 = value.Party_x0020_Set;
	       //alert("partySet1 " + partySet1); // For Testing Only 
	       var servedDate4 = value.Served_x0020_Date;
		   //alert("servedDate4 " + servedDate4); // For Testing Only 
		   var calcPartySet4 = parseInt(value.calcPartySet);
		   //alert("calcPartySet4 " + calcPartySet4	); // For Testing Only 
           
           //Questions Calc 4
           if(value.Party_x0020_Name == uniquePartyName[3]){  

              iNumAdd4 = iNumAdd4 + parseInt(1); 
			  //alert("iNumAdd4 " + iNumAdd4); // For Testing Only 
           } 
           
           //Questions Served Calc 4
           if(value.Party_x0020_Name == uniquePartyName[3]){ 
              if (servedDate4 != null){                           
                 qsNumAdd4 = qsNumAdd4 + parseInt(1);  
                 //alert("qsNumAdd4 " + qsNumAdd4); // For Testing Only
              }              
           } 

           //Total Sets
           if(value.Party_x0020_Name == uniquePartyName[3]){ 
				 calcCount4 = calcCount4 + calcPartySet4;
				 //alert("calcCount4 " + calcCount4); // For Testing Only            
           }
		   
         });      
         
         //Questions Total 4
         partyNameQuestions += "<td></td><td class='questions' colspan='3'>" + iNumAdd4 + "</td>";
         rowArray.push(iNumAdd4); 

         //*** Set Blue Column - Total Questions ***
         //blueColumn(iNumAdd4); 
         
         //Sets Total 4
		 var count4 = strLastElement1.split(',')[3];
		 //alert("count4 " + count4); // For Testing Only 
         partySets += "<td class='questions' colspan='3'>" + count4 + "</td><td></td>";
		 
		 totalSets = count4;
		 //alert("totalSets " + totalSets);	// For Testing Only	
         
         //*** Set Orange Column - Total Questions ***
         //orangeColumn(count4);
         
         //Served Total 4
         questionsServed +=  "<td class='questions' colspan='3'>" + qsNumAdd4 + "</td><td></td>";  
		 
         //*** Set Grey Column - Total Questions ***
         //greyColumn(qsNumAdd4);     
           
      } else {         
         //alert("conditions not met 4");         
      }   
      
      //Totals 4
	  if (uniquePartyNameLength >= 4){
		  
		questionTotals = questionTotals + iNumAdd4;
		//alert("questionTotals 4 " + questionTotals); // For Testing Only
		totalSets = parseInt(totalSets) + parseInt(count4);
		//alert("totalSets 4 " + totalSets); // For Testing Only 
		totalsServed = totalsServed + qsNumAdd4;
		//alert("totalsServed 4 " + totalsServed); // For Testing Only
	  
	  }
    
      //Party Name 5
      if (uniquePartyNameLength >= 5){
       
         var iNum5 = " ";
         var iNumAdd5 = parseInt(0);
         var qsNum5 = parseInt(0); 
         var qsNumAdd5 = parseInt(0); 
		 var psNum5 = parseInt(0);
         var psNumAdd5 = parseInt(0);
		 var calcCount5 = parseInt(0);
		 var lastElement5 = " ";
		 var strLastElement5 = " ";
         
         //Headers 5   
         partyNameHeaders += "<td></td><td class='questionHeaders' colspan='3'>" + uniquePartyName[4] + "</td>";
		 
		 var count = parseInt(0);
		 var calcArrayPartySet5 = []; // An Array to Hold All the Party Sets
		 var loopCount = parseInt(0);
       
         //Questions and Questions Served
         $.each(data.d.results, function (key, value) { 
		 
		   //Create partyName5 Variable
           var partyName5 = value.Party_x0020_Name;
		   //alert("partyName5 " + partyName5);
		   
           //Create arrayPartyName5 Variable
           var arrayPartyName5 = uniquePartyName[4].toString();
		   //alert("arrayPartyName5 " + arrayPartyName5);
		   
		   //Create Party Set Variable
		   var varCalcPartySet5 = parseInt(value.calcPartySet);
		   //alert("varCalcPartySet5 " + varCalcPartySet5); // For Testing Only
		   
		   //Add Items to calcArrayPartySet
			 if (arrayPartyName5 == partyName5) {			   
					calcArrayPartySet5.push([varCalcPartySet5,partyName5]);
			 }
		   
		   //Determine the calcArrayPartySet Length
		   var calcArrayPartySetLength5 = calcArrayPartySet5.length;
		   //alert("calcArrayPartySetLength5 " + calcArrayPartySetLength5); // For Testing Only
		   		   
		   //Get the Last Element in the Array		   
		   if (calcArrayPartySetLength5 > 1){
			   
		      lastElement5 = calcArrayPartySet5[calcArrayPartySetLength5 - 1];
		      //alert("lastElement5 " + lastElement5);

              strLastElement5 = lastElement5.toString();
			  //alert("strLastElement2 " + strLastElement2);
		   		   
		      var count5 = strLastElement5.split(',')[0]; 
		      //alert("count5 " + count5);	
           
           }		   
         			 
		   count = count + parseInt(1);
           //alert("count " + count);	
		   
           var servedQuestion5 = value.Questions_x0020_Served; 
		   //alert("servedQuestion5 " + servedQuestion5); // For Testing Only
		   var partySet5 = value.Party_x0020_Set;
	       //alert("partySet5 " + partySet5); // For Testing Only 
	       var servedDate5 = value.Served_x0020_Date;
		   //alert("servedDate5 " + servedDate5); // For Testing Only 
		   var calcPartySet5 = parseInt(value.calcPartySet);
		   //alert("calcPartySet5 " + calcPartySet5); // For Testing Only 
           
           //Questions Calc 5
           if(value.Party_x0020_Name == uniquePartyName[4]){   
	
              iNumAdd5 = iNumAdd5 + parseInt(1); 
              //alert("iNumAdd5 " + iNumAdd5); // For Testing Only 	  
           } 
           
           //Questions Served Calc 5
           if(value.Party_x0020_Name == uniquePartyName[4]){ 
              if (servedDate5 != null){                           
                 qsNumAdd5 = qsNumAdd5 + parseInt(1);  
                 //alert("qsNumAdd5 " + qsNumAdd5); // For Testing Only
              }              
           }  

           //Total Sets
           if(value.Party_x0020_Name == uniquePartyName[4]){		   
                 calcCount5 = calcCount5 + calcPartySet5;
		         //alert("calcCount5 " + calcCount5); // For Testing Only                 
           }
		   
         });      
        
         //Questions Total 5
         partyNameQuestions += "<td></td><td class='questions' colspan='3'>" + iNumAdd5 + "</td>";
         rowArray.push(iNumAdd5); 
		
         //*** Set Blue Column - Total Questions ***
         //blueColumn(iNumAdd5); 
         
         //Sets Total 5
         var count5 = strLastElement1.split(',')[4];
		 //alert("totalSets " + totalSets);	// For Testing Only	 	
		 //alert("count5 "  count5); // For Testing Only 
         partySets += "<td class='questions' colspan='3'>" + count5 + "</td><td></td>";
		 
         totalSets = count5;
		 //alert("totalSets " + totalSets);	// For Testing Only	
		 
         //*** Set Orange Column - Total Questions ***
         //orangeColumn(count5);
         
         //Questions Served Total 5
         questionsServed +=  "<td class='questions' colspan='3'>" + qsNumAdd5 + "</td><td></td>";
         
         //*** Set Grey Column - Total Questions ***
         //greyColumn(qsNumAdd5);     
           
      } else {         
         //alert("conditions not met 5"); // For Testing Only        
      }      
      
      //Totals 5
	  if (uniquePartyNameLength >= 5){
		  
		questionTotals = questionTotals + iNumAdd5;
		//alert("questionTotals 5 " + questionTotals); // For Testing Only
		totalSets = parseInt(totalSets) + parseInt(count5);
		//alert("totalSets 5 " + totalSets); // For Testing Only 
		totalsServed = totalsServed + qsNumAdd5;
		//alert("totalsServed 5 " + totalsServed); // For Testing Only
		
	  }
      
      //Party Name 6
      if (uniquePartyNameLength >= 6){
       
         var iNum6 = " ";
         var iNumAdd6 = parseInt(0);
         var qsNum6 = parseInt(0); 
         var qsNumAdd6 = parseInt(0);
		 var psNum6 = parseInt(0);
         var psNumAdd6 = parseInt(0);
		 var calcCount6 = parseInt(0);
		 var lastElement6 = " ";
		 var strLastElement6 = " ";
         
         //Headers 6   
         partyNameHeaders += "<td></td><td class='questionHeaders' colspan='3'>" + uniquePartyName[5] + "</td>";
         
		 var count = parseInt(0);
		 var calcArrayPartySet6 = []; // An Array to Hold All the Party Sets
		 var loopCount = parseInt(0);
          
         //Questions and Qquestions Served Calc 6
         $.each(data.d.results, function (key, value) {
			 
           //Create partyName1 Variable
           var partyName6 = value.Party_x0020_Name;
		   //alert("partyName6 " + partyName6);

           //Create arrayPartyName6 Variable
           var arrayPartyName6 = uniquePartyName[5].toString();
		   //alert("arrayPartyName6 " + arrayPartyName6);

		   //Create Party Set Variable
		   var varCalcPartySet6 = parseInt(value.calcPartySet);
		   //alert("varCalcPartySet6 " + varCalcPartySet6); // For Testing Only

		   //Add Items to calcArrayPartySet
			 if (arrayPartyName6 == partyName6) {		   
					calcArrayPartySet6.push([varCalcPartySet1,partyName6]);
			 }

		   //Determine the calcArrayPartySet Length
		   var calcArrayPartySetLength6 = calcArrayPartySet6.length;
		   //alert("calcArrayPartySetLength6 " + calcArrayPartySetLength6); // For Testing Only
		   		   
		   //Get the Last Element in the Array
		   if (calcArrayPartySetLength6 > 1){
		   
		      lastElement6 = calcArrayPartySet6[calcArrayPartySetLength6 - 1];
		      //alert("lastElement6 " + lastElement6);

              strLastElement6 = lastElement6.toString();
		   		   
		      var count6 = strLastElement6.split(',')[0]; 
		      //alert("count6 " + count6);
		   
		   }
		   			 
		   count = count + parseInt(1);
           //alert("count " + count);	
         
           var servedQuestion6 = value.Questions_x0020_Served;
		   //alert("servedQuestion6 " + servedQuestion6); // For testing Only
		   var partySet6 = value.Party_x0020_Set;
	       //alert("partySet1 " + partySet1); // For Testing Only 
	       var servedDate6 = value.Served_x0020_Date;
		   //alert("servedDate6 " + servedDate6); // For Testing Only 
		   var calcPartySet6 = parseInt(value.calcPartySet);
		   //alert("calcPartySet6 " + calcPartySet6); // For Testing Only 
           
           //Questions Calc 6
           if(value.Party_x0020_Name == uniquePartyName[5]){ 

              iNumAdd6 = iNumAdd6 + parseInt(1);   
		      //alert("iNum6 " + iNum6); // For Testing Only 
           }
           
           //Questions Served Calc 6
           if(value.Party_x0020_Name == uniquePartyName[5]){ 
              if (servedDate6 != null){                           
                 qsNumAdd6 = qsNumAdd6 + parseInt(1);  
                 //alert("qsNumAdd6 " + qsNumAdd6); // For Testing Only
              }              
           }

           //Total Sets
           if(value.Party_x0020_Name == uniquePartyName[5]){
				 calcCount6 = calcCount6 + calcPartySet6;
		         //alert("calcCount6 " + calcCount6); // For Testing Only              
           }
		   
         });      

         //Questions Total 6
         partyNameQuestions += "<td></td><td class='questions' colspan='3'>" + iNumAdd6 + "</td>";
         rowArray.push(iNumAdd6);
         
         //*** Set Blue Column - Total Questions ***
         //blueColumn(iNumAdd6);  
         
         //Sets Total 6
         var count6 = strLastElement1.split(',')[5];	 
         partySets += "<td class='questions' colspan='3'>" + count6 + "</td>"; 
		 
         totalSets = count6;
		 //alert("totalSets " + totalSets);	// For Testing Only	
		 
         //*** Set Orange Column - Total Questions ***
         //orangeColumn(count6);
         
         //Served Questions Total 6
         questionsServed +=  "<td class='questions' colspan='3'>" + qsNumAdd6 + "</td><td></td>";
         
         //*** Set Grey Column - Total Questions ***
         //greyColumn(qsNumAdd6);     
           
      } else {         
         //alert("conditions not met 6"); // For Testing Only        
      }   
      
      //Totals 6
	  if (uniquePartyNameLength >= 6){
		  
		questionTotals = questionTotals + iNumAdd6; 
		//alert("questionTotals 6 " + questionTotals); // For Testing Only
		totalSets = parseInt(totalSets) + parseInt(count6);
		//alert("totalSets 6 " + totalSets); // For Testing Only 
		totalsServed = totalsServed + qsNumAdd6;
		
	  }
      
      //Grand Totals - Questions, Sets, Questions Served                                                                  
      questionTotals = "<td></td><td class='questionstotal' colspan='3'>" + questionTotals + "</td>"; 
      totalSets = "<td class='questionstotal' colspan='3'>" + totalSets + "</td>";
      totalsServed = "<td class='questionstotal' colspan='3'>" + totalsServed + "</td>";
         
      var rowCount = Math.max.apply(null,rowArray);
      
      makeTable(uniquePartyNameLength,rowCount);
      
      function makeTable(columns,rows) {
      
         columnNumbers = columns * 4;
         columnNumbers = columnNumbers + 4;
         //alert("columnNumbers " + columnNumbers); // For Testing Only 
      
	     //Header Columns
         listItemInfo += "<table id='DiscoveryRequestsRisks' style='cellpadding:10';><tbody><tr class='title header1' id='Header2'><td width='100%' colspan='" + columnNumbers + "'>&nbsp; Discovery Requests: Party, Total Sets, Questions Served, Questions and Subparts &nbsp;</td></tr>";
		 
		 //Blue, Orange, Grey Columns
		 //listItemInfo += "<tr id='r1600'><td id='L1600' class='scale' width='10%'>1600</td><td></td>" + rowL1600 + "<td>&nbsp;</td></tr>";
		 //listItemInfo += "<tr id='r1500'><td id='L1500' class='scale' width='10%'>1500</td><td></td>" + rowL1500 + "<td>&nbsp;</td></tr>";
		 //listItemInfo += "<tr id='r1400'><td id='L1400' class='scale' width='10%'>1400</td><td></td>" + rowL1400 + "<td>&nbsp;</td></tr>";
		 //listItemInfo += "<tr id='r1300'><td id='L1300' class='scale' width='10%'>1300</td><td></td>" + rowL1300 + "<td>&nbsp;</td></tr>";
         //listItemInfo += "<tr id='r1200'><td id='L1200' class='scale' width='10%'>1200</td><td></td>" + rowL1200 + "<td>&nbsp;</td></tr>";
         //listItemInfo += "<tr id='r1100'><td id='L1100' class='scale' width='10%'>1100</td><td></td>" + rowL1100 + "<td>&nbsp;</td></tr>";
         //listItemInfo += "<tr id='r1000'><td id='L1000' class='scale' width='10%'>1000</td><td></td>" + rowL1000 + "<td>&nbsp;</td></tr>";
         //listItemInfo += "<tr id='r900'><td id='L900' class='scale' width='10%'>900</td><td></td>" + rowL900 + "<td>&nbsp;</td></tr>";
         //listItemInfo += "<tr id='r800'><td id='L800' class='scale' width='10%'>800</td><td></td>" + rowL800 + "<td>&nbsp;</td></tr>";
         //listItemInfo += "<tr id='r700'><td id='L700' class='scale' width='10%'>700</td><td></td>" + rowL700 + "<td>&nbsp;</td></tr>";
         //listItemInfo += "<tr id='r600'><td id='L600' class='scale' width='10%'>600</td><td></td>" + rowL600 + "<td>&nbsp;</td></tr>";
         //listItemInfo += "<tr id='r500'><td id='L500' class='scale' width='10%'>500</td><td></td>" + rowL500 + "<td>&nbsp;</td></tr>";
         //listItemInfo += "<tr id='r400'><td id='L400' class='scale' width='10%'>400</td><td></td>" + rowL400 + "<td>&nbsp;</td></tr>";
         //listItemInfo += "<tr id='r300'><td id='L300' class='scale' width='10%'>300</td><td></td>" + rowL300 + "<td>&nbsp;</td></tr>";
         //listItemInfo += "<tr id='r200'><td id='L200' class='scale' width='10%'>200</td><td></td>" + rowL200 + "<td>&nbsp;</td></tr>";
         //listItemInfo += "<tr id='r100'><td id='L100' class='scale' width='10%'>100</td><td></td>" + rowL100 + "<td>&nbsp;</td></tr>";
         //listItemInfo += "<tr id='r000'><td id='L000' class='scale' width='10%'>0</td><td></td>" + rowL000 + "<td>&nbsp;</td></tr>";
         
         //*** Party Name Headers
		 
         //listItemInfo += "<tr><td colspan='2'></td>" + partyNameHeaders + "<td></td><td class='questionstotal'>TOTAL</td></tr>"; // Use with Full Column Display
		 listItemInfo += "<tr><td colspan='1'></td><td></td><td class='questionstotal'>&nbsp;</td></tr>";
		 listItemInfo += "<tr><td colspan='1'></td>" + partyNameHeaders + "<td></td><td class='questionsTotalHeader'>TOTAL</td></tr>";         
	          
         //*** Total Sets
		 
         //listItemInfo += "<tr id='LTS'><td colspan='2'><img alt='Orange' src='/sites/Regulatory/nebraska/2020NEGRR/Site%20Assets/Dashboard/Colors/Orange2.png' class='legendImage2'/> Total Sets </td>" + partySets + totalSets + "</tr>"; // Use with Full Column Display
		 listItemInfo += "<tr id='LTS'><td colspan='1'><img alt='Orange' src='/sites/Regulatory/nebraska/2020NEGRR/Site%20Assets/Dashboard/Colors/Orange2.png' class='legendImage2'/> Total Sets </td>" + partySets + totalSets + "</tr>";
		          
         //*** Total Questions Served
		 
         //listItemInfo += "<tr id='LQS'><td colspan='2'><img alt='Grey' src='/sites/Regulatory/nebraska/2020NEGRR/Site%20Assets/Dashboard/Colors/Grey2.png' class='legendImage2'/> Questions Served </td>" + questionsServed + totalsServed + "</tr>"; // Use with Full Column Display
		 listItemInfo += "<tr id='LQS'><td colspan='1'><img alt='Grey' src='/sites/Regulatory/nebraska/2020NEGRR/Site%20Assets/Dashboard/Colors/Grey2.png' class='legendImage2'/> Questions Served </td>" + questionsServed + totalsServed + "</tr>";
		 
		 //*** Total Questions
		 
         //listItemInfo += "<tr id='LTQ'><td colspan='2'><img alt='Blue' src='/sites/Regulatory/nebraska/2020NEGRR/Site%20Assets/Dashboard/Colors/Blue2.png' class='legendImage2'/> Total Questions</td>" + partyNameQuestions + questionTotals + "</tr>"; // Use with Full Column Display
		 listItemInfo += "<tr id='LTQ'><td colspan='1'><img alt='Blue' src='/sites/Regulatory/nebraska/2020NEGRR/Site%20Assets/Dashboard/Colors/Blue2.png' class='legendImage2'/> Questions and Subparts</td>" + partyNameQuestions + questionTotals + "</tr>";
		          
         listItemInfo += "<tr><td colspan='" + columnNumbers + "></td></tr></tbody></table></p>";       
      } 

	  //alert("arrayPartyName " + arrayPartyName); // For Testing Only
	  //alert("uniquePartyNameLength " + uniquePartyNameLength); // For Testing Only
   
      return $("#drr").html(listItemInfo);
      //alert("Success"); // For Testing Only     
     
    }); 

    failure(function (data) {

      alert("Failure");

    });
});    

</script>