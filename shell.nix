let
  nixpkgs = builtins.fetchTarball {
    url    = "https://github.com/NixOS/nixpkgs/archive/21a3136d25e1652cb32197445e9799e6a5154588.tar.gz";
    sha256 = "145d474g6dngvaiwq2whqdvaq14ba9pc5pvvcz4x8l2bkwbyn3hg";
  };

  overlay = pkgsNew: pkgsOld: {
    haskell = pkgsOld.haskell // {
      packages = pkgsOld.haskell.packages // {
        ghcjs = pkgsOld.haskell.packages.ghcjs.override (old: {
          overrides =
            let
              oldOverrides = old.overrides or (_: _: {});

              sourceOverrides = pkgsNew.haskell.lib.packageSourceOverrides {
                ghcjs-demo = ./.;
              };

            in
              pkgsNew.lib.composeExtensions oldOverrides sourceOverrides;
        });
      };
    };
  };

  config = { };

  pkgs = import nixpkgs { inherit config; overlays = [ overlay ]; };

in
  pkgs.haskell.packages.ghcjs.ghcjs-demo.env
