--[[

     Awesome WM configuration template
     github.com/lcpz

--]]

-- {{{ Required libraries
local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag
local ipairs, string, os, table, tostring, tonumber, type = ipairs, string, os, table, tostring, tonumber, type

local gears         = require("gears")
local awful         = require("awful")
                      require("awful.autofocus")
                      --require("awful.permissions")
local beautiful     = require("beautiful")
--local wibox         = require("wibox")
--local naughty       = require("naughty")
local lain          = require("lain")
--local menubar       = require("menubar")
local freedesktop   = require("freedesktop")
local hotkeys_popup = require("awful.hotkeys_popup").widget
                      require("awful.hotkeys_popup.keys")
local dpi           = require("beautiful.xresources").apply_dpi
-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

if naughty then
    --naughty.config.defaults.border_width = 0
    --naughty.config.defaults.margin = 16
    --naughty.config.defaults.shape = helpers.rrect(6)
    --naughty.config.defaults.text = "Boo!"
    naughty.config.defaults.timeout = 10
    naughty.config.padding = dpi(8)
    --naughty.config.presets.critical.bg = "#FE634E"
    --naughty.config.presets.critical.fg = "#fefefa"
    --naughty.config.presets.low.bg = "#1771F1"
    --naughty.config.presets.normal.bg = "#1771F1"
    --naughty.config.defaults.icon_size = 64
    naughty.config.spacing = dpi(8)
end


-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Autostart windowless processes

-- This function will run once every time Awesome is started
local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
    end
end


run_once({"picom -b --vsync --backend glx"})

-- This function implements the XDG autostart specification
--[[
awful.spawn.with_shell(
    'if (xrdb -query | grep -q "^awesome\\.started:\\s*true$"); then exit; fi;' ..
    'xrdb -merge <<< "awesome.started:true";' ..
    -- list each of your autostart commands, followed by ; inside single quotes, followed by ..
    'dex --environment Awesome --autostart --search-paths "$XDG_CONFIG_DIRS/autostart:$XDG_CONFIG_HOME/autostart"' -- https://github.com/jceb/dex
)
--]]

-- }}}

-- {{{ Variable definitions

local themes = {
    "blackburn",       -- 1
    "copland",         -- 2
    "dremora",         -- 3
    "holo",            -- 4
    "multicolor",      -- 5
    "powerarrow",      -- 6
    "powerarrow-dark", -- 7
    "rainbow",         -- 8
    "steamburn",       -- 9
    "vertex",          -- 10
}

local chosen_theme = themes[2]
local modkey       = "Mod4"
local altkey       = "Mod1"
local terminal     = "konsole"
local cycle_prev   = false -- cycle trough all previous client or just the first -- https://github.com/lcpz/awesome-copycats/issues/274
local editor       = os.getenv("EDITOR") or "vim"
local gui_editor   = os.getenv("GUI_EDITOR") or "gvim"
local browser      = os.getenv("BROWSER") or "google-chrome"

awful.util.terminal = terminal
awful.util.tagnames = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" }
awful.layout.layouts = {
    awful.layout.suit.tile,
    --awful.layout.suit.floating,
    --awful.layout.suit.tile.left,
    --awful.layout.suit.tile.bottom,
    --awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.max,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier,
    --awful.layout.suit.corner.nw,
    --awful.layout.suit.corner.ne,
    --awful.layout.suit.corner.sw,
    --awful.layout.suit.corner.se,
    --lain.layout.cascade,
    --lain.layout.cascade.tile,
    --lain.layout.centerwork,
    --lain.layout.centerwork.horizontal,
    --lain.layout.termfair,
    --lain.layout.termfair.center,
}

lain.layout.termfair.nmaster           = 3
lain.layout.termfair.ncol              = 1
lain.layout.termfair.center.nmaster    = 3
lain.layout.termfair.center.ncol       = 1
lain.layout.cascade.tile.offset_x      = dpi(2)
lain.layout.cascade.tile.offset_y      = dpi(32)
lain.layout.cascade.tile.extra_padding = dpi(5)
lain.layout.cascade.tile.nmaster       = 5
lain.layout.cascade.tile.ncol          = 2

beautiful.init(string.format("%s/.config/awesome/awesome-copycats/themes/%s/theme.lua", os.getenv("HOME"), chosen_theme))
-- }}}


--menubar.utils.terminal = terminal -- Set the Menubar terminal for applications that require it
-- }}}

-- {{{ Screen
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s) beautiful.at_screen_connect(s) end)
-- }}}

-- {{{ Key bindings

local function scratchpad(rules)
    return function()
        for c in awful.client.iterate(
            function (c) 
                return awful.rules.match(c, rules) 
            end
        ) do
            c.minimized = not c.minimized
            if not c.minimized then
                client.focus = c
                c:raise()
            end
        end
    end
end

globalkeys = gears.table.join(
    -- Hotkeys
    awful.key({ modkey, "Ctrl"  }, "h",      hotkeys_popup.show_help,
              {description = "show help", group="awesome"}),
    awful.key({ modkey, "Shift" }, "e",
        function()
            awful.spawn("qdbus org.kde.ksmserver /KSMServer org.kde.KSMServerInterface.logout -1 -1 -1", false)
        end
    ),
    awful.key({ altkey,         }, "space",
        function()
            --awful.spawn("qdbus org.kde.krunner /App display", false)
            awful.spawn("rofi -show combi", false)
        end
    ),
    awful.key({ altkey, "Shift" }, "space",
        function()
            awful.spawn("rofi -show calc -modi calc -no-show-match -no-sort", false)
        end
    ),
    -- Tag browsing
    awful.key({ modkey, "Shift" }, "h", function() lain.util.tag_view_nonempty(-1, true) end,
              {description = "view previous empty", group = "tag"}),
    awful.key({ modkey, "Shift" }, "l", function() lain.util.tag_view_nonempty(1, true) end,
              {description = "view next empty", group = "tag"}),
    awful.key({ modkey,           }, "BackSpace", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    -- Non-empty tag browsing
    awful.key({ modkey }, "h", function () lain.util.tag_view_nonempty(-1) end,
              {description = "view  previous nonempty", group = "tag"}),
    awful.key({ modkey }, "l", function () lain.util.tag_view_nonempty(1) end,
              {description = "view  previous nonempty", group = "tag"}),


    -- By direction client focus
    awful.key({ altkey }, "j",
        function()
            awful.client.focus.global_bydirection("down")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus down", group = "client"}),
    awful.key({ altkey }, "k",
        function()
            awful.client.focus.global_bydirection("up")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus up", group = "client"}),
    awful.key({ altkey }, "h",
        function()
            awful.client.focus.global_bydirection("left")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus left", group = "client"}),
    awful.key({ altkey }, "l",
        function()
            awful.client.focus.global_bydirection("right")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus right", group = "client"}),

    -- Layout manipulation
    awful.key({ altkey, "Shift"   }, "h", function () awful.client.swap.bydirection("left")    end,
              {description = "swap with left", group = "client"}),
    awful.key({ altkey, "Shift"   }, "j", function () awful.client.swap.bydirection("down")    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ altkey, "Shift"   }, "k", function () awful.client.swap.bydirection("up")    end,
              {description = "swap with left", group = "client"}),
    awful.key({ altkey, "Shift"   }, "l", function () awful.client.swap.bydirection( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ altkey,           }, "Tab",
        function ()
            if cycle_prev then
                awful.client.focus.history.previous()
            else
                awful.client.focus.byidx(-1)
            end
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "cycle with previous/go back", group = "client"}),
    awful.key({ altkey, "Shift"   }, "Tab",
        function ()
            if cycle_prev then
                awful.client.focus.byidx(1)
                if client.focus then
                    client.focus:raise()
                end
            end
        end,
        {description = "go forth", group = "client"}),

    -- On the fly useless gaps change
    --awful.key({ altkey, "Control" }, "=", function () lain.util.useless_gaps_resize(1) end,
    --          {description = "increment useless gaps", group = "tag"}),
    --awful.key({ altkey, "Control" }, "-", function () lain.util.useless_gaps_resize(-1) end,
    --          {description = "decrement useless gaps", group = "tag"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),

    --awful.key({ altkey, "Shift"   }, "l",     function () awful.tag.incmwfact( 0.05)          end,
    --          {description = "increase master width factor", group = "layout"}),
    --awful.key({ altkey, "Shift"   }, "h",     function () awful.tag.incmwfact(-0.05)          end,
    --          {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, altkey   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, altkey   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, altkey }, "j",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, altkey}, "k",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    -- "Scratchpad" for Slack
    awful.key({ modkey,           }, "s", scratchpad({ class = "Slack", name = "Slack | .* | Near & Dear Group", sticky = true, type = "normal" }) ),
    -- "Scratchpad" for Spotify
    awful.key({ modkey,           }, "p", scratchpad({ class = "Spotify", sticky = true, type = "normal" }) ),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"})

)

clientkeys = gears.table.join(

    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),

    awful.key({ modkey, "Shift"   }, "q",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),

    awful.key({ modkey, "Shift" }, "f",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),

    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),

    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),

    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),

    --awful.key({ modkey,           }, "n",
    --    function (c)
    --        -- The client currently has the input focus, so it cannot be
    --        -- minimized, since minimized clients can't have the focus.
    --        c.minimized = true
    --    end ,
    --    {description = "minimize", group = "client"}),


    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "maximize", group = "client"}),

    awful.key({ modkey, "Shift"   }, "m",      lain.util.magnify_client,
              {description = "magnify client", group = "client"}),

    awful.key({ modkey,           }, "y", 
        function (c)
            c.sticky = not c.sticky
        end,
        {description = "toggle sticky flag", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    -- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
    local descr_view, descr_toggle, descr_move, descr_toggle_focus
    if i == 1 or i == 9 then
        descr_view = {description = "view tag #", group = "tag"}
        descr_toggle = {description = "toggle tag #", group = "tag"}
        descr_move = {description = "move focused client to tag #", group = "tag"}
        descr_toggle_focus = {description = "toggle focused client on tag #", group = "tag"}
    end
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  descr_view),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  descr_toggle),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  descr_move),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  descr_toggle_focus)
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules

clientbuttons_jetbrains = gears.table.join(
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize)
)

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
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                     size_hints_honor = true
     }
    },

    -- Titlebars
    { rule_any = { type = { "dialog", "normal" } },
      properties = { titlebars_enabled = true } },

    { rule = { class = "conky" },
          properties = { below = true, sticky = true, border_width = 0, focusable = false } },

    { rule = { class = "Gimp", role = "gimp-image-window" },
          properties = { maximized = true } },

    { rule = { class = "plasmashell",  },
          properties = { floating = true, border_width = 0, focus = false, placement = awful.placement.restore } },

    { rule = { class = "plasmashell", type = "dialog" },
          properties = { above = true, sticky = true, border_width = 0 } },

    { rule = { class = "plasmashell", type = "dock" },
          properties = { above = true, sticky = true, x = 0, y = 0, border_width = 0, focusable = false } },

    { rule = { class = "plasmashell", type = "on_screen_display" },
          properties = { above = true, sticky = true, border_width = 0, floating = true, focusable = false , placement = awful.placement.center_horizontal+awful.placement.center_vertical } },

    { rule = { class = "plasmashell", type = "notification" },
          properties = { above = true, sticky = true, border_width = 1, floating = true, focusable = false } },

    { rule = { class = "plasma-desktop" },
          properties = { border_width = 0, floating = true } },

    { rule = { class = "krunner" },
          properties = { border_width = 0, floating = true } },

    { rule = { class = "systemsettings" },
          properties = { floating = true } },

    { rule = { class = "plasmashell", name = "Desktop — Plasma" },
          properties = { below = true, border_width = 0, focusable = false, raise = false, sticky = true, fullscreen = true, maximized = true } },

    { rule = { class = "Slack" },
          properties = { floating = true, sticky = true } },

    { rule = { class = "Spotify" },
        properties = { floating = true, sticky = true } },

    { rule = { class = "Slack", name = "Slack | Slack call with " },
        properties = { floating = true, sticky = false } },

    -- JetBrains IDEs
	{ rule = { class = "jetbrains-.*", }, 
        properties = { focus = true, buttons = clientbuttons_jetbrains } },
    { rule = { class = "jetbrains-.*", name = "win.*" }, 
        properties = { titlebars_enabled = false, border_width = 0, focusable = false, focus = true, floating = true, placement = awful.placement.restore } }
}
-- }}}

-- {{{ Signals

local function toggle_titlebar(c)
    --if c.floating and c.titlebars_enabled then
    --    awful.titlebar.show(c)
    --else
    --    awful.titlebar.hide(c)
    --end
end

--awful.ewmh.add_activate_filter(function(c)
--    if c.class == "plasmashell" and c.name == "Plasma" then 
--        return false 
--    end
--end, "ewmh")

--awful.permissions.add_activate_filter(function(c)
--    if c.class == "plasmashell" and c.name == "Plasma" then 
--        return false 
--    end
--end, "permissions")

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end

    toggle_titlebar(c)

    -- Remove KDE desktop
    if c.class == "plasmashell" and c.name == "Desktop — Plasma" then
        c:kill()
    end

    
    local id = c.window
    awful.spawn.easy_async_with_shell("xprop -id " .. id .. " _NET_WM_WINDOW_TYPE", function(stdout)
        if string.find(stdout, "_KDE_NET_WM_WINDOW_TYPE_ON_SCREEN_DISPLAY") then
            c.type = "on_screen_display"
            c.x = c.screen.workarea.width / 2 - c.width / 2
            c.y = c.screen.workarea.height * 0.75
            c.focusable = false
        elseif string.find(stdout, "_NET_WM_WINDOW_TYPE_NOTIFICATION") then
            c.type = "notification"
            c.focusable = false
        elseif string.find(stdout, "_NET_WM_WINDOW_TYPE_CALLS-MINI-PANEL") then
            c.type = "calls_mini_panel"
            c.sticky = true
        end
    end)

    --awful.spawn.with_shell(string.format("echo %s > /tmp/awesome.log", gears.debug.dump_return(c)))
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
--client.connect_signal("request::titlebars", function(c)
--    -- Custom
--    if beautiful.titlebar_fun then
--        beautiful.titlebar_fun(c)
--        return
--    end
--
--    -- Default
--    -- buttons for the titlebar
--    local buttons = gears.table.join(
--        awful.button({ }, 1, function()
--            c:emit_signal("request::activate", "titlebar", {raise = true})
--            awful.mouse.client.move(c)
--        end),
--        awful.button({ }, 2, function() c:kill() end),
--        awful.button({ }, 3, function()
--            c:emit_signal("request::activate", "titlebar", {raise = true})
--            awful.mouse.client.resize(c)
--        end)
--    )
--
--    awful.titlebar(c, {size = dpi(16)}) : setup {
--        { -- Left
--            awful.titlebar.widget.iconwidget(c),
--            buttons = buttons,
--            layout  = wibox.layout.fixed.horizontal
--        },
--        { -- Middle
--            { -- Title
--                align  = "center",
--                widget = awful.titlebar.widget.titlewidget(c)
--            },
--            buttons = buttons,
--            layout  = wibox.layout.flex.horizontal
--        },
--        { -- Right
--            awful.titlebar.widget.floatingbutton (c),
--            awful.titlebar.widget.maximizedbutton(c),
--            awful.titlebar.widget.stickybutton   (c),
--            awful.titlebar.widget.ontopbutton    (c),
--            awful.titlebar.widget.closebutton    (c),
--            layout = wibox.layout.fixed.horizontal()
--        },
--        layout = wibox.layout.align.horizontal
--    }
--end)

client.connect_signal("property::floating", toggle_titlebar)
client.connect_signal("property::maximized", function(c)
    if c.maximized then
        c.saved_border_width = c.border_width
        c.border_width = 0
    else
        c.border_width = c.saved_border_width or beautiful.border_width
    end
end)


client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- possible workaround for tag preservation when switching back to default screen:
-- https://github.com/lcpz/awesome-copycats/issues/251
-- }}}
