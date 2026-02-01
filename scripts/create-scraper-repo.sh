#!/bin/bash
set -e

# Create a new scraper repository from template
# Usage: ./create-scraper-repo.sh <country> <portal>

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <country> <portal>"
  echo "Example: $0 australia domain"
  exit 1
fi

COUNTRY=$1
PORTAL=$2
REPO_NAME="landomo-${COUNTRY}-${PORTAL}"
ORG_NAME="landomo-com"

echo "Creating scraper repository: ${REPO_NAME}"

# Check if repo already exists
if gh repo view "${ORG_NAME}/${REPO_NAME}" &>/dev/null; then
  echo "Error: Repository ${ORG_NAME}/${REPO_NAME} already exists"
  exit 1
fi

# Create temporary directory
TEMP_DIR=$(mktemp -d)
cd "${TEMP_DIR}"

# Copy template
cp -r "$(dirname "$0")/../templates/scraper-template" "${REPO_NAME}"
cd "${REPO_NAME}"

# Replace placeholders
find . -type f -not -path '*/node_modules/*' -not -path '*/.git/*' | while read -r file; do
  if [ -f "$file" ]; then
    sed -i "s/COUNTRY/${COUNTRY}/g" "$file"
    sed -i "s/PORTAL/${PORTAL}/g" "$file"
    sed -i "s/COUNTRY_NAME/${COUNTRY^}/g" "$file"
    sed -i "s/PORTAL_NAME/${PORTAL^}/g" "$file"
  fi
done

# Rename package.json
sed -i "s/@landomo\/scraper-COUNTRY-PORTAL/@landomo\/scraper-${COUNTRY}-${PORTAL}/g" package.json

# Initialize git
git init
git add .
git commit -m "Initial commit from template"

# Create GitHub repository
gh repo create "${ORG_NAME}/${REPO_NAME}" \
  --public \
  --description "Landomo scraper for ${PORTAL} in ${COUNTRY}" \
  --source=. \
  --push

echo "✓ Repository created: https://github.com/${ORG_NAME}/${REPO_NAME}"

# Update registry
echo "Updating registry..."
cd "$(dirname "$0")/.."

# TODO: Update scrapers/scrapers.json with new scraper entry
# This should be done via a Node.js script for proper JSON handling

echo "✓ Scraper repository created successfully!"
echo ""
echo "Next steps:"
echo "1. Clone the repository: gh repo clone ${ORG_NAME}/${REPO_NAME}"
echo "2. Implement scraper logic in src/scraper.ts"
echo "3. Implement transformer in src/transformer.ts"
echo "4. Test locally: npm start"
echo "5. Push changes and deploy"

# Cleanup
cd ..
rm -rf "${TEMP_DIR}"
