{ config, pkgs, ... }:

{
  imports =
    [ ./hardware-configuration.nix ./services.nix ./yubikey-gpg.nix ./zsh.nix ];

  hardware.cpu.amd.updateMicrocode = true;
  boot = {
    extraModulePackages = [ config.boot.kernelPackages.wireguard ];
    loader = {
      systemd-boot = {
        configurationLimit = 2;
        enable = true;
        editor = false;
      };
      timeout = 0;
      efi.canTouchEfiVariables = true;
    };

    kernelParams = ["rw" "quiet" "nvme_core.default_ps_max_latency_us=5500" "vga=current" "acpi_backlight=vendor" "amd_iommu=off"];
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking = {
    hostName = "ataar";
    networkmanager = {
      enable = true;
    };
  };

  time.timeZone = "America/New_York";
  nixpkgs.config.allowUnfree = true;    
  environment.systemPackages = with pkgs; [
    alacritty
    brave
    dmenu
    docker
    docker-compose
    electrum
    feh
    firefox
    git
    gimp
    ghc
    gnupg
    i3lock
    inkscape
    libffi
    libreoffice
    light
    mpd
    mpv
    monero-gui
    mullvad-vpn
    mupdf
    neofetch
    ncmpcpp
    networkmanager
    nicotine-plus
    pavucontrol
    pinentry_gnome
    python3Full
    python37Packages.ipython
    qbittorrent 
    redshift
    riot-desktop
    scrot
    slack
    stalonetray
    tdesktop
    unzip
    vim
    vscodium
    wireguard
    xautolock
    xmobar
    xorg.xf86videoamdgpu
    zsh
    zoom-us
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
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluezFull;
  };
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    package = pkgs.pulseaudioFull;
  };
  hardware.acpilight.enable = true;

  users.users = {
      mhmd = {
          isNormalUser = true;
          home = "/home/mhmd";
          description = "Mohamad Safadieh";
          extraGroups = ["wheel" "audio" "video" "networkmanager" "docker"];
          shell = pkgs.zsh;
          initialPassword = "1234";
          createHome = true;
      };
  };

  security.sudo.wheelNeedsPassword = false;
  
  virtualisation.docker.enable = true;
  system.stateVersion = "19.09";


}

