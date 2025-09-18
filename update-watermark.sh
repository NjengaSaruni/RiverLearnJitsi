#!/bin/bash
# Update Jitsi Meet watermark configuration on existing GCE instance

set -e

echo "🔄 Updating Jitsi Meet watermark configuration"
echo "=============================================="

# Configuration
PROJECT_ID="prefab-isotope-472219-p6"
ZONE="us-central1-a"
INSTANCE_NAME="jitsi-meet-server"

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
gcloud config set project $PROJECT_ID

print_status "Uploading watermark configuration files..."

# Create a temporary directory for our files
TEMP_DIR=$(mktemp -d)
echo "Using temporary directory: $TEMP_DIR"

# Copy our configuration files to the temp directory
cp web/watermark.svg "$TEMP_DIR/"
cp web/interface_config.js "$TEMP_DIR/"
cp web/config.js "$TEMP_DIR/"
cp web/lang/main.json "$TEMP_DIR/"
cp docker-compose.yml "$TEMP_DIR/"

# Upload files to the instance
print_status "Uploading files to GCE instance..."
gcloud compute ssh $INSTANCE_NAME --zone=$ZONE --command="mkdir -p ~/jitsi-config"
gcloud compute scp "$TEMP_DIR/watermark.svg" $INSTANCE_NAME:~/jitsi-config/ --zone=$ZONE
gcloud compute scp "$TEMP_DIR/interface_config.js" $INSTANCE_NAME:~/jitsi-config/ --zone=$ZONE
gcloud compute scp "$TEMP_DIR/config.js" $INSTANCE_NAME:~/jitsi-config/ --zone=$ZONE
gcloud compute scp "$TEMP_DIR/main.json" $INSTANCE_NAME:~/jitsi-config/ --zone=$ZONE
gcloud compute scp "$TEMP_DIR/docker-compose.yml" $INSTANCE_NAME:~/jitsi-config/ --zone=$ZONE

# Clean up temp directory
rm -rf "$TEMP_DIR"

print_status "Connecting to instance to apply changes..."

# SSH into the instance and apply the changes
gcloud compute ssh $INSTANCE_NAME --zone=$ZONE --command="
    echo '🔄 Applying watermark configuration changes...'
    
    # Stop the web container
    echo 'Stopping Jitsi web container...'
    cd ~/jitsi-meet && sudo docker compose stop web
    
    # Copy the new configuration files
    echo 'Copying new configuration files...'
    sudo cp ~/jitsi-config/watermark.svg ~/jitsi-meet/web/
    sudo cp ~/jitsi-config/interface_config.js ~/jitsi-meet/web/
    sudo cp ~/jitsi-config/config.js ~/jitsi-meet/web/
    sudo mkdir -p ~/jitsi-meet/web/lang/
    sudo cp ~/jitsi-config/main.json ~/jitsi-meet/web/lang/
    sudo cp ~/jitsi-config/docker-compose.yml ~/jitsi-meet/
    
    # Set proper permissions
    sudo chown -R 1000:1000 ~/jitsi-meet/web/
    
    # Start the web container with new configuration
    echo 'Starting Jitsi web container with new configuration...'
    cd ~/jitsi-meet && sudo docker compose up -d web
    
    # Wait a moment for the container to start
    sleep 10
    
    # Check if the container is running
    echo 'Checking container status...'
    sudo docker compose ps web
    
    echo '✅ Watermark configuration update completed!'
"

print_status "Watermark configuration update completed!"
echo ""
echo "🎉 Changes applied successfully!"
echo "================================"
echo ""
echo "The following changes have been applied:"
echo "• Blank watermark.svg file mounted to replace Jitsi watermark"
echo "• Custom interface_config.js to disable all watermarks"
echo "• Custom config.js with watermark hiding settings"
echo "• Custom main.json for RiverLearn branding"
echo "• Updated docker-compose.yml with new volume mounts"
echo ""
echo "The Jitsi web container has been restarted with the new configuration."
echo "The watermark should now be completely hidden!"
echo ""
echo "You can test the changes by visiting your Jitsi server."
