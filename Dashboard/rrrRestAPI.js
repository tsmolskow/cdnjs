<script language="javascript" src="https://ben.blackhillscorp.com/sites/Regulatory/SiteAssets/JavaScript/jquery-1.11.3.min.js"></script>
<script language="javascript" src="https://ben.blackhillscorp.com/sites/Regulatory/SiteAssets/JavaScript/jquery.SPServices-2014.02.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery-dateFormat/1.0/jquery.dateFormat.min.js" type="text/javascript"></script>
<script src="https://ben.blackhillscorp.com/sites/Regulatory/SiteAssets/JavaScript/moment.js" type="text/javascript"></script>
<script language="javascript">

$(function () {    
    $.ajax({
        url: "/sites/regulatory3/testdashboard/_api/web/lists/GetByTitle('Regulatory Rate Review Status Update')/items?$ID=27",
        type: "GET",
        headers: {
            "accept": "application/json;odata=verbose"
        },
    }).success(function (data) {     
      
      $.each(data.d.results, function (key, value) { 
      
         var Year = value.Year;
         var State = value.State;
         var Utilities = value.Utilities;
         var DirectorsName = value.Directors_x0020_Name;
         var ExpectedFilingDate = value.Expected_x0020_Filing_x0020_Date;
         var ExpectedRateExpectedDate = value.Expected_x0020_Rate_x0020_Expect;
         var TestYearBasePeriod = value.Test_x0020_Year_x0020_Base_x0020;
         var ProFormaPeriodTestPeriod = value.Pro_x0020_Forma_x0020_Period_x00;
         var ReturnonRateRequested = value.Return_x0020_on_x0020_Rate_x0020;
         var ReturnonRateFinal = value.Return_x0020_on_x0020_Rate_x00200;
         var BaseWACCRequested = value.Base_x0020_WACC_x0020_Requested;
         var BaseWACCFinal = value.Base_x0020_WACC_x0020_Final;
         var TotalRateBaseRequested = value.Total_x0020_Rate_x0020_Base_x002;
         var TotalRateBaseFinal = value.Total_x0020_Rate_x0020_Base_x0020;
         var TotalRevenueRequirementRequested = value.Total_x0020_Revenue_x0020_Requir;
         var TotalRevenueRequirementFinal = value.Total_x0020_Revenue_x0020_Requir0;
         var NewRevenuesRequestedRequested = value.New_x0020_Revenues_x0020_Request;
         var NewRevenuesRequestedFinal = value.New_x0020_Revenues_x0020_Request0;
         var RevenueIncreaseRequested = value.Revenue_x0020_Increase_x0020_Req;
         var RevenueIncreaseFinal = value.Revenue_x0020_Increase_x0020_Fin;
         var ImpactPerCustomerRequested = value.Impact_x0020_per_x0020_Customer_;
         var ImpactPerCustomerFinal = value.Impact_x0020_per_x0020_Customer_0;
         var PercentageOfCustomerIncreaseRequested = value.Percentage_x0020_of_x0020_Custom;
         var PercentageOfCustomerIncreaseFinal = value.Percentage_x0020_of_x0020_Custom0;
         var RiderInformationRequested = value.Rider_x0020_Information_x0020_Re;
         var RiderInformationFinal = value.Rider_x0020_Information_x0020_Fi;
      
         //alert("Variable " + TotalRevenueRequirementRequested);
      
      //});
      
      var listItemInfo = '';

      listItemInfo += "<table id='PreparationToFile'><tbody>";
      listItemInfo += "<tr class='title' id='Title1'><td colspan='4'>Regulatory Rate Review Status Update</td></tr>";
      listItemInfo += "<tr class='title' id='Title2'><td colspan='4'>" + Year + "<font color='red'> " + State + "</font> " + Utilities + "</td></tr>";
      listItemInfo += "<tr class='title' id='Title3'><td colspan='4'>Confidential</br></td></tr>";
      listItemInfo += "<tr class='title' id='Title4'><td colspan='4'>Regulatory and Finance Director: <font color='red'> " + DirectorsName + "</font></td></tr>";
      listItemInfo += "<tr class='title header' id='Header1'><td colspan='5'>Preparation to File</td></tr><tr id='Columns1'>"; 
      listItemInfo += "<td class='columns1' rowspan='2'>Expected Filing Date</td>";
      listItemInfo += "<td class='columns1' rowspan='2'>Expected Rate </br> Expected Date</td>"; 
      listItemInfo += "<td class='columns1' rowspan='2'>Test Year Base Period</td>"; 
      listItemInfo += "<td class='columns1' rowspan='2'>Pro Forma Period </br>Test Period</td></tr>";
      listItemInfo += "<tr><td colspan='4'></td></tr>";
      listItemInfo += "<tr id='Data1'>";
      listItemInfo += "<td class='columns1'>" + ExpectedFilingDate+ "</td><td class='columns1'>" + ExpectedRateExpectedDate + "</td>";
      listItemInfo += "<td class='columns1'>" + TestYearBasePeriod + "</td><td class='columns1'>" + ProFormaPeriodTestPeriod + "</td>";
      listItemInfo += "</tr></tbody></table>";
      
      listItemInfo += "<table id='SummaryOfFiling'><tbody><tr class='title header1' id='Header2'><td width='610' colspan='3'>Summary of Filing</td></tr>";
      listItemInfo += "<tr class='header2'><td>&#160;</td><td>Requested</td><td>Final</td></tr>";
      listItemInfo += "<tr id='SFData1'><td class='data1'>Return on Rate Base(WACC)</td><td style='text-align:center;'>" + ReturnonRateRequested + "</td><td style='text-align:center;'>" + ReturnonRateFinal + "</td></tr>";
      listItemInfo += "<tr id='SFData2'></tr><tr></tr><tr id='SFData3'><td class='data1'>Total Rate Base</td><td style='text-align:center;'>" + TotalRateBaseRequested + "</td><td style='text-align:center;'>" + TotalRateBaseFinal + "</td></tr>";
      listItemInfo += "<tr id='SFData4'><td class='data1'>Total Revenue Requirement</td><td style='text-align:center;'>" + TotalRevenueRequirementRequested + "</td><td style='text-align:center;'>" + TotalRevenueRequirementFinal + "</td></tr>";
      listItemInfo += "<tr id='SFData5'><td class='data1' colspan='1'>$ New Revenues Requested</td><td style='text-align:center;'>" + NewRevenuesRequestedRequested + "</td><td style='text-align:center;'>" + NewRevenuesRequestedFinal + "<td></tr>";
      listItemInfo += "<tr id='SFData6'><td class='data1'>% Revenue Increase</td><td style='text-align:center;'>" + RevenueIncreaseRequested + "</td><td style='text-align:center;'>" + RevenueIncreaseFinal + "</td></tr>";
      listItemInfo += "<tr id='SFData7'><td class='data1'>$ Impact per Customer</td><td style='text-align:center;'>" + ImpactPerCustomerRequested + "</td><td style='text-align:center;'>" + ImpactPerCustomerFinal + "<td></tr>";
      listItemInfo += "<tr id='SFData8'><td class='data1'>% of Customer Increase</td><td style='text-align:center;'>" + PercentageOfCustomerIncreaseRequested + "</td><td style='text-align:center;'>" + PercentageOfCustomerIncreaseFinal + "</td></tr>";
      listItemInfo += "<tr id='SFData9'><td class='data1'>Rider Information</td><td style='text-align:center;'>" + RiderInformationRequested + "</td><td style='text-align:center;'>" + RiderInformationFinal + "</td></tr>";
      listItemInfo += "<tr></tr></tbody></table>";      
      
      //alert("Test 1");
      return $("#rrr").html(listItemInfo);
      
      });
      
    }); 

    failure(function (data) {

      alert("Failure");

    });
});    

</script><br/>