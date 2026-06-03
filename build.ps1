# Compile all .twee sources into a single SugarCube 2 HTML file.

$ErrorActionPreference = "Stop"
$root = $PSScriptRoot
$out = Join-Path $root "NursingSimulations.html"

# Prefer local tweego install (tweego-* folder in project root).
$tweego = "tweego"
$tweegoDir = Get-ChildItem -Path $root -Directory -Filter "tweego-*" -ErrorAction SilentlyContinue | Select-Object -First 1
if ($tweegoDir) {
    $tweegoExe = Join-Path $tweegoDir.FullName "tweego.exe"
    if (Test-Path $tweegoExe) { $tweego = $tweegoExe }
}

# Story format: use Tweego's built-in sugarcube-2 (from tweego's storyformats folder).
# A copy of the format may also exist at .\sugarcube-2 for reference or Twine editor use.
$formatArg = "sugarcube-2"

$inputs = @(
    (Get-ChildItem -Path (Join-Path $root "twee") -Filter "*.twee" -File).FullName
    (Get-ChildItem -Path (Join-Path $root "twee\Sims") -Filter "*.twee" -File).FullName
)
if ($inputs.Count -eq 0) {
    Write-Error "No .twee files found under twee\ or twee\Sims\"
}

& $tweego -f $formatArg -o $out @inputs
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
Write-Host "Built: $out ($($inputs.Count) source files)"
