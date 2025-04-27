{ config, pkgs, inputs, ... }: # inputs auch hier verfügbar

{
  # Home Manager Konfiguration
  home.username = "nick";
  home.homeDirectory = "/home/nick";

  # Pakete, die nur für deinen User installiert werden sollen
  home.packages = with pkgs; [
    # Browser
    firefox
    # chromium

    # Kommunikation
    discord
    # signal-desktop

    # Gaming Tools
    lutris
    mangohud # Performance Overlay
    vkbasalt # Post-Processing Filter

    # Web Development Tools (Alternative zur systemweiten Installation)
    nodejs_20 # Oder neuere Version
    yarn
    python3
    # Dein bevorzugter Editor/IDE
    vscode # Oder vscodium
    # neovim

    # Andere nützliche User-Tools
    flameshot # Screenshot Tool
    obs-studio # Streaming/Recording
    gimp
    vlc
    zathura # PDF Viewer
    keepassxc # Passwort Manager
  ];

  # Git Konfiguration
  programs.git = {
    enable = true;
    userName = "Dein Name";
    userEmail = "deine@email.com";
  };

  # Starship Prompt für ZSH (wenn ZSH als Default gesetzt ist)
  programs.starship = {
    enable = true;
    # Konfiguration kann hier oder in ~/.config/starship.toml erfolgen
  };
  programs.zsh.enable = true; # Sicherstellen, dass ZSH für den User konfiguriert wird

  # Hier kannst du deine Dotfiles verwalten
  # Beispiel: Kopiere eine Konfigurationsdatei in das Home-Verzeichnis
  # home.file.".config/meinprogramm/config.toml".source = ./dotfiles/meinprogramm-config.toml;

  # Beispiel: Setze Umgebungsvariablen
  # home.sessionVariables = {
  #   EDITOR = "vim";
  # };

  # Setze den State Version für Home Manager
  home.stateVersion = "23.11"; # An deine NixOS Version anpassen
}