{ config, pkgs, lib, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "mbpnix";
  home.homeDirectory = "/home/mbpnix";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.05";

  # nvim...
  programs.neovim = {
    enable = true;
    vimAlias = true;
    extraConfig = "colorscheme gruvbox";
    plugins = [
      pkgs.vimPlugins.vim-nix
      pkgs.vimPlugins.gruvbox
    ];
  };

  # GTK...
  gtk = {
    enable = true;
    iconTheme.name = "Arc";
    iconTheme.package = pkgs.arc-icon-theme;
    theme.name = "Sweet-Dark";
    theme.package = pkgs.sweet;
  };

  # password-store...
  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
    settings = { PASSWORD_STORE_DIR = "$HOME/.local/share/password-store"; };
  };

  # GPG...
  programs.gpg = {
    enable = true;
    settings = { homedir = "$HOME/.local/share/gnupg"; };
  };

  # GPG Agent...
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    defaultCacheTtl = 60;
    defaultCacheTtlSsh = 60;
  };

  # User Git...
  programs.git = {
    enable = true;
    userEmail = "mbpnix@pm.me";
    userName = "mbpnix";
  };

  # My packages...
  home.packages = with pkgs; [
    arc-icon-theme
    arc-theme
    arduino
    bat
    bc
    bleachbit
    capitaine-cursors
    discord
    etcher
    exa
    filezilla
    freetube
    google-cloud-sdk
    gruvbox-dark-gtk
    gruvbox-dark-icons-gtk
    hping
    htop
    i3lock-color
    i3lock-fancy
    keepassxc
    kotatogram-desktop
    lsd
    mediastreamer-openh264
    neofetch
    nmap
    nordic
    numix-gtk-theme
    numix-solarized-gtk-theme
    obs-studio
    openh264
    orchis
    p7zip
    procs
    ripgrep
    scrot
    speedtest-cli
    stow
    sweet
    tree
    unrar
    unzip
    vimix-gtk-themes
    vlc
    x264
    xarchiver
    xclip
    youtube-dl
  ];

}
