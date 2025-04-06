This PowerShell function retrieves GitHub release information, downloads a specified asset, and optionally extracts it. It also lets you list all release tags and available assets.

Examples:

1. List all releases and available assets:
```
Get-GithubRelease -Repo "ffuf/ffuf" -List

[INFO] Parameters:

   Repo:           ffuf/ffuf
   ReleaseTag:     latest
   Asset:          *
   List:           True
   DownloadFolder: C:\Users\user
   Extract:        True
   SevenZipPath:   C:\Program Files\7-Zip\7z.exe
   ExtractFolder:  C:\Users\user\ffuf
   DeleteArchive:  True

[INFO] Release Assets:

   ReleaseTag: v2.1.0

   ffuf_2.1.0_checksums.txt
   ffuf_2.1.0_checksums.txt.sig
   ffuf_2.1.0_freebsd_386.tar.gz
   ffuf_2.1.0_freebsd_amd64.tar.gz
   ffuf_2.1.0_freebsd_armv6.tar.gz
   ffuf_2.1.0_linux_386.tar.gz
   ffuf_2.1.0_linux_amd64.tar.gz
   ffuf_2.1.0_linux_arm64.tar.gz
   ffuf_2.1.0_linux_armv6.tar.gz
   ffuf_2.1.0_macOS_amd64.tar.gz
   ffuf_2.1.0_macOS_arm64.tar.gz
   ffuf_2.1.0_openbsd_386.tar.gz
   ffuf_2.1.0_openbsd_amd64.tar.gz
   ffuf_2.1.0_openbsd_arm64.tar.gz
   ffuf_2.1.0_openbsd_armv6.tar.gz
   ffuf_2.1.0_windows_386.zip
   ffuf_2.1.0_windows_amd64.zip
   ffuf_2.1.0_windows_arm64.zip
   ffuf_2.1.0_windows_armv6.zip

   ReleaseTag: v2.0.0

   ffuf_2.0.0_checksums.txt
   ffuf_2.0.0_checksums.txt.sig
   ffuf_2.0.0_freebsd_386.tar.gz
   ffuf_2.0.0_freebsd_amd64.tar.gz
   ffuf_2.0.0_freebsd_armv6.tar.gz
   ffuf_2.0.0_linux_386.tar.gz
   ffuf_2.0.0_linux_amd64.tar.gz
   ffuf_2.0.0_linux_arm64.tar.gz
   ffuf_2.0.0_linux_armv6.tar.gz
   ffuf_2.0.0_macOS_amd64.tar.gz
   ffuf_2.0.0_macOS_arm64.tar.gz
   ffuf_2.0.0_openbsd_386.tar.gz
   ffuf_2.0.0_openbsd_amd64.tar.gz
   ffuf_2.0.0_openbsd_arm64.tar.gz
   ffuf_2.0.0_openbsd_armv6.tar.gz
   ffuf_2.0.0_windows_386.zip
   ffuf_2.0.0_windows_amd64.zip
   ffuf_2.0.0_windows_arm64.zip
   ffuf_2.0.0_windows_armv6.zip
```

2. Download the latest release asset matching a pattern:
```
Get-GithubRelease -Repo "ffuf/ffuf" -Asset "ffuf_*_windows_amd64.zip"

[INFO] Parameters:

   Repo:           ffuf/ffuf
   ReleaseTag:     latest
   Asset:          ffuf_*_windows_amd64.zip
   List:           False
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

3. Download a specific release asset:
```
Get-GithubRelease -Repo "ffuf/ffuf" -Asset "ffuf_*_windows_amd64.zip" -ReleaseTag "v2.0.0"

[INFO] Parameters:

   Repo:           ffuf/ffuf
   ReleaseTag:     v2.0.0
   Asset:          ffuf_*_windows_amd64.zip
   List:           False
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
