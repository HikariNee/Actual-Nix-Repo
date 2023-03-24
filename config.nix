{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware.nix
    ];
  
  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
  boot.kernelParams = ["mitigations=off" "nowatchdog" "loglevel=3" "tsc=reliable" "rootfstype=btrfs"];
  boot.kernelPackages = pkgs.linuxPackages_zen;
  networking.hostName = "Tsuki"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.services.systemd-oomd.enable = false;
  # Set your time zone.
  systemd.services.haveged.enable = true;
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
  services.dbus.implementation = "broker";
  environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     haveged
     dbus-broker
     git
     libsForQt5.qtstyleplugin-kvantum
     libsForQt5.breeze-icons
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
        sha256 = "14xw003nyi1z54lgixvnj9ggdhdf6g80ic6in0fnh8viiz5yy6sh";
    };
  in builtins.readFile "${hostsFile}";
}
