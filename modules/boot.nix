{
  config,
  lib,
  pkgs,
  ...
}: {
  boot.kernelModules = [ "wl" ];
  boot.loader.systemd-boot.configurationLimit = 15;
  boot.loader.systemd-boot.enable = true;
  boot.extraModprobeConfig =  "blacklist nouveau \n options nouveau modeset=0 \n options snd_hda_intel power_save=1 \n blacklist btusb bluetooth uvcvideo";
  boot.kernelParams = [ "module_blacklist=nouveau" "cgroup_no_v1=all" "systemd.unified_cgroup_hierarchy=yes" "console=tty1" "mitigations=off" "nowatchdog" "tsc=reliable" "rootfstype=btrfs"];
  hardware.cpu.intel.updateMicrocode = true;
  boot.loader.efi.canTouchEfiVariables = true;
    
  boot.initrd.systemd.enable = true;
  boot.extraModulePackages = [config.boot.kernelPackages.broadcom_sta];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  services.udev.extraRules = ''# Remove NVIDIA USB xHCI Host Controller devices, if present
    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c0330", ATTR{power/control}="auto", ATTR{remove}="1"

    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x0c8000", ATTR{power/control}="auto", ATTR{remove}="1"

    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x040300", ATTR{power/control}="auto", ATTR{remove}="1"

    ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x03[0-9]*", ATTR{power/control}="auto", ATTR{remove}="1"'';

  boot.kernel.sysctl = {
    "vm.swappiness" = 30; # when swapping to ssd, otherwise change to 1
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
  services.power-profiles-daemon.enable = false;
  services.thermald.enable = true;
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
