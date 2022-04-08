Add-SPSolution -LiteralPath e:\wsps\aenewstileswebpart.wsp
Install-SPSolution -Identity contoso_solution.wsp -GACDeployment
Install-SPSolution -Identity aenewstileswebpart.wsp -WebApplication http://vinnolit-uat.westlake.com/ -GACDeployment