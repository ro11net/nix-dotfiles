#!/usr/bin/env sh

RED=0xffed8796

for sid in 1 2 3 4; do
    sketchybar --add space "space.$sid" left \
        --set "space.$sid" \
        space=$sid \
        icon="$sid" \
                              icon.padding_left=22                          \
                              icon.padding_right=22                         \
                              label.padding_right=33                        \
                              icon.highlight_color=$RED                     \
                              background.color=0x44ffffff \
                              background.corner_radius=5 \
                              background.height=30 \
                              background.drawing=off                         \
                              label.font="sketchybar-app-font:Regular:16.0" \
                              label.background.height=30                    \
                              label.background.drawing=on                   \
                              label.background.color=0xff494d64             \
                              label.background.corner_radius=9              \
                              label.drawing=off                             \
        script="$CONFIG_DIR/plugins/space.sh"
done

sketchybar   --add item       separator left                          \
             --set separator  icon=                                  \
                              icon.font="FiraCode Nerd Font:Regular:16.0" \
                              background.padding_left=15              \
                              background.padding_right=15             \
                              label.drawing=off                       \
                              associated_display=active               \
                              icon.color=$WHITE
