<h2>Group On Tool</h2>
<h4>Procedure</h4>
<img src="groupon.png" alt='plant uml diagram' />
<br />
<br />
<h1>GroupOn API Fields</h1>
<table>
<thead>
<th>API Field</th><th>What it Does</th>
</thead>
<tbody>
<tr>
<td>d</td> <td>nothing</td>
</tr>
<tr>
<td>uuid</td>  <td>merchant id such as "93ed5360-8f0a-4ca0-8126-a878535e02d9"</td>
</tr>
<tr>
<td class="critical">dealUrl</td>  <td class="critical">URL for deal - lot's of other junk thrown in</td>
</tr>
<tr>
<td>title</td>  <td>Title of most recent deal</td>
</tr>
<tr>
<td>announcementTitle</td>  <td>different from title</td>
</tr>
<tr>
<td>shortAnnouncementTitle</td>  <td>states what the deal IS - NO % OFF info</td>
</tr>
<tr>
<td>finePrint</td>  <td>Short paragraph.  Says how many per person.  Useful for prospect sorting.</td>
</tr>
<tr>
<td>highlightsHtml</td>  <td>Not very helpful - a weird, short snippet</td>
</tr>
<tr>
<td>soldQuantity</td><td>Displays <b>-1</b> if the deal is NO LONGER ACTIVE</td>
</tr>
<td>
limitedQuantityRemaining</td>
<td>Returns <b>NOTHING</b> if the deal has expired</td>
</tr>
<tr>
<td>
tippingPoint
</td>
<td>Unknown</td>
</tr>
<tr>
<td>
soldQuantityMessage
</td>
<td>Returns <b>-1</b> if the deal has expired</td>
</tr>
<tr>

<td class="image-property">
placeholderUrl
</td>
<td>Expired deal has 1x1 pixel</td>
</tr>
<tr>
<td class="image-property">
grid4ImageUrl
</td>
<td>Image related to the deal</td>
</tr>
<tr>
<td class="image-property">
grid6ImageUrl
</td>
<td>Same as previous image - but larger</td>
</tr>
<tr>
<td class="image-property">
largeImageUrl
</td>
<td>Same as above but larger</td>
</tr>
<tr>
<td class="image-property">
mediumImageUrl
</td>
<td>Same as above but smaller</td>
</tr>
<tr>
<td class="image-property">
smallImageUrl
</td>
<td>Same as above BUT VERY SMALL only 50x50</td>
</tr>
<tr>
<td class="image-property">
sidebarImageUrl
</td>

<td>Same as above but larger - 200x300 pixels</td>
</tr>
<tr>
<td>
status
</td>
<td>Shows <b>open</b> even for <b>expired</b> deals?</td>
</tr>
<tr>
<td>type</td>
<td>Returns &ldquo;groupon&rdquo;</td>
</tr>
<td>
accessType
</td>
<td>
For one expired deal it returns <b>&ldquo;extended&rdquo;</b>
</td>

</tr>
<tr>
<td class="critical">
endAt
</td>
<td class="critical"><b>Returns <u>end date</u> for the deal</b> - the year listing is bizzare.  2019 deals often say 2042.  More investigation needed. </td>
</tr>
<tr>
<td class="critical">
startAt
</td>
<td class="critical">The date the deal <b>began</b>.  The year seems accurate on this one.</td>
</tr>
<tr>
<td>
tippedAt
</td>
<td>A date.  Maybe when "tipping point?" was activated.</td>
</tr>
<tr>
<td>
areas
</td>
<td>Blank on expired deals.</td>

</tr>
<tr>
<td>
channels
</td>
<td>Blank on expired deals.</td>
</tr>
<tr>
<td>
division
</td>
<td>Same object that is returned by Division API.  Details on what Group-On city is selected.  Includes Time Zone as a property (helpful for CRM).  Has city name.  Longitude and Latitude.(note: GroupOn uses nearest division to your location if no division specified.</td>
</tr>
<tr>
<td class="critical">
grouponRating
</td>
<td class="critical">
Sadly, blank for expired listings.
</td>

</tr>
<tr>
<td class="critical">
allowedInCart
</td>
<td class="critical">
Whether or not you can put the offer in your checkout cart.  Good for distinguishing expired from NOT expired deals.  Might be helpful for distinguishing services from goods (not using the 'goods' category filter).
</td>
</tr>
<tr>
<td>
isInviteOnly
</td>
<td>
Boolean.  Tells you whether or not the deal is invite only (did not know invite only deals were a thing).
</td>
</tr>
<tr>
<td>
shippingAddressRequired
</td>
<td>Boolean.  True or False whether or not you need to enter a shipping address to buy this deal.
</td>
</tr>
<tr>
<td>
isOptionListComplete
</td>
<td>Boolean.  Not sure what an incomplete listing would look like.  Mostly returns true.
</td>
</tr>
<tr>
<td class="critical">
isMerchandisingDeal
</td>
<td class="critical">
Boolean.  Could be helpful for distinguishing local service offers from products (besides the GroupOn category &ldquo;Goods&rdquo; select.)</td>
</tr>
<tr>
<td class="critical">
isNowDeal
</td>
<td class="critical">Boolean.  Whether or not the deal is currently active.
</td>

</tr>
<tr>
<td class="critical">
isSoldOut
</td>
<td class="critical">
Boolean. Whether or not the deal is sold out.
</td>

</tr>
<tr>
<td>

isTipped
</td>
<td>
Boolean.  Whether or not the deal has reached the tipping point.  Returns <b>True</b> for expired deals.</td>

</tr>
<tr>
<td>
isTravelBookableDeal
</td>
<td>Boolean.  Does this interact with the Getaways category?</td>
</td>
</tr>
<tr>
<td>
isGliveInventoryDeal
</td>
<td>
G-Live inventory - does this deal count as a live event?  Could be useful to distinguish goods deals. (See: <a href="https://www.groupon.com/occasion/play-live-shows">https://www.groupon.com/occasion/play-live-shows</a></td>
</tr>
<tr>
<td>
isAutoRefundEnabled
</td>
<td>Boolean.  Can auto-refund?
</td>
</tr>
<tr>
<td>
isGiftable
</td>
<td>
Boolean. Can you give the offer as a gift certificate.
</td>
</tr>
<tr>
<td>
placementPriority
</td>
<td>
Returns &ldquo;nearby&rdquo; I have no idea what this means.
</td>
</tr>
<tr>
<td>
redemptionLocation
</td>
<td>More specific CITY location.  i.e. gives the exact neighborhood inside the city. 
</td>
</tr>
<tr>
<td>
locationNote
</td>
<td>
Often blank.
</td>
</tr>
<tr>
<td>
vip
</td>
<td>Often blank.  Specials for VIP member? <a href="https://www.groupon.com/vip">https://www.groupon.com/vip</a></td>
</tr>
<tr>
<td>
fulfillmentMethod
</td>
</tr>
<tr>
<td class="critical">
tags
</td>
<td class="critical">
Returns an object of tags.  Each tag has a <b>name</b> property and unique id for the tag (called <b>uuid</b>).  These tag ids could be extremely helpful.
</td>
</tr>
<td>
displayOptions
</td>
<td>
Returns an interesting object with important fields:
<br />
discount<br />
quantity<br />
timer<br />
merchandisingType<br />
showRedemptionLocations<br />
showPrice<br />
<br />
Probably does not return whether or not a discount exists - but whether or not it should be displayed.
</td>
</tr>
<tr>
<td>
textAd
</td>
<td>Often blank.  Includes: <br />
line1<br />
line2<br />
headline<br />
</td>
</tr>
<tr>
<td class="critical">
merchant
</td>
<td class="critical">
<b>RETURNS WEBSITE.  As well as full company name.  Also returns ratings sometimes, TwitterURL, FacebookURL</b>
<br />
id <br />        
uuid<br />       
name<br />       
websiteUrl <br />
twitterUrl<br /> 
ratings<br />    
facebookUrl<br />
</td>
</tr>
<tr>
<td class="critical">
options
</td>
<td class="critical">
Large object with A LOT of information.
<br />
The <b>price</b> and <b>value</b> property contains the price of the different offers.
</td>
</tr>
<tr>
<td>
says
</td>
<td>
Often blank.
</td>

</tr>
<tr>
<td>
salesforceLink
</td>
<td>
Often blank.  I assume this is for the GroupOn sales team's internal use.
</td>
</tr>
</tbody> 
</table>
</body>
