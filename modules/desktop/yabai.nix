{ config, lib, pkgs, ... }:

{
  services = {
    yabai = {                             # Tiling window manager
      enable = true;
      package = pkgs.yabai;
      config = {                          # Other configuration options
        mouse_follows_focus =           "off";
        focus_follows_mouse =           "off";
        window_origin_display =         "default";
        window_placement =              "second_child";
        window_zoom_persist =           "on";
        window_topmost =                "off";
        window_shadow =                 "on";
        window_animation_duration =     "0.0";
        window_animation_frame_rate =   "120";
        window_opacity_duration =       "0.0";
        active_window_opacity =         "1.0";
        normal_window_opacity =         "0.90";
        window_opacity =                "off";
        insert_feedback_color =         "0xffd75f5f";
        active_window_border_color =    "0xff775759";
        normal_window_border_color =    "0xff555555";
        window_border_width =           "4";
        window_border_radius =          "12";
        window_border_blur =            "off";
        window_border_hidpi =           "on";
        window_border =                 "off";
        split_ratio =                   "0.50";
        split_type =                    "auto";
        auto_balance =                  "off";
        top_padding =                   "12";
        bottom_padding =                "12";
        left_padding =                  "12";
        right_padding =                 "12";
        window_gap =                    "06";
        layout =                        "bsp";
        mouse_modifier =                "fn";
        mouse_action1 =                 "move";
        mouse_action2 =                 "resize";
        mouse_drop_action =             "swap";
      };
    };
  };
}