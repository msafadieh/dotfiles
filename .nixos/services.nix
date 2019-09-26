{ config, pkgs, ... }:

{
  systemd.services = {
      "suspend@" = {
          description = "i3lock";
          before = [ "sleep.target" ];

          environment = { DISPLAY = ":0"; };
          serviceConfig = { Type = "forking"; User = "mhmd"; };
          script = "${pkgs.i3lock}/bin/i3lock -c 323232";
          wantedBy = [ "sleep.target" ];
      };
    "mullvad" = {
          enable = true;
          description = "Mullvad VPN";
          script = ''
          PATH=$PATH:/run/current-system/sw/bin/
          ${pkgs.mullvad-vpn}/bin/mullvad-daemon
          '';
          scriptArgs = "%U";
          wantedBy = [ "multi-user.target" ];
      };
  };
  
  services.mpd = {
    enable = true;
    musicDirectory = "/home/mhmd/Music";
    extraConfig = ''
    auto_update 	"yes"


    audio_output {
        type            "pulse"
        name         "pulse audio"
    }

    audio_output {
        type           "fifo"
        name           "FIFO"
        path           "/tmp/mpd.fifo"
        format         "44100:16:2"
    }
    '';

  };

  services.xserver = {
    enable = true;
    displayManager.startx.enable = true;

    windowManager.default = "xmonad";
    windowManager.xmonad = {
          enable = true;
          enableContribAndExtras = true;
          extraPackages = haskellPackages: [
                haskellPackages.libmpd
                haskellPackages.xmonad-contrib
                haskellPackages.xmonad-extras
                haskellPackages.xmonad
                haskellPackages.roman-numerals
                haskellPackages.xmonad-wallpaper
              ];
    };
    xautolock = {
        enable = true;
        time = 15;
        locker = "${pkgs.systemd}/bin/systemctl suspend";
        extraOptions = [ "-detectsleep" "-corners 0-00" ];
    };

    # disabled middle click to I dont press it accidentally
    libinput = {
        enable = true;
        buttonMapping = "1 1 3 4 5 6 7 8 9 10";
    };
    layout = "us,ara";
    xkbOptions = "grp:alt_space_toggle";
    xkbModel = "pc105";
    xkbVariant = ",qwerty";
  };


}
