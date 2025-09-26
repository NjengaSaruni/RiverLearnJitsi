# Jitsi Standalone Troubleshooting Log (Final)

## Final State (2025-09-26)
- Containers running with images: jitsi/*:unstable
- HTTPS via acme.sh (ZeroSSL) working
- Auth temporarily disabled to unblock meetings; lobby/breakout disabled
- DNS: core records present; feature component subdomains to be added for full feature set

## Key Decisions
- Pinned images to :unstable for compatibility
- Default deployment: guest access (no auth), enable Let’s Encrypt, HTTP->HTTPS redirect
- To enable moderator auth later: set ENABLE_AUTH=1 across services and create focus/moderator users

## Outstanding Items
- Add DNS A records for: lobby, breakout, metadata, polls, endconference, speakerstats
- After DNS propagation, re-enable auth and lobby as needed

