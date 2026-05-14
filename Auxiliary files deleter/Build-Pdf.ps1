param(
    [string]$TexFile = "",
    [string]$Directory = (Get-Location).Path
)

$ErrorActionPreference = "Stop"

$buildDirectory = (Get-Item -LiteralPath $Directory).FullName
$scriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
$cleanScript = Join-Path -Path $scriptDirectory -ChildPath "Clean-LatexAux.ps1"

if ($TexFile) {
    $sources = @(Get-Item -LiteralPath (Join-Path -Path $buildDirectory -ChildPath $TexFile))
}
else {
    $sources = @(Get-ChildItem -Path (Join-Path -Path $buildDirectory -ChildPath "*.tex") | Where-Object { -not $_.PSIsContainer })
}

if ($sources.Count -eq 0) {
    throw "No .tex files found in $buildDirectory."
}

Push-Location -LiteralPath $buildDirectory
try {
    & powershell -NoProfile -ExecutionPolicy Bypass -File $cleanScript -Directory $buildDirectory

    foreach ($source in $sources) {
        if (Get-Command latexmk -ErrorAction SilentlyContinue) {
            & latexmk -pdf -interaction=nonstopmode -halt-on-error $source.Name
            if ($LASTEXITCODE -ne 0) {
                throw "latexmk failed for $($source.Name) with exit code $LASTEXITCODE."
            }
        }
        elseif (Get-Command pdflatex -ErrorAction SilentlyContinue) {
            & pdflatex -interaction=nonstopmode -halt-on-error $source.Name
            if ($LASTEXITCODE -ne 0) {
                throw "pdflatex failed for $($source.Name) with exit code $LASTEXITCODE."
            }

            & pdflatex -interaction=nonstopmode -halt-on-error $source.Name
            if ($LASTEXITCODE -ne 0) {
                throw "pdflatex failed for $($source.Name) with exit code $LASTEXITCODE."
            }
        }
        else {
            throw "Could not find latexmk or pdflatex on PATH."
        }
    }
}
finally {
    & powershell -NoProfile -ExecutionPolicy Bypass -File $cleanScript -Directory $buildDirectory
    Pop-Location
}
