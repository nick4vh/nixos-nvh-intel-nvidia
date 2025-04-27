{ config, pkgs, lib, ... }:

{
  # Aktiviert OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true; # WICHTIG für Steam / Wine (32-bit Spiele)
  };

  # Nvidia Treiber Konfiguration
  services.xserver = {
    enable = true; # Xorg aktivieren (oft stabiler mit Nvidia als Wayland)
    # Alternativ Wayland (z.B. mit Gnome oder KDE Plasma >= 5.27), kann aber noch Probleme machen:
    # Wenn du Wayland willst, aktiviere es im Desktop Manager Modul und prüfe Nvidia Kompatibilität
    # services.displayManager...enable = true; # GDM/SDDM etc. für Wayland-Session auswählen

    # Proprietäre Nvidia Treiber verwenden
    videoDrivers = [ "nvidia" ];
  };

  hardware.nvidia = {
    # Proprietäre Treiber nutzen
    modesetting.enable = true; # Wichtig für neuere Treiber und Wayland/XWayland

    # Treiber-Version (meistens ist 'latest' gut)
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    # Alternative: package = config.boot.kernelPackages.nvidiaPackages.production; # Stabilerer Zweig

    # Power Management (wichtig für Laptops und Effizienz)
    powerManagement.enable = true;
    # Optional: Feinabstimmung bei Laptops mit Optimus (Intel+Nvidia)
    # Siehe: https://nixos.wiki/wiki/Nvidia_Optimus
    # prime = {
    #   offload.enable = true; # Programme explizit auf Nvidia GPU starten (z.B. mit prime-run)
    #   # Wähle die richtige Synchronisationsmethode (sync ist oft gut für externe Monitore)
    #   sync.enable = true; # Versucht Tearing zu verhindern
    #   # Du musst ggf. die Bus IDs deiner GPUs angeben:
    #   intelBusId = "PCI:X:Y:Z"; # Finde mit `lspci | grep VGA`
    #   nvidiaBusId = "PCI:A:B:C"; # Finde mit `lspci | grep VGA`
    # };
  };

  # Optional: Sicherstellen, dass Nvidia Kernel Module geladen werden
  # boot.kernelModules = [ "nvidia" ];
  # boot.extraModulePackages = [ config.boot.kernelPackages.nvidiaPackages.latest ];
}