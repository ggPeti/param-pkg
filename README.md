Parametrizable derivation builder

Usage: 
```
nix run github:ggpeti/param-pkg myflake#lib.mkMyPkg '<arg-expr>'
```

Takes a textual nix expression as the final argument. `myflake#lib.mkMyPkg` is a function of type `any -> derivation`.

Uses `nix eval` under the hood but produces the usual `result` symlink in the cwd.

Hacks utilized:
1. flakes don't support [configurable](https://github.com/NixOS/nix/issues/2861) [outputs](https://github.com/NixOS/nix/pull/6583) and `--argstr` -> but there is `nix eval --apply`
2. `nix eval` doesn't instantiate derivation outputs until they are accessed -> `builtins.readFileType` does that
3. lazy evaluation prevents instantiation as well -> but as is widely known, nix is eager in attrset names.
