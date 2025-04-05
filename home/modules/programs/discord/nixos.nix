config: {
  config.nixpkgs.overlays = [
        (self:
        let
          version = "0.0.619";
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
                sha256 = "00000000000000000000000000000000000000000000";
              };
            }
          );
        in
        super: { 
          discord-canary = enableWayland self.discord-canary "DiscordCanary";
        })
      ];
}