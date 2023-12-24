{
  description = "A very basic flake";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      hello = a: pkgs.writeShellScriptBin "hello" ''
        echo "Hello, ${a}!"
      '';

      apps.${system}.parametrize = {
        type = "app";
        program = "${pkgs.writeShellScriptBin "parametrize" ''
          ln -sfn "$(nix eval "$1" --raw --apply 'f: "''${rec { pkg = f '"$2"'; ''${builtins.readFileType "''${pkg}"} = 1;}.pkg}"')" result
        ''}/bin/parametrize";
      };
    };
}
