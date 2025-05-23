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

    .PARAMETER Repo
        [String] The GitHub repository in the format "<repo-owner>/<repo-name>".

    .PARAMETER List
        [Switch] Retrieves a list of all release tags and assets then exits.

    .PARAMETER Asset
        [String] The asset name or wildcard pattern to download. (Default: "*")

    .PARAMETER Tag
        [String] The release tag to use. (Default: "latest")

    .PARAMETER DownloadFolder
        [String] The folder where the asset will be saved. (Default: "<current-directory>")

    .PARAMETER SevenZipPath
        [String] The path to the 7-Zip executable. (Default: "C:\Program Files\7-Zip\7z.exe")

    .PARAMETER ExtractArchive
        [Bool] When true, extract the asset if it's an archive. (Default: True)

    .PARAMETER ExtractFolder
        [String] The folder where the asset will be extracted. (Default: "DownloadFolder\<repo-name>")

    .PARAMETER DeleteArchive
        [Bool] When true, deletes the asset after extraction. (Default: True)

    .EXAMPLE
        # List all release tags and available assets
        Get-GithubRelease -Repo "ffuf/ffuf" -List

    .EXAMPLE
        # Get the latest asset matching the pattern
        Get-GithubRelease -Repo "ffuf/ffuf" -Asset "ffuf_*windows_amd64.zip"

    .EXAMPLE
        # Get the asset matching the pattern for a specific release
        Get-GithubRelease -Repo "ffuf/ffuf" -Asset "ffuf_*windows_amd64.zip" -Tag "v2.1.0"
    #>

    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$Repo,

        [Parameter()]
        [switch]$List,

        [Parameter()]
        [string]$Asset = "*",

        [Parameter()]
        [string]$Tag = "latest",

        [Parameter()]
        [string]$DownloadFolder = $PWD,

        [Parameter()]
        [string]$SevenZipPath = "C:\Program Files\7-Zip\7z.exe",

        [Parameter()]
        [bool]$ExtractArchive = $true,

        [Parameter()]
        [string]$ExtractFolder = "$DownloadFolder\$($Repo.Split('/')[-1])",

        [Parameter()]
        [bool]$DeleteArchive = $true
    )

    BEGIN {
        if (-not $Repo) {
            Write-Host "`nExamples:`n`n"
            Write-Host "    # List all release tags and assets:`n    Get-GithubRelease -Repo `"ffuf/ffuf`" -List`n`n"
            Write-Host "    # Get the latest asset matching the pattern:`n    Get-GithubRelease -Repo `"ffuf/ffuf`" -Asset `"ffuf_*windows_amd64.zip`"`n`n"
            Write-Host "    # Get the asset matching the pattern for a specific release:`n    Get-GithubRelease -Repo `"ffuf/ffuf`" -Asset `"ffuf_*windows_amd64.zip`" -Tag `"v2.0.0`"`n"
            return
        }

        Write-Host "`nGet-GithubRelease Parameters:`n"
        Write-Host "    Repo:           $($Repo)"
        Write-Host "    List:           $List"
        Write-Host "    Asset:          $Asset"
        Write-Host "    Tag:            $Tag"
        Write-Host "    DownloadFolder: $DownloadFolder"
        Write-Host "    SevenZipPath:   $SevenZipPath"
        Write-Host "    ExtractArchive: $ExtractArchive"
        Write-Host "    ExtractFolder:  $ExtractFolder"
        Write-Host "    DeleteArchive:  $DeleteArchive`n"
    }

    PROCESS {

        if (-not $Repo){
            return
        }

        # -------------------------------
        # LIST MODE: List releases and assets
        # -------------------------------
        if ($List) {
            try {
                $releasesUrl = "https://api.github.com/repos/$Repo/releases"
                $releases = Invoke-RestMethod -Uri $releasesUrl -ErrorAction Stop
            }
            catch {
                Write-Host "Failed to retrieve releases: $_"
                return
            }

            Write-Host "    Release Assets:`n"
            foreach ($release in $releases) {
                Write-Host "    -Tag `"$($release.tag_name)`"`n"
                foreach ($item in $release.assets) {
                    Write-Host "    -Asset `"$($item.name)`""
                }
                Write-Host ""
            }
            return
        }

        # -------------------------------
        # DETERMINE RELEASE URL
        # -------------------------------
        if (-not [string]::IsNullOrWhiteSpace($Tag) -and $Tag -ne "latest") {
            $releaseUrl = "https://api.github.com/repos/$Repo/releases/tags/$Tag"
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
            Write-Host "Failed to retrieve release info: $_"
            return
        }

        # -------------------------------
        # FILTER ASSETS
        # -------------------------------
        $releaseAsset = @($release.assets | Where-Object { $_.name -like $Asset })
        if ($releaseAsset.Count -ne 1) {
            if ($releaseAsset.Count -eq 0) {
                Write-Host "No asset found matching '$Asset':`n"
            }
            else {
                Write-Host "Multiple assets found matching '$Asset':`n"
            }
            Write-Host "    Repo:           $($Repo)"
            Write-Host "    Tag:            $($release.tag_name)`n"
            Write-Host "    Available assets:`n"
            foreach ($item in $release.assets) {
                Write-Host "    -Asset `"$($item.name)`""
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

        Write-Host "Downloading asset:`n"
        Write-Host "    Repo:           $($Repo)"
        Write-Host "    Tag:            $($release.tag_name)"
        Write-Host "    Filename:       $filename"
        Write-Host "    URL:            $downloadUrl"
        Write-Host "    Saved To:       $localFile`n"

        try {
            $ProgressPreference = 'SilentlyContinue'
            Invoke-WebRequest -Uri $downloadUrl -OutFile $localFile -ErrorAction Stop
        }
        catch {
            Write-Host "Download failed: $_"
            return
        }

        # -------------------------------
        # EXTRACT ASSET IF REQUIRED
        # -------------------------------
        if ($ExtractArchive -and $filename.ToLower() -match "\.(zip|7z|gz|rar|xz|bz2)$") {
            if (-not (Test-Path $SevenZipPath)) {
                Write-Host "7-Zip is not installed.`n`n   Install 7-Zip:  winget install 7zip`n"
                return
            }
            try {
                Write-Host "Extracting archive:`n"
                Write-Host "    Archive:        $localFile"
                Write-Host "    Extracted To:   $ExtractFolder`n"
                & $SevenZipPath e $localFile -o"$ExtractFolder" -y > $null 2>&1
            }
            catch {
                Write-Host "Extracting failed: $_"
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
                Write-Host "Deleting archive:`n"
                Write-Host "    Archive:        $localFile`n"

                Remove-Item -Path $localFile -Force
            }
            catch {
                Write-Host "Failed to delete archive: $_"
            }
        }
    }

    END {
    }
}
