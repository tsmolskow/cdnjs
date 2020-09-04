<script language="javascript" src="/sites/Regulatory/SiteAssets/JavaScript/jquery-1.11.3.min.js"></script><script language="javascript" src="/sites/Regulatory/SiteAssets/JavaScript/jquery.SPServices-2014.02.js"></script><script language="javascript">

$(function () {    
    
	//Get List Items
	$.ajax({
        url: "/sites/Regulatory/colorado/_api/web/lists/GetByTitle('Navigation')/items?", 
        type: "GET",
        headers: {
            "accept": "application/json;odata=verbose"
        },
    }).success(function (data) {  
	
      //Create Level 1 and 2 Array Variables
	  var arrayLVL1Sequence = []; // An Array to Hold All the LVL1Sequence Values
      var arrayLVL2Sequence = []; // An Array to Hold All the LVL2Sequence Values
	  
      $.each(data.d.results, function (key, value) {
		  
         //Level 1 and 2 Sequence List Field Variables
		 var vLVL1Sequence = value.LVL1Sequence;
	     var vLVL2Sequence = value.LVL2Sequence;
		  
		 //Load and Sort Level 1 Sequence Array
         if (vLVL1Sequence != null){
		 arrayLVL1Sequence.push(vLVL1Sequence); } 
		 
		 arrayLVL1Sequence.sort();
		 
	     //Load and Sort Level 2 Sequence Array
         if (vLVL2Sequence != null){
		 arrayLVL2Sequence.push(vLVL2Sequence); } 
		 
		 arrayLVL2Sequence.sort();
		 
	}); 
	
	//Update Level 1 Sequence
	var lastItemLVL1 = arrayLVL1Sequence.pop();
        lastItemLVL1 = parseInt(lastItemLVL1) + 1;
	var selLVL1 = $("select[title='Level 1 Sequence']").val(lastItemLVL1);
	//alert("selLVL1: " + selLVL1); //For Testing Only
	
	//Update Level 2 Sequence
        var lastItemLVL2 = arrayLVL2Sequence.pop();
	lastItemLVL2 = parseInt(lastItemLVL2) + 1;
        var selLVL2 = $("select[title='Level 2 Sequence']").val(lastItemLVL2);
	//alert("selLVL2: " + selLVL2); //For Testing Only

    failure(function (data) {

      alert("Failure");

    });
	
  });  

});  

</script>