-- Standard awesome library
local gears = require("gears")
local lain = require("lain")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
-- Freedesktop menu
local freedesktop = require("freedesktop")
-- local translate = require("awesome-wm-widgets.translate-widget.translate")
-- local cpu_widget = require("awesome-wm-widgets.cpu-widget.cpu-widget")
-- Enable VIM help for hotkeys widget when client with matching name is opened:
require("awful.hotkeys_popup.keys.vim")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end
-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then
            return
        end
        in_error = true
        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
-- Chosen colors and buttons look alike adapta maia theme
beautiful.init("/home/del/.config/awesome/themes/cesious/theme.lua")
beautiful.icon_theme = "Papirus-Dark"

beautiful.titlebar_close_button_normal = "/usr/share/awesome/themes/cesious/titlebar/close_normal_adapta.png"
beautiful.titlebar_close_button_focus = "/usr/share/awesome/themes/cesious/titlebar/close_focus_adapta.png"
beautiful.font = "Noto Sans Regular 10"
beautiful.notification_font = "Noto Sans Bold 14"

-- This is used later as the default terminal and editor to run.
browser = "exo-open --launch WebBrowser" or "firefox"
filemanager = "exo-open --launch FileManager" or "thunar"
gui_editor = "mousepad"
terminal = os.getenv("TERMINAL") or "alacritty"

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil
    return function()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end
-- }}}


-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
    { "hotkeys", function()
        return false, hotkeys_popup.show_help
    end, menubar.utils.lookup_icon("preferences-desktop-keyboard-shortcuts") },
    { "manual", terminal .. " -e man awesome", menubar.utils.lookup_icon("system-help") },
    { "edit config", gui_editor .. " " .. awesome.conffile, menubar.utils.lookup_icon("accessories-text-editor") },
    { "restart", awesome.restart, menubar.utils.lookup_icon("system-restart") }
}
myexitmenu = {
    { "log out", function()
        awesome.quit()
    end, menubar.utils.lookup_icon("system-log-out") },
    { "suspend", "systemctl suspend", menubar.utils.lookup_icon("system-suspend") },
    { "hibernate", "systemctl hibernate", menubar.utils.lookup_icon("system-suspend-hibernate") },
    { "reboot", "systemctl reboot", menubar.utils.lookup_icon("system-reboot") },
    { "shutdown", "poweroff", menubar.utils.lookup_icon("system-shutdown") }
}
mymainmenu = freedesktop.menu.build({
    icon_size = 32,
    before = {
        { "Terminal", terminal, menubar.utils.lookup_icon("utilities-terminal") },
        { "Browser", browser, menubar.utils.lookup_icon("internet-web-browser") },
        { "Files", filemanager, menubar.utils.lookup_icon("system-file-manager") },
        -- other triads can be put here
    },
    after = {
        { "Awesome", myawesomemenu, "/usr/share/awesome/icons/awesome32.png" },
        { "Exit", myexitmenu, menubar.utils.lookup_icon("system-shutdown") },
        -- other triads can be put here
    }
})
mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })
-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock("%H:%M ")
-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

darkblue = beautiful.bg_focus
blue = "#9EBABA"
red = "#EB8F8F"
separator = wibox.widget.textbox(' <span color="' .. blue .. '">| </span>')
spacer = wibox.widget.textbox(' <span color="' .. blue .. '"> </span>')
spacer2 = wibox.widget.textbox(' <span color="' .. darkblue .. '"> </span>')

local separators = lain.util.separators
local spr = wibox.widget.textbox(' ')

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
        awful.button({ }, 1, function(t)
            t:view_only()
        end),
        awful.button({ modkey }, 1, function(t)
            if client.focus then
                client.focus:move_to_tag(t)
            end
        end),
        awful.button({ }, 3, awful.tag.viewtoggle),
        awful.button({ modkey }, 3, function(t)
            if client.focus then
                client.focus:toggle_tag(t)
            end
        end),
        awful.button({ }, 4, function(t)
            awful.tag.viewnext(t.screen)
        end),
        awful.button({ }, 5, function(t)
            awful.tag.viewprev(t.screen)
        end)
)

local tasklist_buttons = gears.table.join(
        awful.button({ }, 1, function(c)
            if c == client.focus then
                c.minimized = true
            else
                -- Without this, the following
                -- :isvisible() makes no sense
                c.minimized = false
                if not c:isvisible() and c.first_tag then
                    c.first_tag:view_only()
                end
                -- This will also un-minimize
                -- the client, if needed
                client.focus = c
                c:raise()
            end
        end),
        awful.button({ }, 3, client_menu_toggle_fn()),
        awful.button({ }, 4, function()
            awful.client.focus.byidx(1)
        end),
        awful.button({ }, 5, function()
            awful.client.focus.byidx(-1)
        end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
-- screen.connect_signal("property::geometry", set_wallpaper)

local markup = lain.util.markup

-- Textclock
os.setlocale(os.getenv("LANG")) -- to localize the clock
local clockicon = wibox.widget.imagebox(theme.widget_clock)
local mytextclock = wibox.widget.textclock(markup("#7788af", "%A %d %B ") .. markup("#ab7367", ">") .. markup("#de5e1e", " %H:%M "))
mytextclock.font = theme.font

-- Calendar
--theme.cal = lain.widget.cal({
--    attach_to = { mytextclock },
--    notification_preset = {
--        font = "Noto Sans Mono Medium 10",
--        fg   = theme.fg_normal,
--        bg   = theme.bg_normal
--    }
--})
local month_calendar = awful.widget.calendar_popup.month()
month_calendar:attach(mytextclock, "tr")


-- MEM
-- theme.widget_mem                                = theme.confdir .. "/icons/mem.png"
local memicon = wibox.widget.imagebox(theme.widget_mem)
local memory = lain.widget.mem({
    settings = function()
        widget:set_markup(markup.fontfg(theme.font, "#e0da37", mem_now.used .. "M "))
    end
})

-- CPU
local cpuicon = wibox.widget.imagebox(theme.widget_cpu)
local cpu = lain.widget.cpu({
    settings = function()
        widget:set_markup(markup.fontfg(theme.font, "#e33a6e", " " .. string.format("%02.0f", cpu_now.usage) .. "% "))
    end
})

-- Coretemp
local tempicon = wibox.widget.imagebox(theme.widget_temp)
local temp = lain.widget.temp({
    tempfile = "/sys/devices/pci0000:00/0000:00:18.3/hwmon/hwmon1/temp1_input",
    settings = function()
        widget:set_markup(markup.fontfg(theme.font, "#f1af5f", string.format("%02.1f", coretemp_now) .. "°C "))
    end
})

-- Net
local netdownicon = wibox.widget.imagebox(theme.widget_netdown)
local netdowninfo = wibox.widget.textbox()
local netupicon = wibox.widget.imagebox(theme.widget_netup)
local netupinfo = lain.widget.net({
    settings = function()
        --        if iface ~= "network off" and
        --           string.match(theme.weather.widget.text, "N/A")
        --        then
        --            theme.weather.update()
        --        end

        widget:set_markup(markup.fontfg(theme.font, "#e54c62", string.format("%06.1f", net_now.sent) .. " "))
        netdowninfo:set_markup(markup.fontfg(theme.font, "#87af5f", string.format("%06.1f", net_now.received) .. " "))
    end
})

--[[ CPU diagram
local cpuDiagram = cpu_widget({
    width = 70,
    step_width = 2,
    step_spacing = 0,
    color = '#434c5e'
})
--[[]]


--[[
screen_tags = {
    { },
   { "r&b", "con", "yrn", "dsgn", "?", "?", "?", "?", "?" },
   { "chr", "svc", "ins", "dbg", "tst", "term", "dsgn", "yrn", "build" },
}
]]--


local screens = {
	{ 
    { name = "tty", icon = theme.tags_icon_tty, gap = 3 },
    { name = "web", icon = theme.tags_icon_web },  
    { name = "dev", icon = theme.tags_icon_dev, master_width_factor = 0.85 },
    { name = "con", icon = theme.tags_icon_con },
    { name = "git", icon = theme.tags_icon_git },
    { name = "rdp", icon = theme.tags_icon_rdp },    
    { name = "note", icon = theme.tags_icon_note },    
    { name = "mail", icon = theme.tags_icon_mail },    
    { name = "chat", icon = theme.tags_icon_chat },    
	},
	{
    { name = "chr", icon = theme.tags_icon_chr },
    { name = "svc", icon = theme.tags_icon_svc },  
    { name = "ins", icon = theme.tags_icon_ins },
    { name = "dbg", icon = theme.tags_icon_dbg },
    { name = "tst", icon = theme.tags_icon_tst },
    { name = "term", icon = theme.tags_icon_term },    
    { name = "dsgn", icon = theme.tags_icon_dsgn },    
    { name = "yrn", icon = theme.tags_icon_yrn },    
    { name = "build", icon = theme.tags_icon_build, gap = 3 },    
	}
};

for j = 1, #screens do
	local scrn = screens[j]
  for i = 1, #scrn do
      awful.tag.add(scrn[i].name, {
          icon = scrn[i].icon,
          gap = scrn[i].gap,
          layout =  awful.layout.layouts[1],
          screen = j,
          selected = i == 1,
					master_width_factor = scrn[i].master_width_factor
      })
  end
end


awful.screen.connect_for_each_screen(function(s)


    -- Wallpaper
    -- set_wallpaper(s)

    -- Each screen has its own tag table.
--    if s ~= 1 then
--        awful.tag(screen_tags[s.index], s, awful.layout.layouts[1])
--    end

    

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
            awful.button({ }, 1, function()
                awful.layout.inc(1)
            end),
            awful.button({ }, 3, function()
                awful.layout.inc(-1)
            end),
            awful.button({ }, 4, function()
                awful.layout.inc(1)
            end),
            awful.button({ }, 5, function()
                awful.layout.inc(-1)
            end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    local tray = wibox.widget.systray()
    tray.set_base_size(24)
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
            separator,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            --	    memory,
            --separator,
            --arrl_dl,
            spr,
            separators.arrow_left(theme.bg_mem, theme.bg_mem),
            wibox.container.background(memicon, theme.bg_mem),
            wibox.container.background(memory.widget, theme.bg_mem),
            separators.arrow_left(theme.bg_mem, theme.bg_cpu),
            wibox.container.background(cpuicon, theme.bg_cpu),
            wibox.container.background(cpu.widget, theme.bg_cpu),
            separators.arrow_left(theme.bg_cpu, theme.bg_cpu_temp),
            wibox.container.background(tempicon, theme.bg_cpu_temp),
            wibox.container.background(temp.widget, theme.bg_cpu_temp),
            separators.arrow_left(theme.bg_cpu_temp, theme.bg_net),
            wibox.container.background(netdownicon, theme.bg_net),
            wibox.container.background(netdowninfo, theme.bg_net),
            wibox.container.background(netupicon, theme.bg_net),
            wibox.container.background(netupinfo.widget, theme.bg_net),
            --cpuDiagram,
            separators.arrow_left(theme.bg_net, theme.bg_focus),
            tray,
            mykeyboardlayout,
            separator,
            mytextclock,
            s.mylayoutbox,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
        awful.button({ }, 1, function()
            mymainmenu:hide()
        end),
        awful.button({ }, 3, function()
            mymainmenu:toggle()
        end),
        awful.button({ }, 4, awful.tag.viewnext),
        awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

local function gotoTag(name)
	local t = awful.tag.find_by_name(nil, name)
	for i = 1, #t.screen.selected_tags do
		t.screen.selected_tags[i].selected = false
	end
	t.selected = true
	--t:view_only()
end

local function gotoFigma()
	gotoTag("dsgn")
end

local function gotoChrome()
	gotoTag("chr")
end

local function gotoDev()
	gotoTag("dev")
end

local function gotoGit()
	gotoTag("git")
end

local function gotoWeb()
	gotoTag("web")
end

local function gotoBuild()
	gotoTag("build")
end

-- {{{ Key bindings
globalkeys = gears.table.join(
        awful.key({ modkey, }, "d",  gotoDev, { description = "dev", group = "tags shortcut" }),
        awful.key({ modkey, }, "c",  gotoChrome, { description = "chrome", group = "tags shortcut" }),
        awful.key({ modkey, }, "f",  gotoFigma, { description = "figma", group = "tags shortcut" }),
        awful.key({ modkey, }, "g",  gotoGit, { description = "git", group = "tags shortcut" }),
        awful.key({ modkey, }, "w",  gotoWeb, { description = "web", group = "tags shortcut" }),
        awful.key({ modkey, }, "b",  gotoBuild, { description = "build", group = "tags shortcut" }),


        awful.key({ modkey, }, "s", hotkeys_popup.show_help,
                { description = "show help", group = "awesome" }),
        awful.key({ modkey, }, "Left", awful.tag.viewprev,
                { description = "view previous", group = "tag" }),
        awful.key({ modkey, }, "Right", awful.tag.viewnext,
                { description = "view next", group = "tag" }),
        awful.key({ modkey, }, "Escape", awful.tag.history.restore,
                { description = "go back", group = "tag" }),

        awful.key({ modkey, }, "j",
                function()
                    awful.client.focus.byidx(1)
                end,
                { description = "focus next by index", group = "client" }
        ),
        awful.key({ modkey, }, "k",
                function()
                    awful.client.focus.byidx(-1)
                end,
                { description = "focus previous by index", group = "client" }
        ),
--[[       
        awful.key({ modkey, }, "w", function()
            mymainmenu:show()
        end,
                { description = "show main menu", group = "awesome" }),
]]--

-- Layout manipulation
        awful.key({ modkey, "Shift" }, "j", function()
            awful.client.swap.byidx(1)
        end,
                { description = "swap with next client by index", group = "client" }),
        awful.key({ modkey, "Shift" }, "k", function()
            awful.client.swap.byidx(-1)
        end,
                { description = "swap with previous client by index", group = "client" }),
        awful.key({ modkey, "Control" }, "j", function()
            awful.screen.focus_relative(1)
        end,
                { description = "focus the next screen", group = "screen" }),
        awful.key({ modkey, "Control" }, "k", function()
            awful.screen.focus_relative(-1)
        end,
                { description = "focus the previous screen", group = "screen" }),
        awful.key({ modkey, }, "u", awful.client.urgent.jumpto,
                { description = "jump to urgent client", group = "client" }),
        awful.key({ modkey, }, "Tab",
                function()
                    awful.client.focus.history.previous()
                    if client.focus then
                        client.focus:raise()
                    end
                end,
                { description = "go back", group = "client" }),

-- Standard program
--[[        awful.key({ modkey }, "c",
                function()
                    translate.show_translate_prompt('trnsl.1.1.20200514T060346Z.f9a33d804520e0bb.a158aba3ca14739fd23ac6a2c3749cb49a7b306a')
                end,
                { description = "run translate prompt", group = "launcher" }),]]
        awful.key({                   }, "#107", function()
            awful.util.spawn('flameshot gui')
        end,
                { description = "screenshot", group = "launcher" }),
--awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
        awful.key({ modkey, }, "Return", function()
            awful.util.spawn('alacritty -e fish')
        end,
                { description = "open a terminal", group = "launcher" }),
        awful.key({ modkey, }, "z", function()
            awful.spawn(terminal)
        end,
                { description = "open a terminal", group = "launcher" }),
        awful.key({ modkey, "Control" }, "r", awesome.restart,
                { description = "reload awesome", group = "awesome" }),
        awful.key({ modkey, "Shift" }, "q", awesome.quit,
                { description = "quit awesome", group = "awesome" }),

        awful.key({ modkey, }, "l", function()
            awful.tag.incmwfact(0.05)
        end,
                { description = "increase master width factor", group = "layout" }),
        awful.key({ modkey, }, "h", function()
            awful.tag.incmwfact(-0.05)
        end,
                { description = "decrease master width factor", group = "layout" }),
        awful.key({ modkey, "Shift" }, "h", function()
            awful.tag.incnmaster(1, nil, true)
        end,
                { description = "increase the number of master clients", group = "layout" }),
        awful.key({ modkey, "Shift" }, "l", function()
            awful.tag.incnmaster(-1, nil, true)
        end,
                { description = "decrease the number of master clients", group = "layout" }),
        awful.key({ modkey, "Control" }, "h", function()
            awful.tag.incncol(1, nil, true)
        end,
                { description = "increase the number of columns", group = "layout" }),
        awful.key({ modkey, "Control" }, "l", function()
            awful.tag.incncol(-1, nil, true)
        end,
                { description = "decrease the number of columns", group = "layout" }),
        awful.key({ modkey }, "v", function()
            awful.util.spawn("/usr/bin/vifm")
        end,
                { description = "launch vifm", group = "launcher" }),
        awful.key({ modkey, "Control" }, "b", function()
            awful.spawn(browser)
        end,
                { description = "launch Browser", group = "launcher" }),
        awful.key({ modkey, "Control" }, "Escape", function()
            awful.spawn("/usr/bin/rofi -show drun -modi drun,run,ssh,window,windowcd,combi,keys")
        end,
                { description = "launch rofi", group = "launcher" }),
        awful.key({ modkey, }, "e", function()
            awful.spawn(filemanager)
        end,
                { description = "launch filemanager", group = "launcher" }),
        awful.key({ modkey, }, "space", function()
            awful.layout.inc(1)
        end,
                { description = "select next", group = "layout" }),
        awful.key({ modkey, "Shift" }, "space", function()
            awful.layout.inc(-1)
        end,
                { description = "select previous", group = "layout" }),
        awful.key({                   }, "Print", function()
            awful.spawn.with_shell("sleep 0.1 && /usr/bin/i3-scrot -d")
        end,
                { description = "capture a screenshot", group = "screenshot" }),
        awful.key({ "Control" }, "Print", function()
            awful.spawn.with_shell("sleep 0.1 && /usr/bin/i3-scrot -w")
        end,
                { description = "capture a screenshot of active window", group = "screenshot" }),
        awful.key({ "Shift" }, "Print", function()
            awful.spawn.with_shell("sleep 0.1 && /usr/bin/i3-scrot -s")
        end,
                { description = "capture a screenshot of selection", group = "screenshot" }),

        awful.key({ modkey, "Control" }, "n",
                function()
                    local c = awful.client.restore()
                    -- Focus restored client
                    if c then
                        client.focus = c
                        c:raise()
                    end
                end,
                { description = "restore minimized", group = "client" }),

-- Prompt
        awful.key({ modkey }, "r", function()
            awful.screen.focused().mypromptbox:run()
        end,
                { description = "run prompt", group = "launcher" }),

        awful.key({ modkey }, "ö",
                function()
                    awful.prompt.run {
                        prompt = "Run Lua code: ",
                        textbox = awful.screen.focused().mypromptbox.widget,
                        exe_callback = awful.util.eval,
                        history_path = awful.util.get_cache_dir() .. "/history_eval"
                    }
                end,
                { description = "lua execute prompt", group = "awesome" }),
-- Menubar
        awful.key({ modkey }, "p", function()
            menubar.show()
        end,
                { description = "show the menubar", group = "launcher" })
)

clientkeys = gears.table.join(
        awful.key({ modkey, "Shift" }, "f",
                function(c)
                    c.fullscreen = not c.fullscreen
                    c:raise()
                end,
                { description = "toggle fullscreen", group = "client" }),
        awful.key({ modkey, }, "x", function(c)
            c:kill()
        end,
                { description = "close", group = "client" }),
        awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle,
                { description = "toggle floating", group = "client" }),
        awful.key({ modkey, "Control" }, "Return", function(c)
            c:swap(awful.client.getmaster())
        end,
                { description = "move to master", group = "client" }),
        awful.key({ modkey, }, "o", function(c)
            c:move_to_screen()
        end,
                { description = "move to screen", group = "client" }),
        awful.key({ modkey, }, "t", function(c)
            c.ontop = not c.ontop
        end,
                { description = "toggle keep on top", group = "client" }),
        awful.key({ modkey, }, "n",
                function(c)
                    -- The client currently has the input focus, so it cannot be
                    -- minimized, since minimized clients can't have the focus.
                    c.minimized = true
                end,
                { description = "minimize", group = "client" }),
        awful.key({ modkey, }, "m",
                function(c)
                    c.maximized = not c.maximized
                    c:raise()
                end,
                { description = "(un)maximize", group = "client" }),
        awful.key({ modkey, "Control" }, "m",
                function(c)
                    c.maximized_vertical = not c.maximized_vertical
                    c:raise()
                end,
                { description = "(un)maximize vertically", group = "client" }),
        awful.key({ modkey, "Shift" }, "m",
                function(c)
                    c.maximized_horizontal = not c.maximized_horizontal
                    c:raise()
                end,
                { description = "(un)maximize horizontally", group = "client" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
    -- View tag only.
            awful.key({ modkey }, "#" .. i + 9,
                    function()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                            tag:view_only()
                        end
                    end,
                    { description = "view tag #" .. i, group = "tag" }),
    -- Toggle tag display.
            awful.key({ modkey, "Control" }, "#" .. i + 9,
                    function()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                            awful.tag.viewtoggle(tag)
                        end
                    end,
                    { description = "toggle tag #" .. i, group = "tag" }),
    -- Move client to tag.
            awful.key({ modkey, "Shift" }, "#" .. i + 9,
                    function()
                        if client.focus then
                            local tag = client.focus.screen.tags[i]
                            if tag then
                                client.focus:move_to_tag(tag)
                            end
                        end
                    end,
                    { description = "move focused client to tag #" .. i, group = "tag" }),
    -- Toggle tag on focused client.
            awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                    function()
                        if client.focus then
                            local tag = client.focus.screen.tags[i]
                            if tag then
                                client.focus:toggle_tag(tag)
                            end
                        end
                    end,
                    { description = "toggle focused client on tag #" .. i, group = "tag" })
    )
end

clientbuttons = gears.table.join(
        awful.button({ }, 1, function(c)
            client.focus = c;
            c:raise()
            mymainmenu:hide()
        end),
        awful.button({ modkey }, 1, awful.mouse.client.move),
        awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     size_hints_honor = false, -- Remove gaps between terminals
                     screen = awful.screen.preferred,
                     callback = awful.client.setslave,
                     placement = awful.placement.no_overlap + awful.placement.no_offscreen
      }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
            "DTA", -- Firefox addon DownThemAll.
            "copyq", -- Includes session name in class.
        },
        class = {
            "Arandr",
            "Gpick",
            "Kruler",
            "MessageWin", -- kalarm.
            "Sxiv",
            "Wpa_gui",
            "pinentry",
            "veromix",
            "xtightvncviewer" },

        name = {
            "Event Tester", -- xev.
        },
        role = {
            "AlarmWindow", -- Thunderbird's calendar.
            "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
        }
    }, properties = { floating = true } },

    -- Add titlebars to normal clients and dialogs
    -- { rule_any = {type = { "normal", "dialog" } },
    --   properties = { titlebars_enabled = true }
    -- },
    { rule_any = { type = { "dialog" } },
      properties = { titlebars_enabled = true }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
    { rule = { class = "Firefox" }, properties = { screen = 1, tag = "web" } },
    { rule = { class = "TelegramDesktop" }, properties = { titlebars_enabled = false, screen = 1, tag = "chat" } },
    { rule = { class = "Slack" }, properties = { titlebars_enabled = false, screen = 1, tag = "chat" } },
    { rule = { class = "Chromium" }, properties = { titlebars_enabled = false, screen = 2, tag = "chr" } },
    { rule = { class = "Chromium", name = "*Figma - Chromium" }, properties = { titlebars_enabled = false, screen = 2, tag = "dsgn" } },
    { rule = { class = "Notable" }, properties = { titlebars_enabled = false, screen = 1, tag = "note" } },
    { rule = { class = "Thunderbird" }, properties = { titlebars_enabled = false, screen = 1, tag = "mail" } },
    { rule = { class = "Qmmp" }, properties = { titlebars_enabled = false, screen = 1, tag = "tty" } },
    { rule = { class = "jetbrains-rider", name = "Services - *" }, properties = { screen = 2, tag = "svc" } },
    { rule = { class = "jetbrains-rider", name = "Unit Tests - *" }, properties = { screen = 2, tag = "tst" } },
    { rule = { class = "jetbrains-rider", name = "Terminal - *" }, properties = { screen = 2, tag = "term" } },
    { rule = { class = "jetbrains-rider", name = "Debug - *" }, properties = { screen = 2, tag = "dbg" } },
    { rule = { class = "jetbrains-rider", name = "Build - *" }, properties = { screen = 2, tag = "build" } },
    { rule = { class = "jetbrains-rider", name = "Run - *" }, properties = { screen = 2, tag = "build" } },
}
-- }}}

-- {{{ Signals


-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
            not c.size_hints.user_position
            and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
            awful.button({ }, 1, function()
                client.focus = c
                c:raise()
                awful.mouse.client.move(c)
            end),
            awful.button({ }, 3, function()
                client.focus = c
                c:raise()
                awful.mouse.client.resize(c)
            end)
    )

    awful.titlebar(c):setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton(c),
            awful.titlebar.widget.stickybutton(c),
            -- awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
    -- Hide the menubar if we are not floating
    -- local l = awful.layout.get(c.screen)
    -- if not (l.name == "floating" or c.floating) then
    --     awful.titlebar.hide(c)
    -- end
end)

-- Enable sloppy focus, so that focus follows mouse.
--client.connect_signal("mouse::enter", function(c)
--    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
--        and awful.client.focus.filter(c) then
--        client.focus = c
--    end
--end)

client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
end)
client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
end)

-- Disable borders on lone windows
-- Handle border sizes of clients.
for s = 1, screen.count() do
    screen[s]:connect_signal("arrange", function()
        local clients = awful.client.visible(s)
        local layout = awful.layout.getname(awful.layout.get(s))

        for _, c in pairs(clients) do
            -- No borders with only one humanly visible client
            if c.maximized then
                -- NOTE: also handled in focus, but that does not cover maximizing from a
                -- tiled state (when the client had focus).
                c.border_width = 0
            elseif c.floating or layout == "floating" then
                c.border_width = beautiful.border_width
            elseif layout == "max" or layout == "fullscreen" then
                c.border_width = 0
            else
                local tiled = awful.client.tiled(c.screen)
                if #tiled == 1 then
                    -- and c == tiled[1] then
                    tiled[1].border_width = 0
                    -- if layout ~= "max" and layout ~= "fullscreen" then
                    -- XXX: SLOW!
                    -- awful.client.moveresize(0, 0, 2, 0, tiled[1])
                    -- end
                else
                    c.border_width = beautiful.border_width
                end
            end
        end
    end)
end

-- }}}

--client.connect_signal("property::floating", function (c)
--    if c.floating then
--        awful.titlebar.show(c)
--    else
--        awful.titlebar.hide(c)
--    end
--end)

awful.spawn.with_shell("nitrogen --restore")
-- awful.spawn.with_shell("picom --config  $HOME/.config/picom/picom.conf")

awful.spawn.with_shell("~/.config/awesome/autorun.sh")
os.execute("pgrep -u $USER -x compton || (compton &)")
--os.execute("pgrep -u $USER -x Telegram || (delay 5; telegram-desktop &)")
os.execute("pgrep -u $USER -x slack || (slack &)")
os.execute("pgrep -u $USER -x notable || (notable &)")
os.execute("pgrep -u $USER -x thunderbird || (thunderbird &)")
os.execute("pgrep -u $USER -x remmina || (remmina -i &)")
os.execute("xset -display $DISPLAY s off -dpms")
os.execute("/home/del/nfancurve/temp.sh &")
