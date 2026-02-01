# Contributing to Landomo

Thank you for contributing to the Landomo scraper network!

## Adding a New Scraper

### Option 1: Using the Creation Script (Recommended)

```bash
# Clone the registry
git clone https://github.com/landomo-com/landomo-registry.git
cd landomo-registry

# Create new scraper
./scripts/create-scraper-repo.sh <country> <portal>

# Example
./scripts/create-scraper-repo.sh italy immobiliare
```

This automatically:
1. Creates a new repository from the template
2. Sets up CI/CD workflows
3. Updates the central registry
4. Provides next steps

### Option 2: Manual Creation

1. **Use the template**:
   ```bash
   gh repo create landomo-com/landomo-<country>-<portal> \
     --template landomo-com/scraper-template \
     --public
   ```

2. **Clone and customize**:
   ```bash
   gh repo clone landomo-com/landomo-<country>-<portal>
   cd landomo-<country>-<portal>

   # Update placeholders in:
   # - package.json
   # - README.md
   # - src/config.ts
   ```

3. **Implement scraper**:
   - `src/scraper.ts` - Main scraping logic
   - `src/transformer.ts` - Portal → StandardProperty conversion
   - `src/types.ts` - TypeScript types

4. **Test locally**:
   ```bash
   npm install
   cp .env.example .env
   # Add LANDOMO_API_KEY to .env
   npm start
   ```

5. **Update registry** manually or run:
   ```bash
   cd landomo-registry
   ./scripts/sync-registry.sh
   ```

## Scraper Development Guidelines

### File Structure

Every scraper must have:
- `src/scraper.ts` - Main entry point
- `src/transformer.ts` - Data transformation
- `src/config.ts` - Configuration
- `src/types.ts` - Type definitions
- `README.md` - Documentation
- `.env.example` - Example environment variables

### Code Standards

1. **TypeScript**: All code must be TypeScript
2. **Formatting**: Use Prettier (configured in template)
3. **Linting**: Use ESLint (configured in template)
4. **Testing**: Add tests for transformers
5. **Error Handling**: Handle errors gracefully, don't crash

### Data Transformation

The most important file is `transformer.ts`. It must:

1. Convert portal data to `StandardProperty` format
2. Map property types correctly:
   - `apartment`, `house`, `villa`, `townhouse`, `land`, `commercial`, `other`
3. Include country-specific fields when relevant
4. Preserve raw data for auditing

Example:
```typescript
export function transformToStandard(portalData: any): StandardProperty {
  return {
    title: portalData.title,
    price: parsePrice(portalData.price),
    currency: getCurrency('australia'),
    property_type: normalizePropertyType(portalData.type),
    transaction_type: portalData.saleType === 'sale' ? 'sale' : 'rent',

    location: {
      address: portalData.address,
      city: portalData.city,
      country: 'australia',
    },

    details: {
      bedrooms: parseInt(portalData.beds) || 0,
      bathrooms: parseInt(portalData.baths) || 0,
      sqm: parseFloat(portalData.area) || 0,
    },

    features: portalData.features || [],
    images: portalData.photos || [],
    description: portalData.description,
    url: portalData.url,
    status: 'active',
  };
}
```

### Rate Limiting

Always respect rate limits:
```typescript
// Add delays between requests
await sleep(config.requestDelayMs);

// Use concurrent request limits
const queue = new PQueue({ concurrency: 5 });
```

### Error Handling

```typescript
try {
  const data = await fetchListing(id);
  await sendToCoreService(transform(data));
} catch (error) {
  console.error(`Failed to process listing ${id}:`, error);
  // Don't crash - continue with next listing
}
```

## Testing

### Local Testing

```bash
# Test single listing
export TEST_URL="https://portal.example.com/listing/123"
npm start

# Test with debug mode
export DEBUG=true
npm start
```

### Validation Checklist

Before submitting:
- [ ] Scraper runs without errors
- [ ] Data is correctly transformed to StandardProperty
- [ ] All required fields are populated
- [ ] Images are included
- [ ] Country-specific fields are added (if applicable)
- [ ] Rate limiting is implemented
- [ ] Error handling is robust
- [ ] README is updated with portal-specific notes
- [ ] Tests pass: `npm test`
- [ ] Types check: `npm run type-check`
- [ ] Linting passes: `npm run lint`

## Pull Request Process

1. **Create feature branch**:
   ```bash
   git checkout -b feature/improve-transformer
   ```

2. **Make changes and test**

3. **Commit with conventional commits**:
   ```bash
   git commit -m "feat: add support for commercial properties"
   git commit -m "fix: correct price parsing for rent listings"
   ```

4. **Push and create PR**:
   ```bash
   git push -u origin feature/improve-transformer
   gh pr create
   ```

5. **CI/CD checks must pass**:
   - Tests
   - Type checking
   - Linting
   - Build

## Commit Message Convention

```
<type>(<scope>): <description>

Types:
- feat: New feature
- fix: Bug fix
- refactor: Code refactoring
- docs: Documentation only
- test: Test additions
- chore: Maintenance

Examples:
- feat(transformer): add support for villa property type
- fix(scraper): handle pagination edge case
- docs(readme): update portal-specific notes
```

## Updating the Registry

After adding or updating scrapers, update the registry:

```bash
cd landomo-registry
./scripts/sync-registry.sh
git add scrapers/scrapers.json scrapers/SCRAPERS.md
git commit -m "chore: sync registry with org repos"
git push
```

## Getting Help

- **Questions**: [GitHub Discussions](https://github.com/landomo-com/landomo-registry/discussions)
- **Bugs**: [GitHub Issues](https://github.com/landomo-com/landomo-registry/issues)
- **Templates**: [Scraper Template](../templates/scraper-template/)

## Code Review

All contributions are reviewed for:
1. Code quality and standards
2. Data transformation accuracy
3. Error handling
4. Performance considerations
5. Documentation completeness

Reviews typically take 1-2 business days.

## License

All contributions must be compatible with the project's UNLICENSED status (internal use only).
