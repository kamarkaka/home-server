Gotify allows an application to push messages through its REST API and a client (mobile app/webUI) can receive the notification.
iGotify makes it work for iPhone.

ntfy does the same thing, but I failed to get notification working on iPhones. It's my fault.

```
  gotify:
    container_name: gotify
    image: gotify/server
    restart: unless-stopped
    user: 1000:1001
    ports:
      - 30012:80
    environment:
      TZ: America/New_York
      GOTIFY_DEFAULTUSER_PASS: 'admin'
    volumes:
    - /apps/gotify:/app/data
    labels:
      glance.name: gotify
      glance.icon: di:gotify
      glance.url: https://gotify.${DNS_DOMAIN}
      glance.description: A simple server for sending and receiving messages

  igotify:
    container_name: igotify
    image: ghcr.io/androidseb25/igotify-notification-assist:latest
    restart: unless-stopped
    pull_policy: always
    ports:
      - 30013:8080
    environment:
      GOTIFY_URLS: https://gotify.${DNS_DOMAIN}
      GOTITY_CLIENT_TOKENS: ${GOTITY_CLIENT_TOKENS}
      SECNTFY_TOKENS: ${SECNTFY_TOKENS}
    labels:
      glance.name: igotify
      glance.icon: di:gotify
      glance.description: A small Gotify server notification assistent that decrypt the message and trigger a Push Notifications to iOS Devices via Apple's APNs
```
