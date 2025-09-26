# Jitsi Standalone - Reproducible Deployment

This repository provisions a Jitsi Meet stack (Prosody, Jicofo, JVB, Web) via Docker Compose.

## Requirements
- DNS A records to your server IP (e.g., 35.188.159.72):
  - jitsi.riverlearn.co.ke
  - auth.jitsi.riverlearn.co.ke
  - guest.jitsi.riverlearn.co.ke
  - conference.jitsi.riverlearn.co.ke
  - internal-muc.jitsi.riverlearn.co.ke
  - focus.jitsi.riverlearn.co.ke
  - recorder.jitsi.riverlearn.co.ke
  - lobby.jitsi.riverlearn.co.ke
  - breakout.jitsi.riverlearn.co.ke
  - metadata.jitsi.riverlearn.co.ke
  - polls.jitsi.riverlearn.co.ke
  - endconference.jitsi.riverlearn.co.ke
  - speakerstats.jitsi.riverlearn.co.ke

## Quickstart
1. Update jitsi.env values for domains and email.
2. Ensure PUBLIC_URL in docker-compose.yml matches your site (e.g., https://jitsi.riverlearn.co.ke).
3. Start stack:
   - docker compose up -d
4. First run will provision TLS via acme.sh (Let’s Encrypt/ZeroSSL). Wait for success before testing HTTPS.

## Auth Modes
- Default: authentication disabled; guests can create rooms.
- To enable moderator auth (recommended after DNS propagation):
  - Set ENABLE_AUTH=1 in prosody, jicofo, web service env sections in docker-compose.yml.
  - Keep ENABLE_GUESTS=1 in web.
  - Create users in Prosody:
    - docker exec jitsi-prosody prosodyctl --config /config/prosody.cfg.lua register focus auth.jitsi.riverlearn.co.ke <password>
    - docker exec jitsi-prosody prosodyctl --config /config/prosody.cfg.lua register <moderator> auth.jitsi.riverlearn.co.ke <password>
  - Ensure web /config/config.js has:
    - hosts.anonymousdomain = guest.jitsi.riverlearn.co.ke
    - hosts.authdomain = auth.jitsi.riverlearn.co.ke
  - Restart: docker compose restart

## Image Versions
- Images pinned to :unstable for compatibility. Change to a known stable tag if desired across all services.

## Ports
- Web: 80, 443
- Prosody: 5222, 5280, 5347
- JVB: 10000/udp, 4443/tcp

## Customizations
- Web customizations live in web/ (config.js, interface_config.js, riverlearn-theme.css, custom-nginx.conf).

## Operational Notes
- If port 80/443 are taken by host nginx, stop/disable host nginx before starting the stack.
- If auth errors persist, ensure all DNS records above resolve to the server IP.
