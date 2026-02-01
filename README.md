# Landomo Registry

Central coordination hub for the Landomo real estate scraper network.

## Overview

Landomo aggregates real estate listings from 150+ portals across 80+ countries. This repository serves as the central registry and coordination hub for 1000+ scraper repositories in the `landomo-com` GitHub organization.

**Current Status**:
- **Scrapers**: 0 active
- **Countries**: 0 covered
- **Services**: 2 planned

## Architecture

### One Repository Per Scraper

Each scraper lives in its own repository:

```
landomo-com/
├── landomo-core                    # NPM package - shared utilities
├── landomo-ingest                  # REST API - data ingestion
├── landomo-registry                # This repo - coordination
│
└── Scrapers (one per portal)
    ├── landomo-australia-domain    # domain.com.au
    ├── landomo-uk-rightmove        # rightmove.co.uk
    ├── landomo-italy-immobiliare   # immobiliare.it
    └── ... (1000+ more)
```

### Benefits

✅ Independent deployment per scraper
✅ Clear ownership and maintenance
✅ Fast, isolated CI/CD
✅ Scales to 1000+ scrapers
✅ Future-proof for additional services

## Quick Start

### Create a New Scraper

```bash
# Clone this repository
git clone https://github.com/landomo-com/landomo-registry.git
cd landomo-registry

# Create scraper repository
./scripts/create-scraper-repo.sh <country> <portal>

# Example: Create scraper for domain.com.au in Australia
./scripts/create-scraper-repo.sh australia domain
```

This automatically:
1. Creates `landomo-australia-domain` repository from template
2. Sets up CI/CD workflows
3. Updates the registry
4. Provides next steps for implementation

### Migrate Existing Scraper

```bash
# Migrate from old directory structure
./scripts/migrate-scraper.sh australia domain ../old/australia/domain
```

## Repository Structure

```
landomo-registry/
├── scrapers/
│   ├── scrapers.json           # Machine-readable registry
│   ├── SCRAPERS.md             # Human-readable list
│   └── status/                 # Status tracking
│
├── templates/
│   ├── scraper-template/       # Template for new scrapers
│   │   ├── src/
│   │   ├── package.json
│   │   ├── README.md
│   │   └── .github/workflows/
│   └── service-template/       # Template for services
│
├── scripts/
│   ├── create-scraper-repo.sh  # Create new scraper
│   ├── migrate-scraper.sh      # Migrate existing scraper
│   └── sync-registry.sh        # Sync with GitHub org
│
└── docs/
    ├── README.md               # Documentation hub
    ├── CONTRIBUTING.md         # Contribution guide
    ├── ARCHITECTURE.md         # System architecture
    └── DEPLOYMENT.md           # Deployment guide
```

## Naming Conventions

### Services
Format: `landomo-[service-name]`

Examples:
- `landomo-core` - NPM package
- `landomo-ingest` - Ingestion API
- `landomo-api` - Frontend API (future)
- `landomo-notifications` - Notification service (future)

### Scrapers
Format: `landomo-[country]-[portal]`

Examples:
- `landomo-australia-domain` - domain.com.au
- `landomo-uk-rightmove` - rightmove.co.uk
- `landomo-italy-immobiliare` - immobiliare.it

Rules:
- Country: lowercase, no spaces
- Portal: lowercase, no special characters

## Registry Files

### scrapers.json

Machine-readable registry of all scrapers and services:

```json
{
  "version": "1.0.0",
  "lastUpdated": "2026-02-01",
  "scrapers": [
    {
      "id": "australia-domain",
      "country": "australia",
      "portal": "domain",
      "repo": "landomo-com/landomo-australia-domain",
      "status": "active",
      "priority": "high"
    }
  ],
  "services": [
    {
      "id": "core",
      "name": "Landomo Core",
      "repo": "landomo-com/landomo-core",
      "type": "npm-package"
    }
  ]
}
```

### SCRAPERS.md

Human-readable list of all scrapers organized by country. See [scrapers/SCRAPERS.md](scrapers/SCRAPERS.md).

## Tracking

All scrapers are tracked in the [Landomo Scrapers GitHub Project](https://github.com/orgs/landomo-com/projects).

**Views**:
- By Status: Todo, In Progress, Testing, Production
- By Country: Grouped by country
- By Priority: High, Medium, Low
- Timeline: Gantt chart of migrations

## Development

### Prerequisites

- Node.js 20+
- GitHub CLI (`gh`) authenticated
- Access to `landomo-com` organization

### Scripts

All automation scripts are in `scripts/`:

```bash
# Create new scraper from template
./scripts/create-scraper-repo.sh <country> <portal>

# Migrate existing scraper
./scripts/migrate-scraper.sh <country> <portal> <old-path>

# Sync registry with GitHub organization
./scripts/sync-registry.sh
```

## Contributing

See [docs/CONTRIBUTING.md](docs/CONTRIBUTING.md) for detailed contribution guidelines.

### Quick Checklist

- [ ] Use the scraper template
- [ ] Follow naming conventions
- [ ] Implement transformer correctly
- [ ] Add tests
- [ ] Update documentation
- [ ] Test locally before deploying

## Documentation

- [Main Documentation](docs/README.md) - Overview and guides
- [Contributing Guide](docs/CONTRIBUTING.md) - How to contribute
- [Architecture](docs/ARCHITECTURE.md) - System architecture (TODO)
- [Deployment](docs/DEPLOYMENT.md) - Deployment guide (TODO)

## Core Services

### Landomo Core (`@landomo/core`)
NPM package with shared utilities and types for all scrapers.

**Repository**: [landomo-core](https://github.com/landomo-com/landomo-core)

### Landomo Ingest
REST API for centralized data ingestion.

**Repository**: [landomo-ingest](https://github.com/landomo-com/landomo-ingest)
**Endpoint**: `https://core.landomo.com/api/v1/properties/ingest`

## Future Services

Services will be added when development begins:
- `landomo-api` - Frontend REST API
- `landomo-notifications` - Email/SMS notifications
- `landomo-frontend` - Web application

## Support

- **Issues**: [GitHub Issues](https://github.com/landomo-com/landomo-registry/issues)
- **Discussions**: [GitHub Discussions](https://github.com/landomo-com/landomo-registry/discussions)
- **Project Board**: [Landomo Scrapers](https://github.com/orgs/landomo-com/projects)

## License

UNLICENSED - Internal use only

---

**Status**: Foundation setup in progress
**Next Steps**: Migrate first scraper (australia-domain)
