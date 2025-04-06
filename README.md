# Get-GithubRelease

This PowerShell function retrieves GitHub release information, downloads a specified asset, and optionally extracts it. It also lets you list all release tags and available assets.

## Parameters

```
-Repo <string>              The GitHub repository in the format "owner/repo".

-List                       Lists all GitHub release tags and available assets.

-Asset <string>             The asset name or wildcard pattern to download. (Default: "*")

-ReleaseTag <string>        The release tag to use. If "latest" is specified, the latest release is retrieved. (Default: "latest")

-DownloadFolder <string>    The folder where the downloaded asset will be saved. (Default: current directory)

-Extract <bool>             When true, extract the release asset (if applicable). (Default: True)

-SevenZipPath <string>      The path to the 7-Zip executable. (Default: "C:\Program Files\7-Zip\7z.exe")

-ExtractFolder <string>     The folder where the asset will be extracted if it's an archive. (Default: "<current-directory>\<repo-name>")

-DeleteArchive <bool>       When true, deletes the downloaded archive file after extraction (if applicable). (Default: True)
```

## Usage

### 1. Get the latest release asset matching the pattern:
```
Get-GithubRelease -Repo "ffuf/ffuf" -Asset "ffuf_*_windows_amd64.zip"
```
```
[INFO] Parameters:

   Repo:           ffuf/ffuf
   List:           False
   Asset:          ffuf_*_windows_amd64.zip
   ReleaseTag:     latest
   DownloadFolder: C:\Users\user
   Extract:        True
   SevenZipPath:   C:\Program Files\7-Zip\7z.exe
   ExtractFolder:  C:\Users\user\ffuf
   DeleteArchive:  True

[INFO] Downloading:

   Repo:           ffuf/ffuf
   ReleaseTag:     v2.1.0
   Filename:       ffuf_2.1.0_windows_amd64.zip
   URL:            https://github.com/ffuf/ffuf/releases/download/v2.1.0/ffuf_2.1.0_windows_amd64.zip
   Path:           C:\Users\user\ffuf_2.1.0_windows_amd64.zip

[INFO] Extracting:

   Archive:        C:\Users\user\ffuf_2.1.0_windows_amd64.zip
   Path:           C:\Users\user\ffuf

[INFO] Deleting:

   Archive:        C:\Users\user\ffuf_2.1.0_windows_amd64.zip
```

### 2. Get the release asset matching the pattern for a specific release tag:
```
Get-GithubRelease -Repo "ffuf/ffuf" -Asset "ffuf_*_windows_amd64.zip" -ReleaseTag "v2.0.0"
```
```
[INFO] Parameters:

   Repo:           ffuf/ffuf
   List:           False
   Asset:          ffuf_*_windows_amd64.zip
   ReleaseTag:     v2.0.0
   DownloadFolder: C:\Users\user
   Extract:        True
   SevenZipPath:   C:\Program Files\7-Zip\7z.exe
   ExtractFolder:  C:\Users\user\ffuf
   DeleteArchive:  True

[INFO] Downloading:

   Repo:           ffuf/ffuf
   ReleaseTag:     v2.0.0
   Filename:       ffuf_2.0.0_windows_amd64.zip
   URL:            https://github.com/ffuf/ffuf/releases/download/v2.0.0/ffuf_2.0.0_windows_amd64.zip
   Path:           C:\Users\user\ffuf_2.0.0_windows_amd64.zip

[INFO] Extracting:

   Archive:        C:\Users\user\ffuf_2.0.0_windows_amd64.zip
   Path:           C:\Users\user\ffuf

[INFO] Deleting:

   Archive:        C:\Users\user\ffuf_2.0.0_windows_amd64.zip
```
### 3. List all release tags and available assets:
```
Get-GithubRelease -Repo "ffuf/ffuf" -List
```
```
[INFO] Parameters:

   Repo:           ffuf/ffuf
   List:           True
   Asset:          *
   ReleaseTag:     latest
   DownloadFolder: C:\Users\user
   Extract:        True
   SevenZipPath:   C:\Program Files\7-Zip\7z.exe
   ExtractFolder:  C:\Users\user\ffuf
   DeleteArchive:  True

[INFO] Release Assets:

   -ReleaseTag "v2.1.0"

   -Asset "ffuf_2.1.0_checksums.txt"
   -Asset "ffuf_2.1.0_checksums.txt.sig"
   -Asset "ffuf_2.1.0_freebsd_386.tar.gz"
   -Asset "ffuf_2.1.0_freebsd_amd64.tar.gz"
   -Asset "ffuf_2.1.0_freebsd_armv6.tar.gz"
   -Asset "ffuf_2.1.0_linux_386.tar.gz"
   -Asset "ffuf_2.1.0_linux_amd64.tar.gz"
   -Asset "ffuf_2.1.0_linux_arm64.tar.gz"
   -Asset "ffuf_2.1.0_linux_armv6.tar.gz"
   -Asset "ffuf_2.1.0_macOS_amd64.tar.gz"
   -Asset "ffuf_2.1.0_macOS_arm64.tar.gz"
   -Asset "ffuf_2.1.0_openbsd_386.tar.gz"
   -Asset "ffuf_2.1.0_openbsd_amd64.tar.gz"
   -Asset "ffuf_2.1.0_openbsd_arm64.tar.gz"
   -Asset "ffuf_2.1.0_openbsd_armv6.tar.gz"
   -Asset "ffuf_2.1.0_windows_386.zip"
   -Asset "ffuf_2.1.0_windows_amd64.zip"
   -Asset "ffuf_2.1.0_windows_arm64.zip"
   -Asset "ffuf_2.1.0_windows_armv6.zip"

   -ReleaseTag "v2.0.0"

   -Asset "ffuf_2.0.0_checksums.txt"
   -Asset "ffuf_2.0.0_checksums.txt.sig"
   -Asset "ffuf_2.0.0_freebsd_386.tar.gz"
   -Asset "ffuf_2.0.0_freebsd_amd64.tar.gz"
   -Asset "ffuf_2.0.0_freebsd_armv6.tar.gz"
   -Asset "ffuf_2.0.0_linux_386.tar.gz"
   -Asset "ffuf_2.0.0_linux_amd64.tar.gz"
   -Asset "ffuf_2.0.0_linux_arm64.tar.gz"
   -Asset "ffuf_2.0.0_linux_armv6.tar.gz"
   -Asset "ffuf_2.0.0_macOS_amd64.tar.gz"
   -Asset "ffuf_2.0.0_macOS_arm64.tar.gz"
   -Asset "ffuf_2.0.0_openbsd_386.tar.gz"
   -Asset "ffuf_2.0.0_openbsd_amd64.tar.gz"
   -Asset "ffuf_2.0.0_openbsd_arm64.tar.gz"
   -Asset "ffuf_2.0.0_openbsd_armv6.tar.gz"
   -Asset "ffuf_2.0.0_windows_386.zip"
   -Asset "ffuf_2.0.0_windows_amd64.zip"
   -Asset "ffuf_2.0.0_windows_arm64.zip"
   -Asset "ffuf_2.0.0_windows_armv6.zip"

   ......
```
