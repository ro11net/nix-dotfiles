{ pkgs, self, inputs, ... }:

{
  services.nix-daemon.enable = true;

  nix.package = pkgs.nix;
  nix.settings.experimental-features = "nix-command flakes";
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnsupportedSystems = true;
    };
    hostPlatform = "aarch64-darwin";
  };

      # Install required system packages
  environment.systemPackages = with pkgs; [
        neovim
        vscode
        obsidian
        google-chrome
        brave
        direnv
        kubectl
  ];

    # Homebrew packages
  homebrew = {
    enable = true;
    brews = [
        "mas"
    ];
    casks = [
        "hammerspoon"
        "firefox"
        "iina"
        "the-unarchiver"
    ];
    masApps = {
        "Slack" = 803453959;
    };
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };
#   networking.hostName = "mbp";

  programs.zsh.enable = true;

  users.users."christianrolland" = {
    home = "/Users/christianrolland";
    shell = pkgs.zsh;
    # openssh.authorizedKeys.keys = [
    #   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIOsUvi/j/2Gs8QkZ5S0/bGsK/BhmU8n24eDFCc7GZx9 cardno:13_494_293"
    # ];
  };

  programs.gnupg = {
    agent.enable = false;
    agent.enableSSHSupport = true;
  };


    # System defaults configuration
  system.defaults = {
    dock.autohide = true;
    dock.persistent-apps = [
        "/Applications/Firefox.app"
        "/Applications/Gather.app"
        "/Applications/Launchpad.app"
        "${pkgs.obsidian}/Applications/Obsidian.app"
        "${pkgs.vscode}/Applications/Visual Studio Code.app"
        "/System/Applications/Mail.app"
        "/System/Applications/Calendar.app"
    ];
    finder.FXPreferredViewStyle = "clmv";
    NSGlobalDomain.AppleICUForce24HourTime = true;
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
  };

  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 6;

  # Set primary user
  system.primaryUser = "christianrolland";

        darwinConfigurations."Christians-MacBook-Pro" = nix-darwin.lib.darwinSystem {
          modules = [
            configuration
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                enableRosetta = true;
                user = "christianrolland";
              };
            }
          ];
        };
}