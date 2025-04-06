# Get-GithubRelease

**Author:** goughy12 
**Version:** 1.0  
**Date Created:** 2025-April-06

## Overview

Get-GithubRelease is a PowerShell function that interacts with the GitHub API to retrieve release information for a specified repository. It can:

- Retrieve either the latest release or a specific release by tag.
- Download a release asset that matches a provided wildcard pattern.
- Optionally extract the downloaded asset (if it’s an archive) using 7‑Zip.
- Optionally delete the archive after extraction.
- List all available release tags and assets with the `-List` switch, helping you determine which asset to download.

This function is especially useful for automating deployments or build processes where release assets need to be fetched and processed automatically.

## Features

- **Flexible Retrieval:** Specify a particular release via tag or get the latest release.
- **Wildcard Matching:** Use wildcard patterns to select assets.
- **Automatic Extraction:** Supports archive formats including `.zip`, `.7z`, `.gz`, `.rar`, `.xz`, and `.bz2`.
- **Cleanup Option:** Optionally delete the downloaded archive after extraction.
- **List Mode:** Display all release tags and available assets without downloading.

## Requirements

- **PowerShell 5.1 or later**
- **7‑Zip:** The script uses 7‑Zip to extract archives. The default path is `C:\Program Files\7-Zip\7z.exe`.  
  If 7‑Zip is not installed, install it via [winget](https://github.com/microsoft/winget-cli):
  ```bash
  winget install 7zip.7zip
