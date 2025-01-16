{ inputs, config, pkgs, customLib, ... }: let lib = customLib; in {
  home.packages = with pkgs; [
    qt5.qtwayland
    qt6.qtwayland
    discord-canary
  ];

  wayland.windowManager.hyprland = {
    enable = true;

    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;

    settings = {
      "$terminal" = "kitty";
      "$fileManager" = "dolphin";
      "$menu" = "walker";

      "$lock" = "${pkgs.hyprlock}/bin/hyprlock";

      "$mainMod" = "SUPER";

      general = {
        gaps_in = 5;
        gaps_out = 20;

        border_size = 2;

        allow_tearing = true;
        layout = "dwindle";
      };

      group.groupbar.enabled = true;

      decoration = {
        rounding = 10;

        active_opacity = 1.0;
        inactive_opacity = 1.0;

        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          vibrancy = 0.1696;
        };

        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
          color = "rgba(1a1a1aee)";
        };
      };

      animations = {
        enabled = true;

        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "borderangle, 1, 8, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      cursor = {
        enable_hyprcursor = false;
        no_hardware_cursors = true;
      };

      misc = {
        disable_hyprland_logo = true;
        force_default_wallpaper = 1;
      };

      input = {
        kb_layout = "us";
        kb_variant = "altgr-intl";

        follow_mouse = 1;

        touchpad.natural_scroll = true;

        accel_profile = "flat";
        sensitivity = 0;
      };

      bind = [
        # General
        "$mainMod, Q, killactive"
        "$mainMod, M, exit"
        "$mainMod, L, exec, $lock"

        # Quick exec
        "$mainMod, R, exec, $menu"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, T, exec, $terminal"

        # Window manipulation
        "$mainMod, V, togglefloating"
        "$mainMod, J, togglesplit"
        "$mainMod, F, fullscreen"

        # Workspaces
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        "$mainMod SHIFT, 1, movetoworkspace, 1"
        "$mainMod SHIFT, 2, movetoworkspace, 2"
        "$mainMod SHIFT, 3, movetoworkspace, 3"
        "$mainMod SHIFT, 4, movetoworkspace, 4"
        "$mainMod SHIFT, 5, movetoworkspace, 5"
        "$mainMod SHIFT, 6, movetoworkspace, 6"
        "$mainMod SHIFT, 7, movetoworkspace, 7"
        "$mainMod SHIFT, 8, movetoworkspace, 8"
        "$mainMod SHIFT, 9, movetoworkspace, 9"
        "$mainMod SHIFT, 0, movetoworkspace, 10"

        # Special workspaces
        ## Spotify
        "$mainMod, S, togglespecialworkspace, spotify"
        ## Discord
        "$mainMod, D, togglespecialworkspace, discord"

        # Screenshots
        "$mainMod, bracketright, exec, hyprshot -m region --clipboard-only"
        "$mainMod CTRL, bracketright, exec, hyprshot -m window --clipboard-only"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];

      windowrulev2 = [
        "suppressevent maximize, class:.*"
        "workspace special:spotify, class:^(Spotify)$"
        "workspace special:discord, class:^(discord)$"
        
        # lookingglass
        "immediate, class:^(looking-glass-client)$"

        # Xwaylandvideobridge
        "opacity 0.0 override, class:^(xwaylandvideobridge)$"
        "noanim, class:^(xwaylandvideobridge)$"
        "noinitialfocus, class:^(xwaylandvideobridge)$"
        "maxsize 1 1, class:^(xwaylandvideobridge)$"
        "noblur, class:^(xwaylandvideobridge)$"
      ];

      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "NIXOS_OZONE_WL,1"
        "ELECTRON_ENABLE_WAYLAND,1"
        "ELECTRON_OZONE_PLATFORM_HINT,wayland"
      ];

      monitor = lib.mkDefault [
        "monitor = , preferred, auto, 1"
      ];

      exec-once = [
        "hyprctl setcursor banana 40"

        # Fixed apps
        "[workspace special:discord silent] discordcanary"
        "[workspace special:spotify silent] spotify"
        "[workspace name:vs-code silent] code"
        "[workspace name:vs-code-browser silent] firefox"
      ];
    };
  };
}