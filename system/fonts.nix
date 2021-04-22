{ pkgs, ... }:

{
  fonts = {
    fonts = with pkgs; [
      # nerdfonts
      (nerdfonts.override { fonts = [ "3270" "Iosevka" "IBMPlexMono" "FiraCode" "JetBrainsMono" ]; })

      # normal fonts
      fantasque-sans-mono
      terminus-nerdfont
      fira-code
      fira-mono
      iosevka
      unifont
    ];

    enableDefaultFonts = false;

    fontconfig.defaultFonts = {
      serif = [ "Iosevka" ];
      sansSerif = [ "Iosevka" ];
      monospace = [ "Iosevka" ];
    };
  };
}
