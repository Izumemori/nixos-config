config: {
  config.nixpkgs.overlays = [
        (self:
        let
          version = "0.0.462";
          enableWayland = drv: bin: drv.overrideAttrs (
            old: {
              nativeBuildInputs = (old.nativeBuildInputs or []) ++ [ self.makeWrapper ];
              postFixup = (old.postFixup or "") + ''
                wrapProgram $out/bin/${bin} \
                  --add-flags "--enable-features=UseOzonePlatform" \
                  --add-flags "--ozone-platform=wayland"
              '';
              src = builtins.fetchTarball {
                url = "https://dl-canary.discordapp.net/apps/linux/${version}/discord-canary-${version}.tar.gz";
                sha256 = "0fsg5l2pnfb267n7d88ibfck82c4mdc9b5bhqjnw8n0yqdirjymg";
              };
            }
          );
        in
        super: { 
          discord-canary = enableWayland self.discord-canary "DiscordCanary";
        })
      ];
}