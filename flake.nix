{
  description = "Home Manager configuration of fg";



inputs = {
  # this should be tied to a specific nixpkgs version for stability
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

  home-manager = {
    # use the release branch that matches the nixpkgs version
    url = "github:nix-community/home-manager/release-25.05";
    inputs.nixpkgs.follows = "nixpkgs";
  };
};

  outputs = { nixpkgs, home-manager, ... }:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations."fg" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };
}
