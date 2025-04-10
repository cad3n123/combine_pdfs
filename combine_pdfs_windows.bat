@echo off
setlocal enabledelayedexpansion

echo Starting Combine PDFs setup...

REM 1. Download Python script from GitHub
curl -O https://raw.githubusercontent.com/cad3n123/combine_pdfs/main/combine_pdfs.py

REM 2. Check for Python
where python >nul 2>nul
if errorlevel 1 (
    echo Python is not installed. Please install Python 3 and re-run this script.
    pause
    exit /b
)

REM 3. Install required packages
echo Installing Python packages (PyQt5, PyPDF2, pyinstaller)...
python -m pip install --upgrade pip
python -m pip install PyQt5 PyPDF2 pyinstaller

REM 4. Compile using PyInstaller (with full PyQt5 support)
echo Compiling to EXE...
python -m PyInstaller --onefile --windowed --collect-all PyQt5 combine_pdfs.py

REM 5. Move the EXE to current directory
move /Y dist\combine_pdfs.exe . >nul 2>nul

REM 6. Cleanup
rmdir /s /q build
rmdir /s /q dist
del combine_pdfs.spec
del combine_pdfs.py
