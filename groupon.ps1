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
$htmlpage = $htmlTop;

# For Loop: for now try only 2 cities 

for($d=0;$d -le $all_ids.Length; $d++) {

$division = "&division_id=$($all_ids[$d])";
$category = '&filters=category:beauty-and-spas';
$offset = '&offset=0&limit=250'

$call = $URL + $Token + $division + $category + $offset;
$deals = Invoke-RestMethod -Uri $call 


Write-Host "Number of deals retrieved from $division is $($deals.deals.Length)";
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
        Write-Host "Could not get Beginning or Ending info for $division deal #$i";
    }

    [int]$maxDiscount = $deals.deals[$i].options.discountPercent | Measure-Object -Maximum | select-object -ExpandProperty Maximum
    $websiteURL = $deals.deals[$i].merchant.websiteUrl;

    $newHTML = @"
    <tr>
    <td>$($deals.deals[$i].merchant.name)</td>
    <td>$($maxDiscount)</td>
    <td>$($deals.deals[$i].division.name)</td>
    <td><a href='$($websiteURL)'>$($websiteURL)</a></td>
    <td>$($deals.deals[$i].options.redemptionLocations.phoneNumber)</td>
    <td><a href='$($cleanDealURL)'>$($cleanDealURL)</a></td>
    <td>$($deals.deals[$i].title)</td>
    <td>$($dealStartAt)</td>
    <td>$($dealEndsAt)</td>
    <td>$($deals.deals[$i].tags[0].name)</td>
   
    
    </tr>
"@

    $htmlpage = $htmlpage + $newHTML;
    
}

Start-Sleep -Seconds 5
} #end multi-city for loop

$htmlpage = $htmlpage + $htmlbottom;
$htmlpage | Out-File .\report.html