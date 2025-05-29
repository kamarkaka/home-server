The setup in docker-compose.yml is pretty straightforward. You can also refer to the author's github page https://github.com/favonia/cloudflare-ddns for reference. I have encountered no issue running this app.

```
services:
  cloudflare-ddns:
    container_name: cloudflare-ddns
    image: favonia/cloudflare-ddns:latest
    network_mode: host
    restart: always
    user: 1000:1001 #mengc:docker
    read_only: true
    # Drop all Linux capabilities (optional but recommended)
    # security_opt: [no-new-privileges:true]
    # Another protection to restrict superuser privileges (optional but recommended)
    cap_drop: [all]
    environment:
    - UPDATE_CRON=@every 5m
    - IP6_PROVIDER=none
    - CLOUDFLARE_API_TOKEN=${CLOUDFLARE_API_TOKEN}
    # Your domains (separated by commas)
    - DOMAINS=${DNS_DOMAIN}
    # Tell Cloudflare to cache webpages and hide your IP (optional)
    - PROXIED=false
    labels:
      glance.name: Cloudflare DDNS
      glance.icon: di:cloudflare
      glance.description: A feature-rich and robust Cloudflare DDNS updater with a small footprint. The program will detect your machine’s public IP addresses and update DNS records using the Cloudflare API.
```
