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
    ".config/atuin".source = ./atuin;
    ".config/kitty".source = ./kitty;
    ".zshrc".source = ./zsh/.zshrc;
    ".zshenv".source = ./zsh/.zshenv;
    # ".zshrc".source = ./zshrc/.zshrc;
    # ".config/wezterm".source = ~/dotfiles/wezterm;
    # ".config/skhd".source = ~/dotfiles/skhd;
    ".config/starship".source = ./starship;
    # ".config/zellij".source = ~/dotfiles/zellij;
    # ".config/nvim".source = ./nvim;
    ".config/nvim/init.lua".source = ./nvim/init.lua;
    ".config/nvim/lua".source = ./nvim/lua;
    # ".config/nvim/after".source = ./nvim/after;
    ".config/nix".source = ./nix;
    # ".config/nix-darwin".source = /Users/christianrolland/nix-dotfiles/nix-darwin;
    ".config/tmux".source = ./tmux;
    ".config/k9s".source = ./k9s;
    # ".config/ghostty".source = ~/dotfiles/ghostty;
    # ".config/aerospace".source = ~/dotfiles/aerospace;
    ".config/sketchybar".source = ./sketchybar;
    # ".config/nushell".source = ~/dotfiles/nushell;

    # git
    ".gitconfig".source = ./git/.gitconfig;
    ".gitignore".source = ./git/.gitignore;
    ".gitmessage".source = ./git/.gitmessage;
    "workspace/.gitconfig-2F".source = ./git/.gitconfig-2F;
    "workspace/.gitconfig-2Fgit".source = ./git/.gitconfig-2F;
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
      export PATH=/go/bin:/run/current-system/sw/bin:$HOME/.nix-profile/bin:$PATH
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi

      eval "$(/opt/homebrew/bin/brew shellenv)"

      export ZDOTDIR="$HOME/.config/zsh"
    '';
  };
}
