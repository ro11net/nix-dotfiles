# nix-dotfiles

## Getting Started From Scratch

```shell
sudo mkdir -p ~/.config/
git clone https://github.com/ro11net/nix-dotfiles.git ~/.config/nix
sudo chown $(id -nu):$(id -ng) ~/.config/nix
cd ~/.config/nix

# To use Nixpkgs unstable:
nix flake init -t nix-darwin/master --extra-experimental-features "nix-command flakes"

sed -i '' "s/Christians/MacBook-Pro/$(scutil --get LocalHostName)/" flake.nix
```

### Install the flake

```shell
sudo nix run nix-darwin --extra-experimental-features "nix-command flakes" -- switch --flake ~/.config/nix
```

### Update after modifying the **flake.nix**

```shell
sudo darwin-rebuild switch --flake ~/.config/nix
```

