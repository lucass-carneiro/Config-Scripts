# This only works for admins
# To use this, do:
# Check if $PROFILE exists (type it in PS)
# If not, create it with New-Item -Path $PROFILE -ItemType File -Force
# Copy this file to $PROFILE

function ln {
    param (
        [string]$Target,  # The file or directory to which the link should point
        [string]$LinkPath # The location where the symbolic link will be created
    )
    
    # Check if the target exists
    if (-not (Test-Path $Target)) {
        Write-Error "Target '$Target' does not exist."
        return
    }

    # Check if the link already exists
    if (Test-Path $LinkPath) {
        Write-Error "Link '$LinkPath' already exists."
        return
    }

    # Create the symbolic link
    try {
        New-Item -Path $LinkPath -ItemType SymbolicLink -Target $Target
        Write-Host "Symbolic link created: '$LinkPath' -> '$Target'"
    } catch {
        Write-Error "Failed to create symbolic link: $_"
    }
}

