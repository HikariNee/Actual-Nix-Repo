{
  config,
  pkgs,
  ...
}: {
  boot.kernelModules = [ "wl" ];
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
  boot.loader.grub.useOSProber = true;
  boot.kernelParams = [ "module_blacklist=nouveau" "cgroup_no_v1=all" "systemd.unified_cgroup_hierarchy=yes" "console=tty1" "mitigations=off" "nowatchdog" "tsc=reliable" "rootfstype=btrfs"];
  boot.loader.grub.gfxmodeBios = "1366x768";
  boot.loader.grub.splashImage = null;
  boot.initrd.systemd.enable = true;
  boot.extraModulePackages = [config.boot.kernelPackages.broadcom_sta];
  boot.kernelPackages = pkgs.linuxPackages_zen;
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
  };
}
