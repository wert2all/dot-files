# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Kyiv";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "uk_UA.UTF-8";
    LC_IDENTIFICATION = "uk_UA.UTF-8";
    LC_MEASUREMENT = "uk_UA.UTF-8";
    LC_MONETARY = "uk_UA.UTF-8";
    LC_NAME = "uk_UA.UTF-8";
    LC_NUMERIC = "uk_UA.UTF-8";
    LC_PAPER = "uk_UA.UTF-8";
    LC_TELEPHONE = "uk_UA.UTF-8";
    LC_TIME = "uk_UA.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    enable=true;
    autorun=true;
    layout = "us";
    xkbVariant = "";

    displayManager.lightdm = {
    	enable = true;
    };
    libinput.enable = true;
  };

  users.defaultUserShell = pkgs.zsh;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.wert2all = {
    isNormalUser = true;
    description = "wert2all";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      telegram-desktop
      jetbrains-toolbox
    ];
    shell = pkgs.zsh;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    vim
    glibc
    git
    gcc
    unzip
    neovim
    lightdm-mini-greeter
    bluetuith
    waybar
    kitty
    alacritty
    zsh
    oh-my-zsh
    fastfetch
    rofi-wayland
    dunst
    libnotify
    pavucontrol
    xfce.xfce4-power-manager
    gnome.gnome-keyring
    cava
    libsecret
    qemu
    qemu_kvm
    libvirt
    swww
    grim
    slurp
    xfce.thunar
    xfce.thunar-archive-plugin
    zoxide
    stow
    eza
    cargo
    php83Packages.composer
    lua54Packages.luarocks
    nodejs_20
];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
   programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
   };

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  programs = {
    zsh.enable = true;
  };

  programs.hyprland = {
	  enable = true;
	  xwayland.enable = true;
  };

  sound.enable = true;
  nixpkgs.config.pulseaudio = true;

  hardware = {
  	opengl.enable  = true;
  	pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };
    bluetooth = {
      enable = true;
      settings = {
      	General = {
		      Experimental = true;
	      };
      };
	  };
  };

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
  system.stateVersion = "23.11"; # Did you read the comment?

}
