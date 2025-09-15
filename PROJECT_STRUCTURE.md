# RiverLearn Jitsi Meet - Project Structure

## 📁 Project Files

```
RiverLearnJitsi/
├── .gitignore                 # Git ignore rules
├── CONTRIBUTING.md            # Contribution guidelines
├── LICENSE                    # MIT License
├── README.md                  # Main documentation
├── PROJECT_STRUCTURE.md       # This file
├── GCE_SETUP.md              # Google Cloud Engine setup guide
├── docker-compose.yml         # Docker Compose configuration
├── jitsi.env                 # Environment variables template
├── setup.sh                  # Manual setup script
├── deploy-to-gce.sh          # GCE deployment script
├── gce-startup-script.sh     # GCE instance startup script
├── prosody/                  # Prosody XMPP server config
├── jicofo/                   # Jicofo conference focus config
├── jvb/                      # Jitsi Videobridge config
├── web/                      # Web interface config
└── public/                   # Static files (legacy)
```

## 🎯 Key Files Explained

### Core Configuration
- **`docker-compose.yml`**: Main Docker Compose configuration with all Jitsi Meet services
- **`jitsi.env`**: Environment variables template (secrets will be generated)
- **`.gitignore`**: Comprehensive ignore rules for secrets, logs, and generated files

### Deployment Scripts
- **`deploy-to-gce.sh`**: One-click deployment to Google Cloud Engine
- **`gce-startup-script.sh`**: Automated setup script that runs on GCE instance startup
- **`setup.sh`**: Manual setup script for other hosting providers

### Documentation
- **`README.md`**: Main project documentation with quick start guide
- **`GCE_SETUP.md`**: Detailed Google Cloud Engine setup instructions
- **`CONTRIBUTING.md`**: Guidelines for contributors
- **`PROJECT_STRUCTURE.md`**: This file explaining the project structure

### Configuration Directories
- **`prosody/`**: XMPP server configuration (created during deployment)
- **`jicofo/`**: Conference focus component configuration
- **`jvb/`**: Videobridge configuration for media routing
- **`web/`**: Web interface configuration and SSL certificates

## 🚀 Deployment Options

### Option 1: Google Cloud Engine (Recommended)
```bash
./deploy-to-gce.sh
```
- Automated deployment
- Includes monitoring and backup
- Cost: ~$22/month

### Option 2: Manual Setup
```bash
./setup.sh
docker-compose up -d
```
- Works on any VPS
- Manual configuration required
- Flexible hosting options

## 🔧 Configuration Process

1. **Secrets Generation**: Random secrets are generated for JWT authentication
2. **IP Configuration**: Server IP is set in configuration files
3. **DNS Setup**: Domain records point to server IP
4. **SSL Certificates**: Let's Encrypt certificates are automatically generated
5. **Service Startup**: All Docker containers start with proper networking

## 🔒 Security Features

- **JWT Authentication**: Integrates with RiverLearn Course Organizer
- **SSL/TLS**: Automatic Let's Encrypt certificates
- **Firewall Rules**: GCE-specific firewall configuration
- **Secret Management**: Secure secret generation and storage
- **No Sensitive Data**: All secrets are generated, not stored in repository

## 📊 Monitoring & Maintenance

- **Health Checks**: Automated service health monitoring
- **Log Rotation**: Automatic log management
- **Backups**: Daily configuration backups
- **Updates**: Easy Docker image updates
- **Scaling**: Horizontal scaling support

## 🌐 Integration

- **Course Organizer**: JWT authentication integration
- **Custom Domain**: `jitsi.riverlearn.co.ke` configuration
- **Mobile Support**: Works on all devices
- **API Integration**: REST API for meeting management

## 💡 Customization

- **Branding**: Custom application name and styling
- **Features**: Configurable feature set
- **Recording**: Meeting recording capabilities
- **Streaming**: Live streaming support
- **Breakout Rooms**: Virtual breakout room functionality

## 🔄 Updates & Maintenance

- **Docker Updates**: `docker-compose pull && docker-compose up -d`
- **Configuration Changes**: Edit `jitsi.env` and restart services
- **Backup Restoration**: Restore from backup files
- **Monitoring**: Check logs and health status

## 📞 Support

- **Documentation**: Comprehensive setup and troubleshooting guides
- **Issues**: GitHub issues for bug reports
- **Contributions**: Pull requests welcome
- **Community**: Discussion and support through GitHub
