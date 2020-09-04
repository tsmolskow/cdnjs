<!-- List Slider Open and Close Start -->

<script language="javascript" src="https://ben.blackhillscorp.com/sites/Regulatory/SiteAssets/JavaScript/jquery-1.11.3.min.js"></script>
<script language="javascript" src="https://ben.blackhillscorp.com/sites/Regulatory/SiteAssets/JavaScript/jquery.SPServices-2014.02.js"></script>
<script type="text/javascript">

$(document).ready(function(){        
    
  $("#w").on('click','#nav > li > a',function(e){  
    if($(this).parent().has("ul")) {
      e.preventDefault();
    }
    
      if(!$(this).hasClass("open")) {
    
      //Hide Any Open Menus and Remove All Other Classes
      $("#nav li ul").slideUp(350);
      $("#nav li a").removeClass("open");
      
      //Open A New Menu and Add the Open Class
      $(this).next("ul").slideDown(350);
      $(this).addClass("open");
    }
    
    //Close the New Menu and Remove the Open Class
    else if($(this).hasClass("open")) {
      $(this).removeClass("open");
      $(this).next("ul").slideUp(350);
    }
  });

});

</script> 
<!-- List Slider Open and Close End -->

