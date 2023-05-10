{
  config,
  lib,
  pkgs,
  ...
}: {
  boot.kernelModules = [ "wl" ];
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
  boot.loader.grub.useOSProber = true;
  boot.extraModprobeConfig =  "blacklist nouveau \n options nouveau modeset=0 \n options snd_hda_intel power_save=1 \n blacklist btusb bluetooth uvcvideo";
  boot.kernelParams = [ "module_blacklist=nouveau" "cgroup_no_v1=all" "systemd.unified_cgroup_hierarchy=yes" "intel_pstate=disable" "console=tty1" "mitigations=off" "nowatchdog" "tsc=reliable" "rootfstype=btrfs"];
  hardware.cpu.intel.updateMicrocode = true;
  boot.loader.grub.gfxmodeBios = "1366x768";
  boot.loader.grub.splashImage = null;
  boot.initrd.systemd.enable = true;
  boot.extraModulePackages = [config.boot.kernelPackages.broadcom_sta];
  boot.kernelPackages = pkgs.linuxPackages_xanmod_stable;
  boot.kernel.sysctl = {
    "vm.swappiness" = 90; # when swapping to ssd, otherwise change to 1
    "vm.vfs_cache_pressure" = 50;
    "vm.dirty_background_ratio" = 20;
    "vm.dirty_ratio" = 50;
    "kernel.sched_latency_ns" = 4000000;
    "kernel.sched_min_granularity_ns" = 500000;
    "kernel.sched_wakeup_granularity_ns" = 50000;
    "kernel.sched_migration_cost_ns" = 250000;
    "kernel.sched_cfs_bandwidth_slice_us" = 3000;
    "kernel.sched_nr_migrate" = 128;
    "vm.dirty_writeback_centisecs" = 6000;
    "vm.laptop_mode" = 5;
  };
  services.udev.extraRules = lib.mkMerge [
    # autosuspend USB devices
    ''ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="auto"''
    # autosuspend PCI devices
    ''ACTION=="add", SUBSYSTEM=="pci", TEST=="power/control", ATTR{power/control}="auto"''
    # disable Ethernet Wake-on-LAN
    ''ACTION=="add", SUBSYSTEM=="net", NAME=="enp*", RUN+="${pkgs.ethtool}/sbin/ethtool -s $name wol d"''
  ];
  services.power-profiles-daemon.enable = false;
  services.tlp = {
      enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0=75;
        STOP_CHARGE_THRESH_BAT0=80;
        SOUND_POWER_SAVE_ON_AC=0;
        SOUND_POWER_SAVE_ON_BAT=1;
        RUNTIME_PM_ON_AC="on";
        RUNTIME_PM_ON_BAT="auto";
        NATACPI_ENABLE=1;
        TPACPI_ENABLE=1;
        TPSMAPI_ENABLE=1;
        CPU_SCALING_GOVERNER_ON_AC="none";
        CPU_SCALING_GOVERNER_ON_BAT="none";
      };
    };
}
