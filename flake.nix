{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url =  "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, ... }: {

      # Allow unfree packages
      nixpkgs.config.allowUnfree = true;

      # System defaults configuration
      system.defaults = {
        dock.autohide = true;
        dock.persistent-apps = [
          "/System/Applications/Launchpad.app"
          "/Applications/Firefox.app"
          "/Applications/Gather.app"
          "${pkgs.obsidian}/Applications/Obsidian.app"
          "${pkgs.vscode}/Applications/Visual Studio Code.app"
          "/System/Applications/Mail.app"
          "/System/Applications/Calendar.app"
        ];
        finder.FXPreferredViewStyle = "clmv";
        NSGlobalDomain.AppleICUForce24HourTime = true;
        NSGlobalDomain.AppleInterfaceStyle = "Dark";
      };

      # Necessary for using flakes on this system
      nix.settings.experimental-features = "nix-command flakes";

      # Enable Zsh shell
      programs.zsh.enable = true;

      # Set Git commit hash for darwin-version
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Compatibility for old versions
      system.stateVersion = 6;

      # Set primary user
      system.primaryUser = "christianrolland";

      # Platform configuration (Apple Silicon)
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    darwinConfigurations."Christians-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      system = "aarch-darwin";
      modules = [
        configuration
        ./packages/darwin.nix
        nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              enable = true;
              # Apple Silicon only
              enableRosetta = true;
              user = "christianrolland";
            };
          }
          # users.users.christianrolland.home = "/Users/christianrolland";
      ];
      # specialArgs = { inherit inputs; };
    };
  };
}
