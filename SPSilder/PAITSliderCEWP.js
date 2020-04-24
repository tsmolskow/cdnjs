<script type="text/javascript" src="https://bentest.bhcorp.ad/sites/regulatory3/testsite/SiteAssets/Slider/jquery-1.11.3.min.js"></script>
<script type="text/javascript" src="https://bentest.bhcorp.ad/sites/regulatory3/testsite/SiteAssets/Slider/PAITSlider.js?rev=09"></script>
<script type="text/javascript" src="https://bentest.bhcorp.ad/sites/regulatory3/testsite/SiteAssets/Slider/unslider-min.js"></script>

<link rel="stylesheet" href="https://bentest.bhcorp.ad/sites/regulatory3/testsite/SiteAssets/Slider/unslider.css">
<link rel="stylesheet" href="https://bentest.bhcorp.ad/sites/regulatory3/testsite/SiteAssets/Slider/unslider-dots.css">

<style type="text/css">
 
/*Image Style - Size and Margin */
.PAITSlide
{
	height: 200px;
	width: 200px;
    margin: auto;
    border: 5px solid #FFA500;
}

/*Dot Style - Color, Border Width and Shape */
.unslider-nav ol li {
  border: 2px solid #FFA500;
  border-radius: 50%;
}
.unslider-nav ol li.unslider-active {
  background: #FFA500;
}

.unslider-arrow {
 }
 
/*Next and Previous Aarrow Style (I did not use arrows) */
.next, .prev {
  font-size: 24px;
  color: #3d3d3d;
  top: 20%;
  width: 25px;
  height: 25px;
  line-height: 20px;
  text-align: center;
  border-radius: 2px;
  overflow: hidden;
  border: 2px solid #000;
  cursor: pointer;
}

</style>

<script type="text/javascript">

//Slider Configurations

  $().PAITSlider({
        listName:  'PromotedLinks', //name of Promoted Links list to use for slides
		viewTitle: 'All Promoted Links', //name of the view to use
        prev: "<", //HTML for the previous arrow
        next: ">", //HTML for the next arrow
		autoplay: true, //Play automatically?
		infinite: true, //Play infinitely?
		animation: 'horizontal', //Animation display - Horizontal or Vertical?
		arrows: false, //Show arrows?
		dots: true, //Show dots?
		keys: true,
		delay: 3000	//Delay between image displays	
		
    });
    
</script>

