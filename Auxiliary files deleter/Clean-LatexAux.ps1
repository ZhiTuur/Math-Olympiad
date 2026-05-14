param(
    [string]$Directory = (Get-Location).Path
)

$ErrorActionPreference = "Stop"

$buildDirectory = (Get-Item -LiteralPath $Directory).FullName
$auxiliaryExtensions = @(
    ".aux",
    ".bbl",
    ".bcf",
    ".blg",
    ".fdb_latexmk",
    ".fls",
    ".idx",
    ".ilg",
    ".ind",
    ".lof",
    ".log",
    ".lot",
    ".nav",
    ".out",
    ".run.xml",
    ".snm",
    ".synctex.gz",
    ".toc",
    ".vrb",
    ".xdv"
)

$texFiles = @(Get-ChildItem -Path (Join-Path -Path $buildDirectory -ChildPath "*.tex") | Where-Object { -not $_.PSIsContainer })

foreach ($tex in $texFiles) {
    $stem = [System.IO.Path]::GetFileNameWithoutExtension($tex.Name)

    foreach ($extension in $auxiliaryExtensions) {
        $path = Join-Path -Path $buildDirectory -ChildPath "$stem$extension"
        if (Test-Path -Path $path) {
            Remove-Item -Path $path -Force
        }
    }
}
