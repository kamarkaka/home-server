The docker compose config is shown as below. This is probably the easies set up of all.
```
  excalidraw:
    container_name: excalidraw
    image: excalidraw/excalidraw:latest
    restart: always
    ports:
    - 30006:80
    expose:
    - 80
    healthcheck:
      disable: true
    environment:
    - NODE_ENV=production
    labels:
      glance.name: Excalidraw
      glance.icon: di:excalidraw
      glance.url: https://excalidraw.${DNS_DOMAIN}
      glance.description: Virtual whiteboard for sketching hand-drawn like diagrams
```
