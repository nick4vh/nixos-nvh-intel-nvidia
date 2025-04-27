{
  description = "Mein NixOS System Flake";

  inputs = {
    # Offizielle NixOS Pakete (unstable für aktuellere Pakete, oder z.B. nixos-23.11)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager für User-Konfiguration
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; # Stellt sicher, dass home-manager die gleichen Pakete wie das System nutzt
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      lib = nixpkgs.lib;
    in
    {
      # Systemkonfigurationen (definiere hier für jeden deiner Rechner einen Eintrag)
      nixosConfigurations = {
        # Beispiel für deinen Hauptrechner (Name frei wählbar)
        mein-pc = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; }; # Übergibt inputs an die Konfigurationsdateien
          modules = [
            # Lade die Hauptkonfiguration für diesen Host
            ./nixos/configuration.nix
            # Integriere Home Manager als NixOS Modul
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true; # Nutzt System-pkgs für Home Manager
              home-manager.useUserPackages = true; # Erlaubt User-spezifische Pakete
              # Definiere hier den User und seine Home Manager Konfiguration
              home-manager.users.nick = import ./home/nick.nix;
              # Übergib Argumente an die Home-Manager Konfigurationen
              home-manager.extraSpecialArgs = { inherit inputs; };
            }
          ];
        };
        # Füge hier weitere Hosts hinzu, z.B. für deinen Laptop
        # mein-laptop = lib.nixosSystem { ... };
      };

      # Home-Manager Konfigurationen (optional, wenn du sie separat bauen willst)
      # homeConfigurations = {
      #   "nick" = home-manager.lib.homeManagerConfiguration {
      #     inherit pkgs;
      #     modules = [ ./home/nick.nix ];
      #     extraSpecialArgs = { inherit inputs; };
      #   };
      # };
    };
}