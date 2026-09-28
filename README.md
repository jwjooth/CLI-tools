# PowerShell 7 SWE Productivity Stack

A curated, minimal PowerShell 7 profile that boosts CLI productivity with modern tools — fast, clean, and safe.

---

## Quick Install

### 1. Prerequisites

```powershell
pwsh --version
scoop install powershell
```

### 2. Install Tools (via Scoop)

```powershell
scoop install eza fzf zoxide starship ripgrep bat procs dust fd
```

**Alternative (Chocolatey):**

```powershell
choco install eza fzf zoxide starship ripgrep bat
```

| Tool        | Replaces     | Description                        |
|-------------|--------------|------------------------------------|
| **eza**     | `ls`         | Modern file listing with icons     |
| **fzf**     | —            | Fuzzy finder for files & history   |
| **zoxide**  | `cd`         | Smart directory jumper (`z`)       |
| **starship**| —            | Blazing-fast prompt                |
| **ripgrep** | `grep`       | Fast recursive search (`rg`)       |
| **bat**     | `cat`        | Cat clone with syntax highlighting |
| **procs**   | `ps`         | Modern process viewer              |
| **dust**    | `du`         | Disk usage analyzer                |
| **fd**      | `find`       | Simple, fast file finder           |

### 3. Set Your PowerShell Profile

Find your profile path:

```powershell
$PROFILE
# Usually: C:\Users\<You>\Documents\PowerShell\Microsoft.PowerShell profile.ps1
```

Copy the included profile to that location:

```powershell
Copy-Item "$HOME\project\CLI-tools\powershell_profile.ps1" $PROFILE -Force
```

Or manually copy the contents of `powershell_profile.ps1` into `$PROFILE`.

Create supporting directories:

```powershell
New-Item -ItemType Directory -Path $HOME\.config -Force
New-Item -ItemType Directory -Path $HOME\.cache\starship -Force
```

### 4. Add Starship Config

Copy `starship.toml` to `~/.config/starship.toml`:

```powershell
Copy-Item starship.toml $HOME\.config\starship.toml
```

### 5. Install PSFzf (optional)

```powershell
Install-Module -Name PSFzf -Repository PSGallery -Force
```

### 6. Reload

```powershell
. $PROFILE
```

---

## What You Get

### Aliases

| Alias | Maps to |
|-------|---------|
| `ls`  | `eza`           |
| `cat` | `bat`           |
| `grep`| `rg` (ripgrep)  |
| `ps`  | `procs`         |
| `du`  | `dust`          |
| `find`| `fd`            |

> Aliases are only set if the target command exists — no errors thrown on missing tools.

### Custom Functions

| Function | Description                                      |
|----------|--------------------------------------------------|
| `d`      | Fast `cd` shortcut                                |
| `lsd`    | Long-format listing (uses `eza` if available)    |
| `tree`   | Directory tree view (uses `eza -T` if available) |
| `ff`     | Fuzzy-find files with preview, copies result     |
| `kp`     | Kill a process via fuzzy search                   |
| `gg`     | Git log with fzf preview                          |
| `ssh`    | SSH hosts picked interactively via fzf            |

---

## Keybindings

### PSReadLine (built-in)

| Binding         | Action                   |
|-----------------|--------------------------|
| `Tab`           | Menu complete            |
| `Up / Down`     | History search           |
| `Ctrl + R`      | Search history backward  |

### Zoxide

| Binding      | Action                              |
|--------------|-------------------------------------|
| `z <name>`   | Jump to frecency-matched directory  |
| `zi`         | Interactive directory picker        |

### FZF (PSFzf module, optional)

| Binding         | Action              |
|-----------------|---------------------|
| `Ctrl + T`      | Fuzzy search files  |
| `Ctrl + R`      | Fuzzy search history|

---

## Safety & Stability Features

The profile is designed to fail gracefully — every tool is guarded with `Get-Command` checks:

- **Starship** — wraps `starship init` in `try/catch`; falls back to a simple prompt if it fails
- **Zoxide** — only initializes if the command exists
- **Aliases** — each alias is applied only if the replacement tool is installed
- **UTF-8** — forces `chcp 65001` to prevent character corruption

---

## Customization

### Change Starship Prompt Style

Edit `~/.config/starship.toml`:

```toml
[directory]
style = "bold blue"

[git_status]
format = "[$all_status]($style)"
```

### Change bat Theme

Add to `$PROFILE`:

```powershell
$ENV:BAT_THEME = "Nord"
```

Available themes: `Nord`, `Monokai Extended`, `Solarized (light)`, and more.

### Disable Tools You Don't Use

Comment out the relevant section in `powershell_profile.ps1`:

```powershell
# Invoke-Expression (& { (zoxide init powershell | Out-String) })
```

---

## Troubleshooting

### Tool not found?

```powershell
gcm eza; gcm fzf; gcm zoxide; gcm rg; gcm bat
```

### Starship prompt not showing?

```powershell
starship --version
$ENV:STARSHIP_CONFIG  # Should point to ~/.config/starship.toml
```

### FZF not responding?

```powershell
Install-Module -Name PSFzf -Repository PSGallery -Force -Scope CurrentUser
```

### Slow startup?

Reduce scan timeout in `starship.toml`:

```toml
scan_timeout = 10  # milliseconds
```

---

## Philosophy

- **No conflicting aliases** — eza/bat don't override anything weird
- **One prompt engine** — only Starship, no clutter
- **Minimal git module** — just branch + status
- **No language detection** — no Node/Python/Rust in the prompt
- **Clean function set** — only 7 helpers, not 20

---

## Next Steps

1. Install tools via `scoop install eza fzf zoxide starship ripgrep bat procs dust fd`
2. Copy `powershell_profile.ps1` to `$PROFILE`
3. Copy `starship.toml` to `~/.config/starship.toml`
4. Run `. $PROFILE` to reload
5. Test: `z`, `ls`, `cat somefile.txt`, `Ctrl+R`