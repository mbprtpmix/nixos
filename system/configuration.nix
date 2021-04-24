# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./security.nix
      ./fonts.nix
    ];

  # VirtualBox...
  virtualisation.virtualbox = {
    host.enable = true;
    host.headless = true;
  };

  # Shell...
  programs.bash.interactiveShellInit = ''
    bind "set completion-ignore-case on"
  '';
  programs.bash.shellAliases = {
    x="xclip -selection c -i";		# Cut	(does not filter).
    c="xclip -selection c -i -f";		# Copy	(does filter).
    v="xclip -selection c -o";		# Paste.
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Optimise Store...
  nix.autoOptimiseStore = true;

  # Enable Flakes...
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Enable sandbox...
  nix.useSandbox = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # NetworkManager.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Bucharest";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s20u2.useDHCP = true;
  networking.interfaces.enp8s0.useDHCP = true;
  networking.interfaces.wlp9s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "uk";
  };

  # Video Drivers.
  services.xserver.videoDrivers = [ "intel" "ati" "amdgpu" ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # DE...
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.xfce.enable = true;
  
  # LightDM rice...
  services.xserver.displayManager.lightdm.greeters.gtk.theme.name = "Arc-Dark";
  services.xserver.displayManager.lightdm.greeters.gtk.iconTheme.name = "Arc";
  services.xserver.displayManager.lightdm.greeters.gtk.cursorTheme.name = "Capitaine Cursors";
  services.xserver.displayManager.lightdm.greeters.gtk.clock-format = "%H:%M";
  services.xserver.displayManager.lightdm.background = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/mbprtpmix/nixos/testing/wallpapers/mountains.jpg";
    sha256 = "0k7lpj7rlb08bwq3wy9sbbq44rml55jyp9iy4ipwzy4bch0mc6y4";
  };
  services.xserver.displayManager.lightdm.greeters.gtk.extraConfig = ''
    indicators = ~clock;~spacer;~host;~spacer;~language;~session;~a11y;~power
    font-name = Unifont 12
  '';

  # Configure keymap in X11
  services.xserver.layout = "gb";
  services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # OpenGL...
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    # Support hardware accelerated encoding/decoding.
    extraPackages = with pkgs; [
      vaapiIntel
      libvdpau-va-gl
      vaapiVdpau
      intel-ocl
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      vaapiIntel
      libvdpau-va-gl
      vaapiVdpau
    ];
  };

  # Enable udiskie...
  services.udisks2.enable = true;

  # Set vim as default editor...
  programs.vim.defaultEditor = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  # Intel Microcode.
  hardware.cpu.intel.updateMicrocode = true;

  # Allow Unfree.
  nixpkgs.config.allowUnfree = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mbpnix = {
    isNormalUser = true;
    hashedPassword = "$6$T0889cgw$ztcln2TAS.FQqYr7qkRriwN/4AWEL9cNVa9hUBcN74KF21RIL8jHYi7vN./KvOqIqkFdW/RthR2wnnJbic5.00";
    extraGroups = [ "wheel" "networkmanager" "vboxusers" ]; # Enable ‘sudo’ for the user.
    uid = 1000;
  };

  # qt5ct...
  programs.qt5ct.enable = true;

  # adb...
  programs.adb.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    arc-icon-theme arc-theme capitaine-cursors
    cachix cached-nix-shell nixops
    wget vim firefox git curl rsync rclone bleachbit
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [  ];
  networking.firewall.allowedUDPPorts = [  ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

  # System Auto-Upgrade.
  system.autoUpgrade.enable = true;

  # Locate service.
  services.locate = {
    enable = true;
    interval = "45 * * * *";
  };

  # Don't keep logs after reboots so boot isn't slowed down by flush.
  services.journald.extraConfig = "Storage=volatile";

  # Enable fstrim daily.
  services.fstrim = {
    enable = true;
    interval = "daily";
  };

}

