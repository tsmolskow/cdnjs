<script language="javascript" src="/sites/Regulatory/SiteAssets/JavaScript/jquery-1.11.3.min.js"></script><script language="javascript" src="/sites/Regulatory/SiteAssets/Menu/jquery.SPServices-2014.02.js"></script><script language="javascript">

_spBodyOnLoadFunctionNames.push("validate"); { 

}  

function PreSaveAction() {  
   
   //*** Menu Item Title
   var strTitle = $("input[title='Menu Item Title']").val();
   //alert("strTitle " + strTitle); //For Testing Only
   
   //*** Level
   var ddlLevel = $("select[title='Level'] option:selected").text();
   //alert("ddlLevel " + ddlLevel); //For Testing Only
  
   //*** Level 1 Sequence
   var ddlLvl1Sequence = $("select[title='Level 1 Sequence'] option:selected").text();
   //alert("ddlLvl1Sequence " + ddlLvl1Sequence); //For Testing Only
     
   //*** Level 2 Sequence
   var ddlLvl2Sequence = $("select[title='Level 2 Sequence'] option:selected").text();
   //alert("ddlLvl2Sequence " + ddlLvl2Sequence); //For Testing Only
   
   //*** Top Item ID
   var ddlTopItemID = $("select[title='Top Item ID'] option:selected").text();
   //alert("ddlTopItemID " + ddlTopItemID); //For Testing Only
   
   //*** Link
   var strLink = $("input[title='Link']").val();
   //alert("strLink " + strLink); //For Testing Only

   return validateForm();

   function validateForm(){   

   //*** General Validations: Ensure a Level Has Been Selected
   if(ddlLevel == "1" || ddlLevel == "2"){

   } else {
      alert("Level: You must choose a Level");
   }
   
   //*** Validate: If Level 2 Item
   if(ddlLevel == "2") {
   
      var valTitle2 = "";
      var valLink2 = "";
      var valLvl1Sequence2 = "";
      var valLvl2Sequence2 = "";
      var valTopItemID2 = ""; 
      var errorMsg = ""; 
      
      //The Title Field Cannot be Empty
      if(strTitle == "") {
         errorMsg += "Menu Item Title: You must provide a Title\n\n";
         valTitle2 = "false";
      } else {
         valTitle2 = "true";
      } 
     
      //The Level 1 Sequence Field Value Should Be Zero
      if(ddlLvl1Sequence == "0") {
        valLvl1Sequence2 = "true";
      } else {
        errorMsg += "Level 1 Sequence: You have chosen to create a Level 2 Item, the Level 1 Sequence should be Zero\n\n";         
        valLvl1Sequence2 = "false";
      }
      
      //The Level 2 Sequence Must Not be Zero
      if(ddlLvl2Sequence == "0") {
        errorMsg += "Level 2 Sequence: You have chosen to create a Level 2 menu item, the Level 2 Sequence must not be set to Zero\n\n";
        valLvl2Sequence2 = "false";
      } else {
        valLvl2Sequence2 = "true";
      }
      
      //The Top Item ID Must be Zero
      if(ddlTopItemID == "0") {
        errorMsg += "Top Item ID: You have chosen to create a Level 2 menu item, the Top Item ID must not be set to Zero\n\n";
        valTopItemID2 = "false";
      } else {
        valTopItemID2 = "true";
      }
      
      //The Link Field Should Not Be Empty  
      if(strLink == "") { 
         errorMsg += "Link: You have chosen to create a Level 2 Item, you must provide a Link\n\n";
         valLink2 = "false";
      } else {
         valLink2 = "true";
      }
      
      //Check All Validations and If All True Return True
      if(valLink2 == "true" && valLvl1Sequence2 == "true" && valLvl2Sequence2 == "true" && valTopItemID2 == "true" && valTitle2 == "true") {
        return true;
      } else {
        alert(errorMsg);
        return false;
      }   
   }

   //*** Validate: If Level 1 Item
   if(ddlLevel == "1") {
      
      valTitle1 = "";
      var valLink1 = "";
      var valLvl1Sequence1 = "";
      var valLvl2Sequence1 = "";
      var valTopItemID1 = "";  
      var errorMsg = ""; 
        
      //The Title Field Cannot be Empty
      if(strTitle == "") {
         errorMsg += "Menu Item Title: You must provide a Title\n\n";
         valTitle1 = "false";
      } else {
         valTitle1 = "true";
      }        

      //The Level 1 Sequence Field Value Should Not Be Zero
      if(ddlLvl1Sequence == "0") {
        errorMsg += "Level 1 Sequence: You must select a Level 1 Sequence value greater than Zero\n\n";
        valLvl1Sequence1 = "false";
      } else {
        valLvl1Sequence1 = "true";
      }

      //The Level 2 Sequence Must be Zero
      if(ddlLvl2Sequence == "0") {
        valLvl2Sequence1 = "true";
      } else {
        errorMsg += "Level 2 Sequence: You have chosen to create a Level 1 menu item, the Level 2 Sequence must be set to Zero\n\n";
        valLvl2Sequence1 = "false";
      }

      //The Top Item ID Must be Zero
      if(ddlTopItemID == "0") {
        valTopItemID1 = "true";
      } else {
        errorMsg += "Top Item ID: You have chosen to create a Level 1 menu item, the Top Item ID must be set to Zero\n\n";
        valTopItemID1 = "false";
      }
      
      //The Link Field Should Be Empty  
      if(strLink == "") {  
         valLink1 = "true";
      } else {
         errorMsg += "Link: You have chosen to create a Level 1 Item, the Link field must be empty\n\n";
         valLink1 = "false";
      }


      //Check All Validations and If All True Return True
      if(valLink1 == "true" && valLvl1Sequence1 == "true" && valLvl2Sequence1 == "true" && valTopItemID1 == "true" && valTitle1 == "true") {
        return true;
      } else {
        alert(errorMsg);
        return false;
      }
   } 
 }
}
</script>