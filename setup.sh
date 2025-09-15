#!/bin/bash
# Manual Setup Script for Jitsi Meet

echo "🎯 Setting up Jitsi Meet Self-Hosted Server"
echo "=========================================="

# Generate random secrets
JICOFO_SECRET=$(openssl rand -hex 32)
FOCUS_PASSWORD=$(openssl rand -hex 16)
JVB_PASSWORD=$(openssl rand -hex 16)

echo "Generated secrets:"
echo "JICOFO_SECRET: $JICOFO_SECRET"
echo "FOCUS_PASSWORD: $FOCUS_PASSWORD"
echo "JVB_PASSWORD: $JVB_PASSWORD"
echo ""

# Update docker-compose.yml with generated secrets
sed -i.bak "s/your-jicofo-secret/$JICOFO_SECRET/g" docker-compose.yml
sed -i.bak "s/your-focus-password/$FOCUS_PASSWORD/g" docker-compose.yml
sed -i.bak "s/your-jvb-password/$JVB_PASSWORD/g" docker-compose.yml

# Update jitsi.env with generated secrets
sed -i.bak "s/your-jicofo-secret-change-this/$JICOFO_SECRET/g" jitsi.env
sed -i.bak "s/your-focus-password-change-this/$FOCUS_PASSWORD/g" jitsi.env
sed -i.bak "s/your-jvb-password-change-this/$JVB_PASSWORD/g" jitsi.env

echo "✅ Updated configuration files with generated secrets"
echo ""

# Get server IP
echo "Please enter your server's public IP address:"
read -p "Server IP: " SERVER_IP

if [ -n "$SERVER_IP" ]; then
    sed -i.bak "s/your-server-ip/$SERVER_IP/g" docker-compose.yml
    sed -i.bak "s/your-server-ip/$SERVER_IP/g" jitsi.env
    echo "✅ Updated server IP to: $SERVER_IP"
else
    echo "⚠️  Please manually update 'your-server-ip' in docker-compose.yml and jitsi.env"
fi

echo ""
echo "🔧 Next steps:"
echo "1. Update your DNS records to point to this server:"
echo "   jitsi.riverlearn.co.ke -> $SERVER_IP"
echo "   conference.jitsi.riverlearn.co.ke -> $SERVER_IP"
echo "   focus.jitsi.riverlearn.co.ke -> $SERVER_IP"
echo "   guest.jitsi.riverlearn.co.ke -> $SERVER_IP"
echo "   jitsi-videobridge.jitsi.riverlearn.co.ke -> $SERVER_IP"
echo ""
echo "2. Start the services:"
echo "   docker-compose up -d"
echo ""
echo "3. Check logs:"
echo "   docker-compose logs -f"
echo ""
echo "4. Test your setup:"
echo "   https://jitsi.riverlearn.co.ke"
echo ""
echo "🎉 Setup complete!"
