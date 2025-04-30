{ config, pkgs, inputs, ... }: # inputs hier verfügbar dank specialArgs in flake.nix

{
  imports = [
    # Lade die gemeinsamen Einstellungen
    ./common.nix
    # Hier könnten weitere Module für *diesen speziellen Host* geladen werden
    ./hardware-configuration.nix
  ];

  # Hostname für diesen Rechner
  networking.hostName = "mein-pc"; # Eindeutiger Name

  # Wähle deine Desktop Umgebung
  services.xserver = {
    # GNOME
    # displayManager.gdm.enable = true;
    # desktopManager.gnome.enable = true;

    # KDE Plasma
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;

    # Wähle die Tastaturbelegung für Xorg
    layout = "de";
    xkbVariant = "nodeadkeys"; # Oder was du bevorzugst
  };

  # Sound Server (Pipewire ist modern und empfohlen)
  hardware.pulseaudio.enable = false; # Deaktivieren, wenn Pipewire genutzt wird
  security.rtkit.enable = true; # Wichtig für Echtzeit-Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true; # Für 32-bit Spiele/Anwendungen
    pulse.enable = true;
    # Optional: jack Unterstützung, falls benötigt
    # jack.enable = true;
  };

  # Gaming Setup
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Firewall für Steam Link/Remote Play öffnen
    dedicatedServer.openFirewall = true; # Firewall für Server öffnen
    # Optional: Zusätzliche Pakete für Proton/Steam bereitstellen
    # extraPkgs = pkgs: with pkgs; [
       # Nützlich für manche Spiele / Proton Versionen
       # z.B. mangohud, vkbasalt, wenn nicht über Home Manager
    # ];
  };
  programs.gamemode.enable = true; # Feral Gamemode für Performance-Boost

  # Web Development Setup (systemweit, alternativ über Home Manager oder Dev Shells)
  # environment.systemPackages = with pkgs; [
  #   nodejs_20 # Spezifische Version wählen
  #   yarn
  #   python3
  #   docker
  #   docker-compose
  #   # Dein bevorzugter Editor/IDE
  #   vscode # Oder vscodium
  #   # neovim
  # ];

  # Docker Konfiguration
  virtualisation.docker.enable = true;
  # Füge deinen User zur Docker Gruppe hinzu (wird unten im `users` Block gemacht)

  # Definiere deinen Benutzer
  users.users.nick = {
    isNormalUser = true;
    description = "Nick";
    extraGroups = [ "networkmanager" "wheel" "docker" "adbusers" ]; # wheel für sudo, docker für Docker
    # Setze hier dein initiales Passwort (wird gehasht) oder lass es weg für Passwortabfrage bei Installation
    # initialPassword = "einsehrsicherespasswort";
    # Oder besser: Passwort bei erster Anmeldung setzen lassen
    # openssh.authorizedKeys.keys = [ "ssh-rsa AAA... dein-public-key" ]; # SSH Key für Login
  };

  # NixOS Versionsinformationen
  system.stateVersion = "23.11"; # Oder die Version, mit der du startest. NICHT ändern, ohne zu wissen warum!

  boot.loader = {
    systemd-boot.enable = false;
    grub.enable = false;
  };

}
