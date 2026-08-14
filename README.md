# PowerShell 7 SWE Productivity Stack - Setup Guide

## Quick Install

### 1. Prerequisites
```powershell
# Make sure you have PowerShell 7+
pwsh --version

# Install with scoop or chocolatey
scoop install powershell
```

### 2. Install Tools (via Scoop on Windows)
```powershell
# One-liner for all tools
scoop install eza fzf zoxide starship ripgrep bat

# Or individual:
scoop install eza          # Modern ls
scoop install fzf          # Fuzzy finder
scoop install zoxide       # Smarter cd
scoop install starship     # Prompt
scoop install ripgrep      # Fast grep/search
scoop install bat          # Syntax-highlighted cat
```

**Alternative (Chocolatey):**
```powershell
choco install eza fzf zoxide starship ripgrep bat
```

### 3. Set Your PowerShell Profile
Find where your `$PROFILE` is:
```powershell
$PROFILE
# Usually: C:\Users\YourUsername\Documents\PowerShell\profile.ps1
```

Copy the contents of `powershell_profile.ps1` into that file.

Create directories if they don't exist:
```powershell
New-Item -ItemType Directory -Path $HOME\.config -Force
New-Item -ItemType Directory -Path $HOME\.cache\starship -Force
```

### 4. Add Starship Config
Copy `starship.toml` to `~/.config/starship.toml`:
```powershell
Copy-Item starship.toml $HOME\.config\starship.toml
```

### 5. Install PSFzf (optional but recommended)
```powershell
Install-Module -Name PSFzf -Repository PSGallery -Force
```

### 6. Reload Profile
```powershell
# Reload your profile
. $PROFILE
```

---

## What You Get

### Commands
| Tool | What it does | Usage |
|------|-------------|-------|
| **eza** | Modern `ls` | `ls`, `ll`, `lsa`, `lsT` |
| **fzf** | Fuzzy finder | `Ctrl+T` (search files), `Ctrl+R` (history) |
| **zoxide** | Smarter `cd` | `z projectname`, `zi` (interactive) |
| **starship** | Fast prompt | Shows git status, execution time |
| **ripgrep** | Fast search | `rg "pattern"` (way faster than grep) |
| **bat** | Pretty `cat` | `cat file.txt` (syntax highlighting) |

### Aliases (No Conflicts)
- `ls` → `eza` (with icons, colors)
- `ll` → `eza -lh` (long format)
- `lsa` → `eza -lahF` (all files)
- `cat` → `bat` (with syntax highlighting)
- `rgs` → `rg -B2 -A2` (ripgrep with context)

### Custom Functions
- `ff` - Find files with fzf preview
- `kp` - Kill process by fuzzy search
- `glog` - Git log with fzf preview
- `rgs` - Ripgrep with context lines

---

## Keybindings

### PSReadLine (built-in)
- `Ctrl+R` → Search history backwards
- `Up/Down` → Search history
- `Tab` → Menu complete

### FZF (PSFzf module)
- `Ctrl+T` → Fuzzy search files
- `Ctrl+R` → Fuzzy search history (overrides PSReadLine)

### Zoxide
- `z <name>` → Jump to frecency-matched directory
- `zi` → Interactive fuzzy selector for recent dirs

---

## Customization

### Change Starship Prompt Style
Edit `~/.config/starship.toml`:
```toml
[directory]
style = "bold blue"  # Change color

[git_status]
format = "[$all_status]($style)"  # Show more detail
```

### Change bat Theme
Add to `$PROFILE`:
```powershell
$ENV:BAT_THEME = "Nord"  # or "Monokai Extended", "Solarized (light)", etc.
```

### Disable Tools You Don't Use
Comment out lines in `$PROFILE`:
```powershell
# Invoke-Expression (& { (zoxide init --hook prompt powershell | Out-String) })
```

---

## Troubleshooting

### FZF not working?
```powershell
Install-Module -Name PSFzf -Repository PSGallery -Force -Scope CurrentUser
```

### Starship prompt not showing?
```powershell
# Check if starship is installed
starship --version

# Check config path
$ENV:STARSHIP_CONFIG
# Should be: C:\Users\YourUsername\.config\starship.toml
```

### Command not found?
```powershell
# Verify tool is in PATH
gcm eza
gcm fzf
gcm zoxide
gcm ripgrep
gcm bat
```

### Slow startup?
Reduce scan_timeout in `starship.toml`:
```toml
scan_timeout = 10    # milliseconds
```

---

## What's NOT Overengineered Here

✅ No conflicting aliases (eza doesn't override anything weird)  
✅ Only 1 prompt engine (starship, not multiple)  
✅ Minimal git module config (just branch + status)  
✅ No language runtime detection (no node/python/rust prompts)  
✅ Clean function set (only 4 helpers, not 20)  
✅ No complex keybindings (just PSReadLine defaults + FZF)

If you want less, remove what you don't use. If you want more, ask for specific additions.

---

## Next Steps

1. Install tools via scoop
2. Copy profile to `$PROFILE`
3. Copy starship config to `~/.config/starship.toml`
4. Run `. $PROFILE` to reload
5. Test: `z`, `ls`, `cat somefile.txt`, `Ctrl+T`

Done. Now your CLI is faster.
