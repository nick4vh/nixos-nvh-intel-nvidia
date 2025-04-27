{ config, pkgs, lib, ... }:

{
  imports = [
    # Hier könntest du eigene Module importieren, z.B. für Nvidia
    ./modules/hardware/nvidia.nix
  ];

  # Zeitzone und Sprache
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF-8";
  console.keyMap = "de";

  # Bootloader (systemd-boot ist oft einfacher auf UEFI)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Netzwerk (NetworkManager ist üblich)
  networking.networkmanager.enable = true;
  # Optional: Hostname setzen (kann auch in host-spezifischer config)
  # networking.hostName = "nixos-common";

  # Standard-Shell auf ZSH setzen (optional)
  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  # Erlaube unfree Pakete (WICHTIG für Nvidia Treiber, Steam, etc.)
  nixpkgs.config.allowUnfree = true;

  # SSH Server (optional)
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false; # Empfohlen: Nur Key-Auth
    settings.PermitRootLogin = "no";
  };

  # Grundlegende Pakete, die immer nützlich sind
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    vim # oder nano
    htop
    nix-output-monitor # Hilfreich beim Bauen/Switching
    ripgrep
    fd
    # Füge hier weitere *systemweite* Tools hinzu
  ];

  # Garbage Collection für alte Generationen aktivieren
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d"; # Löscht Generationen älter als 7 Tage
  };
  nix.settings.auto-optimise-store = true; # Optimiert den Nix Store

  # Nix Flakes experimentelles Feature aktivieren (nötig)
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}