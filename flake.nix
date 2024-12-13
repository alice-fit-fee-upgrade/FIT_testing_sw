{
  inputs.artiq.url = git+https://github.com/elhep/artiq.git?ref=fit-release-8;
  inputs.extrapkg.url = "git+https://git.m-labs.hk/M-Labs/artiq-extrapkg.git?ref=release-8";
  inputs.extrapkg.inputs.artiq.follows = "artiq";

  outputs = { self, artiq, extrapkg }:
  let
    pkgs = import artiq.inputs.nixpkgs { system = "x86_64-linux"; };
    aqmain = artiq.packages.x86_64-linux;
    aqextra = extrapkg.packages.x86_64-linux;

    makeArtiqBoardPackage = variant: artiq.makeArtiqBoardPackage {
        target = "kasli";
        variant = variant;
        buildCommand = 
          "python -m artiq.gateware.targets.kasli ${./variants}/${variant}.json";
    };

    makeVariantDDB = variant: pkgs.runCommand "ddb-${variant}" {
        buildInputs = [
            artiq.devShell.x86_64-linux.buildInputs
        ];
    }
    ''
    mkdir -p $out
    artiq_ddb_template ${./variants}/${variant}.json -o $out/device_db.py
    '';

  in rec {

    packages.x86_64-linux = {
      fit-testing-firmware = makeArtiqBoardPackage "fit-testing";
      fit-testing-ddb = makeVariantDDB "fit-testing";
    };

    defaultPackage.x86_64-linux = pkgs.mkShell {
        name = "artiq-env";
        packages = [
          (pkgs.python3.withPackages(ps: [
            aqmain.artiq
            ps.paho-mqtt
            ps.jsonschema
            (ps.matplotlib.override { enableQt = true; })
          ]))
          aqmain.openocd-bscanspi
        ];
        shellHook = ''
          export QT_QPA_PLATFORM_PLUGIN_PATH="${pkgs.qt5.qtbase.bin}/lib/qt-${pkgs.qt5.qtbase.version}/plugins/platforms";
        '';
      };
  
  };

  nixConfig = {
    extra-trusted-public-keys = "nixbld.m-labs.hk-1:5aSRVA5b320xbNvu30tqxVPXpld73bhtOeH6uAjRyHc=";
    extra-substituters = "https://nixbld.m-labs.hk";
    sandbox = false;
  };

}