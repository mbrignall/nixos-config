{ config, pkgs, ... }:

let configRepoUrl = "https://github.com/mbrignall/sway-dotfiles.git";

in {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  boot.kernelModules = [ "amdgpu" ];

  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];

  hardware.enableAllFirmware = true;

  networking.hostName = "nixos"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/London";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  # Configure keymap in X11
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  hardware.bluetooth = { enable = true; };
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account.
  users.users.mbrignall = {
    isNormalUser = true;
    description = "Martin Brignall";
    extraGroups = [ "networkmanager" "wheel" "wireless" ];
    shell = pkgs.zsh;
    packages = with pkgs; [ firefox ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # System packages
  environment.systemPackages = with pkgs; [
    alacritty
    bc
    bfcal
    blueberry
    brightnessctl
    clang
    coreutils
    direnv
    editorconfig-core-c
    emacs
    eww-wayland
    fd
    font-awesome_5
    fuzzel
    git
    glib
    pkgs.theme-obsidian2
    gnome3.adwaita-icon-theme
    google-chrome
    graphviz
    grim
    jdk17
    jq
    nodePackages.js-beautify
    libnotify
    mako
    maim
    nixfmt
    nodejs_18
    pkgs.openai
    pandoc
    pavucontrol
    plantuml
    powerstat
    python39
    python39Packages.black
    python39Packages.pyflakes
    python39Packages.isort
    pipenv
    python39Packages.nose
    python39Packages.pytest
    ripgrep
    shellcheck
    shfmt
    slack
    slurp
    nodePackages.stylelint
    swayidle
    swaylock
    html-tidy
    vim
    vulkan-loader
    waybar
    wayland
    wl-clipboard
    wdisplays
    xdg-utils
    zsh
  ];

  nixpkgs.overlays = [
    (import (builtins.fetchTarball
      "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz"))
  ];

  fonts.fonts = with pkgs;
    [
      (nerdfonts.override {
        fonts = [ "FiraCode" "FiraMono" "Hack" "DroidSansMono" ];
      })
    ];

  # Disable the X11 window system.
  services.xserver.enable = false;

  # Enable Sway.
  programs.sway.enable = true;

  # Enable ZSH
  programs.zsh.enable = true;

  # If you use elogind (default is setuid)
  # security.pam.services.sway = {
  #   startSession = true;
  #   stopSession = true;
  # };

  # If you want to use dmenu
  # programs.dmenu.enable = true;

  # If you want to use waybar as your swaybar
  # programs.waybar.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken.
  system.stateVersion = "22.11"; # Did you read the comment?
}
