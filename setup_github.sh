#!/bin/bash

# 🦦 Otter Client Enhanced - GitHub Setup Script
# This script helps you set up the GitHub repository

echo "🚀 Setting up Otter Client Enhanced on GitHub..."

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo "❌ Git is not installed. Please install git first."
    exit 1
fi

# Initialize git repository
echo "📁 Initializing git repository..."
git init

# Add all files
echo "📄 Adding files to repository..."
git add .

# Make initial commit
echo "💾 Making initial commit..."
git commit -m "🚀 Initial commit: Otter Client Enhanced v4.0.0 - Ultimate Enhancement"

echo "✅ Local repository setup complete!"
echo ""
echo "🔗 Next steps:"
echo "1. Go to GitHub.com and create a new repository"
echo "2. Repository name: otter-client-enhanced"
echo "3. Make it public"
echo "4. Don't initialize with README (we already have one)"
echo "5. Copy the repository URL"
echo "6. Run these commands:"
echo ""
echo "   git remote add origin https://github.com/YOUR_USERNAME/otter-client-enhanced.git"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""
echo "🎯 After pushing, update the loadstring with your GitHub URL!"
echo "📝 Replace 'YOUR_USERNAME' in Loadstring.lua with your actual GitHub username"
echo ""
echo "🌟 Enjoy your enhanced Otter Client! 🌟"
