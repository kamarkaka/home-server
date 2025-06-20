Setup is pretty straightforward. Things are running in first try.

Couple notes though:
- The "PUSH_*" environment variables are supposed to activate Mobile Client push notifications to automatically sync your personal vault between the mobile app, the web extension and the web vault without the need to sync manually.
- Follow the guild here: https://github.com/dani-garcia/vaultwarden/wiki/Enabling-Mobile-Client-push-notification
- The "ICON_*" environment variables are supposed to fetch icon for vault entries, it works for most sites, but some are failing, not sure why though.
- Add a cronjob to automatically backup the password database: `5 0 * * * docker exec -it vaultwarden /vaultwarden backup; mv /apps/vaultwarden/db_*.sqlite3 /mnt/backup-02/backup/vaultwarden/`


```
  vaultwarden:
    image: vaultwarden/server:latest
    container_name: vaultwarden
    restart: always
    environment:
      DOMAIN: "https://vaultwarden.${DNS_DOMAIN}"
      PUSH_ENABLED: true
      PUSH_INSTALLATION_ID: ${VW_PUSH_INSTALLATION_ID}
      PUSH_INSTALLATION_KEY: ${VW_PUSH_INSTALLATION_KEY}
      SIGNUPS_ALLOWED: false
      ICON_SERVICE: google
      ICON_CACHE_NEGTTL: 3600
      ICON_DOWNLOAD_TIMEOUT: 120
    volumes:
      - /apps/vaultwarden/:/data/
    ports:
      - 30011:80
    labels:
      glance.name: Vaultwarden
      glance.icon: auto-invert di:vaultwarden
      glance.url: https://vaultwarden.${DNS_DOMAIN}
      glance.description: An alternative server implementation of the Bitwarden Client API
```
