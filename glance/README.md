A cool dashboard that is highly customizable. You can find my configuration file at [home.yml](./home.yml).

For app icons, you can go search for them at https://dashboardicons.com

```
  glance:
    container_name: glance
    image: glanceapp/glance:latest
    restart: always
    volumes:
    - /apps/glance/config:/app/config
    - /apps/glance/assets:/app/assets
    - /var/run/docker.sock:/var/run/docker.sock:ro
    ports:
    - 30001:8080
    env_file: /apps/glance/.env
    labels:
      glance.name: Glance
      glance.icon: di:glance
      glance.url: https://glance.${DNS_DOMAIN}
      glance.description: What if you could see everything at a...
```
