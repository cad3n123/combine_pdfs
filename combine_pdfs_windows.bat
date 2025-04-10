@echo off
setlocal enabledelayedexpansion

echo Starting Combine PDFs setup...

REM 1. Download Python script from GitHub
curl -O https://raw.githubusercontent.com/cad3n123/combine_pdfs/main/combine_pdfs.py

REM 2. Check for Python
where python >nul 2>nul
if errorlevel 1 (
    echo Python is not installed. Installing it now...

    REM Download Python installer
    curl -o python-installer.exe https://www.python.org/ftp/python/3.11.9/python-3.11.9-amd64.exe

    REM Run the installer silently with Add to PATH and pip
    start /wait python-installer.exe /quiet InstallAllUsers=1 PrependPath=1 Include_pip=1

    REM Cleanup installer
    del python-installer.exe

    REM Reload environment variables
    echo Refreshing environment...
    set "PATH=%ProgramFiles%\Python311\Scripts;%ProgramFiles%\Python311;%PATH%"
)

REM 3. Check again for Python (after install)
where python >nul 2>nul
if errorlevel 1 (
    echo Python installation failed. Please install Python manually and re-run this script.
    pause
    exit /b
)

REM 4. Install required Python packages
echo Installing Python packages (PyQt5, PyPDF2, pyinstaller)...
python -m pip install --upgrade pip
python -m pip install PyQt5 PyPDF2 pyinstaller

REM 5. Compile the script using PyInstaller
echo Compiling to EXE...
python -m PyInstaller --onefile --windowed combine_pdfs.py

REM 6. Move EXE to current directory
move /Y dist\combine_pdfs.exe . >nul 2>nul

REM 7. Cleanup
rmdir /s /q build
rmdir /s /q dist
del combine_pdfs.spec
del combine_pdfs.py
