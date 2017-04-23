-----------------------------
-- AwesomeWM configuration --
--      version v4.0       --
--  <herulor@gmail.com>    --
--  based on Dust GTX by tdy@gmx.com
-----------------------------

local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
beautiful.init(awful.util.getdir("config") .. "/themes/multidust/theme.lua")
local naughty = require("naughty")
local menubar = require("menubar")
local wi = require("wi")

-- {{{ Error handling
-- Startup
if awesome.startup_errors then
	naughty.notify({ preset = naughty.config.presets.critical,
	title = "Oops, there were errors during startup!",
	text = awesome.startup_errors })
end

-- Runtime
do
	local in_error = false
	awesome.connect_signal("debug::error",
	function(err)
		if in_error then return end
		in_error = true
		naughty.notify({ preset = naughty.config.presets.critical,
		title = "Oops, an error happened!",
		text = err })
		in_error = false
	end)
end
-- }}}

-- {{{ Variables
terminal   = awful.util.getdir("config") .. "../../bin/Materm"
--terminal   = "urxvt"
editor     = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

modkey = "Mod4"
altkey = "Mod1"
-- }}}

-- {{{ Layouts
local layouts = {
	awful.layout.suit.floating,
	awful.layout.suit.tile,
	awful.layout.suit.tile.left,
	awful.layout.suit.tile.bottom,
	awful.layout.suit.tile.top,
	awful.layout.suit.fair,
	awful.layout.suit.fair.horizontal,
	awful.layout.suit.spiral,
	awful.layout.suit.spiral.dwindle,
	awful.layout.suit.max,
	awful.layout.suit.max.fullscreen,
	awful.layout.suit.magnifier
}
-- }}}

-- {{{ Naughty presets
naughty.config.defaults.timeout = 5
naughty.config.defaults.screen = 1
naughty.config.defaults.position = "top_right"
naughty.config.defaults.margin = 8
naughty.config.defaults.gap = 1
naughty.config.defaults.ontop = true
naughty.config.defaults.font = "Fixed 9"
naughty.config.defaults.icon = nil
naughty.config.defaults.icon_size = 256
naughty.config.defaults.fg = beautiful.fg_tooltip
naughty.config.defaults.bg = beautiful.bg_tooltip
naughty.config.defaults.border_color = beautiful.border_tooltip
naughty.config.defaults.border_width = 2
naughty.config.defaults.hover_timeout = nil
-- }}}


--  {{{ Wallpaper configuration - edit to your liking
math.randomseed(os.time())
wp_path = awful.util.getdir("config") .. "../../Imagenes/Wallpapers/"

-- Get the list of files from a directory. Must be all images or folders and non-empty. 
function scanDir(directory)
	local i, fileList, popen = 0, {}, io.popen
	for filename in popen([[find "]] ..directory.. [[" -type f]]):lines() do
		i = i + 1
		fileList[i] = filename
	end
	return fileList
end
wp_files = scanDir(wp_path)

function setWalls()
	if beautiful.wallpaper then
		for s = 1, screen.count() do
			if s < 2 then
				gears.wallpaper.fit(wp_files[math.random(1, #wp_files)], s)
			else
				gears.wallpaper.fit(wp_files[math.random(1, #wp_files)], s)
			end
		end
	end
end

setWalls()

-- setup the timer
wp_timeout  = math.random(200, 600)
wp_timer = timer { timeout = wp_timeout }
wp_timer:connect_signal("timeout", function()

	-- set wallpaper to current index
	setWalls()

	-- stop the timer (we don't need multiple instances running at the same time)
	wp_timer:stop()

	--restart the timer
	wp_timer.timeout = wp_timeout
	wp_timer:start()
end)

-- initial start when rc.lua is first run
wp_timer:start()

--}}}


-- {{{ Launcher functions: Lock, Reboot and Shutdown
mylauncher = wibox.widget.imagebox()
mylauncher:set_image(beautiful.awesome_icon)
mylauncher:buttons(awful.util.table.join(
-- Lock
awful.button({ }, 1,
function()
	local lock = "i3lock -d -p default -i /home/herulor/Imagenes/Wallpapers/AlgebraicsLock.png"
	awful.spawn(lock, false)
end),

-- Reboot and shutdown
awful.button({ modkey }, 1,
function()
	local shutdown = awful.util.getdir("config") .. "../../bin/shutdown_dialog.sh"
	awful.spawn(shutdown, false)
end)))
-- }}}


-- Menubar
menubar.utils.terminal = terminal

-- Create a wibox for each screen and add it
-- {{{ Initialize wiboxes
mywibox = {}
mygraphbox = {}
mypromptbox = {}
mylayoutbox = {}

-- Taglist
mytaglist = {}
local mytaglist_buttons = awful.util.table.join(

awful.button({ }, 1, function (t)
	t:view_only()
end),

awful.button({ modkey }, 1, function (t) 
	if client.focus then
		client.focus:move_to_tag(t)
	end
end),

awful.button({ }, 3, awful.tag.viewtoggle),
awful.button({ modkey }, 3, function (t)
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

-- Tasklist
mytasklist = {}
local mytasklist_buttons = awful.util.table.join(
awful.button({ }, 1,
function(c)
	if c == client.focus then
		c.minimized = true
	else
		c.minimized = false
		if not c:isvisible() and c.first_tag then
			c.first_tag:view_only()
		end
		client.focus = c
		c:raise()
	end
end),
awful.button({ }, 3,
function()
	if instance then
		instance:hide()
		instance = nil
	else
		instance = awful.menu.clients({ width=250 })
	end
end),
awful.button({ }, 4,
function()
	awful.client.focus.byidx(1)
	if client.focus then client.focus:raise() end
end),
awful.button({ }, 5,
function()
	awful.client.focus.byidx(-1)
	if client.focus then client.focus:raise() end
end))
-- }}}



-- {{{ Create wiboxes
awful.screen.connect_for_each_screen(function(s)

	local tagnames = { "一", "二", "三", "四", "五", "六", "七", "八", "九", "十" }
	local taglayouts = { layouts[2], layouts[10], layouts[2], layouts[2], layouts[2],
	layouts[3], layouts[10], layouts[6], layouts[6], layouts[1] }
	awful.tag(tagnames, s, taglayouts)

	s.mypromptbox = awful.widget.prompt()

	-- Layoutbox
	s.mylayoutbox = awful.widget.layoutbox(s)

	s.mylayoutbox:buttons(awful.util.table.join(
	awful.button({ }, 1, function() awful.layout.inc(layouts, 1) end),
	awful.button({ }, 3, function() awful.layout.inc(layouts, -1) end),
	awful.button({ }, 4, function() awful.layout.inc(layouts, 1) end),
	awful.button({ }, 5, function() awful.layout.inc(layouts, -1) end)))

	-- Taglist
	s.mytaglist = awful.widget.taglist(s,
	awful.widget.taglist.filter.all, mytaglist_buttons)

	-- Tasklist
	s.mytasklist = awful.widget.tasklist(s,
	awful.widget.tasklist.filter.currenttags, mytasklist_buttons)

	-- Wibox
	s.mywibox = awful.wibar({ position = "top", height = 15, screen = s })

	local left_wibox = wibox.layout.fixed.horizontal()
	left_wibox:add(s.mytaglist)
	left_wibox:add(space)
	left_wibox:add(s.mypromptbox)
	left_wibox:add(s.mylayoutbox)
	left_wibox:add(space)

	local right_wibox = wibox.layout.fixed.horizontal()
	right_wibox:add(space)
	right_wibox:add(wibox.widget.systray()) 
	right_wibox:add(mpdicon)
	right_wibox:add(mpdwidget)
	right_wibox:add(volspace)
	right_wibox:add(volicon)
	right_wibox:add(volpct)
	right_wibox:add(volpct2)
	right_wibox:add(volpct3)

	local wibox_layout = wibox.layout.align.horizontal()
	wibox_layout:set_left(left_wibox)
	wibox_layout:set_middle(s.mytasklist)
	wibox_layout:set_right(right_wibox)

	s.mywibox:set_widget(wibox_layout)

	-- Graphbox
	s.mygraphbox = awful.wibar({ position = "bottom", height = 15, screen = s })

	local left_graphbox = wibox.layout.fixed.horizontal()
	left_graphbox:add(mylauncher)
	left_graphbox:add(space)
	left_graphbox:add(diskwidget)
	left_graphbox:add(tab)
	left_graphbox:add(tempicon)
	left_graphbox:add(temp.widget)
	left_graphbox:add(space)
	left_graphbox:add(cpu0icon)
	left_graphbox:add(cpufreq)
	left_graphbox:add(cpuxicon)
	left_graphbox:add(cpupct0)
	left_graphbox:add(cpuxicon)
	left_graphbox:add(cpupct1)
	left_graphbox:add(cpuxicon)
	left_graphbox:add(cpupct2)
	left_graphbox:add(cpuxicon)
	left_graphbox:add(cpupct3)
	left_graphbox:add(cpuxicon)
	left_graphbox:add(cpupct4)
	left_graphbox:add(tab)
	left_graphbox:add(memicon)
	left_graphbox:add(memused)
	left_graphbox:add(tab)
	left_graphbox:add(mempct)
	left_graphbox:add(tab)
	left_graphbox:add(wifiicon)
	left_graphbox:add(wifi)
	left_graphbox:add(tab)
	left_graphbox:add(pacicon)
	left_graphbox:add(pacwidget)
	left_graphbox:add(tab)
	left_graphbox:add(baticon)
	left_graphbox:add(batpct)

	local right_graphbox = wibox.layout.fixed.horizontal()
	right_graphbox:add(weathericon)
	right_graphbox:add(weather)
	right_graphbox:add(space)
	right_graphbox:add(clockicon)
	right_graphbox:add(mytextclock)
	right_graphbox:add(space)

	local graphbox_layout = wibox.layout.align.horizontal()
	graphbox_layout:set_left(left_graphbox)
	graphbox_layout:set_right(right_graphbox)

	-- mygraphbox[s]:set_widget(graphbox_layout)
	s.mygraphbox:set_widget(graphbox_layout)
end
)
-- }}}

-- {{{ Global keybindings
globalkeys = awful.util.table.join(
-- Tag navigation
awful.key({ modkey, }, "Left", awful.tag.viewprev ),
awful.key({ modkey, }, "Right", awful.tag.viewnext ),
awful.key({ modkey, }, "Escape", awful.tag.history.restore),

-- Client navigation
awful.key({ altkey, }, "Tab",
function()
	awful.client.focus.byidx( 1)
	if client.focus then client.focus:raise() end
end),
awful.key({ modkey, "Shift" }, "Tab",
function()
	awful.client.focus.byidx(-1)
	if client.focus then client.focus:raise() end
end),

-- Layout manipulation
awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx( 1) end),
awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.byidx(-1) end),
awful.key({ modkey, }, "Tab", function() awful.screen.focus_relative( 1) end),
awful.key({ modkey, "Shift" }, "Tab", function() awful.screen.focus_relative(-1) end),
awful.key({ modkey, }, "u", awful.client.urgent.jumpto),
awful.key({ modkey, }, "p",
function()
	awful.client.focus.history.previous()
	if client.focus then client.focus:raise() end
end),

-- Standard program
awful.key({ modkey, }, "Return", function() awful.spawn(terminal) end),
awful.key({ modkey, "Control" }, "r", awesome.restart),
awful.key({ modkey, "Shift" }, "q", awesome.quit),
awful.key({ modkey, }, "l", function() awful.tag.incmwfact( 0.05) end),
awful.key({ modkey, }, "h", function() awful.tag.incmwfact(-0.05) end),
awful.key({ modkey, }, "k", function() awful.client.incwfact( 0.03) end),
awful.key({ modkey, }, "j", function() awful.client.incwfact(-0.03) end),
awful.key({ modkey, "Shift" }, "h", function() awful.tag.incnmaster( 1) end),
awful.key({ modkey, "Shift" }, "l", function() awful.tag.incnmaster(-1) end),
awful.key({ modkey, "Control" }, "h", function() awful.tag.incncol( 1) end),
awful.key({ modkey, "Control" }, "l", function() awful.tag.incncol(-1) end),
awful.key({ modkey, }, "space", function() awful.layout.inc(layouts, 1) end),
awful.key({ modkey, "Shift" }, "space", function() awful.layout.inc(layouts, -1) end),
awful.key({ modkey, "Control" }, "n", awful.client.restore),

-- miscellaneous
awful.key({ modkey, "Shift" }, "w", function() setWalls() end),

-- Prompts
-- awful.key({ modkey }, "r", function() mypromptbox[mouse.screen]:run() end), -- deprecated awesome4.0
awful.key({ modkey }, "r", function() awful.screen.focused().mypromptbox:run() end),

awful.key({ modkey }, "x",
function()
	awful.prompt.run {
		prompt  = "Run Lua code: ",
		textbox = awful.screen.focused().mypromptbox.widget,
		exe_callback = awful.util.eval,
		history_path = awful.util.get_cache_dir() .. "/history_eval"
	}
end),

-- Menubar
awful.key({ altkey }, "F2", function() menubar.show() end),

-- {{{ volume + mpd
awful.key({ }, "XF86AudioLowerVolume", function () awful.spawn("paVolume 1 2", false)  end),
awful.key({ }, "XF86AudioRaiseVolume", function () awful.spawn("paVolume 2 2", false)  end),
awful.key({ }, "XF86AudioStop",        function () awful.spawn("mpc stop") end),
awful.key({ }, "XF86AudioPlay",        function () awful.spawn("mpc toggle") end),
awful.key({ }, "XF86AudioNext",        function () awful.spawn("mpc next") end),
awful.key({ }, "XF86AudioPrev",        function () awful.spawn("mpc prev") end),
awful.key({ }, "XF86AudioMute",        function () awful.spawn("paVolume 0", false) end),
awful.key({   modkey, }, "v",          function () awful.spawn(terminal .. " -e ncmpcpp") end),
-- }}}

-- {{{ Brightness buttons
awful.key({ }, "XF86MonBrightnessDown", function () awful.spawn("xbacklight -dec 10") end),
awful.key({ }, "XF86MonBrightnessUp",   function () awful.spawn("xbacklight -inc 10") end),
-- }}}

-- {{{ Wireless button
awful.key({ }, "XF86WLAN", function () awful.spawn("wicd-client", false) end),
awful.key({ }, "#248", function () awful.spawn("wicd-client", false) end),
-- }}}

-- {{{ R with calculator key
awful.key({ }, "XF86Calculator",       function () awful.spawn(terminal .. " -e R --vanilla --no-save") end),
--- }}}

-- {{{ web
awful.key({   modkey, altkey }, "c", function () awful.spawn("chromium") end),
awful.key({   modkey, altkey }, "f", function () awful.spawn("firefox") end),
-- }}}

-- {{{ extra screen
awful.key({  modkey           }, "F8", function () awful.spawn("screenChange") end),
-- }}}

-- {{{ Lock
awful.key({ modkey    }, "Insert", function () awful.spawn("xlock", false) end),
-- }}}

-- {{{ Tag 0
awful.key({ modkey }, 0,
function()
	local screen = awful.screen.focused()
	if screen.tags[10] then
		screen.tags[10]:view_only()
	end
end),
awful.key({ modkey, "Control" }, 0,
function()
	local screen = awful.screen.focused()
	local tag = screen.tags[10]
	if tag then
		awful.tag.viewtoggle(tag)
	end
end),
awful.key({ modkey, "Shift" }, 0,
function()
	if client.focus then
		local tag = client.focus.screen.tags[10]
		if tag then
			client.focus:move_to_tag(tag)
		end
	end
end),
awful.key({ modkey, "Control", "Shift" }, 0,
function()
	if client.focus then
		local tag = client.focus.screen.tags[10]
		if tag then
			client.focus:toggle_tag(tag)
		end
	end
end)
)
-- }}}

-- {{ Other tags
for i = 1, 9 do
	globalkeys = awful.util.table.join(
	globalkeys,
	awful.key({ modkey }, "#" .. i + 9,
	function()
		local screen = awful.screen.focused()
		local tag = screen.tags[i]
		if tag then
			tag:view_only() 
		end
	end),
	awful.key({ modkey, "Control" }, "#" .. i + 9,
	function()
		local screen = awful.screen.focused()
		local tag = screen.tags[i]
		if tag then
			awful.tag.viewtoggle(tag)
		end
	end),
	awful.key({ modkey, "Shift" }, "#" .. i + 9,
	function()
		if client.focus then
			local tag = client.focus.screen.tags[i]
			if tag then
				client.focus:move_to_tag(tag)
			end
		end
	end),
	awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
	function()
		if client.focus then
			local tag = client.focus.screen.tags[i]
			if tag then
				client.focus:toggle_tag(tag)
			end
		end
	end))
end
-- }}}

-- {{{ Client keybindings
clientkeys = awful.util.table.join(
awful.key({ modkey, }, "f", function(c) c.fullscreen = not c.fullscreen end),
awful.key({ modkey, "Shift" }, "c", function(c) c:kill() end),
awful.key({ modkey, "Control" }, "space", awful.client.floating.toggle ),
awful.key({ modkey, "Control" }, "Return", function(c) c:swap(awful.client.getmaster()) end),
awful.key({ modkey, }, "o", awful.client.movetoscreen ),
awful.key({ modkey, }, "t", function(c) c.ontop = not c.ontop end),
awful.key({ modkey, }, "n", function(c) c.minimized = true end),

-- Maximize
awful.key({ modkey, }, "m",
function(c)
	c.maximized_horizontal = not c.maximized_horizontal
	c.maximized_vertical = not c.maximized_vertical
end))

clientbuttons = awful.util.table.join(
awful.button({ }, 1, function(c) client.focus = c; c:raise() end),
awful.button({ modkey }, 1, awful.mouse.client.move),
awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
	{
		rule = { },
		properties = { border_width = beautiful.border_width,
		border_color = beautiful.border_normal,
		focus = awful.client.focus.filter,
		keys = clientkeys,
		buttons = clientbuttons,
		screen = awful.screen.preferred,
		placement = awful.placement.no_overlap+awful.placement.no_offscreen
	}
},

--   names   = { "一", "二", "三", "四", "五", "六", "七", "八", "九", "十"},
{ rule = { class = "MPlayer" },
properties = { floating = true } },
{ rule = { class = "Skype" },
properties = { floating = true, tag = "十" } },
{ rule = { class = "Godesk" },
properties = { floating = true } },
{ rule = { class = "RStudio" },
properties = { tag = "四"} },
{ rule = { class = "calibre" },
properties = { tag = "八"} },
{ rule = { class = "pinentry" },
properties = { floating = true } },
{ rule = { class = "Chrome" },
properties = { tag = "一" } },
{ rule = { class = "Chromium" },
properties = { tag = "七" } },
{ rule = { class = "Firefox" },
properties = { tag = "二" } },
{ rule = { class = "Gimp" },
properties = { floating = true, tag = "五" } } }
-- }}}

-- {{{ Signals
client.connect_signal("manage",
function(c, startup)
	c.size_hints_honor = false

	-- Sloppy focus
	c:connect_signal("mouse::enter",
	function(c)
		if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
			and awful.client.focus.filter(c) then
			client.focus = c
		end
	end)

	if not startup then
		-- Set the windows at the slave
		awful.client.setslave(c)

		-- Place windows in a smart way, only if they do not set an initial position
		if not c.size_hints.user_position and not c.size_hints.program_position then
			awful.placement.no_overlap(c)
			awful.placement.no_offscreen(c)
		end
	end

	local titlebars_enabled = false
	if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
		local left_layout = wibox.layout.fixed.horizontal()
		left_layout:add(awful.titlebar.widget.iconwidget(c))

		local right_layout = wibox.layout.fixed.horizontal()
		right_layout:add(awful.titlebar.widget.floatingbutton(c))
		right_layout:add(awful.titlebar.widget.maximizedbutton(c))
		right_layout:add(awful.titlebar.widget.stickybutton(c))
		right_layout:add(awful.titlebar.widget.ontopbutton(c))
		right_layout:add(awful.titlebar.widget.closebutton(c))

		local title = awful.titlebar.widget.titlewidget(c)
		title:buttons(awful.util.table.join(
		awful.button({ }, 1,
		function()
			client.focus = c
			c:raise()
			awful.mouse.client.move(c)
		end),
		awful.button({ }, 3,
		function()
			client.focus = c
			c:raise()
			awful.mouse.client.resize(c)
		end)))

		local layout = wibox.layout.align.horizontal()
		layout:set_left(left_layout)
		layout:set_right(right_layout)
		layout:set_middle(title)

		awful.titlebar(c):set_widget(layout)
	end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
