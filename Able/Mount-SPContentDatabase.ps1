asnp *sh*

# Get-SPContentDatabase -Identity "9A892B5C-A3F9-4F22-B378-642A09DC4A85" | Upgrade-SPContentDatabase

Get-SPContentDatabase -Identity "9A892B5C-A3F9-4F22-B378-642A09DC4A85"

Mount-SPContentDatabase "WSS_Content_ATLAS-PRD" -WebApplication "http://atlas-uat.westlake.com"
Mount-SPContentDatabase	"WSS_Content_ATLAS-PRD-TMP" -WebApplication "http://atlas-uat.westlake.com"
Mount-SPContentDatabase	"WSS_Content_ATLAS-IS-PRD" -WebApplication "http://atlas-uat.westlake.com"
Mount-SPContentDatabase	"WSS_Content_MasterDataMgmt-PRD" -WebApplication "http://atlas-uat.westlake.com"
Mount-SPContentDatabase	"WSS_Content_PDA-PRD" -WebApplication "http://atlas-uat.westlake.com"
Mount-SPContentDatabase	"WSS_Content_BI-Portal-PRD" -WebApplication "http://atlas-uat.westlake.com"
Mount-SPContentDatabase	"WSS_Content_COE-PRD" -WebApplication "http://atlas-uat.westlake.com"
Mount-SPContentDatabase	"WSS_Content_TIP-PRD" -WebApplication "http://atlas-uat.westlake.com"
Mount-SPContentDatabase	"WSS_Content_WLK-Collab-PRD" -WebApplication "http://collab-uat.westlake.com"
Mount-SPContentDatabase	"WSS_Content_SAP-PRD" -WebApplication "http://collab-uat.westlake.com"
Mount-SPContentDatabase	"WSS_Content_Collab_Teams-Restored-PRD" -WebApplication "http://collab-uat.westlake.com" #(located at W:\Data on houdbspd01p)
Mount-SPContentDatabase	"WSS_Content_Collab_Teams-2" -WebApplication "http://collab-uat.westlake.com"
Mount-SPContentDatabase	"WSS_Content_WLK-Connect-PRD" -WebApplication "http://connectone-uat.westlake.com"
Mount-SPContentDatabase	"WSS_Content_Contracts-PRD" -WebApplication "https://contracts-uat.westlake.com"
#Mount-SPContentDatabase	"WSS_Content_EDMS-TMP" -WebApplication "http://edms-uat.westlake.com" # Contains 0 site collections in PRD. Disregard.
Mount-SPContentDatabase	"WSS_Content_EDMS-PRD"  -WebApplication "http://edms-uat.westlake.com" #(Corrupted on houdbspd11t - Pete to backup/restore manually from PRD)
Mount-SPContentDatabase	"WSS_Content_SharePointIntranet" -WebApplication "http://hub-uat.westlake.com"
Mount-SPContentDatabase	"WSS_Content_CorpAccting" -WebApplication "http://hub-uat.westlake.com"
Mount-SPContentDatabase	"WSS_Content_AIM_Plants-PRD" -WebApplication "http://hub-uat.westlake.com"
Mount-SPContentDatabase	"WSS_Content_Legal-PRD" -WebApplication "http://hub-uat.westlake.com"
Mount-SPContentDatabase	"WSS_Content_SPD-PRD" -WebApplication "http://hub-uat.westlake.com"
Mount-SPContentDatabase	"WSS_Content_Finance-PRD" -WebApplication "http://hub-uat.westlake.com"
Mount-SPContentDatabase	"WSS_Content_BuildingProducts-PRD" -WebApplication "http://hub-uat.westlake.com"
Mount-SPContentDatabase	"WSS_Content_Corp_Coms-PRD" -WebApplication "http://hub-uat.westlake.com"
Mount-SPContentDatabase	"WSS_Content_EHSS-PRD" -WebApplication "http://hub-uat.westlake.com"
Mount-SPContentDatabase	"WSS_Content_HR-PRD" -WebApplication "http://hub-uat.westlake.com"
Mount-SPContentDatabase	"WSS_Content_PCDocs-PRD" -WebApplication "http://hub-uat.westlake.com"
Mount-SPContentDatabase	"WSS_Content_TradeCompliance-PRD" -WebApplication "http://hub-uat.westlake.com"
Mount-SPContentDatabase	"WSS_Content_Royal_Portal-PRD" -WebApplication "http://hub-uat.westlake.com"
Mount-SPContentDatabase	"WSS_Content_CSR-PRD" -WebApplication "http://hub-uat.westlake.com"
Mount-SPContentDatabase	"WSS_Content_Chemicals-PRD" -WebApplication "http://hub-uat.westlake.com"
Mount-SPContentDatabase	"WSS_Content_Natrium_Pub-PRD" -WebApplication "http://hub-uat.westlake.com"
Mount-SPContentDatabase	"WSS_Content_O365-ARCHIVES" -WebApplication "http://hub-uat.westlake.com"
Mount-SPContentDatabase	"WSS_Content_RBP-PRD" -WebApplication "http://hub-uat.westlake.com"
Mount-SPContentDatabase	"WSS_Content_MySites-PRD" -WebApplication "http://myhub-uat.westlake.com"
Mount-SPContentDatabase	"WSS_Content_OneIT-Europe-PRD" -WebApplication "http://oie-uat.westlake.com"
Mount-SPContentDatabase	"WSS_Content_SearchCenter-PRD" -WebApplication "http://search-uat.westlake.com"
Mount-SPContentDatabase	"WSS_Content_Vinnolit-PRD" -WebApplication "http://vinnolit-uat.westlake.com"
