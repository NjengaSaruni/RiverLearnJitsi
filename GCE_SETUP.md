# Google Cloud Engine (GCE) Setup for Jitsi Meet

## 🎯 Why GCE is Perfect for Jitsi Meet

- ✅ **Full Control**: All ports and networking available
- ✅ **Persistent Storage**: SSD persistent disks for certificates and data
- ✅ **Global Network**: Google's global network for low latency
- ✅ **Auto-scaling**: Can scale resources as needed
- ✅ **Load Balancing**: Built-in load balancer support
- ✅ **Firewall Rules**: Granular security controls
- ✅ **Monitoring**: Cloud Monitoring and Logging integration

## 🚀 Quick Setup Guide

### Step 1: Create GCE Instance

```bash
# Create a new VM instance
gcloud compute instances create jitsi-meet-server \
    --zone=us-central1-a \
    --machine-type=e2-standard-2 \
    --image-family=ubuntu-2204-lts \
    --image-project=ubuntu-os-cloud \
    --boot-disk-size=20GB \
    --boot-disk-type=pd-ssd \
    --tags=jitsi-server \
    --metadata=startup-script='#!/bin/bash
apt-get update
apt-get install -y docker.io docker-compose-plugin
systemctl start docker
systemctl enable docker
usermod -aG docker $USER'
```

### Step 2: Configure Firewall Rules

```bash
# Allow HTTP/HTTPS
gcloud compute firewall-rules create allow-jitsi-web \
    --allow tcp:80,tcp:443 \
    --source-ranges 0.0.0.0/0 \
    --target-tags jitsi-server

# Allow Jitsi Meet ports
gcloud compute firewall-rules create allow-jitsi-ports \
    --allow tcp:10000,udp:10000,tcp:4443,tcp:5222,tcp:5280,tcp:5347 \
    --source-ranges 0.0.0.0/0 \
    --target-tags jitsi-server
```

### Step 3: Get External IP

```bash
# Get the external IP
gcloud compute instances describe jitsi-meet-server \
    --zone=us-central1-a \
    --format='get(networkInterfaces[0].accessConfigs[0].natIP)'
```

### Step 4: Deploy Jitsi Meet

```bash
# SSH into the instance
gcloud compute ssh jitsi-meet-server --zone=us-central1-a

# Clone your repository
git clone https://github.com/NjengaSaruni/RiverLearnJitsi.git
cd RiverLearnJitsi

# Run setup with your GCE IP
./setup.sh
# Enter your GCE external IP when prompted

# Start services
docker-compose up -d
```

## 🔧 GCE-Specific Configuration

### Update docker-compose.yml for GCE

```yaml
# Add to your docker-compose.yml
version: '3.8'

services:
  # ... existing services ...
  
  # Add GCE-specific environment variables
  web:
    # ... existing config ...
    environment:
      # ... existing env vars ...
      - GOOGLE_CLOUD_PROJECT=your-project-id
      - GCE_ZONE=us-central1-a
      - GCE_INSTANCE_NAME=jitsi-meet-server
```

### GCE Startup Script

Create a startup script for automatic deployment:

```bash
#!/bin/bash
# startup-script.sh

# Update system
apt-get update
apt-get upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
apt-get install -y docker-compose-plugin

# Install Git
apt-get install -y git

# Clone repository
git clone https://github.com/your-username/jitsi-standalone.git /opt/jitsi-meet
cd /opt/jitsi-meet

# Get external IP
EXTERNAL_IP=$(curl -s http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip -H "Metadata-Flavor: Google")

# Update configuration
sed -i "s/your-server-ip/$EXTERNAL_IP/g" docker-compose.yml
sed -i "s/your-server-ip/$EXTERNAL_IP/g" jitsi.env

# Start services
docker-compose up -d

# Enable auto-start
systemctl enable docker
```

## 💰 Cost Optimization

### Instance Types

| Instance Type | vCPUs | RAM | Cost/month | Use Case |
|---------------|-------|-----|------------|----------|
| e2-micro | 1 | 1GB | ~$5 | Testing only |
| e2-small | 2 | 2GB | ~$10 | Light usage |
| e2-standard-2 | 2 | 8GB | ~$20 | Recommended |
| e2-standard-4 | 4 | 16GB | ~$40 | Heavy usage |

### Cost-Saving Tips

1. **Use Preemptible Instances**: 80% cost reduction for non-critical workloads
2. **Commit to 1-3 years**: Get sustained use discounts
3. **Use e2 instances**: Best price/performance ratio
4. **Monitor usage**: Use Cloud Monitoring to optimize resources

### Preemptible Instance Setup

```bash
# Create preemptible instance (80% cheaper)
gcloud compute instances create jitsi-meet-server \
    --zone=us-central1-a \
    --machine-type=e2-standard-2 \
    --preemptible \
    --image-family=ubuntu-2204-lts \
    --image-project=ubuntu-os-cloud \
    --boot-disk-size=20GB \
    --boot-disk-type=pd-ssd \
    --tags=jitsi-server
```

## 🔒 Security Configuration

### IAM and Service Accounts

```bash
# Create service account for Jitsi
gcloud iam service-accounts create jitsi-service-account \
    --display-name="Jitsi Meet Service Account"

# Grant necessary permissions
gcloud projects add-iam-policy-binding your-project-id \
    --member="serviceAccount:jitsi-service-account@your-project-id.iam.gserviceaccount.com" \
    --role="roles/compute.instanceAdmin"
```

### Firewall Rules

```bash
# Restrict SSH access
gcloud compute firewall-rules create allow-ssh-restricted \
    --allow tcp:22 \
    --source-ranges YOUR_IP/32 \
    --target-tags jitsi-server

# Allow only necessary ports
gcloud compute firewall-rules create allow-jitsi-minimal \
    --allow tcp:80,tcp:443,udp:10000 \
    --source-ranges 0.0.0.0/0 \
    --target-tags jitsi-server
```

## 📊 Monitoring and Logging

### Cloud Monitoring Setup

```bash
# Install monitoring agent
curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh
sudo bash add-google-cloud-ops-agent-repo.sh --also-install

# Configure logging
sudo tee /etc/google-cloud-ops-agent/config.yaml << EOF
logging:
  receivers:
    jitsi_logs:
      type: files
      include_paths:
        - /var/log/jitsi/*.log
  processors:
    jitsi_processor:
      type: parse_json
  service:
    pipelines:
      default_pipeline:
        receivers: [jitsi_logs]
        processors: [jitsi_processor]
EOF

sudo systemctl restart google-cloud-ops-agent
```

### Custom Metrics

```bash
# Create custom dashboard
gcloud monitoring dashboards create --config-from-file=dashboard.json
```

## 🔄 Backup and Recovery

### Automated Backups

```bash
# Create backup script
cat > /opt/backup-jitsi.sh << 'EOF'
#!/bin/bash
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/opt/backups"
mkdir -p $BACKUP_DIR

# Backup configuration
tar -czf $BACKUP_DIR/jitsi-config-$DATE.tar.gz \
    /opt/jitsi-meet/prosody \
    /opt/jitsi-meet/jicofo \
    /opt/jitsi-meet/jvb \
    /opt/jitsi-meet/web \
    /opt/jitsi-meet/docker-compose.yml \
    /opt/jitsi-meet/jitsi.env

# Upload to Cloud Storage
gsutil cp $BACKUP_DIR/jitsi-config-$DATE.tar.gz gs://your-backup-bucket/

# Clean old backups (keep last 7 days)
find $BACKUP_DIR -name "jitsi-config-*.tar.gz" -mtime +7 -delete
EOF

chmod +x /opt/backup-jitsi.sh

# Schedule daily backups
echo "0 2 * * * /opt/backup-jitsi.sh" | crontab -
```

## 🚀 Deployment Commands

### Complete GCE Deployment

```bash
# 1. Create instance
gcloud compute instances create jitsi-meet-server \
    --zone=us-central1-a \
    --machine-type=e2-standard-2 \
    --image-family=ubuntu-2204-lts \
    --image-project=ubuntu-os-cloud \
    --boot-disk-size=20GB \
    --boot-disk-type=pd-ssd \
    --tags=jitsi-server \
    --metadata-from-file startup-script=startup-script.sh

# 2. Configure firewall
gcloud compute firewall-rules create allow-jitsi-ports \
    --allow tcp:80,tcp:443,udp:10000,tcp:10000,tcp:4443 \
    --source-ranges 0.0.0.0/0 \
    --target-tags jitsi-server

# 3. Get external IP
EXTERNAL_IP=$(gcloud compute instances describe jitsi-meet-server \
    --zone=us-central1-a \
    --format='get(networkInterfaces[0].accessConfigs[0].natIP)')

echo "Your Jitsi Meet server will be available at: https://$EXTERNAL_IP"
echo "Update your DNS to point jitsi.riverlearn.co.ke to: $EXTERNAL_IP"
```

## 🔗 Integration with Course Organizer

Your Course Organizer on Railway will work perfectly with GCE-hosted Jitsi Meet:

1. **JWT Authentication**: Already configured
2. **CORS Settings**: Already updated
3. **API Communication**: Works across different platforms
4. **SSL/TLS**: Both services use HTTPS

## 📈 Scaling Options

### Horizontal Scaling

```bash
# Create instance template
gcloud compute instance-templates create jitsi-template \
    --machine-type=e2-standard-2 \
    --image-family=ubuntu-2204-lts \
    --image-project=ubuntu-os-cloud \
    --boot-disk-size=20GB \
    --boot-disk-type=pd-ssd \
    --tags=jitsi-server

# Create managed instance group
gcloud compute instance-groups managed create jitsi-group \
    --template=jitsi-template \
    --size=2 \
    --zone=us-central1-a
```

### Load Balancer

```bash
# Create load balancer
gcloud compute backend-services create jitsi-backend \
    --protocol=HTTP \
    --health-checks=jitsi-health-check

# Add instances to backend
gcloud compute backend-services add-backend jitsi-backend \
    --instance-group=jitsi-group \
    --instance-group-zone=us-central1-a
```

## 🎯 Next Steps

1. **Create GCE instance** using the commands above
2. **Configure DNS** to point to your GCE external IP
3. **Deploy Jitsi Meet** using the provided setup
4. **Test integration** with your Railway-hosted Course Organizer
5. **Set up monitoring** and backups

## 💡 Pro Tips

- Use **us-central1** region for best performance
- Enable **Cloud CDN** for static assets
- Use **Cloud SQL** if you need persistent database
- Set up **Cloud Armor** for DDoS protection
- Use **Cloud NAT** for outbound traffic
