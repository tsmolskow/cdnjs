<script src="https://code.jquery.com/jquery-1.12.4.js" type="text/javascript"></script><script type="text/javascript">

$(function () {

	$(".ms-standardheader:contains('Title')").closest("tr").hide();
    $(".ms-standardheader:contains('Order')").closest("tr").hide();
    $(".ms-standardheader:contains('Expires')").closest("tr").hide();
    $(".ms-standardheader:contains('Image Description')").closest("tr").hide();
    $(".ms-standardheader:contains('PL Created')").closest("tr").hide();
    $(".ms-standardheader:contains('PData Request Topic')").closest("tr").hide();
    $(".ms-standardheader:contains('Data Request Topic')").closest("tr").hide();
    $(".ms-standardheader:contains('Body')").closest("td").hide();
	$("input[value='Close']").hide();

});

</script> 
<style type="text/css">

 #sideNavBox {DISPLAY: none}
 #contentBox {MARGIN-LEFT: 5px}
 
 .ms-formtoolbar{ display: none !important; }
 
</style>