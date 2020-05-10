# Incoming Phone Call

Send a push message with the Lead or Contact that is calling. If the caller are not in Salesforce a new Lead is created.
A task is created linked to the record.

## Installation

1. Setup -> Sites -> Register My Salesforce Site Domain
Enter a domain name e.g. my-company
2. Setup -> Sites -> New
Site Label: Incoming Phone Call
Active Site Home Page: Unauthorized
Activate
3. Setup -> Custom Settings -> Incomming Phone Key -> Manage -> New (On top of Default Organization Level Value)
Key: <key>
4. Test go to url
<the domain>/services/apexrest/incomingPhoneCall?to=<caller number>&from=<receiver number>&key=<key>

## Links
[Quick Tip – Public RESTful Web Services on Force.com Sites](https://developer.salesforce.com/blogs/developer-relations/2012/02/quick-tip-public-restful-web-services-on-force-com-sites.html)
[Release Your Updated Package](https://github.com/afawcett/customnotificationdemo)
[Custom Notification Demos](https://trailhead.salesforce.com/content/learn/projects/perm-set-unlocked/perm-set-unlocked-release)