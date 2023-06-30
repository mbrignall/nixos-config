{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
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
    packages = [ pkgs.terminus_font ];
    font = "${pkgs.terminus_font}/share/consolefonts/ter-i22b.psf.gz";
    useXkbConfig = true; # use xkbOptions in tty.
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
    extraGroups = [
      "networkmanager"
      "wheel"
      "wireless"
      "docker"
      "audio"
      "libvirtd"
      "input"
      "disk"
      "kvm"
    ];
    shell = pkgs.zsh;
    packages = with pkgs; [ firefox ];
  };

  users.extraGroups.docker.members = [ "mbrignall" ];

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
    cmake
    coreutils
    direnv
    docker
    docker-compose
    editorconfig-core-c
    emacs
    emptty
    eww-wayland
    fd
    font-awesome_5
    fuzzel
    gcc
    gsettings-desktop-schemas
    git
    gimp
    glib
    gnome3.adwaita-icon-theme
    google-chrome
    graphviz
    grim
    python311Packages.grip
    gnumake
    hugo
    ispell
    jdk17
    jq
    nodePackages.js-beautify
    karlender
    libnotify
    libtool
    mako
    maim
    networkmanager-fortisslvpn
    nixfmt
    nodejs
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
    python311Packages.weasyprint
    qemu
    ripgrep
    rnix-lsp
    shellcheck
    shfmt
    slack
    slurp
    nodePackages.stylelint
    swayidle
    swaylock
    terminus-nerdfont
    html-tidy
    vim
    virt-manager
    vulkan-loader
    waybar
    wayland
    wl-clipboard
    wdisplays
    wget
    xdg-utils
    yarn
    zsh
  ];

  nixpkgs.overlays = [
    (import (builtins.fetchTarball
      "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz"))
  ];

  fonts = {
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      font-awesome
      (nerdfonts.override {
        fonts = [ "FiraCode" "FiraMono" "Hack" "DroidSansMono" "Meslo" ];
      })
    ];
  };

  # home.file.".config" = {
  #   source = "sway-dotfiles";
  #   target = ".config";
  # };

  # Disable the X11 window system.

  services.xserver.enable = false;
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;
  virtualisation.docker.enable = true;

  # # Home Manager
  # imports = [ <home-manager/nixos> ];
  # home-manager.users.mbrignall = {
  #   home.stateVersion = "23.05";
  #   home.packages = [ ];

  #   home.file = {
  #     ".config".source = builtins.fetchGit {
  #       url = "https://github.com/mbrignall/sway-dotfiles.git";
  #       ref = "main";
  #     };
  #     ".config".target = ".config";
  #   };
  # };

  # Enable Sway.
  programs.sway.enable = true;
  programs.hyprland.enable = true;

  # Enable ZSH
  programs.zsh.enable = true;

  # If you want to use waybar as your swaybar
  programs.waybar.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken.
  system.stateVersion = "23.05"; # Did you read the comment?
}
