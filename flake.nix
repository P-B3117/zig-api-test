{
  description = "Zig API test project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Zig package from nixpkgs
        zig = pkgs.zig;

        # Build the project
        zig-api-test = pkgs.stdenv.mkDerivation rec {
          pname = "zig-api-test";
          version = "0.0.0";

          src = ./.;

          nativeBuildInputs = with pkgs; [
            zig
          ];

          buildInputs = with pkgs; [
            sqlite
          ];

          # Set up Zig cache directory
          preBuild = ''
            export ZIG_GLOBAL_CACHE_DIR=$TMPDIR/zig-cache
            export ZIG_LOCAL_CACHE_DIR=$TMPDIR/zig-cache
          '';

          buildPhase = ''
            runHook preBuild

            # Build the project using Zig
            zig build --cache-dir $TMPDIR/zig-cache -Doptimize=ReleaseSafe

            runHook postBuild
          '';

          installPhase = ''
            runHook preInstall

            # Install the executable and library
            mkdir -p $out/bin
            mkdir -p $out/lib

            # Copy the built executable
            cp zig-out/bin/zig_api_test $out/bin/

            # Copy the built library if it exists
            if [ -f zig-out/lib/libzig_api_test.a ]; then
              cp zig-out/lib/libzig_api_test.a $out/lib/
            fi

            runHook postInstall
          '';

          # Allow network access during build for dependency fetching
          __noChroot = true;

          meta = with pkgs.lib; {
            description = "Zig API test project";
            homepage = "https://github.com/your-username/zig-api-test";
            license = licenses.mit; # Adjust license as needed
            maintainers = [ ];
            platforms = platforms.all;
          };
        };

      in
      {
        packages = {
          default = zig-api-test;
          zig-api-test = zig-api-test;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            zig
            sqlite
            python3
            # Add any other development dependencies you need
          ];

          shellHook = ''
            echo "Zig API test development environment"
            echo "Zig version: $(zig version)"
            export ZIG_GLOBAL_CACHE_DIR=$PWD/.zig-cache
            export ZIG_LOCAL_CACHE_DIR=$PWD/.zig-cache
          '';
        };

        apps.default = {
          type = "app";
          program = "${zig-api-test}/bin/zig_api_test";
        };
      });
}
