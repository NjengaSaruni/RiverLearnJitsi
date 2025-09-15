#!/bin/bash
# GCE Startup Script for Jitsi Meet
# This script runs when the GCE instance starts

set -e

echo "🚀 Starting Jitsi Meet deployment on GCE..."

# Update system
apt-get update
apt-get upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
apt-get install -y docker-compose-plugin

# Install Git
apt-get install -y git

# Install additional tools
apt-get install -y curl wget unzip

# Create jitsi user
useradd -m -s /bin/bash jitsi
usermod -aG docker jitsi

# Create application directory
mkdir -p /opt/jitsi-meet
cd /opt/jitsi-meet

# Get external IP from metadata
EXTERNAL_IP=$(curl -s http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip -H "Metadata-Flavor: Google")
echo "📍 External IP: $EXTERNAL_IP"

# Clone repository
git clone https://github.com/NjengaSaruni/RiverLearnJitsi.git /opt/jitsi-meet
cd /opt/jitsi-meet

# Generate secure secrets
JICOFO_SECRET=$(openssl rand -hex 32)
FOCUS_PASSWORD=$(openssl rand -hex 16)
JVB_PASSWORD=$(openssl rand -hex 16)

echo "🔐 Generated secrets:"
echo "JICOFO_SECRET: $JICOFO_SECRET"
echo "FOCUS_PASSWORD: $FOCUS_PASSWORD"
echo "JVB_PASSWORD: $JVB_PASSWORD"

# Update docker-compose.yml with secrets and IP
sed -i "s/your-jicofo-secret/$JICOFO_SECRET/g" docker-compose.yml
sed -i "s/your-focus-password/$FOCUS_PASSWORD/g" docker-compose.yml
sed -i "s/your-jvb-password/$JVB_PASSWORD/g" docker-compose.yml
sed -i "s/your-server-ip/$EXTERNAL_IP/g" docker-compose.yml

# Update jitsi.env with secrets and IP
sed -i "s/your-jicofo-secret-change-this/$JICOFO_SECRET/g" jitsi.env
sed -i "s/your-focus-password-change-this/$FOCUS_PASSWORD/g" jitsi.env
sed -i "s/your-jvb-password-change-this/$JVB_PASSWORD/g" jitsi.env
sed -i "s/your-server-ip/$EXTERNAL_IP/g" jitsi.env

# Create configuration directories
mkdir -p prosody jicofo jvb web/letsencrypt

# Start services
echo "🚀 Starting Jitsi Meet services..."
docker-compose up -d

# Wait for services to start
echo "⏳ Waiting for services to start..."
sleep 30

# Check service status
echo "📊 Service status:"
docker-compose ps

# Create health check script
cat > /opt/jitsi-meet/health-check.sh << 'EOF'
#!/bin/bash
# Health check script for Jitsi Meet

echo "🔍 Checking Jitsi Meet health..."

# Check if containers are running
if ! docker-compose ps | grep -q "Up"; then
    echo "❌ Some containers are not running"
    exit 1
fi

# Check web interface
if ! curl -f http://localhost/health > /dev/null 2>&1; then
    echo "❌ Web interface not responding"
    exit 1
fi

echo "✅ All services are healthy"
EOF

chmod +x /opt/jitsi-meet/health-check.sh

# Set up log rotation
cat > /etc/logrotate.d/jitsi << 'EOF'
/var/log/jitsi/*.log {
    daily
    missingok
    rotate 7
    compress
    delaycompress
    notifempty
    create 644 root root
    postrotate
        docker-compose -f /opt/jitsi-meet/docker-compose.yml restart web
    endscript
}
EOF

# Create systemd service for auto-start
cat > /etc/systemd/system/jitsi-meet.service << 'EOF'
[Unit]
Description=Jitsi Meet
Requires=docker.service
After=docker.service

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=/opt/jitsi-meet
ExecStart=/usr/bin/docker-compose up -d
ExecStop=/usr/bin/docker-compose down
TimeoutStartSec=0

[Install]
WantedBy=multi-user.target
EOF

# Enable the service
systemctl enable jitsi-meet.service

# Create monitoring script
cat > /opt/jitsi-meet/monitor.sh << 'EOF'
#!/bin/bash
# Monitoring script for Jitsi Meet

LOG_FILE="/var/log/jitsi/monitor.log"
mkdir -p /var/log/jitsi

echo "$(date): Starting Jitsi Meet monitoring" >> $LOG_FILE

# Check container health
if ! docker-compose ps | grep -q "Up"; then
    echo "$(date): ERROR - Some containers are down" >> $LOG_FILE
    # Restart services
    docker-compose restart
fi

# Check disk space
DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ $DISK_USAGE -gt 80 ]; then
    echo "$(date): WARNING - Disk usage is ${DISK_USAGE}%" >> $LOG_FILE
fi

# Check memory usage
MEMORY_USAGE=$(free | awk 'NR==2{printf "%.2f", $3*100/$2}')
if (( $(echo "$MEMORY_USAGE > 80" | bc -l) )); then
    echo "$(date): WARNING - Memory usage is ${MEMORY_USAGE}%" >> $LOG_FILE
fi

echo "$(date): Monitoring check completed" >> $LOG_FILE
EOF

chmod +x /opt/jitsi-meet/monitor.sh

# Set up cron job for monitoring
echo "*/5 * * * * /opt/jitsi-meet/monitor.sh" | crontab -

# Create backup script
cat > /opt/jitsi-meet/backup.sh << 'EOF'
#!/bin/bash
# Backup script for Jitsi Meet

BACKUP_DIR="/opt/backups"
DATE=$(date +%Y%m%d_%H%M%S)

mkdir -p $BACKUP_DIR

# Backup configuration
tar -czf $BACKUP_DIR/jitsi-config-$DATE.tar.gz \
    /opt/jitsi-meet/prosody \
    /opt/jitsi-meet/jicofo \
    /opt/jitsi-meet/jvb \
    /opt/jitsi-meet/web \
    /opt/jitsi-meet/docker-compose.yml \
    /opt/jitsi-meet/jitsi.env

# Clean old backups (keep last 7 days)
find $BACKUP_DIR -name "jitsi-config-*.tar.gz" -mtime +7 -delete

echo "$(date): Backup completed - jitsi-config-$DATE.tar.gz" >> /var/log/jitsi/backup.log
EOF

chmod +x /opt/jitsi-meet/backup.sh

# Set up daily backups
echo "0 2 * * * /opt/jitsi-meet/backup.sh" | crontab -

# Final status
echo "🎉 Jitsi Meet deployment completed!"
echo "📍 External IP: $EXTERNAL_IP"
echo "🌐 Web interface: https://$EXTERNAL_IP"
echo "🔗 Custom domain: https://jitsi.riverlearn.co.ke (after DNS update)"
echo ""
echo "📋 Next steps:"
echo "1. Update DNS records to point to: $EXTERNAL_IP"
echo "2. Wait for DNS propagation (24-48 hours)"
echo "3. Test your setup: https://jitsi.riverlearn.co.ke"
echo ""
echo "📊 Monitor logs: docker-compose logs -f"
echo "🔍 Health check: /opt/jitsi-meet/health-check.sh"
echo "💾 Backup: /opt/jitsi-meet/backup.sh"

# Log completion
echo "$(date): Jitsi Meet deployment completed successfully" >> /var/log/jitsi/deployment.log