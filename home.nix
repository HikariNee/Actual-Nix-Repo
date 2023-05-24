{
  config,
  pkgs,
  lib,
  ...
}: {
  home.username = "hikari";
  home.homeDirectory = "/home/hikari";
  home.stateVersion = "22.11";
  nixpkgs.config = {
    allowUnfree = true;
  };
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.zsh = {
    enable = true;
    shellAliases = {
      update = "cd $HOME/Nix-Flake && sudo nixos-rebuild switch --upgrade --flake .#Tsuki";
    };
    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    autocd = true;
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    initExtra = ''
      TYPEWRITTEN_SYMBOL='$'
      TYPEWRITTEN_CURSOR='beam'

    '';

    plugins = with pkgs; [
      {
        name = "typewritten";
        src = fetchFromGitHub {
          owner = "reobin";
          repo = "typewritten";
          rev = "6f78ec20f1a3a5b996716d904ed8c7daf9b76a2a";
          hash = "sha256-qiC4IbmvpIseSnldt3dhEMsYSILpp7epBTZ53jY18x8=";
        };  
        file = "typewritten.plugin.zsh";

      }
    ];
  };

  home.packages = with pkgs; [
    cabal2nix
    thermald
    gzdoom
    element-desktop
    rng-tools
    haveged
    libsForQt5.qtstyleplugin-kvantum
    glfw-wayland
    lightly-boehs
    wireshark
    ibm-plex
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    haskell-language-server
    ghc
    cabal-install
    alacritty
    neovim
    adw-gtk3
    libva-utils
    ormolu
    git
    intel-gpu-tools
    ripgrep
    libsForQt5.keysmith
    libsForQt5.applet-window-buttons
    nurl
    libreoffice-qt
    prismlauncher
    firefox-wayland
  ];
  home.sessionVariables = {
    MOZ_ENABLE_WAYLAND = 1;
    XDG_CURRENT_DESKTOP = "kde";
  };

}
