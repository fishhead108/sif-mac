{ config, lib, pkgs, ... }:

{
  services = {
    # Hotkey daemon
    skhd = {
      enable = true;
      package = pkgs.skhd;
      skhdConfig = ''
        # alt + a / u / o / s are blocked due to umlaute

        # Cycle windows forwards and backwards in focused stack only
        # cmd - tab : yabai -m window --focus stack.next || yabai -m window --focus stack.first
        cmd - left : yabai -m window --focus stack.next
        cmd - right : yabai -m window --focus stack.prev
        # cmd + shift - k : if [ "$(yabai -m query --spaces --space | jq -r '.type')" = "stack" ]; then (yabai -m window --focus stack.next || yabai -m window --focus stack.first); else yabai -m window --focus next || yabai -m window --focus first; fi
        # cmd + shift - j : if [ "$(yabai -m query --spaces --space | jq -r '.type')" = "stack" ]; then (yabai -m window --focus stack.prev || yabai -m window --focus stack.last); else yabai -m window --focus prev || yabai -m window --focus last; fi

        # https://github.com/koekeishiya/yabai/issues/203
        # https://github.com/rriski/dotfiles.fish/blob/main/skhd/skhdrc
        # alt - k : yabai -m query --spaces --space \
        #   | jq -re ".index" \
        #   | xargs -I{} yabai -m query --windows --space {} \
        #   | jq -sre 'add | map(select(."is-minimized"==false)) | sort_by(.display, .frame.y, .frame.x, .id) | . as $array | length as $array_length | index(map(select(."has-focus"==true))) as $has_index | if $has_index > 0 then nth($has_index - 1).id else nth($array_length - 1).id end' \
        #   | xargs -I{} yabai -m window --focus {}

        # alt - j : yabai -m query --spaces --space \
        #   | jq -re ".index" \
        #   | xargs -I{} yabai -m query --windows --space {} \
        #   | jq -sre 'add | map(select(."is-minimized"==false)) | sort_by(.display, .frame.y, .frame.x, .id) | . as $array | length as $array_length | index(map(select(."has-focus"==true))) as $has_index | if $array_length - 1 > $has_index then nth($has_index + 1).id else nth(0).id end' \
        #   | xargs -I{} yabai -m window --focus {}


        # forward
        # yabai -m query --spaces --space \
        #   | jq -re ".index" \
        #   | xargs -I{} yabai -m query --windows --space {} \
        #   | jq -sre "add | map(select(.minimized != 1)) | sort_by(.display, .frame.y, .frame.x, .id) | reverse | nth(index(map(select(.focused == 1))) - 1).id" \
        #   | xargs -I{} yabai -m window --focus {}

        # # backward
        # yabai -m query --spaces --space \
        #   | jq -re ".index" \
        #   | xargs -I{} yabai -m query --windows --space {} \
        #   | jq -sre "add | map(select(.minimized != 1)) | sort_by(.display, .frame.y, .frame.y, .id) | nth(index(map(select(.focused == 1))) - 1).id" \
        #   | xargs -I{} yabai -m window --focus {}

        # focus window
        alt - h : yabai-next-window
        # alt - h : yabai -m window --focus west
        # alt - j : yabai -m window --focus south
        # alt - k : yabai -m window --focus north
        # alt - l : yabai -m window --focus east

        # swap managed window
        shift + alt - h : yabai -m window --swap west
        shift + alt - j : yabai -m window --swap south
        shift + alt - k : yabai -m window --swap north
        shift + alt - l : yabai -m window --swap east

        # move managed window
        shift + cmd - h : yabai -m window --warp west
        shift + cmd - j : yabai -m window --warp south
        shift + cmd - k : yabai -m window --warp north
        shift + cmd - l : yabai -m window --warp east

        # balance size of windows
        shift + alt - 0 : yabai -m space --balance

        # make floating window fill screen
        shift + alt - up     : yabai -m window --grid 1:1:0:0:1:1

        # make floating window fill left-half of screen
        shift + alt - left   : yabai -m window --grid 1:2:0:0:1:1

        # make floating window fill right-half of screen
        shift + alt - right  : yabai -m window --grid 1:2:1:0:1:1

        # create desktop, move window and follow focus - uses jq for parsing json (brew install jq)
        shift + cmd - n : yabai -m space --create && \
                          index="$(yabai -m query --spaces --display | jq 'map(select(."native-fullscreen" == 0))[-1].index')" && \
                          yabai -m window --space "''${index}" && \
                          yabai -m space --focus "''${index}"

        # destroy desktop
        cmd + alt - w : yabai -m space --destroy

        # fast focus desktop
        cmd - x : yabai -m space --focus recent
        cmd - z : yabai -m space --focus prev
        #cmd - c : yabai -m space --focus next
        cmd - 1 : yabai -m space --focus 1
        cmd - 2 : yabai -m space --focus 2
        cmd - 3 : yabai -m space --focus 3
        cmd - 4 : yabai -m space --focus 4
        cmd - 5 : yabai -m space --focus 5
        cmd - 6 : yabai -m space --focus 6
        cmd - 7 : yabai -m space --focus 7
        cmd - 8 : yabai -m space --focus 8
        cmd - 9 : yabai -m space --focus 9
        cmd - 0 : yabai -m space --focus 10

        # send window to desktop and follow focus
        shift + cmd - x : yabai -m window --space recent; yabai -m space --focus recent
        shift + cmd - z : yabai -m window --space prev; yabai -m space --focus prev
        shift + cmd - c : yabai -m window --space next; yabai -m space --focus next
        shift + cmd - 1 : yabai -m window --space  1; yabai -m space --focus 1
        shift + cmd - 2 : yabai -m window --space  2; yabai -m space --focus 2
        # conflict with screenshot shortcut  
        shift + cmd - 3 : yabai -m window --space  3; yabai -m space --focus 3
        shift + cmd - 4 : yabai -m window --space  4; yabai -m space --focus 4
        shift + cmd - 5 : yabai -m window --space  5; yabai -m space --focus 5
        shift + cmd - 6 : yabai -m window --space  6; yabai -m space --focus 6
        shift + cmd - 7 : yabai -m window --space  7; yabai -m space --focus 7
        shift + cmd - 8 : yabai -m window --space  8; yabai -m space --focus 8
        shift + cmd - 9 : yabai -m window --space  9; yabai -m space --focus 9
        shift + cmd - 0 : yabai -m window --space 10; yabai -m space --focus 10

        # focus monitor
        ctrl + alt - x  : yabai -m display --focus recent
        ctrl + alt - z  : yabai -m display --focus prev
        ctrl + alt - c  : yabai -m display --focus next
        ctrl + alt - 1  : yabai -m display --focus 1
        ctrl + alt - 2  : yabai -m display --focus 2
        ctrl + alt - 3  : yabai -m display --focus 3

        # send window to monitor and follow focus
        ctrl + cmd - x  : yabai -m window --display recent; yabai -m display --focus recent
        ctrl + cmd - z  : yabai -m window --display prev; yabai -m display --focus prev
        ctrl + cmd - c  : yabai -m window --display next; yabai -m display --focus next
        ctrl + cmd - 1  : yabai -m window --display 1; yabai -m display --focus 1
        ctrl + cmd - 2  : yabai -m window --display 2; yabai -m display --focus 2
        ctrl + cmd - 3  : yabai -m window --display 3; yabai -m display --focus 3

        # move floating window
        shift + ctrl - a : yabai -m window --move rel:-20:0
        shift + ctrl - s : yabai -m window --move rel:0:20
        shift + ctrl - w : yabai -m window --move rel:0:-20
        shift + ctrl - d : yabai -m window --move rel:20:0

        # increase window size
        shift + alt - a : yabai -m window --resize left:-20:0
        shift + alt - s : yabai -m window --resize bottom:0:20
        shift + alt - w : yabai -m window --resize top:0:-20
        shift + alt - d : yabai -m window --resize right:20:0

        # decrease window size
        shift + cmd - a : yabai -m window --resize left:20:0
        shift + cmd - s : yabai -m window --resize bottom:0:-20
        shift + cmd - w : yabai -m window --resize top:0:20
        shift + cmd - d : yabai -m window --resize right:-20:0

        # set insertion point in focused container
        # ctrl + alt - h : yabai -m window --insert west
        # ctrl + alt - j : yabai -m window --insert south
        # ctrl + alt - k : yabai -m window --insert north
        # ctrl + alt - l : yabai -m window --insert east

        # toggle window zoom
        # alt - d : yabai -m window --toggle zoom-parent

        # toggle window fullscreen zoom
        alt - z : yabai -m window --toggle zoom-fullscreen

        # toggle window native fullscreen
        shift + alt - z : yabai -m window --toggle native-fullscreen

        # toggle window border
        shift + alt - b : yabai -m window --toggle border

        # toggle window split type
        alt - e : yabai -m window --toggle split

        # float / unfloat window and center on screen
        alt - t : yabai -m window --toggle float;\
                  yabai -m window --grid 4:4:1:1:2:2

        # # toggle sticky
        # alt - s : yabai -m window --toggle sticky

        # # toggle sticky, float and resize to picture-in-picture size
        # alt - p : yabai -m window --toggle sticky;\
        #           yabai -m window --grid 5:5:4:0:1:1

        # # change layout of desktop
        # ctrl + alt - a : yabai -m space --layout bsp
        # ctrl + alt - s : yabai -m space --layout stack
      '';
    };
  };

}