# ============================================================================
# MINIMAL POWERSHELL 7 PROFILE - STABLE & CLEAN
# ============================================================================

# 1. Force UTF-8 to prevent character corruption (common cause of weird chars)
$OutputEncoding = [System.Text.Encoding]::UTF8
chcp 65001 | Out-Null

# 2. Disable Telemetry for speed
$env:POWERSHELL_TELEMETRY_OPTOUT = 1

# --- PROMPT: STARSHIP (Configured Safely) -----------------------------------
# We check existence first. If it fails or leaks codes, we fallback to default PS prompt.
if (Get-Command starship -ErrorAction SilentlyContinue) {
    try {
        # Initialize Starship silently
        $null = starship init powershell | Invoke-Expression
        
        # CRITICAL FIX: Ensure Starship doesn't output raw text if something goes wrong
        # Some versions leak config errors into stdout. We suppress non-error streams.
    } catch {
        Write-Warning "Starship failed to load cleanly. Falling back to default prompt."
        # Explicitly reset prompt to standard PowerShell if Starship breaks the terminal
        function global:prompt { 
            "$($PWD.Path)> " 
        }
    }
} else {
    # Fallback if Starship is not installed
    function global:prompt { 
        "$($PWD.Path)> " 
    }
}

# --- TOOLING: ZOXIDE --------------------------------------------------------
if (Get-Command zoxide -ErrorAction SilentlyContinue) {
    # Use the official installer method which is less prone to parsing errors
    Invoke-Expression (& { (zoxide init powershell | Out-String) })
}

# --- READLINE: KEYBINDINGS --------------------------------------------------
if (Get-Module -ListAvailable -Name PSReadLine) {
    Import-Module PSReadLine
    
    # Only set handlers if module loaded successfully
    Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
    Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
    Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
    
    # Prevent bell sound on error (annoying in terminals)
    Set-PSReadLineOption -BellStyle None
}

# --- ALIASES: SAFE MAPPING --------------------------------------------------
# Instead of complex loops that might fail, explicit checks are faster and cleaner
$aliases = @{
    ls   = 'eza'
    cat  = 'bat'
    grep = 'rg'
    ps   = 'procs'
    du   = 'dust'
    find = 'fd'
}

foreach ($key in $aliases.Keys) {
    $target = $aliases[$key]
    if (Get-Command $target -ErrorAction SilentlyContinue) {
        Set-Alias $key $target -Force -Option AllScope
    }
}

# --- FUNCTIONS: UTILITY -----------------------------------------------------

# Fast CD
function d { Set-Location @args }

# List Details
function lsd {
    if (Get-Command eza -ErrorAction SilentlyContinue) { eza -lhF @args }
    else { Get-ChildItem @args }
}

# Tree View
function tree {
    if (Get-Command eza -ErrorAction SilentlyContinue) { eza -T --level=2 @args }
    else { Get-ChildItem @args }
}

# Fuzzy Find Files
function ff {
    if ((Get-Command fd -ErrorAction SilentlyContinue) -and (Get-Command fzf -ErrorAction SilentlyContinue)) {
        $f = fd --type f --strip-cwd-prefix | fzf --preview 'bat --color=always {}'
        if ($f) { $f | Set-Clipboard; Write-Host "Copied: $f" -ForegroundColor Green }
    } else {
        Write-Error "Requires fd and fzf"
    }
}

# Kill Process
function kp {
    if ((Get-Command procs -ErrorAction SilentlyContinue) -and (Get-Command fzf -ErrorAction SilentlyContinue)) {
        $p = procs | fzf
        if ($p) {
            $id = ($p -split '\s+')[0]
            Stop-Process -Id $id -Confirm:$false
            Write-Host "Killed PID: $id" -ForegroundColor Red
        }
    } else {
        Write-Error "Requires procs and fzf"
    }
}

# Git Log Fuzzy
function gg {
    if (Get-Command fzf -ErrorAction SilentlyContinue) {
        git log --oneline --graph --all | fzf --preview 'git show --color=always {1}'
    } else {
        git log --oneline --graph --all
    }
}

# SSH Helper
function ssh {
    if ($args.Count -eq 0) {
        if (Get-Command fzf -ErrorAction SilentlyContinue) {
            $configPath = Join-Path $HOME '.ssh\config'
            if (Test-Path $configPath) {
                $hosts = Get-Content $configPath | 
                    Where-Object { $_ -match '^\s*Host\s+' } | 
                    ForEach-Object { ($_ -replace '^\s*Host\s+', '').Trim() } |
                    Sort-Object -Unique
                
                $selected = $hosts | fzf
                if ($selected) {
                    & (Get-Command ssh -CommandType Application).Source $selected
                }
            } else {
                Write-Error "SSH config not found at $configPath"
            }
        } else {
            Write-Error "Requires fzf for interactive mode"
        }
    } else {
        & (Get-Command ssh -CommandType Application).Source @args
    }
}
