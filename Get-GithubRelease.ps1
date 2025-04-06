function Get-GithubRelease {
    <#
    .SYNOPSIS
        Retrieves GitHub release information, downloads a specified asset, and optionally extracts it.

    .DESCRIPTION
        The Get-GithubRelease function interacts with the GitHub API to retrieve release information for a specified repository.
        It supports fetching either the latest release or a specific release by tag. The function downloads a release asset that 
        matches a provided wildcard pattern. If the -List switch is specified, it will list all release tags and available assets 
        for the repository, allowing users to determine which asset they may want to download.

        Additionally, if the downloaded asset is an archive (supported formats include .zip, .7z, .gz, .rar, .xz, and .bz2), 
        the function can automatically extract its contents using 7-Zip into a designated extraction folder. After extraction, 
        if the -DeleteArchive switch is enabled, the downloaded archive will be deleted. Users can customize both the download 
        and extraction folders via parameters.

        This function is useful for automating the process of obtaining and processing release assets from GitHub repositories, 
        especially in deployment or build integration scenarios.

    .NOTES
        Version: 1.0
        DateCreated: 2025-April-06

    .PARAMETER Repo
        (Mandatory) [String] The GitHub repository in the format "owner/repo".

    .PARAMETER Asset
        (Optional) [String] The asset name or wildcard pattern to download.

    .PARAMETER ReleaseTag
        (Optional) [String] The release tag to use. If "latest" is specified, the latest release is retrieved.

    .PARAMETER DownloadFolder
        (Optional) [String] The folder where the downloaded asset will be saved. Defaults to the current directory.

    .PARAMETER Extract
        (Optional) [Bool] Indicates whether to extract the release asset if it is an archive.

    .PARAMETER SevenZipPath
        (Optional) [String] The path to the 7-Zip executable.

    .PARAMETER ExtractFolder
        (Optional) [String] The folder where the asset will be extracted if it's an archive.

    .PARAMETER List
        (Optional) [Switch] When provided, lists all GitHub release tags and available assets, then exits.

    .PARAMETER DeleteArchive
        (Optional) [Bool] When true, deletes the downloaded archive file after extraction (if applicable).

    .EXAMPLE
        # List all release tags and available assets 
        Get-GithubRelease -Repo "ffuf/ffuf" -List

    .EXAMPLE
        # Get the latest release asset matching the wildcard pattern
        Get-GithubRelease -Repo "ffuf/ffuf" -Asset "ffuf_*windows_amd64.zip"

    .EXAMPLE
        # Get the release asset matching the wildcard pattern for a specific release tag
        Get-GithubRelease -Repo "ffuf/ffuf" -Asset "ffuf_*windows_amd64.zip" -ReleaseTag "v2.1.0"
    #>

    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [string]$Repo,

        [Parameter()]
        [switch]$List,

        [Parameter()]
        [string]$Asset = "*",

        [Parameter()]
        [string]$ReleaseTag = "latest",

        [Parameter()]
        [string]$DownloadFolder = $PWD,

        [Parameter()]
        [bool]$Extract = $true,

        [Parameter()]
        [string]$SevenZipPath = "C:\Program Files\7-Zip\7z.exe",

        [Parameter()]
        [string]$ExtractFolder = "$DownloadFolder\$($Repo.Split('/')[-1])",

        [Parameter()]
        [bool]$DeleteArchive = $true
    )

    BEGIN {
        Write-Host "`n[INFO] Parameters:`n"
        Write-Host "   Repo:           $($Repo)"
        Write-Host "   ReleaseTag:     $ReleaseTag"
        Write-Host "   Asset:          $Asset"
        Write-Host "   List:           $List"
        Write-Host "   DownloadFolder: $DownloadFolder"
        Write-Host "   Extract:        $Extract"
        Write-Host "   SevenZipPath:   $SevenZipPath"
        Write-Host "   ExtractFolder:  $ExtractFolder"
        Write-Host "   DeleteArchive:  $DeleteArchive`n"
    }

    PROCESS {
        # -------------------------------
        # LIST MODE: List releases and assets
        # -------------------------------
        if ($List) {
            try {
                $releasesUrl = "https://api.github.com/repos/$Repo/releases"
                $releases = Invoke-RestMethod -Uri $releasesUrl -ErrorAction Stop
            }
            catch {
                Write-Host "[ERROR] Failed to retrieve releases for $($Repo): $_"
                return
            }

            Write-Host "[INFO] Release Assets:`n"
            foreach ($release in $releases) {
                Write-Host "   -ReleaseTag `"$($release.tag_name)`"`n"
                foreach ($item in $release.assets) {
                    Write-Host "   $($item.name)"
                }
                Write-Host ""
            }
            return
        }

        # -------------------------------
        # DETERMINE RELEASE URL
        # -------------------------------
        if (-not [string]::IsNullOrWhiteSpace($ReleaseTag) -and $ReleaseTag -ne "latest") {
            $releaseUrl = "https://api.github.com/repos/$Repo/releases/tags/$ReleaseTag"
        }
        else {
            $releaseUrl = "https://api.github.com/repos/$Repo/releases/latest"
        }

        # -------------------------------
        # RETRIEVE RELEASE INFORMATION
        # -------------------------------
        try {
            $release = Invoke-RestMethod -Uri $releaseUrl -ErrorAction Stop
        }
        catch {
            Write-Host "[ERROR] Failed to retrieve release info for $($Repo): $_"
            return
        }

        # -------------------------------
        # FILTER ASSETS
        # -------------------------------
        $releaseAsset = $release.assets | Where-Object { $_.name -like $Asset }

        if ($releaseAsset.Count -ne 1) {
            if ($releaseAsset.Count -eq 0) {
                Write-Host "[ERROR] No asset found matching '$Asset':`n"           
            }
            else {
                Write-Host "[ERROR] Multiple assets found matching '$Asset':`n" 
            }
            Write-Host "   Repo:           $($Repo)"
            Write-Host "   ReleaseTag:     $($release.tag_name)`n"
            Write-Host "   Available assets:`n"
            foreach ($item in $release.assets) {
                Write-Host "   -Asset `"$($item.name)`""
            }
            Write-Host ""
            return
        }

        # -------------------------------
        # DOWNLOAD ASSET
        # -------------------------------
        $downloadUrl = $releaseAsset.browser_download_url
        $filename    = $releaseAsset.name
        $localFile   = Join-Path -Path $DownloadFolder -ChildPath $filename

        Write-Host "[INFO] Downloading:`n"
        Write-Host "   Repo:           $($Repo)"
        Write-Host "   ReleaseTag:     $($release.tag_name)"
        Write-Host "   Filename:       $filename"
        Write-Host "   URL:            $downloadUrl"
        Write-Host "   Path:           $localFile`n"

        try {
            $ProgressPreference = 'SilentlyContinue'
            Invoke-WebRequest -Uri $downloadUrl -OutFile $localFile -ErrorAction Stop
        }
        catch {
            Write-Host "[ERROR] Download failed: $_"
            return
        }

        # -------------------------------
        # EXTRACT ASSET IF REQUIRED
        # -------------------------------
        if ($Extract -and $filename.ToLower() -match "\.(zip|7z|gz|rar|xz|bz2)$") {
            if (-not (Test-Path $SevenZipPath)) {
                Write-Host "[ERROR] 7-Zip is not installed.`n`n   Install 7-Zip:  winget install 7zip`n"
                return
            }
            try {
                Write-Host "[INFO] Extracting:`n"
                Write-Host "   Archive:        $localFile"
                Write-Host "   Path:           $ExtractFolder`n"
                & $SevenZipPath e $localFile -o"$ExtractFolder" -y > $null 2>&1
            }
            catch {
                Write-Host "[ERROR] Extract failed: $_"
                return
            }
        }
        else {
            return
        }

        # -------------------------------
        # DELETE ARCHIVE IF SWITCHED ON
        # -------------------------------
        if ($DeleteArchive) {
            try {
                Write-Host "[INFO] Deleting:`n`n" `
                "  Archive:        $localFile`n"
                Remove-Item -Path $localFile -Force
            }
            catch {
                Write-Host "[ERROR] Failed to delete archive: $_"
            }
        }
    }

    END {
    }
}
