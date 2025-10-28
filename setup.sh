#!/bin/bash

# FreshGrocer E-Commerce Installation Script
# This script automates the setup process

set -e

echo "========================================="
echo "🛒 FreshGrocer E-Commerce Setup"
echo "========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check Ruby version
echo "Checking Ruby version..."
ruby_version=$(ruby -v)
echo "✓ $ruby_version"
echo ""

# Check if PostgreSQL is installed
if ! command -v psql &> /dev/null; then
    echo -e "${RED}✗ PostgreSQL is not installed${NC}"
    echo "Please install PostgreSQL first:"
    echo "  - Mac: brew install postgresql"
    echo "  - Ubuntu: sudo apt-get install postgresql postgresql-contrib"
    exit 1
else
    echo -e "${GREEN}✓ PostgreSQL is installed${NC}"
fi

# Check if Redis is installed (optional for Sidekiq)
if ! command -v redis-cli &> /dev/null; then
    echo -e "${YELLOW}⚠ Redis is not installed (needed for background jobs)${NC}"
    echo "Install Redis for full functionality:"
    echo "  - Mac: brew install redis"
    echo "  - Ubuntu: sudo apt-get install redis-server"
else
    echo -e "${GREEN}✓ Redis is installed${NC}"
fi

echo ""
echo "========================================="
echo "📦 Installing Dependencies"
echo "========================================="
echo ""

# Install gems
echo "Installing Ruby gems..."
bundle install

echo ""
echo "========================================="
echo "🗄️  Setting Up Database"
echo "========================================="
echo ""

# Database setup
echo "Creating databases..."
rails db:create || echo "Database may already exist"

echo "Running migrations..."
rails db:migrate

echo "Loading seed data..."
rails db:seed

echo ""
echo "========================================="
echo "✨ Setup Complete!"
echo "========================================="
echo ""

echo -e "${GREEN}Your FreshGrocer application is ready!${NC}"
echo ""
echo "To start the application, run these commands in separate terminals:"
echo ""
echo -e "${YELLOW}Terminal 1:${NC} rails server"
echo -e "${YELLOW}Terminal 2:${NC} rails tailwindcss:watch"
echo -e "${YELLOW}Terminal 3:${NC} bundle exec sidekiq (if Redis is installed)"
echo ""
echo "Access the application:"
echo -e "${GREEN}Customer Storefront:${NC} http://localhost:3000"
echo -e "${GREEN}Admin Dashboard:${NC}     http://localhost:3000/admin"
echo ""
echo "Default Credentials:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}Customer:${NC}"
echo "  Email:    customer@example.com"
echo "  Password: password123"
echo ""
echo -e "${GREEN}Admin:${NC}"
echo "  Email:    admin@freshgrocer.com"
echo "  Password: password123"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "📚 Documentation:"
echo "  - README.md                  - Overview"
echo "  - QUICK_START.md             - Quick start guide"
echo "  - SETUP.md                   - Detailed setup"
echo "  - IMPLEMENTATION_SUMMARY.md  - Full documentation"
echo ""
echo -e "${GREEN}Happy coding! 🚀${NC}"
echo ""
