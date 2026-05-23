# Ubuntu 22.04 xRDP in Docker
### Drop-in replacement for hopingboyz/debianxrdp

Same functions, same files, same Railway deploy flow — just Ubuntu 22.04 LTS instead of Debian Bullseye.

## Deploy on Railway

1. Push this repo to GitHub
2. Go to [railway.app](https://railway.app) → New Project → Deploy from GitHub repo
3. Select this repo
4. Railway builds and deploys automatically
5. Go to **Settings → Networking → Generate Domain**
6. Railway gives you a public domain on port 3389

## Connect via RDP

Use any RDP client (or browser-based RDP):
- **Host:** your Railway domain
- **Port:** 3389
- **Username:** `root`
- **Password:** `root`

## Build & run locally

```bash
docker build -t xrdp .

docker run -d -p 3389:3389 -v xrdp-root-home:/root --name xrdp-ubuntu xrdp
```

## What changed from the original (Debian → Ubuntu 22.04)

| Original | This repo |
|---|---|
| `FROM debian:bullseye` | `FROM ubuntu:22.04` |
| `firefox-esr` | `firefox` (Ubuntu ships the snap-free deb version) |
| Everything else | **100% identical** |

## Files

| File | Purpose |
|---|---|
| `Dockerfile` | Builds the Ubuntu 22.04 container with xrdp, xfce4, wine, audio |
| `start.sh` | Starts dbus, pulseaudio, xrdp — identical to original |
| `pulse-client.conf` | PulseAudio client config |
