# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{

  environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # ./vm.nix
    ];

  environment.sessionVariables = rec {
    HEADPHONES = "50:C2:75:29:C7:6E";
	};

	environment.localBinInPath = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  console = {
    font = "Lat2-Terminus16";
    # keyMap = "us";
    useXkbConfig = true; # use xkb.options in tty.
  };

# named fonts.fonts on 23.05
fonts.packages = with pkgs; [
	noto-fonts
	noto-fonts-emoji
	ultimate-oldschool-pc-font-pack
];

 #  ____             _
# |  _ \  _____   _(_) ___ ___  ___
# | | | |/ _ \ \ / / |/ __/ _ \/ __|
# | |_| |  __/\ V /| | (_|  __/\__ \
# |____/ \___| \_/ |_|\___\___||___/
# devices

 # Enable CUPS to print documents.
 # services.printing.enable = true;

 hardware.bluetooth.enable = true; # enables support for Bluetooth
 hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
 services.blueman.enable = true;

 hardware.trackpoint.speed = 50;
 hardware.trackpoint.sensitivity = 100;

services.mullvad-vpn.enable = true;

# Enable sound with pipewire.
		sound.enable = true;
# hardware.pulseaudio.enable = lib.mkForce false;
	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
# If you want to use JACK applications, uncomment this
		jack.enable = true;
		wireplumber.enable = true;
	};

# nvidia config
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
  prime = {
	  offload = {
		  enable = true;
		  enableOffloadCmd = true;
	  };
	  amdgpuBusId = "PCI:5:0:0";
	  nvidiaBusId = "PCI:1:0:0";
  };

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "Legion5"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };

  # Enable the X11 windowing system.
	services.xserver = {
		enable = true;
		#xkb.layout = "us";
		xkb.options = "eurosign:e,caps:escape";
		autoRepeatDelay = 300;
		autoRepeatInterval = 50;

    desktopManager = {
      xterm.enable = false;
# Enable the KDE Plasma Desktop Environment.
			plasma5.enable = true;
    };

    displayManager = {
        defaultSession = "none+i3";
				sddm.enable = true;
    };

    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        dmenu #application launcher most people use
        i3status # gives you the default i3 status bar
        i3lock #default i3 screen locker
        i3blocks #if you are planning on using i3blocks over i3status
     ];
    };

		windowManager.xmonad = {
			enable = true;
			enableContribAndExtras = true;
			# config = builtins.readFile ./dotfiles/xmonad/xmonad.hs;
		};

		#	displayManager.lightdm.enable = true;
		# desktopManager.xfce.enable = true;
		# windowManager.dwm.package = pkgs.dwm.overrideAttrs (oldAttrs: rec {
		# 		src = builtins.fetchTarball {
		# 		url = "https://github.com/flexbusterman/dwm/archive/flexmaster.tar.gz";
		# 		# sha256 = "0azn8xqh9ig6bk639wywqdx8hay9ch6nk62scij7zs2xd22yv8c4";
		# 		};
		# 		});
		# windowManager.dwm.enable = true;

		# windowManager.bspwm = {
		# 	enable = true;
		# };

		# windowManager.spectrwm = {
		# 	enable = true;
		# };

		# windowManager.awesome = {
		# 	enable = true;
		# };

	};

	services.picom.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # # Enable sound with pipewire.
  # sound.enable = true;
  # hardware.pulseaudio.enable = false;
  # security.rtkit.enable = true;
  # services.pipewire = {
  #   enable = true;
  #   alsa.enable = true;
  #   alsa.support32Bit = true;
  #   pulse.enable = true;
  #   # If you want to use JACK applications, uncomment this
  #   #jack.enable = true;
  #
  #   # use the example session manager (no others are packaged yet so this is enabled by default,
  #   # no need to redefine it in your config for now)
  #   #media-session.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

#   # Define a user account. Don't forget to set a password with ‘passwd’.
#   users.users.flex = {
#     isNormalUser = true;
#     description = "flex";
#     extraGroups = [ "networkmanager" "wheel" ];
# # user packages
#     packages = with pkgs; [
#     ];
#   };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

programs.zsh.enable = true;
users.defaultUserShell = pkgs.zsh;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    haskellPackages.xmobar
    haskellPackages.xmonad
    haskellPackages.xmonad-contrib
    haskellPackages.xmonad-extras
		yt-dlp
		acpi
		alacritty
		bat
		binutils
		bluez
		htop-vim
		cargo
		coreutils
		du-dust
		dunst
		eza
		feh
		figlet
		fzf
		gcc
		git
		gnumake
		gnupg
		killall
		libgccjit
		libnotify
		lshw
		neofetch
		neovim
		nodejs
		p7zip
		pamixer
		pass
		pavucontrol
		polybarFull
		pulsemixer
		ranger
		ripgrep
		rustc
		stalonetray
		sysstat
		themechanger
		tldr
		tmux
		tree
		unzip
		vim
		wget
		xclip
		xlockmore
		xorg.xkill
		xsel
		zplug
		zsh
			(dmenu.overrideAttrs (oldAttrs: rec { src = builtins.fetchTarball { url = "https://github.com/flexbusterman/dmenu/archive/master.tar.gz";
														sha256="15n6c1baba8mfncbzqzdbmv4116yblfm5kl7xl5mf6vpy40y433r";
														}; }))
  ];

programs.dconf.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

boot.blacklistedKernelModules = [ "snd_pcsp" ];

programs.steam = {
  enable = true;
  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
};

#  ____                  _
# / ___|  ___ _ ____   _(_) ___ ___  ___
# \___ \ / _ \ '__\ \ / / |/ __/ _ \/ __|
#  ___) |  __/ |   \ V /| | (_|  __/\__ \
# |____/ \___|_|    \_/ p|_|\___\___||___/
# services

  # systemd.user.services.dropbox = {
  #   description = "Dropbox";
  #   wantedBy = [ "graphical-session.target" ];
  #   environment = {
  #     QT_PLUGIN_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtPluginPrefix;
  #     QML2_IMPORT_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtQmlPrefix;
  #   };
  #   serviceConfig = {
  #     ExecStart = "${lib.getBin pkgs.dropbox}/bin/dropbox";
  #     ExecReload = "${lib.getBin pkgs.coreutils}/bin/kill -HUP $MAINPID";
  #     KillMode = "control-group"; # upstream recommends process
  #     Restart = "on-failure";
  #     PrivateTmp = true;
  #     ProtectSystem = "full";
  #     Nice = 10;
  #   };
  # };

# services.pipewire.wireplumber.configPackages = [
# 	(pkgs.writeTextDir "share/wireplumber/bluetooth.lua.d/51-bluez-config.lua" ''
# 	 bluez_monitor.properties = {
# 	 ["bluez5.enable-sbc-xq"] = true,
# 	 ["bluez5.enable-msbc"] = true,
# 	 ["bluez5.enable-hw-volume"] = true,
# 	 ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
# 	 }
# 	 '')
# ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
