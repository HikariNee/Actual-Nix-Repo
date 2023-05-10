{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware.nix
    ./modules/systemd.nix
    ./modules/boot.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  networking.hostName = "Tsuki"; # Define your hostname. #systemd
  networking.networkmanager.enable = true;
  networking.wireless.iwd.enable = true;
  networking.networkmanager.wifi.backend = "iwd";
  networking.dhcpcd.extraConfig = "noarp";
  nix.extraOptions = ''
    keep-outputs = true
    keep-derivations = true
  '';
  programs.zsh.enable = true;

  # Set your time zone.
  programs.dconf.enable = true;
  time.timeZone = "Asia/Kolkata";
  users.users.hikari.shell = pkgs.zsh;
  i18n.defaultLocale = "en_GB.UTF-8";
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiIntel # LIBVA_DRIVER_NAME=iHD
    ];
  };

  users.users.hikari = {
    isNormalUser = true;
    extraGroups = ["wheel" "video" "audio"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
    ];
  };

  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  services.xserver.displayManager.sddm.theme = "breeze";
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    inxi
    unzip
    clang
    gnomeExtensions.blur-my-shell
    gnomeExtensions.material-you-color-theming   
  ];
  nixpkgs.config.allowUnfree = true;

  programs = {
    mtr = {
      enable = true;
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
  hardware.opengl.driSupport32Bit = true;
#  services = {
 #   pipewire = {
  #    enable = true;
   #   alsa.enable = true;
    #  pulse.enable = true;
    #};
 # };
  security.rtkit.enable = true;
  xdg.portal = {
    enable = true;
  };

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  zramSwap.enable = true;
  system.stateVersion = "22.11"; # Did you read the comment?
  networking.extraHosts = let
    hostsFile = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts";
      sha256 = "0w25s0dbl2c53r8gi349i4fp9zqwdr99qhja12vl0p092k6fb8gk";
    };
  in
    builtins.readFile "${hostsFile}";
}
