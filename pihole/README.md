Remember to change the default DNS for your router, or manually set up DNS for each device.

I am using two block lists:
https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts (default one)
https://raw.githubusercontent.com/hagezi/dns-blocklists/main/adblock/pro.txt (there are a lot of different flavors in terms of aggressiveness, pick and choose one for you)

I did not find good ways of blocking ads in YouTube as ads and videos are both served from google servers, which makes it technically impossible for pihole. Despite this I find overall performance to be very positive.

```
services:
  pihole:
    container_name: pihole
    image: pihole/pihole:latest
    restart: unless-stopped
    ports:
    # DNS Ports
    - 53:53/tcp
    - 53:53/udp
    # Default HTTP Port
    - 30002:80/tcp
    # Default HTTPs Port. FTL will generate a self-signed certificate
    # "4443:443/tcp"
    # Uncomment the line below if you are using Pi-hole as your DHCP server
    #- "67:67/udp"
    # Uncomment the line below if you are using Pi-hole as your NTP server
    #- "123:123/udp"
    dns:
    - 8.8.8.8
    - 1.1.1.1
    environment:
      # Set the appropriate timezone for your location (https://en.wikipedia.org/wiki/List_of_tz_database_time_zones), e.g:
      TZ: America/New_York
      # Set a password to access the web interface. Not setting one will result in a random password being assigned
      FTLCONF_webserver_api_password: ${PIHOLE_PASSWORD}
      # If using Docker's default `bridge` network setting the dns listening mode should be set to 'all'
      FTLCONF_dns_listeningMode: 'all'
    # Volumes store your data between container upgrades
    volumes:
    # For persisting Pi-hole's databases and common configuration file
    - /apps/pihole:/etc/pihole
    # Uncomment the below if you have custom dnsmasq config files that you want to persist. Not needed for most starting fresh with Pi-hole v6. If you're upgrading from v5 you and have used this directory before, you should keep it enabled for the first v6 container start to allow for a complete migration. It can be removed afterwards. Needs environment variable FTLCONF_misc_etc_dnsmasq_d: 'true'
    #- './etc-dnsmasq.d:/etc/dnsmasq.d'
    cap_add:
    # See https://github.com/pi-hole/docker-pi-hole#note-on-capabilities
    # Required if you are using Pi-hole as your DHCP server, else not needed
    - NET_ADMIN
    # Required if you are using Pi-hole as your NTP client to be able to set the host's system time
    - SYS_TIME
    # Optional, if Pi-hole should get some more processing time
    - SYS_NICE
    labels:
      glance.name: Pi-hole
      glance.icon: di:pi-hole
      glance.url: https://pihole.${DNS_DOMAIN}/admin
      glance.description: Network-wide ad blocking via your own Linux hardware
```
