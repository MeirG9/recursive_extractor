# Recursive Extractor

A batch script for Windows that automates the extraction of compressed files (.rar, .zip, .7z) from a specified target folder and its subfolders using 7-Zip. The script handles file overwriting and skipping options, providing a user-friendly experience.

## Features

- Recursively extracts archives from the target folder and its subdirectories.
- Supports multiple archive formats: `.rar`, `.zip`, and `.7z`.
- Prompts the user for file overwriting or skipping existing files.
- Checks for the installation of 7-Zip and handles errors gracefully.

## Requirements

- Windows operating system
- [7-Zip](https://www.7-zip.org/) installed (default location is `C:\Program Files\7-Zip\7z.exe` or included in the system's PATH).

## Usage

1. Clone or download this repository to your local machine.
2. Open a command prompt.
3. Navigate to the directory containing the `recursive_extractor.bat` script.
4. Run the script with the target folder path as an argument:

   ```bash
   .\recursive_extractor.bat "C:\path\to\target\folder"
