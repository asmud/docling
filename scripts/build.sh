#!/bin/bash
# Build script for docling-enhanced package

set -e

echo "🔨 Building docling-enhanced package..."

# Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -rf dist/ build/ *.egg-info/ src/*.egg-info/

# Install build dependencies
echo "📦 Installing build dependencies..."
pip install --upgrade pip build twine setuptools-scm

# Build the package
echo "🏗️ Building package..."
python -m build

# Check the package
echo "✅ Checking package integrity..."
twine check dist/*

echo "🎉 Build completed successfully!"
echo "📁 Build artifacts are in: dist/"
ls -la dist/

echo ""
echo "Next steps:"
echo "  - Test installation: pip install dist/*.whl"
echo "  - Publish to Test PyPI: twine upload --repository-url https://test.pypi.org/legacy/ dist/*"
echo "  - Publish to PyPI: twine upload dist/*"