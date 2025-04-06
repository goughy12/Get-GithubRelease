Get-GithubRelease

This PowerShell function retrieves GitHub release information, downloads a specified asset, and optionally extracts it. It also allows you to list all release tags and available assets.

Examples:

1. List all releases and available assets:
--------------------------------------------------
Get-GithubRelease -Repo "ffuf/ffuf" -List
--------------------------------------------------

2. Download the latest release asset matching a pattern:
--------------------------------------------------
Get-GithubRelease -Repo "ffuf/ffuf" -Asset "ffuf_*_windows_amd64.zip"
--------------------------------------------------

3. Download a specific release asset:
--------------------------------------------------
Get-GithubRelease -Repo "ffuf/ffuf" -Asset "ffuf_*_windows_amd64.zip" -ReleaseTag "v2.0.0"
--------------------------------------------------

Optional parameters let you set the download folder, enable extraction (using 7‑Zip), and delete the archive after extraction.
