{
inputs.artiq.url = git+https://github.com/elhep/artiq.git?ref=fit-r8-pmt-dio-trigger;

outputs = { self, artiq }:
let
  pkgs = import artiq.inputs.nixpkgs { system = "x86_64-linux"; };
  aqmain = artiq.packages.x86_64-linux;
  aqenv = artiq.devShells.x86_64-linux.boards.buildInputs;

  # Helper funcions -----------------------------------------------------------------------------

  makeArtiqBoardPackage = variantJson: 
    artiq.makeArtiqBoardPackage {
      target = "kasli";
      variant = builtins.fromJSON (builtins.readFile variantJson).variant;
      buildCommand = 
        "python -m artiq.gateware.targets.kasli ${variantJson}";
    };

  makeDeviceDb = variantJson:
    pkgs.runCommand "device-db" {
      buildInputs = artiq.devShell.x86_64-linux.buildInputs;
    }
    ''
    mkdir -p $out
    artiq_ddb_template ${variantJson} -o $out/device_db.py
    '';

  makeStartupKernel = variantJson: startupExperiment: 
    pkgs.runCommand "startup-kernel" {
      buildInputs = artiq.devShell.x86_64-linux.buildInputs;
    }
    ''
    mkdir -p $out
    artiq_compile --device-db ${makeDeviceDb variantJson} ${startupExperiment} \
      -o $out/startup_kernel.elf
    '';

  makeRtioMap = variantJson:
    pkgs.runCommand "rtio-map" {
      buildInputs = artiq.devShell.x86_64-linux.buildInputs;
    }
    ''
    mkdir -p $out
    
    '';

  makeStorage = { variantJson, clockSource ? "int_125", startupExperiment ? null }:
    let
      desc = builtins.fromJSON (builtins.readFile variantJson);
      core_addr = desc.core_addr;
      startup-kernel-option = if startupExperiment != null
        then "-f startup_kernel ${makeStartupKernel variantJson startupExperiment}/startup_kernel"
        else "";
      rtio-map-option = "-f device_map ${makeRtioMap}/rtio_map";
    in
      pkgs.runCommand "storage" {
        buildInputs = aqenv;
      }
      ''
        mkdir -p $out
        artiq_mkfs -s ip ${core_addr} -s rtio_clock ${clockSource} \
          ${startup-kernel-option} ${rtio-map-option} $out/storage.img
      '';

  # Helper funcions -----------------------------------------------------------------------------

in rec {

    packages.x86_64-linux = {
      fit-testing-firmware = makeArtiqBoardPackage "fit-testing";
      fit-testing-ddb = makeDeviceDb "fit-testing";
    };

    devShells.x86_64-linux.default = artiq.devShells.x86_64-linux.boards;
      
  };

  nixConfig = {
    extra-trusted-public-keys = "nixbld.m-labs.hk-1:5aSRVA5b320xbNvu30tqxVPXpld73bhtOeH6uAjRyHc=";
    extra-substituters = "https://nixbld.m-labs.hk";
    sandbox = false;
  };

}
