{ inputs, ... }:
let
  folder = "${inputs.sketchybar}/config/sketchybar";
in
{
  home.file.sketchybar = {
    executable = true;
    target = "${folder}/sketchybarrc";
    text = ''
      #!/usr/bin/env zsh

      SKETCHYBAR_CONFIG="${folder}"

      # This is used to determine if a monitor is used
      # Since the notch is -only- on the laptop, if a monitor isn't used,
      # then that means the internal display is used ¯\_(ツ)_/¯
      MAIN_DISPLAY=$(system_profiler SPDisplaysDataType | grep -B 3 'Main Display:' | awk '/Display Type/ {print $3}')

      if [[ $MAIN_DISPLAY = "Built-in" ]]; then
          source "$SKETCHYBAR_CONFIG/sketchybarrc-laptop"
      else
          source "$SKETCHYBAR_CONFIG/sketchybarrc-desktop"
      fi
    '';
  };
}
