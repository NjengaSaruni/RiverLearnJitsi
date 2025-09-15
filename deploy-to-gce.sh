#!/bin/bash
# Deploy Jitsi Meet to Google Cloud Engine

set -e

echo "🚀 Deploying Jitsi Meet to Google Cloud Engine"
echo "=============================================="

# Configuration
PROJECT_ID="prefab-isotope-472219-p6"  # Your GCP project ID
REPO_URL="https://github.com/NjengaSaruni/RiverLearnJitsi.git"
ZONE="us-central1-a"          # Replace with your preferred zone
INSTANCE_NAME="jitsi-meet-server"
MACHINE_TYPE="e2-standard-2"  # 2 vCPUs, 8GB RAM
DISK_SIZE="20GB"
IMAGE_FAMILY="ubuntu-2204-lts"
IMAGE_PROJECT="ubuntu-os-cloud"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Check if gcloud is installed
if ! command -v gcloud &> /dev/null; then
    print_error "gcloud CLI is not installed. Please install it first:"
    echo "https://cloud.google.com/sdk/docs/install"
    exit 1
fi

# Check if user is authenticated
if ! gcloud auth list --filter=status:ACTIVE --format="value(account)" | grep -q .; then
    print_error "You are not authenticated with gcloud. Please run:"
    echo "gcloud auth login"
    exit 1
fi

# Set the project
echo "Setting project to: $PROJECT_ID"
gcloud config set project $PROJECT_ID

# Create firewall rules
print_status "Creating firewall rules..."

# Allow HTTP/HTTPS
gcloud compute firewall-rules create allow-jitsi-web \
    --allow tcp:80,tcp:443 \
    --source-ranges 0.0.0.0/0 \
    --target-tags jitsi-server \
    --description "Allow HTTP/HTTPS for Jitsi Meet web interface" \
    --quiet || print_warning "Firewall rule 'allow-jitsi-web' may already exist"

# Allow Jitsi Meet ports
gcloud compute firewall-rules create allow-jitsi-ports \
    --allow tcp:10000,udp:10000,tcp:4443,tcp:5222,tcp:5280,tcp:5347 \
    --source-ranges 0.0.0.0/0 \
    --target-tags jitsi-server \
    --description "Allow Jitsi Meet communication ports" \
    --quiet || print_warning "Firewall rule 'allow-jitsi-ports' may already exist"

# Allow SSH (restrict to your IP)
YOUR_IP=$(curl -s https://ipinfo.io/ip)
gcloud compute firewall-rules create allow-ssh-restricted \
    --allow tcp:22 \
    --source-ranges $YOUR_IP/32 \
    --target-tags jitsi-server \
    --description "Allow SSH from your IP only" \
    --quiet || print_warning "Firewall rule 'allow-ssh-restricted' may already exist"

# Create the instance
print_status "Creating GCE instance..."

gcloud compute instances create $INSTANCE_NAME \
    --zone=$ZONE \
    --machine-type=$MACHINE_TYPE \
    --image-family=$IMAGE_FAMILY \
    --image-project=$IMAGE_PROJECT \
    --boot-disk-size=$DISK_SIZE \
    --boot-disk-type=pd-ssd \
    --tags=jitsi-server \
    --metadata-from-file startup-script=gce-startup-script.sh \
    --metadata=enable-oslogin=TRUE \
    --scopes=https://www.googleapis.com/auth/cloud-platform

# Wait for instance to be ready
print_status "Waiting for instance to be ready..."
sleep 30

# Get external IP
EXTERNAL_IP=$(gcloud compute instances describe $INSTANCE_NAME \
    --zone=$ZONE \
    --format='get(networkInterfaces[0].accessConfigs[0].natIP)')

print_status "Instance created successfully!"
echo "📍 Instance Name: $INSTANCE_NAME"
echo "📍 Zone: $ZONE"
echo "📍 External IP: $EXTERNAL_IP"
echo "📍 Machine Type: $MACHINE_TYPE"

# Wait for startup script to complete
print_status "Waiting for Jitsi Meet to deploy (this may take 5-10 minutes)..."
echo "You can monitor the progress by SSH'ing into the instance:"
echo "gcloud compute ssh $INSTANCE_NAME --zone=$ZONE"

# Check if services are running
echo ""
print_status "Checking service status..."
sleep 60

# Try to check if the web interface is responding
if curl -f http://$EXTERNAL_IP/health > /dev/null 2>&1; then
    print_status "Jitsi Meet is running successfully!"
else
    print_warning "Jitsi Meet may still be starting up. Please wait a few more minutes."
fi

echo ""
echo "🎉 Deployment completed!"
echo "========================"
echo ""
echo "📍 Your Jitsi Meet server details:"
echo "   • External IP: $EXTERNAL_IP"
echo "   • Web interface: https://$EXTERNAL_IP"
echo "   • Custom domain: https://jitsi.riverlearn.co.ke (after DNS update)"
echo ""
echo "📋 Next steps:"
echo "1. Update your DNS records to point to: $EXTERNAL_IP"
echo "   • jitsi.riverlearn.co.ke → $EXTERNAL_IP"
echo "   • conference.jitsi.riverlearn.co.ke → $EXTERNAL_IP"
echo "   • focus.jitsi.riverlearn.co.ke → $EXTERNAL_IP"
echo "   • guest.jitsi.riverlearn.co.ke → $EXTERNAL_IP"
echo "   • jitsi-videobridge.jitsi.riverlearn.co.ke → $EXTERNAL_IP"
echo ""
echo "2. Wait for DNS propagation (24-48 hours)"
echo ""
echo "3. Test your setup:"
echo "   • https://jitsi.riverlearn.co.ke"
echo "   • https://$EXTERNAL_IP"
echo ""
echo "🔧 Management commands:"
echo "   • SSH into instance: gcloud compute ssh $INSTANCE_NAME --zone=$ZONE"
echo "   • View logs: docker-compose logs -f"
echo "   • Restart services: docker-compose restart"
echo "   • Stop services: docker-compose down"
echo "   • Start services: docker-compose up -d"
echo ""
echo "📊 Monitoring:"
echo "   • Health check: /opt/jitsi-meet/health-check.sh"
echo "   • Monitor logs: /opt/jitsi-meet/monitor.sh"
echo "   • Backup: /opt/jitsi-meet/backup.sh"
echo ""
echo "💰 Cost optimization:"
echo "   • Current instance: $MACHINE_TYPE (~$20/month)"
echo "   • Consider preemptible instances for 80% cost savings"
echo "   • Monitor usage with Cloud Monitoring"
echo ""
echo "🔒 Security:"
echo "   • SSH access restricted to your IP: $YOUR_IP"
echo "   • Firewall rules configured"
echo "   • SSL/TLS with Let's Encrypt"
echo ""
print_status "Deployment completed successfully! 🎉"
