Just do not try to expose it onto the public, it will alright ban you.
FlareSolverr is for certain scrapers scraping sites that are behind cloudflare captcha challenges. There are different docker images with slight differences, try to see if one works for you.
Do not expect the scraper to work right out of the box (at lease for me), fortunately it's not that hard to debug and fix.

```
  stash:
    container_name: stash
    image: stashapp/stash:latest
    restart: unless-stopped
    ports:
    - "9999:9999"
    logging:
      driver: "json-file"
      options:
        max-file: 10
        max-size: 2m
    depends_on:
    - stash-flaresolverr
    environment:
    - STASH_STASH=/data/
    - STASH_GENERATED=/generated/
    - STASH_METADATA=/metadata/
    - STASH_CACHE=/cache/
    - STASH_PORT=9999
    volumes:
    - /etc/localtime:/etc/localtime:ro
    - /apps/stash/config:/root/.stash
    - /apps/stash/data:/data
    - /apps/stash/metadata:/metadata
    - /apps/stash/cache:/cache
    - /apps/stash/blobs:/blobs
    - /apps/stash/generated:/generated
    labels:
      glance.name: Stash
      glance.icon: di:stash

  stash-flaresolverr:
    container_name: stash-flaresolverr
    image: alexfozor/flaresolverr:pr-1300-experimental #21hsmw/flaresolverr:nodriver flaresolverr/flaresolverr:latest
    restart: unless-stopped
    network_mode: host
    environment:
      - LOG_LEVEL=info
      - LOG_HTML=false
      - CAPTCHA_SOLVER=hcaptcha
      - TZ=America/New_York
      - LANG=en-US
    labels:
      glance.name: Stash - FlareSolverr
      glance.icon: di:flaresolverr
      glance.description: FlareSolverr is a proxy server to bypass Cloudflare and DDoS-GUARD protection
```
