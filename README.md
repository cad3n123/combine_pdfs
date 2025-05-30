# Combine PDFs – One-Click Installer for Windows & macOS

This tool combines multiple PDF files into one, with a simple, native GUI.  
Install it in one command — no coding or setup required.

---

## Windows Installation

1. Open **Command Prompt** or **PowerShell**
2. Run this one-liner:

```powershell
curl -o installer.bat https://raw.githubusercontent.com/cad3n123/combine_pdfs/main/combine_pdfs_windows.bat ; ./installer.bat
```

What it does:

- Downloads the Python script
- Installs Python (if missing)
- Installs required packages: PyQt5, PyPDF2, pyinstaller
- Compiles everything into `combine_pdfs.exe`
- Cleans itself up

> Result: A standalone `.exe` you can run from anywhere

---

## macOS Installation

1. Open **Terminal**
2. Run this one-liner:

```bash
curl -fsSL https://raw.githubusercontent.com/cad3n123/combine_pdfs/main/combine_pdfs_mac.sh | bash
```

What it does:

- Downloads the Python script
- Installs Homebrew (if missing)
- Installs Python (if missing)
- Installs required packages: PyQt5, PyPDF2, py2app
- Builds a `.app` bundle using `py2app`
- Cleans up all temp files

> Result: A native Mac app in your current folder

---

## Output

Both scripts will leave you with a **single-file app**:

- `combine_pdfs.exe` on Windows
- `combine_pdfs.app` on macOS

You can run the app, pick PDFs, and save a merged copy with a native file dialog.

---

## Cleanup

Both scripts delete all temporary files and even remove themselves after running.

---

## Troubleshooting

- **macOS Gatekeeper** might block the `.app` if it’s unsigned.  
  Just right-click > Open once to bypass the warning.

- **Windows SmartScreen** may also prompt — click "More info" > "Run anyway".

---

## License

MIT License
