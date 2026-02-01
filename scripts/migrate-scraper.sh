#!/bin/bash
set -e

# Migrate an existing scraper from old/ directory to new repository
# Usage: ./migrate-scraper.sh <country> <portal> <path-to-old-scraper>

if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <country> <portal> <path-to-old-scraper>"
  echo "Example: $0 australia domain ../old/australia/domain"
  exit 1
fi

COUNTRY=$1
PORTAL=$2
OLD_PATH=$3
REPO_NAME="landomo-${COUNTRY}-${PORTAL}"
ORG_NAME="landomo-com"

echo "Migrating scraper: ${COUNTRY}/${PORTAL}"
echo "From: ${OLD_PATH}"
echo "To: ${ORG_NAME}/${REPO_NAME}"

# Check if old path exists
if [ ! -d "${OLD_PATH}" ]; then
  echo "Error: Source path ${OLD_PATH} does not exist"
  exit 1
fi

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

# Replace placeholders in template
find . -type f -not -path '*/node_modules/*' -not -path '*/.git/*' | while read -r file; do
  if [ -f "$file" ]; then
    sed -i "s/COUNTRY/${COUNTRY}/g" "$file"
    sed -i "s/PORTAL/${PORTAL}/g" "$file"
    sed -i "s/COUNTRY_NAME/${COUNTRY^}/g" "$file"
    sed -i "s/PORTAL_NAME/${PORTAL^}/g" "$file"
  fi
done

# Copy existing scraper code (overwrite template src/)
if [ -d "${OLD_PATH}/src" ]; then
  echo "Copying existing source code..."
  rm -rf src/
  cp -r "${OLD_PATH}/src" src/
fi

# Copy other files if they exist
[ -f "${OLD_PATH}/README.md" ] && cp "${OLD_PATH}/README.md" README.md
[ -f "${OLD_PATH}/.env.example" ] && cp "${OLD_PATH}/.env.example" .env.example
[ -f "${OLD_PATH}/package.json" ] && cp "${OLD_PATH}/package.json" package.json

# Update package.json name
sed -i "s/\"name\": \".*\"/\"name\": \"@landomo\/scraper-${COUNTRY}-${PORTAL}\"/g" package.json

# Initialize git
git init
git add .
git commit -m "Migrate scraper from legacy structure

Migrated from: ${OLD_PATH}
Initial migration to one-repository-per-scraper architecture."

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

echo "✓ Scraper migrated successfully!"
echo ""
echo "Repository: https://github.com/${ORG_NAME}/${REPO_NAME}"
echo ""
echo "Next steps:"
echo "1. Review the migrated code"
echo "2. Update to use @landomo/core utilities"
echo "3. Test locally: npm start"
echo "4. Deploy to production"

# Cleanup
cd ..
rm -rf "${TEMP_DIR}"
