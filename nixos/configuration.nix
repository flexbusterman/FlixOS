# Edit this conf/home/flex/.configxmonadxmonad.pes;iguration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, xmonad-contexts, ... }:

{

  environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # ./vm.nix
    ];

  environment.sessionVariables = rec {
    HEADPHONES = "50:C2:75:29:C7:6E";
		EDITOR = "nvim";
    BROWSER = "qutebrowser";
	};

	environment.localBinInPath = true;

nix.settings.allowed-users = ["root" "flex"];
nix.settings.trusted-users = ["root" "flex"];

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  # nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  # nix.nixPath = ["/etc/nix/path"];
  # environment.etc =
  #   lib.mapAttrs'
  #   (name: value: {
  #     name = "nix/path/${name}";
  #     value.source = value.flake;
  #   })
  #   config.nix.registry;

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
  };

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
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
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

  # Enable networking
  networking.hostName = "Legion5"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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
		exportConfiguration = true;

  displayManager = {
		gdm.enable = true;
		defaultSession = "none+qtile";
		# sddm.enable = true;
	};

  desktopManager.gnome.enable = true;
	windowManager.qtile.enable = true;

	windowManager.xmonad = {
		enable = true;
		enableContribAndExtras = true;
		ghcArgs = [
			"-hidir /tmp" # place interface files in /tmp, otherwise ghc tries to write them to the nix store
			"-odir /tmp" # place object files in /tmp, otherwise ghc tries to write them to the nix store
			"-i${xmonad-contexts}" # tell ghc to search in the respective nix store path for the module
		];
	};

    # windowManager.awesome = {
    #   enable = true;
    # #   luaModules = with pkgs.luajitPackages; [
    # #     luarocks # is the package manager for Lua modules
				# # luadbi
    # #     luadbi-mysql # Database abstraction layer
    # #   ];
    # };

    # windowManager.i3 = {
    #   enable = true;
    #   extraPackages = with pkgs; [
    #     dmenu #application launcher most people use
    #     i3status # gives you the default i3 status bar
    #     i3lock #default i3 screen locker
    #     i3blocks #if you are planning on using i3blocks over i3status
    #  ];
    # };

# windowManager.dwm.package = pkgs.dwm.override {
# 	conf = ./config.def.h;
#   patches = [
#     # for local patch files, replace with relative path to patch file
#     # ./path/to/local.patch
#     # for external patches
#     (pkgs.fetchpatch {
# 			# https://dwm.suckless.org/patches/systray/
#       url = "https://dwm.suckless.org/patches/systray/dwm-systray-20230922-9f88553.diff";
#       # replace hash with the value from `nix-prefetch-url "https://dwm.suckless.org/patches/path/to/patch.diff" | xargs nix hash to-sri --type sha256`
#       # or just leave it blank, rebuild, and use the hash value from the error
#       hash = "sha256-KeNXvXTxgAFomP/68hljeVLHd9JvXy8WHQ+66nQZCKE=";
#     })
#   ];
# };

# windowManager.dwm.enable = true;

		#	displayManager.lightdm.enable = true;
		# desktopManager.xfce.enable = true;
		# windowManager.dwm.package = pkgs.dwm.overrideAttrs (oldAttrs: rec {
		# 		src = builtins.fetchTarball {
		# 		url = "https://github.com/flexbusterman/dwm/archive/flexmaster.tar.gz";
		# 		# sha256 = "0azn8xqh9ig6bk639wywqdx8hay9ch6nk62scij7zs2xd22yv8c4";
		# 		};
		# 		});
		# windowManager.dwm.enable = true;

		windowManager.bspwm = {
			enable = true;
		};

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

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.flex = {
    isNormalUser = true;
    description = "flex";
    extraGroups = [ "networkmanager" "wheel" "users" "realtime"];
# user packages configured in home manager
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

programs.steam = {
  enable = true;
  remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
};

users.defaultUserShell = pkgs.zsh;

programs.zsh = {
  enable = true;
  enableCompletion = true;
  autosuggestions.enable = true;
  syntaxHighlighting.enable = true;
  shellAliases = {
    ll = "ls -l";
    update = "sudo nixos-rebuild switch";
  };
  # history.size = 10000;
  # history.path = "${config.xdg.dataHome}/zsh/history";
};

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
		python311Packages.iwlib
		qpwgraph
		htop-vim
		btop
		xcalib
		brightnessctl
		ffmpeg
		xdotool
		ncmpcpp
		mpc-cli
		mpd
		ueberzugpp
		sxiv
		maim
		# for awesomewm
    luajitPackages.luarocks
		luajitPackages.luadbi
    # luajitPackages.luadbi-mysql
    # luajitPackages.luadbi-mysql
    # luajitPackages.luarocks
		networkmanagerapplet
# for i3
		# autotiling
		python3
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
  programs.mtr.enable = true;
  programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
   };

boot.blacklistedKernelModules = [ "snd_pcsp" ];

# ____                  _                     _
#/ ___|  ___  _   _ ___| |_ ___ _ __ ___   __| |
#\___ \ / _ \| | | / __| __/ _ \ '_ ` _ \ / _` |
# ___) | (_) | |_| \__ \ ||  __/ | | | | | (_| |
#|____/ \___/ \__, |___/\__\___|_| |_| |_|\__,_|
#             |___/
# systemd services

# prevent 90 seconds waiting on shutdown / reboot
systemd.extraConfig = ''
	DefaultTimeoutStopSec=10s
'';

  systemd.user.services.dropbox = {
    description = "Dropbox";
    wantedBy = [ "graphical-session.target" ];
    environment = {
      QT_PLUGIN_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtPluginPrefix;
      QML2_IMPORT_PATH = "/run/current-system/sw/" + pkgs.qt5.qtbase.qtQmlPrefix;
    };
    serviceConfig = {
      ExecStart = "${lib.getBin pkgs.dropbox}/bin/dropbox";
      ExecReload = "${lib.getBin pkgs.coreutils}/bin/kill -HUP $MAINPID";
      KillMode = "control-group"; # upstream recommends process
      Restart = "on-failure";
      PrivateTmp = true;
      ProtectSystem = "full";
      Nice = 10;
    };
  };

  systemd.user.services.wallpaper = {
    description = "Set wallpaper with feh";
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${lib.getBin pkgs.feh}/bin/feh --bg-fill /home/flex/.local/share/flex/background.jpg";
      ExecReload = "${lib.getBin pkgs.coreutils}/bin/kill -HUP $MAINPID";
      KillMode = "control-group"; # upstream recommends process
      Restart = "on-failure";
      PrivateTmp = true;
      ProtectSystem = "full";
      Nice = 10;
    };
  };

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
  services.openssh.enable = true;

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
  system.stateVersion = "23.11"; # Did you read the comment?

}
# # This is your system's configuration file.
# # Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
# {
#   inputs,
#   lib,
#   config,
#   pkgs,
#   ...
# }: {
#   # You can import other NixOS modules here
#   imports = [
#     # If you want to use modules from other flakes (such as nixos-hardware):
#     # inputs.hardware.nixosModules.common-cpu-amd
#     # inputs.hardware.nixosModules.common-ssd
#
#     # You can also split up your configuration and import pieces of it here:
#     # ./users.nix
#
#     # Import your generated (nixos-generate-config) hardware configuration
#     ./hardware-configuration.nix
#   ];
#
#   nixpkgs = {
#     # You can add overlays here
#     overlays = [
#       # If you want to use overlays exported from other flakes:
#       # neovim-nightly-overlay.overlays.default
#
#       # Or define it inline, for example:
#       # (final: prev: {
#       #   hi = final.hello.overrideAttrs (oldAttrs: {
#       #     patches = [ ./change-hello-to-hi.patch ];
#       #   });
#       # })
#     ];
#     # Configure your nixpkgs instance
#     config = {
#       # Disable if you don't want unfree packages
#       allowUnfree = true;
#     };
#   };
#
#   # This will add each flake input as a registry
#   # To make nix3 commands consistent with your flake
#   nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);
#
#   # This will additionally add your inputs to the system's legacy channels
#   # Making legacy nix commands consistent as well, awesome!
#   nix.nixPath = ["/etc/nix/path"];
#   environment.etc =
#     lib.mapAttrs'
#     (name: value: {
#       name = "nix/path/${name}";
#       value.source = value.flake;
#     })
#     config.nix.registry;
#
#   nix.settings = {
#     # Enable flakes and new 'nix' command
#     experimental-features = "nix-command flakes";
#     # Deduplicate and optimize nix store
#     auto-optimise-store = true;
#   };
#
#   environment.sessionVariables = rec {
#     HEADPHONES = "50:C2:75:29:C7:6E";
# 	};
#
# 	environment.localBinInPath = true;
#
#   nix.settings.experimental-features = [ "nix-command" "flakes" ];
#
#   console = {
#     font = "Lat2-Terminus16";
#     # keyMap = "us";
#     useXkbConfig = true; # use xkb.options in tty.
#   };
#
# # named fonts.fonts on 23.05
# fonts.packages = with pkgs; [
# 	noto-fonts
# 	noto-fonts-emoji
# 	ultimate-oldschool-pc-font-pack
# ];
#
#
#   networking.hostName = "Legion5";
#
#
#   users.users = {
#     flex = {
#       initialPassword = "1234";
#       isNormalUser = true;
#       openssh.authorizedKeys.keys = [
#         # Add your SSH public key(s) here, if you plan on using SSH to connect
#       ];
#       #: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
#       extraGroups = ["wheel" "networkmanager" "audio" "users"];
#     };
#   };
#
#   # This setups a SSH server. Very important if you're setting up a headless system.
#   # Feel free to remove if you don't need it.
#   # services.openssh = {
#   #   enable = true;
#   #   settings = {
#   #     # Forbid root login through SSH.
#   #     PermitRootLogin = "no";
#   #     # Use keys only. Remove if you want to SSH using password (not recommended)
#   #     PasswordAuthentication = false;
#   #   };
#   # };
#
#   # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  # system.stateVersion = "23.11"; # Did you read the comment?
# }
