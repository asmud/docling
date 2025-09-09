#!/bin/bash
# Test installation script for docling-enhanced

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${GREEN}🧪 Testing docling-enhanced installation...${NC}"

# Create temporary virtual environment
TEMP_VENV=$(mktemp -d)/test-env
echo -e "${BLUE}📁 Creating test environment: $TEMP_VENV${NC}"
python -m venv "$TEMP_VENV"

# Activate virtual environment
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    source "$TEMP_VENV/Scripts/activate"
else
    source "$TEMP_VENV/bin/activate"
fi

# Install package
echo -e "${BLUE}📦 Installing package...${NC}"
if ls dist/*.whl 1> /dev/null 2>&1; then
    pip install dist/*.whl
else
    echo -e "${RED}❌ No wheel file found in dist/. Run build script first.${NC}"
    exit 1
fi

# Test basic import
echo -e "${BLUE}🔍 Testing basic import...${NC}"
python -c "
import docling_enhanced
print(f'✅ Successfully imported docling_enhanced version: {docling_enhanced.__version__}')
"

# Test ONNX detection
echo -e "${BLUE}🔍 Testing ONNX detection...${NC}"
python -c "
from docling_enhanced import is_onnx_available, get_optimal_providers

onnx_available = is_onnx_available()
print(f'ONNX available: {onnx_available}')

if onnx_available:
    providers = get_optimal_providers()
    print(f'Available providers: {providers}')
    
print('✅ ONNX detection working correctly')
"

# Test enhanced model imports
echo -e "${BLUE}🔍 Testing enhanced model imports...${NC}"
python -c "
from docling_enhanced.models import EnhancedLayoutModel, EnhancedTableStructureModel, EnhancedDocumentPictureClassifier
from docling_enhanced.utils import EnhancedModelFactory

print('✅ Enhanced model imports successful')
"

# Test factory creation
echo -e "${BLUE}🔍 Testing factory creation...${NC}"
python -c "
from docling_enhanced import EnhancedModelFactory
from docling.datamodel.accelerator_options import AcceleratorOptions

accelerator_options = AcceleratorOptions()
factory = EnhancedModelFactory(accelerator_options)

info = factory.get_info()
print(f'Factory info: {info}')
print('✅ Factory creation working correctly')
"

# Cleanup
deactivate
rm -rf "$TEMP_VENV"

echo ""
echo -e "${GREEN}🎉 All tests passed successfully!${NC}"
echo -e "${GREEN}✅ Package is ready for distribution${NC}"