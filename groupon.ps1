[system.collections.arraylist]$alldeals = @();
# Sytanx is $URL + $Token + $Selects
$Token = Get-Content .\mytoken.txt;
$URL = "https://partner-api.groupon.com/deals.json?";
$selector = "";
$all_ids = @();
$ids = @{};
$currentDivision = "";
$deals = [ordered]@{};

# Cycle through each city?
# Get List of all City IDS
$ids = Invoke-RestMethod -Uri "https://partner-api.groupon.com/division.json";
$all_ids = @($ids.divisions.id);
Write-Host { "Grabbing the most recent list of ALL GroupOn cities." }
Write-Host $all_ids;
Write-Host { "selecting the deals"};

# Only get Beauty and Spa deals
# filters=category:beauty-and-spas


for($d=0;$d -lt $all_ids.Length; $d++) {

$division = "&division_id=$($all_ids[$d])";
$category = '&filters=category:beauty-and-spas';
$offset = '&offset=0&limit=250'

$call = $URL + $Token + $division + $category + $offset;
$deals = Invoke-RestMethod -Uri $call 


Write-Host { "Number of deals retrieved from $division is $($deals.deals.Length)"};
# @TODO use offset if # of deals is over 250


# The properites we are interested in:
# Name, Website, GroupOn URL: $deals.deals[0].merchant.websiteUrl / name / 
# Recent Deal #1: $deals.deals[0].title
# *(new) Announcement Title: $deals.deals[0].announcementTitle
# Date Deal Started: $deals.deals[0].options.startAt 
# *(new) Ends: $deals.deals[0].options.endsAt
# Deal Still Active $deals.deals[0].isNowDeal
# Tags $deals.deals[0].tags (iterate through this)
# Limited Quantity: $deals.deals[0].isLimitedQuantity
# Number of Days Offer Lasts: $deals.deals[0].expiresInDays
# Phone Number: $deals.deals[0].redemptionLocations.phoneNumber
# City $deals.deals[0].division.name
# Discount %: $deals.deals[0].discountPercent
# $deals.deals[0].merchant.ratings?!
# #####################################

# Use Start-Sleep to pause between each call
# Use a random number that gives a liberal amount of pause between each call
# Now call the API to get the first 250 results
# #############################################



# Convert each deal in the city
for($i=0; $i -lt $deals.deals.length; $i++) {
    $fullDealURL = $deals.deals[$i].options[0].buyUrl;
    $cleanDealURL = $fullDealURL -replace 'confirmation.*';
    
    try {
    $dealStartAt = $deals.deals[$i].options.pricingMetadata[0].offerBeginsAt;
    $dealStartAt = $dealStartAt -replace 'T.*';
 
    $dealEndsAt = $deals.deals[$i].options.pricingMetadata[0].offerEndsAt;
    $dealEndsAt = $dealEndsAt -replace 'T.*';
    }
    catch {
        Write-Debug "Could not get Beginning or Ending info for $division deal #$i";
    }

    [int]$maxDiscount = $deals.deals[$i].options.discountPercent | Measure-Object -Maximum | select-object -ExpandProperty Maximum
    $websiteURL = $deals.deals[$i].merchant.websiteUrl;

$dealCleaned = @{
    merchantName = $deals.deals[$i].merchant.name;
    maxDiscount = $maxDiscount;
    divisionName = $deals.deals[$i].division.name;
    websiteURL = $websiteUrl;
    phoneNumber = $deals.deals[$i].options.redemptionLocations.phoneNumber;
    cleanDealURL = $cleanDealURL;
    dealTitle = $deals.deals[$i].title;
    dealStartAt = $dealStartAt;
    dealEndsAt = $dealEndsAt;
    tags = @($deals.deals[$i].tags)
}
$allDeals += $dealCleaned;


}

#Cut deals over 55
#Add price to clean deal?



Start-Sleep -Seconds 5
} #end multi-city for loop
Write-Host { "Exporting all INFO to Json file: dealsDump.json"}
$deals | ConvertTo-Json -Depth 15 | Set-Content -Path C:dealsDump.json

Write-Host { "Exporting all cleaned deals to allDeals.json"}
$allDeals | ConvertTo-Json -depth 15 | Set-Content -Path C:allDeals.json

$sortedbyDiscount = $allDeals | Sort-Object { $_.maxDiscount }
Write-Host { "Exporting all sorted by max discount deals to sortedDeals.json" }
$sortedbyDiscount | ConvertTo-Json -Depth 15 | Set-Content -Path C:sortedDeals.json

Write-Host "Making HTML file";

$htmlBody = "";

$allDeals | foreach-object { 
    $newHTML = @"
    <tr>
    <td>$($_.merchantName)</td>
    <td>$($_.maxDiscount)</td>
    <td>$($_.divisionName)</td>
    <td><a href='$($_.websiteURL)'>$($_.websiteURL)</a></td>
    <td>$($_.phoneNumber)</td>
    <td><a href='$($_.cleanDealURL)'>$($_.cleanDealURL)</a></td>
    <td>$($_.dealTitle)</td>
    <td>$($_.dealStartAt)</td>
    <td>$($_.dealEndsAt)</td>
    <td>$($_.tags[0].name)</td>
   
    
    </tr>
"@

    $htmlBody += $newHTML;
    
}
#>
$htmlTop = @"
<!DOCTYPE html>
<html>
  <head>
    <meta charset='UTF-8'>
    <title>GroupOn Deals</title>
  <style type='text/css'>
  
table {
    border: 5px dashed black;
}
tr:nth-child(odd) { 
    background-color: #e9e9e9;
}
tr:hover {
    background-color: #ff0000; 
}
.critical { 
    background-color: #ffff00; 
}

th, td {
        padding: 10px;
        max-width: 400px;

}
th {
  background-color: #4CAF50;
  color: white;
}
.image-property {
    background-color: #2b91a7;

}

.image-property:nth-of-type(3) {
    background-color: #18777e;
}
</style>
<script src="sorttable.js"></script>
  </head>
  <body>
<h1>GroupOn Export</h1>
<table class="sortable">
<caption>GroupOn Export</caption>
<tr>
    <th>Name</th><th>MAX Discount %</th><th>City</th><th>Website</th><th>Phone Number</th><th>GroupOn URL</th>
    <th>Recent Deal #1</th><th>Date Deal Starts</th><th>Date Deal Ends</th><th>Tags</th>
    
</tr>
"@


$htmlBottom = @"
</body>
</html>
"@
$htmlpage = $htmlTop + $htmlpage + $htmlbottom;
$htmlpage | Out-File .\report.html
# Export a CSV file
$allDeals | sort-object { $_.maxDiscount } | select-object @{n="Tags"; e={$_.tags[0].name}}, @{n="Name"; e={$_.merchantName}}, @{n="City"; e={$_.divisionName}}, @{n="Discount"; e={$_.maxDiscount}}, @{n="Website URL"; e={$_.websiteURL}}, @{n="Phone Number"; e={$_.phoneNumber[0]}}, @{n="GroupOn URL"; e={$_.cleanDealURL}}, @{n="Recent Deal"; e={$_.dealTitle}}, @{n="Deal Start Date"; e={$_.dealStartAt}}, @{n="Deal End Date"; e={$_.dealEndsAt}} | Export-Csv -Path .\ed-export-with-city.csv
