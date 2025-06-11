Get it running is easy, but you probably will spend a lot time integrating your devices with home assistant. So far things are working after couple tries, and the provided integrations documentations are easy to follow.

Things I have integrated so far:
- Roborock vacuum: it was added without any specific setup, there are existing integrations from Roborock
- Kasa smart plug and lightbulbs: very easy to add
- Liebherr smart fridge: A bit tricky as you need to install HACS and then it will have Liehberr integration supported. Got API working after couple fails.
- Sony TV: not very useful but very easy to add
- Verizon router: no trouble adding it
- A smart nightlight with Apple HomeKit support: just do not use the bridge thing as it adds home assistant to homekit lol
- Nest thermostats: You need a lot of setups and $5 (wtf google?) and may hit authentication errors especially if your instance is behind a reserve proxy. Try adding the following into the `configuration.yaml`:
  ```
  http:
  server_port: 30010
  use_x_forwarded_for: true
  trusted_proxies:
  - <your desired ip range>
  - 127.0.0.1
  - ::1
  ```

```
  home-assistant:
    container_name: home-assistant
    image: ghcr.io/home-assistant/home-assistant:stable
    restart: unless-stopped
    privileged: true
    network_mode: host
    environment:
      TZ: America/New_York
    volumes:
    - /apps/homeassistant:/config
    - /run/dbus:/run/dbus:ro
    - /etc/localtime:/etc/localtime:ro
    labels:
      glance.name: Home Assistant
      glance.icon: di:home-assistant
      glance.url: https://home.${DNS_DOMAIN}
      glance.description: Open source home automation that puts local control and privacy first.
```
