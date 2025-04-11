#!/bin/bash

set -e

echo "==== Combine PDFs Builder for macOS ===="

# 1. Setup paths
STARTDIR="$(pwd)"
TEMPDIR="$STARTDIR/combine_pdf_build_temp"
PYTHON_EXEC=""

# 2. Clean up previous temp folder if it exists
if [[ -d "$TEMPDIR" ]]; then
    echo "Cleaning up leftover build folder..."
    rm -rf "$TEMPDIR"
fi

mkdir -p "$TEMPDIR"
cd "$TEMPDIR"

# 3. Find non-Anaconda, non-conda Python
echo "Looking for a clean Python install..."
while IFS= read -r path; do
    if [[ "$path" != *"anaconda"* && "$path" != *"conda"* && "$path" != *"Cellar"* ]]; then
        PYTHON_EXEC="$path"
        break
    fi
done < <(which -a python3 || true)

# 4. Install Homebrew Python if needed
if [[ -z "$PYTHON_EXEC" ]]; then
    echo "No valid python3 found. Installing with Homebrew..."
    if ! command -v brew &>/dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" </dev/null
    fi
    brew install python
    PYTHON_EXEC="$(which python3)"
fi

echo "Using Python: $PYTHON_EXEC"

# 5. Create venv and activate
"$PYTHON_EXEC" -m venv venv
source venv/bin/activate

# 6. Install dependencies
pip install --upgrade pip
pip install PyQt5 PyPDF2 py2app

# 7. Download Python script
curl -O https://raw.githubusercontent.com/cad3n123/combine_pdfs/main/combine_pdfs.py

# 8. Write setup.py
cat <<EOF > setup.py
from setuptools import setup

APP = ['combine_pdfs.py']
OPTIONS = {
    'argv_emulation': True,
    'packages': ['PyQt5', 'PyPDF2']
}

setup(
    app=APP,
    options={'py2app': OPTIONS},
    setup_requires=['py2app'],
)
EOF

# 9. Build the app
echo "Building .app with py2app..."
python setup.py py2app

# 10. Move result directly to current directory
mv dist/*.app "$STARTDIR"

# 11. Clean everything
cd "$STARTDIR"
rm -rf "$TEMPDIR"

echo
echo "==== Build Complete ===="
echo "Your app is ready at: $STARTDIR"
echo
echo "If macOS blocks the app from opening:"
echo " - Right-click the app in Finder and select 'Open'"
echo " - Confirm the Gatekeeper prompt"
