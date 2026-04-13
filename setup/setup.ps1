# One-time setup for a new Windows machine.
# Run after OneDrive has synced 5_projects/agent-skills/.
# No admin rights required (uses NTFS junctions, not symlinks).

$skills = "$env:USERPROFILE\OneDrive\5_projects\agent-skills\skills"

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
