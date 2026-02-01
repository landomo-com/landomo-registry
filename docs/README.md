# Landomo Registry

Central coordination hub for the Landomo scraper network.

## Overview

The Landomo Registry tracks all scrapers and services across 1000+ repositories in the `landomo-com` GitHub organization. It provides:

- **Central registry** (`scrapers/scrapers.json`) - Machine-readable list of all scrapers
- **Templates** - Starter templates for new scrapers and services
- **Scripts** - Automation tools for creating and migrating scrapers
- **Documentation** - Architecture, guides, and best practices

## Architecture

```
landomo-com/
├── Core Infrastructure
│   ├── landomo-core          # NPM package - shared utilities
│   ├── landomo-ingest        # REST API - data ingestion
│   └── landomo-registry      # This repo - coordination hub
│
├── Future Services (when needed)
│   ├── landomo-api           # Frontend API
│   ├── landomo-notifications # Notification service
│   └── landomo-frontend      # Web application
│
└── Scrapers (1000+ repos)
    ├── landomo-australia-domain
    ├── landomo-uk-rightmove
    └── ... (1000+ more)
```

## Repository Naming

**Services**: `landomo-[service-name]`
- Examples: `landomo-core`, `landomo-api`, `landomo-notifications`

**Scrapers**: `landomo-[country]-[portal]`
- Examples: `landomo-australia-domain`, `landomo-uk-rightmove`
- Country: lowercase, no spaces
- Portal: lowercase, no special chars

## Quick Start

### Creating a New Scraper

```bash
# From this repository
./scripts/create-scraper-repo.sh australia domain

# This creates:
# 1. landomo-australia-domain repository
# 2. Updates scrapers.json
# 3. Provides next steps
```

### Migrating an Existing Scraper

```bash
# Migrate from old/ directory structure
./scripts/migrate-scraper.sh australia domain ../old/australia/domain

# This:
# 1. Creates new repository from template
# 2. Copies existing code
# 3. Updates registry
```

### Syncing the Registry

```bash
# Update scrapers.json from GitHub organization
./scripts/sync-registry.sh
```

## Files

### Registry Files

- `scrapers/scrapers.json` - Machine-readable scraper registry
- `scrapers/SCRAPERS.md` - Human-readable scraper list
- `scrapers/status/` - Status tracking per scraper

### Templates

- `templates/scraper-template/` - Starter template for new scrapers
- `templates/service-template/` - Template for new services

### Scripts

- `scripts/create-scraper-repo.sh` - Create new scraper repository
- `scripts/migrate-scraper.sh` - Migrate existing scraper
- `scripts/sync-registry.sh` - Sync registry with GitHub

### Documentation

- `docs/README.md` - This file
- `docs/CONTRIBUTING.md` - How to contribute
- `docs/ARCHITECTURE.md` - System architecture
- `docs/DEPLOYMENT.md` - Deployment guide

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed instructions on:
- Adding new scrapers
- Updating existing scrapers
- Contributing to core infrastructure
- Code standards and best practices

## Tracking

All scrapers are tracked in the [Landomo Scrapers GitHub Project](https://github.com/orgs/landomo-com/projects).

## Support

- **Issues**: [GitHub Issues](https://github.com/landomo-com/landomo-registry/issues)
- **Discussions**: [GitHub Discussions](https://github.com/landomo-com/landomo-registry/discussions)

## License

UNLICENSED - Internal use only
