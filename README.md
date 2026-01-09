# Evalynx Jitsi Meet Server Configuration

This repository contains the complete configuration and patches for the Evalynx self-hosted Jitsi Meet server.

## Server Details
- **Domain:** evalynx-meet.duckdns.org
- **IP:** 140.238.255.190
- **Jitsi Version:** 2.0.10655-1

## Files Included

### Configuration Files
- **evalynx-meet.duckdns.org-config.js** - Main Jitsi Meet configuration
  - Lobby disabled
  - P2P disabled
  - Visitors disabled
  - Custom toolbar configuration

- **jicofo.conf** - Jicofo (Jitsi Conference Focus) configuration
  - Auto-owner enabled
  - Lobby disabled at conference level

- **interface_config.js** - UI configuration
  - Lobby invite header hidden

### Patched Files
- **lib-jitsi-meet.min.js** - Patched version with isLobbySupported() fix
  - Added try-catch and null checks to prevent disconnection bug
  
- **lib-jitsi-meet.min.js.backup** - Original backup before patching

## Important Notes

### Critical Patch
The lib-jitsi-meet.min.js file contains a critical patch to fix the isLobbySupported() crash that was causing participants to disconnect. This patch must be maintained when updating Jitsi Meet.

### File Locations on Server
- /etc/jitsi/meet/evalynx-meet.duckdns.org-config.js
- /etc/jitsi/jicofo/jicofo.conf
- /usr/share/jitsi-meet/interface_config.js
- /usr/share/jitsi-meet/libs/lib-jitsi-meet.min.js

### Service Restart Commands
After making changes, restart services:
`ash
sudo systemctl restart jicofo
sudo systemctl restart jitsi-videobridge2
sudo systemctl restart prosody
sudo systemctl restart nginx
`

## Updating Configuration

1. Make changes to files on the server
2. Copy updated files to this repo directory
3. Commit and push:
`ash
cd ~/evalynx-jitsi-server
git add .
git commit -m  Description of changes
git push origin main
`

## Last Updated
January 9, 2026
