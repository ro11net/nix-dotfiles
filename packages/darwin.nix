{ pkgs, ... }:

{

      # Install required system packages
      environment.systemPackages = with pkgs; [
        home-manager
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
        # brews = [
        #   "mas"
        # ];
        casks = [
        #   "hammerspoon"
          "firefox"
        #   "iina"
        #   "the-unarchiver"
        ];
        masApps = {
          "Slack" = 803453959;
        };
        onActivation.cleanup = "zap";
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
      };
}
