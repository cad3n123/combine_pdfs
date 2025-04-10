#!/bin/bash

set -e

# 1. Download Python script from GitHub
REPO_URL="https://raw.githubusercontent.com/cad3n123/combine_pdfs/main/combine_pdfs.py"
curl -O "$REPO_URL"

# 2. Install Homebrew if it's missing
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" </dev/null
fi

# 3. Install Python if missing
if ! command -v python3 &> /dev/null; then
    echo "Installing Python 3..."
    brew install python
fi

# 4. Install required packages
python3 -m pip install --user py2app PyQt5 PyPDF2 || python3 -m pip install --break-system-packages py2app PyQt5 PyPDF2

# 5. Create minimal setup.py
cat <<EOF > setup.py
from setuptools import setup

APP = ['combine_pdfs.py']
OPTIONS = {'argv_emulation': True, 'packages': ['PyQt5', 'PyPDF2']}

setup(
    app=APP,
    options={'py2app': OPTIONS},
    setup_requires=['py2app'],
)
EOF

# 6. Compile the app
python3 setup.py py2app

# 7. Move app to current directory (from dist/)
mv dist/*.app ./

# 8. Cleanup
rm -rf build dist __pycache__ setup.py combine_pdfs.py

# 9. Delete self
if [[ "$0" != "bash" && -f "$0" ]]; then
    rm -- "$0"
fi
