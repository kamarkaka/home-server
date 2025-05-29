I think you can technically use Nginx to fulfill all the functionalities, but this tool is just way easier to use.

```
services:
  nginx-proxy-manager:
    container_name: nginx-proxy-manager
    image: jc21/nginx-proxy-manager:latest
    restart: unless-stopped
    ports:
    - 80:80
    - 443:443
    - 30000:81
    volumes:
    - /apps/nginx-proxy-manager/data:/data
    - /apps/nginx-proxy-manager/letsencrypt:/etc/letsencrypt
    labels:
      glance.name: Nginx Proxy Manager
      glance.icon: di:nginx-proxy-manager
      glance.url: https://nginx.${DNS_DOMAIN}
      glance.description: Enables you to easily forward to your websites running at home or otherwise, including free SSL, without having to know too much about Nginx or Letsencrypt.
```
