Nothing fancy. Just bind your desired directory and you are good to go

```
  filebrowser:
    container_name: filebrowser
    image: filebrowser/filebrowser
    restart: always
    user: 1000:1001
    ports:
    - 30007:80
    volumes:
    - /apps/filebrowser/filebrowser.db:/database/filebrowser.db
    - /apps/filebrowser/filebrowser.json:/.filebrowser.json
    - /mnt/backup-02/downloads/:/srv/
    labels:
      glance.name: File Browser
      glance.icon: di:filebrowser
      glance.url: https://files.${DNS_DOMAIN}
      glance.description: Web File Browser
```
