Pretty straightforward except the environment variables. And remember port-forwarding port 6881.

```
  qbittorrent:
    container_name: qbittorrent
    image: qbittorrentofficial/qbittorrent-nox:latest
    restart: unless-stopped
    environment:
    - QBT_LEGAL_NOTICE=accept
    - QBT_VERSION=latest
    - QBT_WEBUI_PORT=30004
    - QBT_CONFIG_PATH=/config
    - QBT_DOWNLOADS_PATH=/downloads
    - TZ=America/New_York
    volumes:
    - /apps/qbittorrent/appdata:/config
    - /mnt/backup-01/BaiduDownload:/downloads
    ports:
    - 30004:30004
    - 6881:6881/tcp
    - 6881:6881/udp
    labels:
      glance.name: qBittorrent
      glance.icon: di:qbittorrent
      glance.url: https://qbittorrent.${DNS_DOMAIN}
      glance.description: qBittorrent is a bittorrent client programmed in C++ / Qt that uses libtorrent (sometimes called libtorrent-rasterbar) by Arvid Norberg.
```
