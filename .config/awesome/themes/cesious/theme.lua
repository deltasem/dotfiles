--[[
    Cesious Awesome WM theme
    Created by Culinax
    Modified by Thanos Apostolou
--]]

--local themes_path = require("gears.filesystem").get_themes_dir()
local themes_path = os.getenv("HOME") .. "/.config/awesome/themes/cesious/"
local dpi = require("beautiful.xresources").apply_dpi
theme = {}
theme.confdir                                   = os.getenv("HOME") .. "/.config/awesome/themes/cesious"

theme.widget_temp                               = theme.confdir .. "/icons/temp.png"
theme.widget_uptime                             = theme.confdir .. "/icons/ac.png"
theme.widget_cpu                                = theme.confdir .. "/icons/cpu.png"
theme.widget_weather                            = theme.confdir .. "/icons/dish.png"
theme.widget_fs                                 = theme.confdir .. "/icons/fs.png"
theme.widget_mem                                = theme.confdir .. "/icons/mem.png"
theme.widget_note                               = theme.confdir .. "/icons/note.png"
theme.widget_note_on                            = theme.confdir .. "/icons/note_on.png"
theme.widget_netdown                            = theme.confdir .. "/icons/net_down.png"
theme.widget_netup                              = theme.confdir .. "/icons/net_up.png"
theme.widget_mail                               = theme.confdir .. "/icons/mail.png"
theme.widget_batt                               = theme.confdir .. "/icons/bat.png"
theme.widget_clock                              = theme.confdir .. "/icons/clock.png"
theme.widget_vol                                = theme.confdir .. "/icons/spkr.png"
theme.taglist_squares_sel                       = theme.confdir .. "/icons/square_a.png"
theme.taglist_squares_unsel                     = theme.confdir .. "/icons/square_b.png"


theme.font              = "Noto Sans Regular 10"
theme.notification_font = "Noto Sans Bold 12"


-- {{{ Colors
theme.fg_normal  = "#efebe6"
theme.fg_focus   = "#a583f5"
theme.fg_urgent  = "#d54523"
theme.fg_minimize = "#ffffff"
--theme.bg_normal = "#222D32"
--theme.bg_focus = "#2C3940"
theme.bg_normal  = "#101421"
theme.bg_focus   = "#343846"
theme.bg_urgent  = theme.bg_normal
theme.bg_systray = theme.bg_focus
theme.bg_minimize = "#101010"

theme.bg_net = "#604B44"
theme.bg_cpu = "#344A37"
theme.bg_cpu_temp = "#353142"
theme.bg_mem = "#605F44"
-- }}}

-- {{{ Borders
theme.useless_gap   = dpi(0)
theme.border_width  = dpi(1)
theme.border_normal = "#101421"
theme.border_focus  = "#3034f1"
-- theme.border_focus  = "#303441"
theme.border_marked = "#CC9393"
-- }}}


theme.hotkeys_modifiers_fg = "#2EB398"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Display the taglist squares
theme.taglist_squares_sel   = themes_path .. "taglist/squarefw.png"
theme.taglist_squares_unsel = themes_path .. "taglist/squarew.png"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = themes_path .. "icons/submenu.png"
theme.menu_height = dpi(25)
theme.menu_width  = dpi(300)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal              = themes_path .. "titlebar/close_normal_arc.png"
theme.titlebar_close_button_focus               = themes_path .. "titlebar/close_focus_arc.png"

theme.titlebar_ontop_button_normal_inactive     = themes_path .. "titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive      = themes_path .. "titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active       = themes_path .. "titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active        = themes_path .. "titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive    = themes_path .. "titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive     = themes_path .. "titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active      = themes_path .. "titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active       = themes_path .. "titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive  = themes_path .. "titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive   = themes_path .. "titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active    = themes_path .. "titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active     = themes_path .. "titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = themes_path .. "titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path .. "titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active   = themes_path .. "titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active    = themes_path .. "titlebar/maximized_focus_active.png"

-- theme.wallpaper = themes_path .. "cesious/awesome-scrabble.png"
-- theme.wallpaper = "/big/distr/old/wallpapers/" .. "18905_1920x1080_ugadajkin.com.jpg"
theme.wallpaper = "/big/distr/old/wallpapers/" .. "Wallpapers Autumn Pack/Autumn Wallpapers (8).jpg"

-- You can use your own layout icons like this:
theme.layout_fairh      = themes_path .. "layouts/fairh.png"
theme.layout_fairv      = themes_path .. "layouts/fairv.png"
theme.layout_floating   = themes_path .. "layouts/floating.png"
theme.layout_magnifier  = themes_path .. "layouts/magnifier.png"
theme.layout_max        = themes_path .. "layouts/max.png"
theme.layout_fullscreen = themes_path .. "layouts/fullscreen.png"
theme.layout_tilebottom = themes_path .. "layouts/tilebottom.png"
theme.layout_tileleft   = themes_path .. "layouts/tileleft.png"
theme.layout_tile       = themes_path .. "layouts/tile.png"
theme.layout_tiletop    = themes_path .. "layouts/tiletop.png"
theme.layout_spiral     = themes_path .. "layouts/spiral.png"
theme.layout_dwindle    = themes_path .. "layouts/dwindle.png"
theme.layout_cornernw   = themes_path .. "layouts/cornernw.png"
theme.layout_cornerne   = themes_path .. "layouts/cornerne.png"
theme.layout_cornersw   = themes_path .. "layouts/cornersw.png"
theme.layout_cornerse   = themes_path .. "layouts/cornerse.png"

theme.awesome_icon = themes_path .. "candy-icons/apps/scalable/distributor-logo-manjaro.svg"

theme.tags_icon_tty = themes_path .. "candy-icons/apps/scalable/terminal.svg"
theme.tags_icon_web = themes_path .. "candy-icons/apps/scalable/internet-archive.svg"
theme.tags_icon_dev = themes_path .. "candy-icons/apps/scalable/cmake.svg"
theme.tags_icon_con = themes_path .. "candy-icons/apps/scalable/chrome-ighkikkfkalojiibipjigpccggljgdff-Default.svg"
theme.tags_icon_git = themes_path .. "candy-icons/apps/scalable/vscodium.svg"
theme.tags_icon_rdp = themes_path .. "candy-icons/apps/scalable/remmina.svg"
theme.tags_icon_note = themes_path .. "candy-icons/apps/scalable/basket.svg"
theme.tags_icon_mail = themes_path .. "candy-icons/apps/scalable/mail-client.svg"
theme.tags_icon_chat = themes_path .. "candy-icons/apps/scalable/slack.svg"

theme.tags_icon_dbg = themes_path .. "candy-icons/apps/scalable/nemiver.svg"

-- Define the icon theme for application icons. If not set then the icons 
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "Adwaita"

theme.wibar_height = 24

return theme
