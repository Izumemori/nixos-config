{pkgs, ...}: {
  # Fix missing modules for rpi kernel
  nixpkgs.overlays = [
    (final: super: {
      makeModulesClosure = x:
        super.makeModulesClosure (x // { allowMissing = true; });
    })
  ];

  # Utilities for RPI
  environment.systemPackages = [
    pkgs.libraspberrypi
  ];

  hardware = {
    raspberry-pi."4" = {
      # Enable GPU module
      fkms-3d = {
        enable = true;
      };

      # Disable ETH Led, other LED options bugged, see below
      leds = {
        eth.disable = true;
      };

      # Make sure dt overlays are applied
      apply-overlays-dtmerge.enable = true;
    };

    # Disable the Activity and Power LEDs
    # See https://github.com/NixOS/nixos-hardware/pull/1290
    deviceTree.overlays = [
      {
        name = "disable-act-led";
        filter = "*rpi-4-b*";
        dtsText = ''
          /dts-v1/;
          /plugin/;
          /{
            compatible = "raspberrypi,4-model-b";
            fragment@0 {
                target = <&led_act>;
                __overlay__ {
                    gpios = <&gpio 42 0>; /* first two values copied from bcm2711-rpi-4-b.dts */
                    linux,default-trigger = "none";
                };
            };
          };
        '';
      }

      {
        name = "disable-pwr-led";
        filter = "*rpi-4-b*";
        dtsText = ''
          /dts-v1/;
          /plugin/;
          /{
            compatible = "raspberrypi,4-model-b";
            fragment@0 {
                target = <&led_pwr>;
                __overlay__ {
                    gpios = <&expgpio 2 0>; /* first two values copied from bcm2711-rpi-4-b.dts */
                    linux,default-trigger = "default-on";
                };
            };
          };
        '';
      }
    ];
  };
}