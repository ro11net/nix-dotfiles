# nix-darwin config

nix-darwin + home-manager configuration for Chris's MacBook Pro (Apple Silicon, `aarch64-darwin`).

Manages system packages, macOS defaults, Homebrew apps, and dotfile symlinks declaratively from a single flake.

---

## Repo location

This repo lives at `~/.config/nix-darwin` on the machine. Clone it there:

```bash
git clone <repo-url> ~/.config/nix-darwin
```

---

## Fresh macOS setup (from scratch)

Follow these steps in order on a brand new Mac.

### 1. Xcode Command Line Tools

```bash
xcode-select --install
```

### 2. Determinate Nix

This config uses [Determinate Systems' Nix installer](https://determinate.systems/nix-installer/) rather than the official installer. The flake sets `nix.enable = false` to tell nix-darwin not to manage the Nix installation itself.

```bash
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Restart your shell after this step.

### 3. Homebrew

nix-darwin manages Homebrew packages declaratively but requires Homebrew itself to already be installed.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Follow the post-install instructions to add Homebrew to your PATH (the `eval "$(/opt/homebrew/bin/brew shellenv)"` line).

### 4. Clone this repo

```bash
git clone <repo-url> ~/.config/nix-darwin
```

### 5. Personalise before first run

If you are setting up on a machine with a different username or hostname, update these values in [flake.nix](flake.nix) before proceeding:

- `username` variable (line 16) — must match your macOS username (`whoami`)
- The hostname key in `darwinConfigurations` (line 175) — must match `scutil --get LocalHostName`

### 6. First-time bootstrap

nix-darwin is not installed yet, so you cannot use the `darwin-rebuild` command directly. Use `nix run` to bootstrap:

```bash
nix run nix-darwin -- switch --flake ~/.config/nix-darwin#Chriss-MacBook-Pro
```

This installs nix-darwin, runs home-manager, installs all Homebrew packages, and applies all macOS system defaults. It will take a while on the first run.

### 7. Reload your shell

```bash
exec zsh
```

The `nrs` alias is now available for all future rebuilds.

---

## Applying changes

After the initial bootstrap, rebuild with:

```bash
# Short form (alias defined in home/zsh/aliases)
nrs

# Full form
noglob sudo /run/current-system/sw/bin/darwin-rebuild switch --flake /Users/chrisrolland/.config/nix-darwin#Chriss-MacBook-Pro
```

The `noglob` prefix prevents zsh from expanding the `#` in the flake path.

---

## Repo structure

```
~/.config/nix-darwin/
├── flake.nix          # Single entry point — inputs, system config, Homebrew, macOS defaults
├── flake.lock         # Locked dependency versions
└── home/
    ├── home.nix       # home-manager entry point — wires up dotfile symlinks
    ├── zsh/           # .zshrc, aliases, functions, .zshenv
    ├── git/           # .gitconfig, .gitignore, .gitmessage, per-dir gitconfigs
    ├── kitty/         # Terminal emulator config
    ├── sketchybar/    # macOS status bar config and plugins
    ├── starship/      # Shell prompt (Catppuccin Mocha theme)
    ├── atuin/         # Shell history config
    ├── k9s/           # Kubernetes TUI config
    ├── nix/           # Nix user config (nix.conf overrides)
    └── ...            # Other tool configs (ghostty, nushell, tmux, etc.)
```

### Package management split

| What | Where |
|------|-------|
| CLI dev tools (go, python, terraform, awscli2, etc.) | `flake.nix` → `environment.systemPackages` |
| Homebrew CLI tools (git, gh, nvim, kubectl, helm, etc.) | `flake.nix` → `homebrew.brews` |
| GUI apps (Firefox, Slack, VS Code, Kitty, etc.) | `flake.nix` → `homebrew.casks` |
| Mac App Store apps (Logic Pro, etc.) | `flake.nix` → `homebrew.masApps` |
| Dotfile symlinks | `home/home.nix` → `home.file` |

### Making changes

- **Add a system CLI tool** — add to `environment.systemPackages` in [flake.nix](flake.nix)
- **Add a Homebrew formula or cask** — add to `homebrew.brews` or `homebrew.casks` in [flake.nix](flake.nix)
- **Change a dotfile** — edit the file under `home/`; the symlink into `~/.config/` is already wired up in [home/home.nix](home/home.nix)
- **Add a new dotfile directory** — add a `home.file` entry in [home/home.nix](home/home.nix) and create the directory
- **Change macOS system defaults** — edit `system.defaults` in [flake.nix](flake.nix)
- **Change dock apps** — edit `system.defaults.dock.persistent-apps` in [flake.nix](flake.nix)

---

## Useful aliases

Defined in [home/zsh/aliases](home/zsh/aliases):

| Alias | Expands to |
|-------|------------|
| `nrs` | full nix-darwin rebuild + switch |
| `k` | `kubectl` |
| `cat` | `bat` |
| `ls` | `eza` |
| `vi` | `nvim` |
| `gct` / `gcat` / `gfix` | git commit helpers |
