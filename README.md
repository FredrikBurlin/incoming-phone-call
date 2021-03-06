# Incoming Phone Call

Send a push message with the Lead or Contact that is calling. If the caller are not in Salesforce a new Lead is created.
A task is created linked to the record.

## Installation

1. Setup -> Sites -> Register My Salesforce Site Domain
Enter a domain name e.g. my-company if not already have one
2. Add public access to the class Setup -> Sites -> Incoming Phone Call(Site Label) -> Public Access Settings -> Enable Apex Class Access
Add IncomingPhoneCall
2. `sfdx force:data:tree:import -f config/CurrencyTypes.json` to use AUD as currency
3. Install [Package](https://login.salesforce.com/packaging/installPackage.apexp?p0=04tf4000004PtnmAAC) and [ask me](mailto:fredrik@nordiccloudlabs.com?subject=Hello%20Fredrik!&body=Hi%20Fredrik%2C%0A%0AI%20wish%20to%20install%20the%20Incoming%20Phone%20Call%20package.%20Could%20you%20send%20me%20the%20key.%0A%0AHave%20a%20great%20day!%0A%0ABR%2C%0AYOUR%20NAME%0A) for the installation key
4. Setup -> Custom Settings -> Incomming Phone Key -> Manage -> New (On top of Default Organization Level Value)
Key: <key>
5. Add Phone number to your user
6. Setup -> Notification Builder -> Notification Delivery Settings -> Custom Notification Types -> Incoming Phone Call
check Desktop and Mobile
check Salesforce for Android and Salesforce for iOS
7. Test go to url
<the domain>incomingPhoneCall/services/apexrest/incomingPhoneCall?to=<caller number>&from=<receiver number>&key=<key>


## Links
[Quick Tip – Public RESTful Web Services on Force.com Sites](https://developer.salesforce.com/blogs/developer-relations/2012/02/quick-tip-public-restful-web-services-on-force-com-sites.html)
[Custom Notification Demos](https://github.com/afawcett/customnotificationdemo)
[Release Your Updated Package](https://trailhead.salesforce.com/content/learn/projects/perm-set-unlocked/perm-set-unlocked-release)\