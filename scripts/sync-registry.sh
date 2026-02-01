#!/bin/bash
set -e

# Sync scrapers.json with GitHub organization repositories
# This script queries all repos matching landomo-[country]-[portal] and updates the registry

ORG_NAME="landomo-com"
REGISTRY_FILE="$(dirname "$0")/../scrapers/scrapers.json"

echo "Syncing registry with GitHub organization: ${ORG_NAME}"

# Get all repositories in the organization
REPOS=$(gh repo list "${ORG_NAME}" --limit 1000 --json name,description,updatedAt,isArchived)

# TODO: Parse REPOS and update scrapers.json
# This should be done with a proper JSON parser (jq or Node.js script)

echo "Found $(echo "${REPOS}" | jq '. | length') repositories"

# Filter scraper repos (landomo-[country]-[portal] pattern)
SCRAPER_REPOS=$(echo "${REPOS}" | jq '[.[] | select(.name | test("^landomo-[a-z]+-[a-z]+$"))]')

SCRAPER_COUNT=$(echo "${SCRAPER_REPOS}" | jq '. | length')
echo "Found ${SCRAPER_COUNT} scraper repositories"

# Update scrapers.json
# TODO: Implement proper JSON update logic

echo "Registry sync completed"
echo "Scraper repositories: ${SCRAPER_COUNT}"
echo "Registry file: ${REGISTRY_FILE}"
