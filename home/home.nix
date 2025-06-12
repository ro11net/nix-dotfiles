# home.nix
# home-manager switch

{ config, pkgs, ... }:

{
  home.username = "christianrolland";
  home.homeDirectory = "/Users/christianrolland";
  home.stateVersion = "23.05"; # Please read the comment before changing.

# Makes sense for user specific applications that shouldn't be available system-wide
  home.packages = [
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/zsh".source = ./zsh;
    # ".zshrc".source = ./zshrc/.zshrc;
    # ".zshrc".source = ./zshrc/.zshrc;
    # ".config/wezterm".source = ~/dotfiles/wezterm;
    # ".config/skhd".source = ~/dotfiles/skhd;
    # ".config/starship".source = ~/dotfiles/starship;
    # ".config/zellij".source = ~/dotfiles/zellij;
    # ".config/nvim".source = ./nvim;
    ".config/nvim/init.lua".source = ./nvim/init.lua;
    ".config/nvim/lua".source = ./nvim/lua;
    # ".config/nvim/after".source = ./nvim/after;
    ".config/nix".source = ./nix;
    # ".config/nix-darwin".source = /Users/christianrolland/nix-dotfiles/nix-darwin;
    ".config/tmux".source = ./tmux;
    # ".config/ghostty".source = ~/dotfiles/ghostty;
    # ".config/aerospace".source = ~/dotfiles/aerospace;
    # ".config/sketchybar".source = ~/dotfiles/sketchybar;
    # ".config/nushell".source = ~/dotfiles/nushell;
  };

  home.sessionVariables = {
  };

  home.sessionPath = [
    "/run/current-system/sw/bin"
    "$HOME/.nix-profile/bin"
  ];
  programs.home-manager.enable = true;
  programs.zsh = {
    enable = true;
    initExtra = ''
      # Add any additional configurations here
      export PATH=/run/current-system/sw/bin:$HOME/.nix-profile/bin:$PATH
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi

      eval "$(/opt/homebrew/bin/brew shellenv)"

      export ZDOTDIR="$HOME/.config/zsh"
    '';
  };
}
