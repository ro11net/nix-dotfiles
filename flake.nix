{
  description = "My Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    # nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let

    # Enable Zsh shell
    programs.zsh.enable = true;

    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs;
        [
          # vim
          direnv
          sshs
          glow
          nushell
          carapace
          # neovim
          # vscode
          obsidian
          google-chrome
          brave
          direnv
          # kubectl
          go
          python3
          age
          dive
          # flux
          nodejs
          # pulumi
          sops
          talosctl
          omnictl
          talhelper
          terraform
          trivy
          sketchybar
          # krew
          # tmux
          # google-cloud-sdk
          awscli2
          go-task
          # kustomize
          # docker-client
        ];
      # services.nix-daemon.enable = true;
      nix.settings.experimental-features = "nix-command flakes";
      programs.zsh.enable = true;  # default shell on catalina
      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 4;
      nixpkgs.hostPlatform = "aarch64-darwin";
      # security.pam.enableSudoTouchIdAuth = true;

      users.users.christianrolland.home = "/Users/christianrolland";
      home-manager.backupFileExtension = "backup";
      # nix.configureBuildUsers = true;
      # nix.useDaemon = true;
      ids.gids.nixbld = 350;
      system.primaryUser = "christianrolland";


      # Allow unfree packages
      nixpkgs.config.allowUnfree = true;

      system.defaults = {
        dock.autohide = true;
        dock.mru-spaces = false;
        finder.AppleShowAllExtensions = true;
        finder.FXPreferredViewStyle = "clmv";
        dock.persistent-apps = [
          "/System/Applications/Launchpad.app"
          "/Applications/Spotify.app"
          "/Applications/Slack.app"
          "/Applications/Firefox.app"
          "${pkgs.brave}/Applications/Brave Browser.app"
          "${pkgs.google-chrome}/Applications/Google Chrome.app"
          "/Applications/Gather.app"
          "${pkgs.obsidian}/Applications/Obsidian.app"
          "${pkgs.vscode}/Applications/Visual Studio Code.app"
          "/Applications/kitty.app"
          "/System/Applications/Mail.app"
          "/System/Applications/Calendar.app"
        ];
        # loginwindow.LoginwindowText = "devops-toolbox";
        screencapture.location = "~/Pictures/screenshots";
        # screensaver.askForPasswordDelay = 10;
      };

      # Homebrew packages
      homebrew = {
        enable = true;
        # brews = [
        #   "mas"
        # ];
        casks = [
        #   "hammerspoon"
          "firefox"
          # "wireshark"
          "bitwarden"
          # "docker"
          "font-fira-code"
          "font-fira-code-nerd-font"
          "font-victor-mono-nerd-font"
          "font-roboto-mono-nerd-font"
          "gather"
          "google-chrome"
          "google-drive"
          "kitty"
          "slack"
          "spotify"
          "sf-symbols"
          "zoom"
          "appgate-sdp-client"
          "adobe-acrobat-reader"
          "visual-studio-code"
          # "google-cloud-sdk"
          # "google-chrome"
        #   "iina"
        #   "the-unarchiver"
        ];
        brews = [
          "atuin"
          "asdf"
          "bat"
          "bitwarden-cli"
          "bash"
          "curl"
          "direnv"
          "eza"
          "fzf"
          "git"
          "glab"
          "glow"
          # "imagemagick"
          "jq"
          "jp2a"
          "k9s"
          "mpv"
          "neofetch"
          # "nightlight"
          "nnn"
          "pastel"
          "poppler"
          "ripgrep"
          # "skhd"
          # "sketchybar"
          "spotify_player"
          "starship"
          "tmux"
          "tmuxinator"
          "trash-cli"
          "zsh"
          "nvim"
          "helm"
          "helmfile"
          "fluxcd/tap/flux"
          "krew"
          "kubernetes-cli"
          "kubelogin"
          "pulumi"
          "python"
          "wget"
          "kustomize"
          "hashicorp/tap/vault"
        ];
        taps = [
          "koekeishiya/formulae"
          "smudge/smudge"
          # "homebrew/cask-fonts"
          "FelixKratz/formulae"
          "hashicorp/tap"
          "fluxcd/tap"
          # "go-task/tap/go-task"
        ];

        # masApps = {
        #   "Slack" = 803453959;
        # };
        onActivation.cleanup = "zap";
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
      };
    };
  in
  {
    darwinConfigurations."Christians-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
	configuration
        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.christianrolland = import ./home/home.nix;
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."Christians-MacBook-Pro".pkgs;
  };
}
