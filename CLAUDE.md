# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

A nix-darwin flake configuration for Chris's MacBook Pro (Apple Silicon, `aarch64-darwin`). It manages both system-level config via nix-darwin and user environment via home-manager, with Homebrew handling GUI apps and some CLI tools.

## Applying Changes

```bash
# Short form (alias defined in home/zsh/aliases)
nrs

# Full form
noglob sudo /run/current-system/sw/bin/darwin-rebuild switch --flake /Users/chrisrolland/.config/nix-darwin#Chriss-MacBook-Pro
```

The `noglob` prefix is required to prevent zsh from expanding the `#` in the flake path.

## Architecture

### Entry Point

[flake.nix](flake.nix) is the single entry point. It defines:
- Flake inputs: `nixpkgs` (unstable), `nix-darwin`, `home-manager`
- One system config: `darwinConfigurations."Chriss-MacBook-Pro"`
- System packages, macOS defaults, Homebrew config, and home-manager module all live here

### User Config

[home/home.nix](home/home.nix) is the home-manager entrypoint. It primarily sets up `home.file` symlinks from the repo into `~/.config/` and `~/`. Tool-specific configs live in subdirectories:

- `home/zsh/` — zsh rc, aliases, functions, `.zshenv`
- `home/git/` — `.gitconfig`, `.gitmessage`, `.gitignore`
- `home/sketchybar/` — macOS status bar config and plugins
- `home/kitty/` — terminal config
- `home/starship/` — prompt (Catppuccin Mocha theme)
- `home/atuin/`, `home/k9s/`, `home/nix/`, etc.

### Package Management Split

| What | Where |
|------|-------|
| CLI dev tools (go, python, terraform, awscli2, talosctl, sops, etc.) | `flake.nix` → `environment.systemPackages` |
| Homebrew CLI tools (git, gh, fzf, nvim, kubectl, helm, vault, etc.) | `flake.nix` → `homebrew.brews` |
| GUI apps (Firefox, Slack, VS Code, Kitty, etc.) | `flake.nix` → `homebrew.casks` |
| Mac App Store apps (Logic Pro, etc.) | `flake.nix` → `homebrew.masApps` |
| Dotfile symlinks | `home/home.nix` → `home.file` |

### Useful Aliases (home/zsh/aliases)

- `nrs` — rebuild and switch nix config
- `k` / `kak` / `kge` — kubectl shortcuts
- `gct` / `gcat` / `gfix` — git commit helpers
- `cat=bat`, `ls=eza`, `vi=nvim`

## Making Changes

- **Add a system CLI tool**: add to `environment.systemPackages` in `flake.nix`
- **Add a Homebrew formula/cask**: add to `homebrew.brews` or `homebrew.casks` in `flake.nix`
- **Add/change a dotfile**: edit the file under `home/`, the symlink is already wired up in `home.nix`
- **Add a new dotfile dir**: add a `home.file` entry in `home/home.nix` and create the dir
- **Change macOS system defaults**: edit `system.defaults` in `flake.nix`
- **Change dock apps**: edit `system.defaults.dock.persistent-apps` in `flake.nix`
