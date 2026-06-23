# home.nix

{ config, pkgs, lib, username, ... }:

{
  home.username = username;
  home.homeDirectory = "/Users/${username}";
  home.stateVersion = "23.05"; # Please read the comment before changing.

  home.packages = [
  ];

  home.file = {
    ".config/zsh".source = ./zsh;
    ".config/atuin".source = ./atuin;
    ".config/kitty".source = ./kitty;
    ".zshenv".source = ./zsh/.zshenv;
    ".config/starship".source = ./starship;
    ".config/nix".source = ./nix;
    ".config/k9s".source = ./k9s;
    ".config/sketchybar".source = ./sketchybar;


    # Uncomment to enable:
    # ".config/nvim".source = ./nvim;
    # ".config/tmux".source = ./tmux;
    # ".config/ghostty".source = ./ghostty;
    # ".config/nushell".source = ./nushell;
    # ".config/zellij".source = ./zellij;
    # ".config/hammerspoon".source = ./hammerspoon;

    # git
    ".gitconfig".source = ./git/.gitconfig;
    ".gitignore".source = ./git/.gitignore;
    ".gitmessage".source = ./git/.gitmessage;
    "workspace/.gitconfig-dev".source = ./git/.gitconfig-dev;
    "workspace/.gitconfig-2Fgit".source = ./git/.gitconfig-2Fgit;
  };

  home.sessionPath = [
    "/run/current-system/sw/bin"
    "$HOME/.nix-profile/bin"
  ];

  # UAD Meter & Control Panel has & in its path, which breaks nix-darwin's plist generation.
  # Inject it directly into the dock plist after nix-darwin sets the dock.
  home.activation.uadMeterDock = lib.hm.dag.entryAfter ["writeBoundary"] ''
    /usr/bin/python3 - <<'EOF'
import plistlib, os, sys

plist_path = os.path.expanduser("~/Library/Preferences/com.apple.dock.plist")
uad_path = "/Applications/Universal Audio/UAD Meter & Control Panel.app"

if not os.path.isdir(uad_path):
    sys.exit(0)

with open(plist_path, 'rb') as f:
    plist = plistlib.load(f)

apps = plist.get('persistent-apps', [])
paths = [e.get('tile-data', {}).get('file-data', {}).get('_CFURLString', "") for e in apps]

if uad_path not in paths:
    apps.append({'tile-data': {'file-data': {'_CFURLString': uad_path, '_CFURLStringType': 0}}})
    plist['persistent-apps'] = apps
    with open(plist_path, 'wb') as f:
        plistlib.dump(plist, f, fmt=plistlib.FMT_BINARY)
    os.system("killall Dock 2>/dev/null")
EOF
  '';

  home.activation.dockerBuildx = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p "$HOME/.config/docker/cli-plugins"
    buildxPlugin="/Applications/Docker.app/Contents/Resources/cli-plugins/docker-buildx"
    if [ -f "$buildxPlugin" ] && [ ! -e "$HOME/.config/docker/cli-plugins/docker-buildx" ]; then
      ln -s "$buildxPlugin" "$HOME/.config/docker/cli-plugins/docker-buildx"
    fi
  '';

  programs.home-manager.enable = true;
  programs.zsh = {
    enable = true;
    initContent = ''
      export PATH=/go/bin:/run/current-system/sw/bin:$HOME/.nix-profile/bin:$PATH
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
      eval "$(/opt/homebrew/bin/brew shellenv)"
      export ZDOTDIR="$HOME/.config/zsh"
    '';
  };
}
