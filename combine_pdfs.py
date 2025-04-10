import subprocess
import sys

# Install PyQt5 if it's not already installed
try:
    import PyQt5
except ImportError:
    subprocess.check_call(
        [sys.executable, "-m", "pip", "install", "PyQt5"],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL
    )
    import PyQt5

from PyQt5.QtWidgets import QApplication, QFileDialog

# Install PyPDF2 if it's not already installed
try:
    import PyPDF2
except ImportError:
    subprocess.check_call(
        [sys.executable, "-m", "pip", "install", "PyPDF2"],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL
    )
    import PyPDF2

def merge_pdfs(pdf_paths, output_path):
    merger = PyPDF2.PdfMerger()
    for pdf in pdf_paths:
        merger.append(pdf)
    merger.write(output_path)
    merger.close()

def main():
    app = QApplication(sys.argv)
    app.setQuitOnLastWindowClosed(False)  # So dialog doesn't close the app

    # Select multiple PDF files
    files, _ = QFileDialog.getOpenFileNames(
        None,
        "Select PDF files to merge",
        "",
        "PDF Files (*.pdf)"
    )

    if not files:
        print("No files selected.")
        return

    # Ask where to save the merged PDF
    save_path, _ = QFileDialog.getSaveFileName(
        None,
        "Save merged PDF as...",
        "merged.pdf",
        "PDF Files (*.pdf)"
    )

    if not save_path:
        print("No save location selected.")
        return

    if not save_path.lower().endswith(".pdf"):
        save_path += ".pdf"

    try:
        merge_pdfs(files, save_path)
        print(f"PDFs merged and saved to: {save_path}")
    except Exception as e:
        print(f"Failed to merge PDFs: {e}")

if __name__ == "__main__":
    main()
