{ config, pkgs, ... }:

{
  imports =
    [ ./hardware-configuration.nix ./services.nix ./yubikey-gpg.nix ./zsh.nix ];

  boot = {
    extraModulePackages = [ config.boot.kernelPackages.wireguard ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernelParams = ["rw" "quiet" "nvme_core.default_ps_max_latency_us=5500" "vga=current" "acpi_backlight=vendor" "amd_iommu=off"];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking.hostName = "ataar";
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";
    
  nixpkgs.config.allowUnfree = true; 
  environment.systemPackages = with pkgs; [
    alacritty
#    linuxPackages.amdgpu-pro
    compton
    dmenu
    feh
    firefox
    git
    gimp
    ghc
    gnupg
    i3lock
    inkscape
    light
    mpd
    mullvad-vpn
    mupdf
    neofetch
    ncmpcpp
    networkmanager
    pavucontrol
    pinentry_gnome
    python3Full
    python37Packages.ipython 
    redshift
    riot-desktop
    scrot
    unzip
    vim
    vscodium
    wireguard
    xautolock
    xorg.xf86videoamdgpu
    xmobar
    zsh
    zsh-syntax-highlighting
  ];

  fonts.fonts = with pkgs; [
    anonymousPro
    fira-code
    terminus_font
    iosevka
  ];


  programs.gnupg.agent = { 
    enable = true;
    enableSSHSupport = true;
  };

  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
  };
  nixpkgs.config.pulseaudio = true;
  hardware.acpilight.enable = true;

  users.users = {
      mhmd = {
          isNormalUser = true;
          home = "/home/mhmd";
          description = "Mohamad Safadieh";
          extraGroups = ["wheel" "audio" "video" "networkmanager"];
          shell = pkgs.zsh;
          initialPassword = "1234";
          createHome = true;
      };
  };

  security.sudo.extraRules = [
    { commands = [ { command = "ALL"; options = [ "NOPASSWD" ]; } ]; groups = [ "wheel" ]; }
  ];

  system.stateVersion = "19.09";

}

