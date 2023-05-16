{
  config,
  pkgs,
  lib,
  ...
}: {
  systemd = {
    extraConfig = ''
      DefaultCPUAccounting=yes
      DefaultMemoryAccounting=yes
      DefaultIOAccounting=yes
    '';
    user.extraConfig = ''
      DefaultCPUAccounting=yes
      DefaultMemoryAccounting=yes
      DefaultIOAccounting=yes
    '';
    services."user@".serviceConfig.Delegate = true;
    services.haveged.enable = true;
    services.NetworkManager-wait-online.enable = false;
    services.systemd-oomd.enable = false;
    services.thermald.enable = true;
    services.ModemManager.enable = false;
    services.bluetooth.enable = false;
    services.rngd.enable = true;
    services."zram-reloader".restartIfChanged = lib.mkForce false;
    services.tlp.enable = true;
 };
  services.journald.extraConfig = "Storage=auto";
  systemd.services.nix-daemon.serviceConfig = {
    CPUWeight = 20;
    IOWeight = 20;
  };
  networking.firewall.allowedTCPPorts = [ 22 ];
}
