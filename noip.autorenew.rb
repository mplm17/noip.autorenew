#!/usr/bin/env ruby

# Summary:  The script avoid the need to manualy login every month in http://www.noip.com and update your domains to keep them alive.
#           It will automaticaly retrieve his current public IP from http://checkip.dyndns.org/
# Author: Felipe Molina (@felmoltor)
# Date: July 2013
# License: GPLv3
# updated by @t0mciu (02.08.2016). Changes:
# - replace http://checkip.dyndns.org to https://api.ipify.org (is faster, thx @LukeOwncloud for tip in perl version)
# - update log/errors messages
# updated by @mplm17 (01.25.2020), Changes:
# - no-ip username and password are setted in that file and not given in argument anymore
# - domain to update is now a mandatory argument

require 'date'
require 'mechanize'
require 'net/http'

user = "no-ip_username"
password = "no-ip_password"
domain_to_update = ARGV[0] if !ARGV[0].nil?

def getMyCurrentIP()
    m = Mechanize.new do |agent|
        agent.user_agent_alias = (Mechanize::AGENT_ALIASES.keys - ['Mechanize']).sample
    end
    ip = Net::HTTP.get(URI("https://api.ipify.org"))
    return ip
end

# ================

def setMyCurrentNoIP(user,password,my_public_ip,fqdn)
    
    updated_hosts = []
    m = Mechanize.new do |agent|
        agent.user_agent_alias = (Mechanize::AGENT_ALIASES.keys - ['Mechanize']).sample
    end
    loginpage = m.get("https://www.noip.com/login/")
    
    members_page = loginpage.form_with(:id => 'clogs') do |form|
        form.username = user
        form.password = password
    end.submit
    
    # Once successfuly loged in, access to DNS manage page
    dns_page = m.get("https://www.noip.com/members/dns/")
    dns_page.links_with(:text => "Modify").each do |link|
        # Update all the domains with my current IP
        update_host_page = m.click(link)
        hostname = update_host_page.forms[0].field_with(:name => "host[host]").value
        domain = update_host_page.forms[0].field_with(:name => "host[domain]").value
        if fqdn.nil? or fqdn == "#{hostname}.#{domain}"
            updated_hosts << "#{hostname}.#{domain}"
            update_host_page.forms[0].field_with(:name => "host[ip]").value = my_public_ip
            update_host_page.forms[0].submit
        end
    end
    
    return updated_hosts
end

# ================

puts "======== Start job: #{Date.today.to_s} #{Time.now.strftime "%T"} ================================\n\n"

if domain_to_update.nil?
puts "Error. Enter the FQDN you want to update. \nExample: noip.autorenew.rb mydomain.ddns.net\n\n"
puts "======== End job: #{Date.today.to_s} #{Time.now.strftime "%T"} ==================================\n\n"
exit(1)
else
    puts "Getting my current public IP..."
    my_public_ip = getMyCurrentIP()
    puts "Done. This IP is '#{my_public_ip}'"
    msg = "Sending Keep Alive request to noip.com"
    if !domain_to_update.nil?
        msg += " only for domain #{domain_to_update}"
    end
    puts msg
    updated_hosts = setMyCurrentNoIP(user,password,my_public_ip,domain_to_update)   
    if !updated_hosts.nil? and updated_hosts.size > 0
        puts "Done. Keeping alive #{updated_hosts.size} host with IP '#{my_public_ip}':"
        updated_hosts.each do |host|
            puts "- #{host}"
        end
    else
        $stderr.puts "Error!!!\nYou may have entered the wrong username and password,\nor there is no domain to autorenew. Check it!"
    end
end

puts "\n======== End job: #{Date.today.to_s} #{Time.now.strftime "%T"} ==================================\n\n"
