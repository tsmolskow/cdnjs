<script language="javascript" src="https://ben.blackhillscorp.com/sites/Regulatory/SiteAssets/JavaScript/jquery-1.11.3.min.js"></script><script language="javascript" src="https://ben.blackhillscorp.com/sites/Regulatory/SiteAssets/JavaScript/jquery.SPServices-2014.02.js"></script><script language="javascript">

_spBodyOnLoadFunctionNames.push("validate"); { 

}  

function PreSaveAction() {
   
   //*** Title
   var strTitle = $("input[title='Title']").val();
   
   //*** Level
   var ddlLevel = $("select[title='Level'] option:selected").text();
  
   //*** Level 1 Sequence
   var ddlLvl1Sequence = $("select[title='Level 1 Sequence'] option:selected").text();
     
   //*** Level 2 Sequence
   var ddlLvl2Sequence = $("select[title='Level 2 Sequence'] option:selected").text();
   
   //*** Top Item ID
   var ddlTopItemID = $("select[title='Top Item ID'] option:selected").text();
   
   //*** Link
   var strLink = $("input[title='Link']").val();

   return validateForm();

   function validateForm(){   
      
   //*** General Validations: Ensure a Title Has Been Provided
   if(strTitle == "") {
      alert("You must provide a Title " + strTitle); //For Testing 
   } else {
      alert("You have provided a Title " + strTitle);
      return false;
   }

   //*** General Validations: Ensure a Level Has Been Selected
   if(ddlLevel == "1" || ddlLevel == "2"){
   } else {
      alert("You must choose a Level");
      return false;
   }

   //*** Validate: If Level 1 Item
   if(ddlLevel == "1") {
      
      var valLink = "";
      var valLvl1Sequence = "";
      var valLvl2Sequence = "";
      var valTopItemID = "";
         
      //The Link Field Should Be Empty  
      if(strLink == "") {        
         alert("The Link field is empty"); //For Testing 
         valLink = "true";
      } else {
         alert("You have chosen to create a Level 1 Item, the Link field must be empty");
         valLink = "false";
      }

      //The Level 1 Sequence Field Value Should Not Be Zero
      if(ddlLvl1Sequence == "0") {
        alert("You must select a Level 1 Sequence value greater than Zero");
        valLvl1Sequence = "false";
      } else {
        valLvl1Sequence = "true";
      }

      //The Level 2 Sequence Must be Zero
      if(ddlLvl2Sequence == "0") {
        valLvl2Sequence = "true";
      } else {
        alert("You have chosen to create a Level 1 menu item, the Level 2 Sequence must be set to Zero");
        valLvl2Sequence = "false";
      }

      //The Top Item ID Must be Zero
      if(ddlTopItemID == "0") {
        valTopItemID = "true";
      } else {
        alert("You have chosen to create a Level 1 menu item, the Top Item ID must be set to Zero");
        valTopItemID = "false";
      }


      return false;
   } 
 }
}

</script>