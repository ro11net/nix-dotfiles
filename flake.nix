{
  description = "My Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    username = "chrisrolland";

    mkSystem = hostname: nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        (configuration hostname)
        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit username; };
          home-manager.users.${username} = import ./home/home.nix;
        }
      ];
    };

    configuration = hostname: { pkgs, ... }: {
      environment.systemPackages = with pkgs;
        [
          sshs
          nushell
          carapace
          go
          python3
          age
          dive
          nodejs
          sops
          talosctl
          talhelper
          terraform
          trivy
          sketchybar
          awscli2
          go-task
        ];

      nix.enable = false; # Determinate Systems manages the Nix installation

      environment.etc."nix/nix.custom.conf".text = ''
        trusted-users = root ${username}
      '';
      programs.zsh.enable = true;
      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 4;
      nixpkgs.hostPlatform = "aarch64-darwin";

      users.users.${username}.home = "/Users/${username}";
      home-manager.backupFileExtension = "backup";
      system.primaryUser = username;

      nixpkgs.config.allowUnfree = true;

      system.defaults = {
        dock.autohide = true;
        dock.mru-spaces = false;
        finder.AppleShowAllExtensions = true;
        finder.FXPreferredViewStyle = "clmv";
        dock.persistent-apps = [
          "/System/Applications/Apps.app"
          "/Applications/Spotify.app"
          "/Applications/Slack.app"
          "/Applications/Firefox.app"
          "/Applications/Brave Browser.app"
          "/Applications/Google Chrome.app"
          "/Applications/Gather.app"
          "/Applications/Obsidian.app"
          "/Applications/Visual Studio Code.app"
          "/Applications/kitty.app"
          "/Applications/Logic Pro.app"
          "/System/Applications/Mail.app"
          "/System/Applications/Calendar.app"
        ];
        screencapture.location = "~/Pictures/screenshots";
        NSGlobalDomain."com.apple.swipescrolldirection" = false;
      };


      homebrew = {
        enable = true;
        casks = [
          "firefox"
          "bitwarden"
          "brave-browser"
          "font-fira-code"
          "font-fira-code-nerd-font"
          "font-sketchybar-app-font"
          "font-victor-mono-nerd-font"
          "font-roboto-mono-nerd-font"
          "gather"
          "google-chrome"
          "google-drive"
          "kitty"
          "obsidian"
          "slack"
          "spotify"
          "sf-symbols"
          "zoom"
          "adobe-acrobat-reader"
          "visual-studio-code"
          "claude-code"
        ];
        brews = [
          "mas"
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
          "gh"
          "glab"
          "glow"
          "jq"
          "k9s"
          "mpv"
          "neofetch"
          "nnn"
          "pastel"
          "poppler"
          "ripgrep"
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
          "wget"
          "kustomize"
          "hashicorp/tap/vault"
        ];
        taps = [
          "FelixKratz/formulae"
          "hashicorp/tap"
          "fluxcd/tap"
        ];

        masApps = {
          "Logic Pro" = 634148309;
        };

        onActivation.cleanup = "zap";
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
      };
    };
  in
  {
    darwinConfigurations = {
      "Chriss-MacBook-Pro" = mkSystem "Chriss-MacBook-Pro";
    };
  };
}
