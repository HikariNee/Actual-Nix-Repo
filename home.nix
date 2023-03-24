{ config, pkgs, lib , ... }:
{

  home.username = "hikari";
  home.homeDirectory = "/home/hikari";
  home.stateVersion = "22.11";
  nixpkgs.config = {
  allowUnfree = true;
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.vivaldi.enable = true;
  programs.chromium = {
    enable = true;
    commandLineArgs=["--force-dark-mode" "--enable-features=WebUIDarkMode" "--ignore-gpu-blocklist" "--ozone-platform=x11" "--process-per-site" "--use-gl=egl" "--enable-zero-copy" "--enable-gpu-rasterization"];
    extensions = [{id="cjpalhdlnbpafiamejdnhcphjbkeiagm";} {id="cimiefiiaegbelhefglklhhakcgmhkai";}];
  };  
  programs.zsh = {
    enable = true;
    shellAliases = {
      update = "cd $HOME/Nix-Flake && sudo nixos-rebuild switch --flake .#Tsuki";
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
      AGKOZAK_CMD_EXEC_TIME=5
      AGKOZAK_COLORS_CMD_EXEC_TIME='yellow'
      AGKOZAK_COLORS_PROMPT_CHAR='magenta'
      AGKOZAK_CUSTOM_SYMBOLS=( '⇣⇡' '⇣' '⇡' '+' 'x' '!' '>' '?' )
      AGKOZAK_MULTILINE=0
      AGKOZAK_PROMPT_CHAR=( ❯ ❯ ❮ ) '';

    plugins = with pkgs; [
      {
       name = "agkozak-zsh-prompt";
       src = fetchFromGitHub {
         owner = "agkozak";
         repo = "agkozak-zsh-prompt";
         rev = "v3.7.0";
         sha256 = "1iz4l8777i52gfynzpf6yybrmics8g4i3f1xs3rqsr40bb89igrs";
      };
       file = "agkozak-zsh-prompt.plugin.zsh";
     }];
  };

  home.packages = with pkgs; [
    glxinfo
    neofetch
    krita
    neovim
    ibm-plex
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    (pkgs.nerdfonts.override { fonts = [ "Overpass" ]; })
  ];
}