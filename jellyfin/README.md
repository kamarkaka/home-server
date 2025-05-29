Default port for this app is 8096, took me a while to figure this out... Otherwise pretty straightforward to get it up and running.
I still need to test out GPU hardware acceleration. It is supposed to be working but I think I've seen failures...

```
services:
  jellyfin:
    container_name: jellyfin
    image: jellyfin/jellyfin:latest
    restart: unless-stopped
    user: 1000:1001
    ports:
    - 30003:8096
    volumes:
    - /apps/jellyfin/config:/config
    - /apps/jellyfin/cache:/cache
    - type: bind
      source: /mnt/backup-01/Movie
      target: /mnt/movies
    - type: bind
      source: /mnt/backup-01/Anime
      target: /mnt/animes
    - type: bind
      source: /mnt/backup-01/AnimeMovie
      target: /mnt/anime_movies
    - type: bind
      source: /mnt/backup-01/TV
      target: /mnt/tvshows
    deploy:
      resources:
        reservations:
          devices:
          - driver: nvidia
            count: 1
            capabilities:
            - gpu
    labels:
      glance.name: Jellyfin
      glance.icon: di:jellyfin
      glance.url: https://jellyfin.${DNS_DOMAIN}
      glance.description: The Free Software Media System
```
