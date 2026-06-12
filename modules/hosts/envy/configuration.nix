{self, inputs, ...}: {
  flake.nixosModules.envyConfiguration = {pkgs, lib, ...}: {
    imports = [
      self.nixosModules.envyMachineHardware
      self.nixosModules.niri
    ];

  # --- Bootloader & Kernel ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # --- Networking ---
  networking.hostName = "nixos";
  networking.networkmanager.enable = true; # Ensure NM is active if using the group
  networking.firewall.allowedTCPPorts = [ 53317 ]; # LocalSend
  networking.firewall.allowedUDPPorts = [ 53317 ];

  # --- Bluetooth ---
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;


  # --- User Configuration ---
  users.users."dav" = {
    isNormalUser = true;
    description = "David Denny George";
    extraGroups = [ "networkmanager" "wheel" "video" ]; # Added 'video' for brightnessctl
    shell = pkgs.fish;
  };

  # --- Desktop Environment & WM ---
  
  services.xserver.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.displayManager.sddm.enable = true;
  
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  programs.waybar.enable = true;

  programs.firefox.enable = true;

  # --- Sound (Pipewire) ---
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # --- Services (Syncthing & Keyring) ---
  services.syncthing = {
    enable = true;
    user = "dav";
    dataDir = "/home/dav/.config/syncthing";
    openDefaultPorts = true;
  };

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;

  # --- Shells & Fonts ---
  programs.fish.enable = true;
  
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
    ];
  };

  # --- System Packages ---
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # Core Utilities
    vim
    wget
    git
    fastfetch
    fzf
    wl-clipboard
    brightnessctl
    playerctl
    
    # Terminals & Launchers
    kitty
    hyprlauncher
    
    # GUI Applications
    vscode
    obsidian
    chromium
    onlyoffice-desktopeditors
    localsend
    keepassxc
    seahorse
    libsecret
    firefox
    kdePackages.dolphin
    hyprpolkitagent
    
    # Media & Entertainment
    tauon
    zathura
    zathuraPkgs.zathura_pdf_mupdf
    dunst
    awww
    ani-cli
    mpv
    yt-dlp
    ffmpeg
    aria2
    gemini-cli
    proton-vpn-cli
  ];

  # --- Nix Settings ---
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # CRITICAL: Fix this to match your actual install version
  system.stateVersion = "26.05";

  };
}