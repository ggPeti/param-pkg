{
  description = "Parametrize packages";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      lib.hello = a: pkgs.writeShellScriptBin "hello" ''
        echo "Hello, ${a}!"
      '';

    } //
    (flake-utils.lib.eachDefaultSystem (system: {
      apps.parametrize = flake-utils.lib.mkApp {
        drv = pkgs.writeShellScriptBin "parametrize" ''
          if 
          echo "Usage: parametrize flake#lib.mkPkg '<nix-expr>'"
          ln -sfn "$(nix eval "$1" --raw --apply 'f: "''${rec { pkg = f '"$2"'; ''${builtins.readFileType "''${pkg}"} = 1;}.pkg}"')" result
        '';
      };
    }));
}
    
