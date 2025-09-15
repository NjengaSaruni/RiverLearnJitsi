# Contributing to RiverLearn Jitsi Meet

Thank you for your interest in contributing to RiverLearn Jitsi Meet! This document provides guidelines for contributing to this project.

## 🚀 Getting Started

1. Fork the repository
2. Clone your fork: `git clone https://github.com/your-username/RiverLearnJitsi.git`
3. Create a feature branch: `git checkout -b feature/your-feature-name`
4. Make your changes
5. Test your changes thoroughly
6. Commit your changes: `git commit -m "Add your feature"`
7. Push to your fork: `git push origin feature/your-feature-name`
8. Create a Pull Request

## 📋 Development Guidelines

### Code Style
- Use clear, descriptive commit messages
- Follow existing code formatting
- Add comments for complex logic
- Update documentation for new features

### Testing
- Test all changes in a development environment
- Verify Docker containers start correctly
- Test JWT authentication integration
- Check SSL certificate generation

### Documentation
- Update README.md for new features
- Add inline comments for complex configurations
- Update deployment scripts if needed

## 🐛 Reporting Issues

When reporting issues, please include:

1. **Environment details**:
   - Operating system
   - Docker version
   - GCP project details (if applicable)

2. **Steps to reproduce**:
   - Clear, numbered steps
   - Expected vs actual behavior

3. **Logs and error messages**:
   - Docker container logs
   - System logs
   - Error messages

4. **Configuration**:
   - Relevant configuration files (remove sensitive data)
   - DNS settings
   - Firewall rules

## 🔧 Development Setup

### Local Development

```bash
# Clone the repository
git clone https://github.com/NjengaSaruni/RiverLearnJitsi.git
cd RiverLearnJitsi

# Set up development environment
./setup.sh

# Start services
docker-compose up -d

# View logs
docker-compose logs -f
```

### Testing Changes

```bash
# Test configuration
docker-compose config

# Test service health
./health-check.sh

# Test SSL certificates
curl -I https://localhost
```

## 📝 Pull Request Process

1. **Fork and clone** the repository
2. **Create a feature branch** from `main`
3. **Make your changes** following the guidelines above
4. **Test thoroughly** in a development environment
5. **Update documentation** as needed
6. **Submit a pull request** with a clear description

### Pull Request Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Configuration change

## Testing
- [ ] Tested locally
- [ ] Tested on GCE
- [ ] Verified SSL certificates
- [ ] Tested JWT authentication

## Checklist
- [ ] Code follows project style
- [ ] Self-review completed
- [ ] Documentation updated
- [ ] No sensitive data in commits
```

## 🔒 Security

- **Never commit secrets** or sensitive data
- **Use environment variables** for configuration
- **Test security features** thoroughly
- **Report security issues** privately

## 📞 Support

For questions or support:
- Create an issue for bugs or feature requests
- Use discussions for general questions
- Contact the maintainers for security issues

## 🎯 Roadmap

Current priorities:
- [ ] Improve monitoring and alerting
- [ ] Add load balancing support
- [ ] Enhance backup and recovery
- [ ] Optimize performance
- [ ] Add more deployment options

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.
