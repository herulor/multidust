-------------------------
-- AwesomeWM widgets --
--    version 4.0    --
-----------------------

local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local vicious = require("vicious")
local naughty = require("naughty")
local contrib = require("vicious.contrib")
local lain = require("lain")

local markup = lain.util.markup

graphwidth  = 40
graphheight = 20
pctwidth    = 30
netwidth    = 40

-- {{{ Spacers
space = wibox.widget.textbox()
space:set_text(" ")

comma = wibox.widget.textbox()
comma:set_markup(",")

pipe = wibox.widget.textbox()
pipe:set_markup("<span color='" .. beautiful.bg_em .. "'>|</span>")

tab = wibox.widget.textbox()
tab:set_text(" ")

volspace = wibox.widget.textbox()
volspace:set_text(" ")
-- }}}

-- {{{ Processor
-- Cache
vicious.cache(vicious.widgets.cpu)
vicious.cache(vicious.widgets.cpuinf)

--Coretemp
tempicon = wibox.widget.imagebox(theme.widget_temp)
temp = lain.widgets.temp({
	settings = function()
		--widget:set_markup(markup.fontfg(them.font, "#f1af5f", coretemp_now .. "C"))
		widget:set_markup(coretemp_now .. "°C")
	end
})


-- All Cores freq
cpu0icon = wibox.widget.imagebox(theme.widget_cpu0)
cpufreq = wibox.widget.textbox()
vicious.register(cpufreq, vicious.widgets.cpuinf,
function(widget, args)
	return string.format(--"<span color='" .. beautiful.fg_em ..
	--"'>cpu:</span>%1.1fGHz",
	"%1.2fGHz",
	args["{cpu0 ghz}"] + args["{cpu1 ghz}"] + args["{cpu2 ghz}"] + args["{cpu3 ghz}"]) 
end, 3000)


-- Each Core Usage
cpuxicon = wibox.widget.imagebox(theme.widget_cpux)
cpupct0 = wibox.widget.textbox()
vicious.register(cpupct0, vicious.widgets.cpu, "$1%", 3)

cpupct1 = wibox.widget.textbox()
vicious.register(cpupct1, vicious.widgets.cpu, "$2%", 7)

cpupct2 = wibox.widget.textbox()
vicious.register(cpupct2, vicious.widgets.cpu, "$3%", 5)

cpupct3 = wibox.widget.textbox()
vicious.register(cpupct3, vicious.widgets.cpu, "$4%", 3)

cpupct4 = wibox.widget.textbox()
vicious.register(cpupct4, vicious.widgets.cpu, "$5%", 5)
-- }}}

-- {{{ Memory
-- Cache
memicon = wibox.widget.imagebox(theme.widget_mem)
vicious.cache(vicious.widgets.mem)

-- RAM used
memused = wibox.widget.textbox()
vicious.register(memused, vicious.widgets.mem,
--  "<span color='" .. beautiful.fg_em .. "'>ram:</span>$2MB", 5)
"$2MB", 5)

-- RAM %
mempct = wibox.widget.textbox()
mempct.width = pctwidth
vicious.register(mempct, vicious.widgets.mem, "$1%", 5)
-- }}}

-- {{{ Filesystem
-- Disk usage widget
disk = require("diskusage")
diskwidget = wibox.widget.imagebox()
diskwidget:set_image(beautiful.widget_disk)
disk.addToWidget(diskwidget, 75, 90, false)
-- }}}

-- {{{ Net
neticon = wibox.widget.imagebox(theme.widget_netdown)
netinfo = lain.widgets.net({
	settings = function()
		if net_now.state == "up" then 
			neticon:set_image(theme.widget_netup)
		else net_state = "Off" 
			neticon:set_image(theme.widget_netdown)
		end
	end
})
-- }}}


-- {{{ Wifi
wifiicon = wibox.widget.imagebox()
wifiicon:set_image(beautiful.widget_wifi)
--
wifi = wibox.widget.textbox()
vicious.register(wifi, vicious.widgets.wifi,
"<span color='#7788af'>${ssid}</span><span color='" .. beautiful.fg_em .. "'> ${linp}%</span>", 2, "wlp6s0")

vicious.register(wifiicon, vicious.widgets.wifi,
function(wifiicon, args)
	if args["{ssid}"] == "N/A" then
		wifiicon:set_image(beautiful.widget_nowifi)
	else
		wifiicon:set_image(beautiful.widget_wifi)
	end
end, 2, "wlp6s0")

wifiicon:buttons(awful.util.table.join(
awful.button({ }, 1,
function() awful.util.spawn("wicd-client", false) end))) --,
wifi:buttons(wifiicon:buttons())
-- }}}

-- {{{ Weather
weathericon = wibox.widget.imagebox(theme.widget_weather)
weather = wibox.widget.textbox()
weather_t = awful.tooltip({objects = {weather}})

vicious.register(weather, vicious.widgets.weather,
function (widget, args)
	if args["{city}"] == "LAFAYETTE PURDUE UNIV AIRPORT , IN" then
		args["{city}"] = "Purdue University, IN"
	end
	weather_t:set_text("City: " .. args["{city}"] .."\nWind: " .. args["{windkmh}"] .. " km/h "
	.. args["{wind}"] .. 
	"\nSky: " .. args["{sky}"] .. "\nHumidity: " .. args["{humid}"] .. "%")
	return args["{tempc}"] .. "°C/" .. args["{tempf}"] .. "°F"
end, 
50, "KLAF")
-- 50, "SKBO")
weather:buttons(awful.util.table.join(awful.button({ }, 1,
function() vicious.force({ weather }) end)))
-- }}}


-- {{{ Textclock
os.setlocale(os.getenv("LANG")) -- to localize the clock
clockicon = wibox.widget.imagebox(theme.widget_clock)
mytextclock = wibox.widget.textclock(markup.fg("#7788af", "%A %Y/%m/%d ") .. markup.fg("#535f7a", "@") .. markup.fg("#de5e1e", " %H:%M"))

function popup_agenda()
	local agenda = ""
	--local f = io.popen("gcalcli agenda --nocolor | sed '/^\\s*$/d'")
	local f = io.popen("gcalcli agenda --nocolor")
	if f then
		agenda = f:read("*a")
	end
	f:close()
	naughty.notify { text = agenda , fg = theme.fg_urgent }
end
mytextclock:buttons(awful.util.table.join(awful.button({ }, 1, popup_agenda)))

agenda_timer = timer { timeout = 600 }
agenda_timer:connect_signal("timeout", function ()
	agenda_timer:stop()
	local f = io.popen("gcalcli remind 15")
	agenda_timer.timeout = 600 
	agenda_timer:start()
end)

agenda_timer:start()
-- }}}

-- {{{ Pacman
-- Icon
pacicon = wibox.widget.imagebox()
pacicon:set_image(beautiful.widget_pac)

-- Upgrades
pacwidget = wibox.widget.textbox()
vicious.register(pacwidget, vicious.widgets.pkg,
function(widget, args)

	if args[1] > 0 then
		pacicon:set_image(beautiful.widget_pacnew)
	else
		pacicon:set_image(beautiful.widget_pac)
	end

	return args[1]
end, 1801, "Arch S") -- Arch S for ignorepkg

-- Buttons
function popup_pac()
	local pac_updates = ""
	local f = io.popen("pacman -Sup --dbpath /var/lib/pacman/")
	if f then
		pac_updates = "Updates available"
		--pac_updates = f:read("*a"):match(".*/(.*)-.*\n$")
	end
	f:close()

	if not pac_updates then pac_updates = "System is up to date" end

	naughty.notify { text = pac_updates , fg = theme.fg_urgent }
end
pacwidget:buttons(awful.util.table.join(awful.button({ }, 1, popup_pac)))
pacicon:buttons(pacwidget:buttons())
-- }}}

-- {{{ mpd
-- Icon
mpdicon = wibox.widget.imagebox()
mpdicon:set_image(beautiful.widget_mpd)
mpdicon_t = awful.tooltip({objects = {mpdicon}})

mpdwidget = wibox.widget.textbox()
-- Register widget
vicious.register(mpdwidget, vicious.widgets.mpd,
function (mpdwidget, args)
	-- Requires to modify mpd.lua to include Date
	if args["{Date}"] == "N/A" then args["{Date}"] = "" 
	else args["{Date}"] = string.gsub(args["{Date}"], "-%d+", "")
	end
	if args["{state}"] == "Stop" or args["{state}"] == "N/A"
		or (args["{Artist}"] == "N/A" and args["{Title}"] == "N/A") then return ""
	else return '<span color="white">музыка:</span><span color="yellow">'
		..args["{Title}"]..'</span><span color="grey"> '
		..args["{Date}"]..'</span><span color="cyan"> '
		..args["{Artist}"]..'</span><span color="magenta"> '
		..args["{Album}"]..'</span>'
	end
end, 2)
vicious.register(mpdicon, vicious.widgets.mpd,
function (mpdicon, args)
	if args["{state}"] ~= "Play" then
		mpdicon:set_image(beautiful.widget_mute)
	else
		mpdicon:set_image(beautiful.widget_mpd)
	end

	if args["{time}"] == "" then return nil end

	elapsed = string.gsub(args["{time}"], "^(.*):.*", "%1")
	total   = string.gsub(args["{time}"], "^(.*):", "")

	if (elapsed == "" or elapsed ~= nil) then
		elapsed = 0
	end

	if (total == "" or total ~= nil) then
		total = 0
	end

	timeMin = math.floor(tonumber(elapsed)/60)
	timeSec = math.ceil(((tonumber(elapsed) / 60) - timeMin) * 60)

	lengthMin = math.floor(tonumber(total)/60)
	lengthSec = math.ceil(((tonumber(total) / 60) - lengthMin) * 60)

	if (timeMin == 0) then timeMin = "" end
	if (lengthMin == 0) then lengthMin = "" end

	mpdicon_t:set_text(timeMin .. ":" .. string.format("%02d", timeSec) .. "/" .. lengthMin .. ":" .. string.format("%02d", lengthSec))

end, 1)

-- mpd buttons
mpdwidget:buttons(awful.util.table.join(
awful.button({ }, 1,
function() awful.util.spawn("mpc toggle", false) 
end))) --,
mpdicon:buttons(mpdwidget:buttons())
--}}}

-- {{{ Volume
-- Cache
vicious.cache(vicious.widgets.volume)

-- Icon
volicon = wibox.widget.imagebox()
volicon:set_image(beautiful.widget_vol)

-- Volume %
volpct = wibox.widget.textbox()
volpct2 = wibox.widget.textbox()
volpct3 = wibox.widget.textbox()
vicious.register(volpct, contrib.pulse,  '<span color="blue"> $1% </span>', 2, "alsa_output.pci-0000_00_1b.0.analog-stereo")
vicious.register(volpct2, contrib.pulse, '<span color="white"> $1% </span>', 2, "alsa_output.pci-0000_00_03.0.hdmi-stereo")
vicious.register(volpct3, contrib.pulse, '<span color="red"> $1% </span>', 2, "bluez_sink.B8_69_C2_66_06_0B")

-- Buttons
volicon:buttons(awful.util.table.join(
awful.button({ }, 1,
function() awful.util.spawn("pavucontrol", false) end),
awful.button({ }, 4,
function() awful.util.spawn("paVolume 2 2", false) end),
awful.button({ }, 5,
function() awful.util.spawn("paVolume 1 2", false) end)
))
volspace:buttons(volicon:buttons())
volpct:buttons(volicon:buttons())
volpct2:buttons(volicon:buttons())
volpct3:buttons(volicon:buttons())
-- }}}

-- {{{ Battery
-- Battery attributes
local bat_state  = ""
local bat_charge = 0
local bat_time   = 0
local blink      = true

-- Icon
baticon = wibox.widget.imagebox()
baticon:set_image(beautiful.widget_batfull)

-- Charge %
batpct = wibox.widget.textbox()
vicious.register(batpct, vicious.widgets.bat,
function(widget, args)
	bat_state  = args[1]
	bat_charge = args[2]
	bat_time   = args[3]

	if args[1] ~= "+" then
		if bat_charge == 100 then
			baticon:set_image(beautiful.widget_ac)
		elseif bat_charge > 70 then
			baticon:set_image(beautiful.widget_batfull)
		elseif bat_charge > 30 then
			baticon:set_image(beautiful.widget_batmed)
		elseif bat_charge > 10 then
			baticon:set_image(beautiful.widget_batlow)
		else
			baticon:set_image(beautiful.widget_batempty)
		end
	else
		baticon:set_image(beautiful.widget_ac)
		if args[1] == "+" then
			blink = not blink
			if blink then
				baticon:set_image(beautiful.widget_acblink)
			end
		end
	end

	if bat_charge < 30 then
		return '<span color="yellow">' .. args[2] .. "%</span>"
	else
		return args[2] .. "%"
	end

end, nil, "BAT0")

-- Buttons
function popup_bat()
	local state = ""
	if bat_state == "↯" then
		state = "Full"
	elseif bat_state == "↯" then
		state = "Charged"
	elseif bat_state == "+" then
		state = "Charging"
	elseif bat_state == "-" then
		state = "Discharging"
	elseif bat_state == "⌁" then
		state = "Not charging"
	else
		state = "Unknown"
	end

	naughty.notify { text = "Charge : " .. bat_charge .. "%\nState  : " .. state ..
	" (" .. bat_time .. ")", timeout = 5, hover_timeout = 0.5 }
end
batpct:buttons(awful.util.table.join(awful.button({ }, 1, popup_bat)))
baticon:buttons(batpct:buttons())
-- }}}
