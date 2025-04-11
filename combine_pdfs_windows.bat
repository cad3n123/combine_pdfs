@echo off
setlocal enabledelayedexpansion

echo ==== Combine PDFs Builder ====

REM Where to output the final .exe
set "STARTDIR=%cd%"

REM Python.org local install path fallback
set "PYTHON_INSTALL_DIR=%LocalAppData%\Programs\PDFCombinerPython"
set "FALLBACK_PYTHON_EXE=%PYTHON_INSTALL_DIR%\python.exe"
set "USE_PYTHON="

REM Step 1: Look for an existing non-Anaconda, non-MicrosoftStore Python
for /f "delims=" %%P in ('where python 2^>nul') do (
    echo Found Python at: %%P

    echo %%P | find /I "anaconda" >nul
    if not errorlevel 1 (
        echo Skipping Anaconda Python...
    ) else (
        echo %%P | find /I "WindowsApps" >nul
        if not errorlevel 1 (
            echo Skipping Microsoft Store placeholder...
        ) else (
            set "USE_PYTHON=%%P"
        )
    )
    
    if defined USE_PYTHON (
        goto :found_python
    )
)

REM Step 2: Install Python from python.org if needed
echo No non-Anaconda Python found. Installing standalone copy...
mkdir "%PYTHON_INSTALL_DIR%"
curl -o python-installer.exe https://www.python.org/ftp/python/3.11.9/python-3.11.9-amd64.exe
start /wait python-installer.exe /quiet InstallAllUsers=0 TargetDir="%PYTHON_INSTALL_DIR%" Include_pip=1 PrependPath=0
del python-installer.exe

if not exist "%FALLBACK_PYTHON_EXE%" (
    echo Python install failed. Exiting.
    pause
    exit /b
)
set "USE_PYTHON=%FALLBACK_PYTHON_EXE%"

:found_python
echo Using Python: %USE_PYTHON%

REM Step 3: Create temp folder
set "TEMPDIR=%STARTDIR%\combine_pdf_build_temp"
REM Make sure temp folder is clean
if exist "%TEMPDIR%" (
    echo Cleaning up leftover temp folder...
    rmdir /s /q "%TEMPDIR%"
)
mkdir "%TEMPDIR%"
cd /d "%TEMPDIR%"

REM Step 4: Create virtual environment
"%USE_PYTHON%" -m venv venv
call venv\Scripts\activate.bat

REM Step 5: Install required packages
pip install --upgrade pip
pip install pyinstaller PyQt5 PyPDF2

REM Step 6: Download your script
curl -O https://raw.githubusercontent.com/cad3n123/combine_pdfs/main/combine_pdfs.py

REM Step 7: Build with onefile
pyinstaller --onefile --windowed ^
  --exclude-module PyQt5.QtWebEngine ^
  --exclude-module PyQt5.QtMultimedia ^
  --exclude-module PyQt5.QtSvg ^
  --exclude-module PyQt5.QtNetwork ^
  combine_pdfs.py

REM Step 8: Move output .exe to final folder
move /Y dist\combine_pdfs.exe "%STARTDIR%\combine_pdfs.exe"

REM Step 9: Clean everything up
cd /d "%STARTDIR%"
rmdir /s /q "%TEMPDIR%"

echo.
echo ==== Build Complete! ====
pause
