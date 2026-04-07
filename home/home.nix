# home.nix

{ config, pkgs, username, ... }:

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
