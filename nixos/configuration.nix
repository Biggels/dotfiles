# This is the file to edit for system-wide programs and settings.
{ pkgs, ... }:

{
  # This file is created for this computer by `nixos-generate-config`.
  imports = [
    ./hardware-configuration.nix
  ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # NVIDIA's userspace driver and Discord are unfree software.
  nixpkgs.config.allowUnfree = true;

  # Networking and regional settings
  networking.hostName = "bixos-ibp-9290";
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  # Desktop
  services.xserver.enable = true;
  services.xserver.xkb.layout = "us";
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Graphics
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics.enable = true;
  hardware.nvidia.open = true;

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # User account
  users.users.biggels = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
  };

  # Programs with dedicated NixOS options go here.
  programs.firefox.enable = true;
  programs.git = {
    enable = true;
    config.init.defaultBranch = "main";
  };

  # Other system-wide programs go in this list.
  environment.systemPackages = with pkgs; [
    discord
    emacs
    stow
  ];

  # Keep this at the version used for the first installation of this system.
  system.stateVersion = "26.05";
}
