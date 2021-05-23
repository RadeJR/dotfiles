import os
import socket
from libqtile.config import Screen
from libqtile import widget, bar, qtile
from keys import myTerm


colors = [["#11121d", "#11121d"],  # panel background
          ["#3d3f4b", "#434758"],  # background for current screen tab
          ["#ffffff", "#ffffff"],  # font color for group names
          ["#ff5555", "#ff5555"],  # border line color for current tab
          # border line color for 'other tabs' and color for 'odd widgets'
          ["#74438f", "#74438f"],
          ["#4f76c7", "#4f76c7"],  # color for the 'even widgets'
          ["#e1acff", "#e1acff"],  # window name
          ["#ecbbfb", "#ecbbfb"]]  # backbround for inactive screens


prompt = "{0}@{1}: ".format(os.environ["USER"], socket.gethostname())

widget_defaults = dict(
    font="Ubuntu Mono",
    fontsize=12,
    padding=0,
    background=colors[2]
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.CurrentLayoutIcon(
                    custom_icon_paths=[os.path.expanduser(
                        "~/.config/qtile/icons")],
                    foreground=colors[0],
                    background=colors[0],
                    padding=0,
                    scale=0.7
                ),
                widget.Sep(
                    linewidth=0,
                    padding=6,
                    foreground=colors[2],
                    background=colors[0]
                ),
                widget.GroupBox(
                    font="Ubuntu Bold",
                    fontsize=9,
                    margin_y=3,
                    margin_x=0,
                    padding_y=5,
                    padding_x=3,
                    borderwidth=3,
                    active=colors[2],
                    inactive=colors[7],
                    rounded=False,
                    highlight_color=colors[1],
                    highlight_method="line",
                    this_current_screen_border=colors[6],
                    this_screen_border=colors[4],
                    other_current_screen_border=colors[6],
                    other_screen_border=colors[4],
                    foreground=colors[2],
                    background=colors[0]
                ),
                widget.Prompt(
                    prompt=prompt,
                    font="Ubuntu Mono",
                    padding=10,
                    foreground=colors[3],
                    background=colors[1]
                ),
                widget.Sep(
                    linewidth=0,
                    padding=20,
                    foreground=colors[2],
                    background=colors[0]
                ),
                widget.WindowName(
                    foreground=colors[6],
                    background=colors[0],
                    padding=0
                ),
                widget.Sep(
                    linewidth=0,
                    padding=6,
                    foreground=colors[0],
                    background=colors[0]
                ),
                widget.TextBox(
                    text='',
                    background=colors[0],
                    foreground=colors[4],
                    padding=-7,
                    font='JetBrainsMono Nerd Font',
                    fontsize=43
                ),
                widget.Net(
                    interface="enp0s3",
                    format='{down} ↓↑ {up}',
                    foreground=colors[2],
                    background=colors[4],
                    padding=5
                ),
                widget.TextBox(
                    text='',
                    background=colors[4],
                    foreground=colors[5],
                    padding=-7,
                    font='JetBrainsMono Nerd Font',
                    fontsize=43
                ),
                widget.TextBox(
                    text=" ⟳",
                    padding=3,
                    foreground=colors[2],
                    background=colors[5],
                    fontsize=14
                ),
                widget.CheckUpdates(
                    update_interval=1800,
                    distro="Arch_checkupdates",
                    display_format="{updates} Updates ",
                    foreground=colors[2],
                    mouse_callbacks={'Button1': lambda: qtile.cmd_spawn(
                        myTerm + ' -e sudo pacman -Syu')},
                    background=colors[5],
                ),
                widget.TextBox(
                    text='',
                    background=colors[5],
                    foreground=colors[4],
                    padding=-7,
                    font='JetBrainsMono Nerd Font',
                    fontsize=43
                ),
                widget.TextBox(
                    text=" 🖬",
                    foreground=colors[2],
                    background=colors[4],
                    padding=0,
                    fontsize=14
                ),
                widget.Memory(
                    foreground=colors[2],
                    background=colors[4],
                    mouse_callbacks={
                        'Button1': lambda: qtile.cmd_spawn(myTerm + ' -e htop')},
                    padding=5
                ),
                widget.TextBox(
                    text='',
                    background=colors[4],
                    foreground=colors[5],
                    padding=-7,
                    font='JetBrainsMono Nerd Font',
                    fontsize=43
                ),
                widget.Clock(
                    padding=0,
                    foreground=colors[2],
                    background=colors[5],
                    format="%A, %B %d - %H:%M "
                ),
                widget.TextBox(
                    text='',
                    background=colors[5],
                    foreground=colors[4],
                    padding=-7,
                    font='JetBrainsMono Nerd Font',
                    fontsize=43
                ),
                widget.Systray(
                    background=colors[4],
                    padding=5
                ),
                widget.Sep(
                    linewidth=0,
                    padding=9,
                    foreground=colors[2],
                    background=colors[4]
                ),
            ],
            22,
        ),
    ),
]
