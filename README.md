noip.autorenew Docker version (forked from <a href="https://github.com/felmoltor/noip.autorenew" target="_blank">felmoltor/noip.autorenew</a>)
====================================

**Works with Debian. Tested on Debian Buster.**
**<a href="https://docs.docker.com/" target="_blank">Docker</a> needs to be installed.**

Usually, when you want to keep alive a hostname of noip.com with a Free Account, they will send you an email every month
to keep alive this hostname in their DNSs. Thus, you will have to manually login in your noip.com account and click in
"confirm" the hostname to avoid deletion of this hostname from their DNS.

With this script you only have to place in the device where the hostname wants to be maintained (for example, in your
home Raspberry Pi) and schedule a '''cron job''' to execute it every 15 days or so.

The script will automatically retrieve the device public IP address and will login into your noip.com account to 
refresh your hostnames.


Usage
-----

1. Set your noip.com account info in `noip.autorenew.rb` at these lines:
``` bash
user = "no-ip_username"
password = "no-ip_password"
```
2. Build docker image:
``` bash
cd noip.autorenew.dockerized/
docker build -t noip-autorenew-image .
```
3. Run docker container:
``` bash
docker run --name noip-autorenew -dit noip-autorenew-image
```
4. Create a cronjob if desired with this line: 
``` bash
0 0 1,15 * * docker exec noip-autorenew ./noip.autorenew.rb <FQDN> >/dev/null 2>&1
```
5. You can try it manually:
``` bash
docker exec noip-autorenew ./noip.autorenew.rb <FQDN>
```
