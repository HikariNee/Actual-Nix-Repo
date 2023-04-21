{
  config,
  pkgs,
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
  };
  services.journald.extraConfig = "Storage=auto";
  systemd.services.nix-daemon.serviceConfig = {
    CPUWeight = 20;
    IOWeight = 20;
  };
}
