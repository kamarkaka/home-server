# Guide to Set Up My Home Server
I have spent the last two weeks setting up a home server with applications running in Docker. It will be helpful for me (and hopefully others) to document the steps as some are a bit tricky and I don't want to waste my time doing it again.

## 1. OS Installation
I am using Ubuntu for no obvious reasons. Other Linux distributions should just work as well.

- Download official image: https://ubuntu.com/download/server#manual-install (I am using Server version as I don't really need a GUI, you can if you want)
- Get a thumbdrive and write the image onto the drive using Rufus or whatever software you would prefer.
- Boot from the thumbdrive and install the operating system for your home server.
  - The Ubuntu installation guide is pretty straightforward by itself, just make sure you have SSH installed.
  - **DO NOT INSTALL DOCKER!**: Ubuntu installed Docker will give you headaches when you try to use docker compose later. I am sure you can get it working, but it's not worth it. It is recommended to install Docker following Docker's official guide.
  - **DO NOT INSTALL PYTHON!**: Similar to Docker, Ubuntu installed Python has issues when getting pip to work. Don't waste your time.
  - Run `sudo timedatectl set-timezone America/New_York`

## 2. Samba
I use Samba to share my drives across the local network

### 2.1 Mounting Drives
- Run `blkid` and take notes of your hard drives and their corresponding UUIDs
- Append to file `/etc/fstab` with `UUID=<UUID> <path/to/mount> auto defaults 0 2`
- Run `sudo findmnt --verify` to verify fstab
- Run `sudo mount -a` to take effect, and the mount should persist through restarts (TODO: verify this)
- Run `lsblk` or `df -hT` to verify the mounted drives

### 2.2 Installing Samba
To install, run:
```
sudo apt update
sudo apt install samba
```
To verify, run:
```
whereis samba
sudo systemctl status smbd.service
```
Also you can use the command above to start/stop/restart Samba service

### 2.3 Configure Samba
Samba config file: `/etc/samba/smb.conf`

Below is my config:
```
[backup-01]
  path = /mnt/backup-01
  valid users = mengc
;  guest ok = yes
;  browseable = yes
  read only = no

[backup-02]
  path = /mnt/backup-02
  valid users = mengc
  read only = no

[backup-03]
  path = /mnt/backup-03
  valid users = mengc
  read only = no
```

### Notes
- I don't use ufw and it seems off by default, but if you do, don't forget adding a rule for Sambe into ufw.
- When mapping the shared drives for the first time on Windows machines, I was running into errors. If that happens, comment out `valid users` and uncomment `guest ok = yes` and `browseable = yes`. This seems to solve the issue by making the directory public. Don't forget to edit the config back if that is not what you want (usually not). Windows can remember the user name and credentials so once the drives are connected, you can/should add back the `valid users` line.

## 3. ZeroTier
It helps to access your local resources from public internet. Many are using tailscale VPN but I am too lazy to check it out.

Run the following to install ZeroTier server:
```
curl -s 'https://raw.githubusercontent.com/zerotier/ZeroTierOne/master/doc/contact%40zerotier.com.gpg' | gpg --import && \
if z=$(curl -s 'https://install.zerotier.com/' | gpg); then echo "$z" | sudo bash; fi
```
To join a network:
```
sudo zerotier-cli join <group_name>
```

### Notes
- To access local services/resources from outside of your local network, you would also need to configure port-forwarding in your router

## 4. Docker Installation
Following instructions here: https://docs.docker.com/engine/install/ubuntu/, below is the exact copy of commands at the time of writing:
```
# uninstall unofficial packages
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install the Docker packages
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verify that the installation is successful
sudo docker run hello-world
```

## 5. Other Applications
All the other applications are running as docker containers. You can refer to the [docker-compose.yml](./docker-compose.yml) file for reference.

Summary of ports used by apps

30000: nginx-proxy-manager

30001: glance

30002: pihole

30003: jellyfin

30004: qbittorrent

30005: immich-server

30006: excalidraw

30007: filebrowser

30008: money-tracker-api

30009: money-tracker-ui

30010: home-assistant

30011: vaultwarden

30012: gotify

30013: igotify

### 5.1 [Cloudflare DDNS](./cloudflare-ddns/README.md)
The program will detect your machine's public ID address and update DNS records using the Cloudflare API

### 5.2 [NGINX Proxy Manager](./nginx-proxy-manager/README.md)
Enables you to easily forward to your websites running at home or otherwise, including free SSL, without having to know too much about Nginx or Letsencrypt.

### 5.3 [Glance](./glance/README.md)
A nice dashboard/homepage

### 5.4 [Pihole](./pihole/README.md)
Network-wide ad blocking via your own Linux hardware

### 5.5 [Jellyfin](./jellyfin/README.md)
The Free Software Media System alternative to Plex

### 5.6 [qBittorrent](./qbittorrent/README.md)
qBittorrent is a bittorrent client programmed in C++ / Qt that uses libtorrent (sometimes called libtorrent-rasterbar) by Arvid Norberg.

### 5.7 [Immich](./immich/README.md)
High performance self-hosted photo and video management solution

### 5.8 [Excalidraw](./excalidraw/README.md)
Virtual whiteboard for sketching hand-drawn like diagrams

### 5.9 [Filebrowser](./filebrowser/README.md)
Web File Browser

### 5.10 [Money Tracker](./money-tracker/README.md)
Self-made budgeting app that keeps track of your spendings; in memory of Mint.com

### 5.11 [App Updater](./app-updater/README.md)
Self-made little crawler-like app that checks for software updates

### 5.12 [Home Assistant](./home-assistant/README.md)
Open source home automation that puts local control and privacy first.

### 5.13 [Gotify & iGotify](./gotify/README.md)
A simple server for sending and receiving messages.

### 5.14 [Vaultwarden](./vaultwarden/README.md)
An alternative server implementation of the Bitwarden Client API, written in Rust and compatible with official Bitwarden clients, perfect for self-hosted deployment where running the official resource-heavy service might not be ideal.

### 5.15 [Stash](./stash/README.md)
