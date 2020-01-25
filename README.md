noip.autorenew docker version (forked from felmoltor/noip.autorenew)
====================================

Ussually, when you want to keep alive a hostname of noip.com with a Free Account, they will send you an email every month
to keep alive this hostname in their DNSs. Thus, you will have to manually login in your noip.com account and click in
"Modify" the hostname to avoid deletion of this hostname from their DNS.

With this script you only have to place in the device where the hostname wants to be maintained (for example, in your
home Raspberry Pi) and schedule a '''cron job''' to execute it every 15 days or so.

The script will automatically retrieve the device public IP address and will login into your noip.com account to 
refresh your hostnames.


Usage
-----

Create a cronjob if desired with this line: 

`./noip.autorenew.rb <usename> <password> [<FQDN>]`


Needed gems
-----------

- mechanize
- nokogiri
- date
