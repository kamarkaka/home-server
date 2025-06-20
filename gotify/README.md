Gotify allows an application to push messages through its REST API and a client (mobile app/webUI) can receive the notification.

iGotify makes it work for iPhone.

- `GOTITY_CLIENT_TOKENS` and `SECNTFY_TOKENS` can be ';' separated.
- When setting up nginx proxy manager, don't check the boxes which say "HTTP/2 Support" and "HSTS enabled".

ntfy does the same thing, but I failed to get notification working on iPhones. It's my fault.

```
  gotify:
    container_name: gotify
    image: gotify/server
    restart: always
    user: 1000:1001
    ports:
      - 30012:80
    environment:
      TZ: America/New_York
      GOTIFY_DEFAULTUSER_PASS: 'admin'
    volumes:
    - /apps/gotify:/app/data
    labels:
      glance.id: gotify
      glance.name: gotify
      glance.icon: di:gotify
      glance.url: https://gotify.${DNS_DOMAIN}
      glance.description: A simple server for sending and receiving messages

  igotify:
    container_name: igotify
    image: ghcr.io/androidseb25/igotify-notification-assist:latest
    restart: always
    user: 1000:1001
    ports:
      - 30013:8080
    pull_policy: always
    volumes:
      - /apps/igotify:/app/data
    labels:
      glance.parent: gotify
      glance.name: igotify
```
