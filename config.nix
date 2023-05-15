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
  
  services.xserver.displayManager.sddm.theme = "${(pkgs.fetchFromGitLab {
  owner = "isseigx";
  repo = "simplicity-sddm-theme";
  rev = "0365a7ddc19099a4047116a7e2dfec6207d8fd59";
  hash = "sha256-Txrz/uHA4vNxX+5cHjPdNZ7M75n7RBM5CLn96Xe+NJ4=";
  })}";

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
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    inxi
    unzip
    clang
    powertop
    auto-cpufreq
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
  hardware.pulseaudio.enable = false;
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
 };
  security.rtkit.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-kde xdg-desktop-portal-gtk];
  }; 
   

  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  zramSwap.enable = true;
  system.stateVersion = "22.11"; # Did you read the comment?
  networking.extraHosts = let
    hostsFile = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts";
      sha256 = "0ma9j18irqv0crq81r9wnyad6fckac2bv1y74p77lwmn3sripg11";
    };
  in
    builtins.readFile "${hostsFile}";
}
