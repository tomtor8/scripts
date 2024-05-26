# Introduction

- 'ss2ocr' stands for **s**creen**s**hot to ocr
- OCR multiple pictures in a `jpeg`, `jpg`, `png` format using `tesseract`

# Usage

- the default directory for the pictures is `$HOME/Pictures/Screenshots`
- the script creates a new `scanned-text.txt` file in the `Screenshots` folder
- if this file is already present, the script allows to rewrite the file or append to the file
- special timestamp headers are created each time after running the script in the `scanned-text.txt` file

# Dependencies

- `tesseract-ocr`
