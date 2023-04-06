{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware.nix
    ];
  
  #  boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
  boot.kernelParams = ["console=tty1" "intel_pstate=disable" "splash" "mitigations=off" "nowatchdog" "quiet" "tsc=reliable" "rootfstype=btrfs"];
  boot.loader.grub.gfxmodeBios = "1366x768";
  boot.loader.grub.extraConfig = "set theme=${pkgs.libsForQt5.breeze-grub}/grub/themes/breeze/theme.txt";  
  boot.loader.grub.splashImage = null;
  boot.initrd.systemd.enable = true;
  boot.initrd.kernelModules = ["i915"];
  boot.plymouth.enable = true;
  boot.plymouth.theme = "breeze";
  boot.kernelPackages = pkgs.linuxPackages_5_15;
  networking.hostName = "Tsuki"; # Define your hostname. #systemd
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.services.systemd-oomd.enable = false;
  systemd.services.ModemManager.enable = false;
  systemd.services.upower.enable = false;
  systemd.services.power-profiles-daemon.enable = false;
  systemd.services.thermald.enable = true;
  systemd.services.accounts-daemon.enable = false;
	services.journald.extraConfig = "Storage=auto";
  
  programs.zsh.enable = true;
  # Set your time zone.
  programs.dconf.enable = true;
  time.timeZone = "Asia/Kolkata";
  users.users.hikari.shell = pkgs.zsh;
  i18n.defaultLocale = "en_GB.UTF-8";
  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  users.users.hikari = {
     isNormalUser = true;
     extraGroups = [ "wheel" "video" "audio" ]; # Enable ‘sudo’ for the user.
     packages = with pkgs; [
     ];
   };

  services.xserver.displayManager.sddm.theme = "${(pkgs.fetchFromGitHub {
    owner = "MarianArlt";
    repo = "kde-plasma-chili";
    rev = "a371123959676f608f01421398f7400a2f01ae06";
    sha256 = "17pkxpk4lfgm14yfwg6rw6zrkdpxilzv90s48s2hsicgl3vmyr3x";
  })}";
  services.dbus.implementation = "broker";
  environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     dbus-broker
     git
     libsForQt5.qtstyleplugin-kvantum
     libsForQt5.breeze-icons
     libsForQt5.breeze-grub
     libsForQt5.breeze-plymouth
     clang
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
 services.xserver.videoDrivers = [ "modesetting" ];
 hardware.opengl.driSupport32Bit = true;
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-kde xdg-desktop-portal-gtk];
  };
  
  services.xserver.enable = true;
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;  
  zramSwap.enable = true;
  #system.copySystemConfiguration = true;
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
  networking.extraHosts = let
    hostsFile = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-gambling-porn/hosts";
        sha256 = "1dpphz6hiqkvqqw2h8jlp08dr68k605y231y8h1mhlhb572iss6x";
    };
  in builtins.readFile "${hostsFile}";
}
