# One-time setup for a new Windows machine.
# Run from anywhere — the script locates itself and derives the skills path.
# Usage: & "C:\path\to\agent-skills\setup\setup.ps1"
# No admin rights required (uses NTFS junctions, not symlinks).

$skills = (Resolve-Path "$PSScriptRoot\..\skills").Path

if (-not (Test-Path $skills)) {
    Write-Error "Skills folder not found at $skills. Make sure OneDrive has finished syncing."
    exit 1
}

$targets = @(
    "$env:USERPROFILE\.claude\skills",
    "$env:USERPROFILE\.cursor\skills"
)

foreach ($t in $targets) {
    if (Test-Path $t) {
        $backup = "$t.bak"
        Move-Item $t $backup -Force
        Write-Host "Backed up existing: $t -> $backup"
    }
    cmd /c "mklink /J `"$t`" `"$skills`"" | Out-Null
    Write-Host "Linked: $t -> $skills"
}

Write-Host "Done. Both Claude Code and Cursor now use: $skills"
