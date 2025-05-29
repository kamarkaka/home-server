Default port for this app is 8096, took me a while to figure this out... Otherwise pretty straightforward to get it up and running.
Getting hardware acceleration on Nvidia GPU is a bit of work. Fortunately Jellyfin has pretty detailed guides navigating you through the process:
- https://jellyfin.org/docs/general/post-install/transcoding/hardware-acceleration/
- https://jellyfin.org/docs/general/post-install/transcoding/hardware-acceleration/nvidia

Notes:
Your GPU may not support all codecs, refer to https://developer.nvidia.com/video-encode-and-decode-gpu-support-matrix-new and *ONLY* enable the ones that are supported. Otherwise playback will fail.


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
    - /dev/nvidia-caps:/dev/nvidia-caps
    - /dev/nvidia0:/dev/nvidia0
    - /dev/nvidiactl:/dev/nvidiactl
    - /dev/nvidia-modeset:/dev/nvidia-modeset
    - /dev/nvidia-uvm:/dev/nvidia-uvm
    - /dev/nvidia-uvm-tools:/dev/nvidia-uvm-tools
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
