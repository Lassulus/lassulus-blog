{ nixpkgs ? import <nixpkgs> {} }:

let
  pname = "lassul.us";
  version = "1";

  buildInputs = with nixpkgs; [
    hsEnv
  ];

  hsEnv = nixpkgs.haskellPackages.ghcWithPackages (self: with self;
    [
      hakyll
    ]);

  extraCmds = with nixpkgs; ''
    export MANPATH=$(ls -d $(echo "$PATH" | tr : \\n | sed -n 's:\(^/nix/store/[^/]\+\).*:\1/share/man:p') 2>/dev/null | tr \\n :)
    export SSL_CERT_FILE="/etc/ssl/certs/ca-bundle.crt"
  '';

in nixpkgs.myEnvFun {
  name = "${pname}-${version}";
  inherit buildInputs extraCmds;
}
