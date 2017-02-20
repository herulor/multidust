-----------------------
--  AwesomeWM theme  --
-- based on Dust GTK --
--   <tdy@gmx.com>   --
-- and Multicolor Awesome WM theme 2.0
-- github.com/copycat-killer
-----------------------
local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local os    = { getenv = os.getenv, setlocale = os.setlocale }


-- {{{ Helpers
function hometheme(path) return awful.util.getdir("config") .. "/themes/multidust" .. path end
function hometags(path) return hometheme("/taglist") .. path end
function homelayouts(path) return hometheme("/layouts") .. path end
function homewidgets(path) return hometheme("/widgets") .. path end
function hometp(path) return hometheme("/tp") .. path end
function hometitle(path) return hometheme("/titlebar") .. path end

function systheme(path) return "/usr/share/awesome/themes/default" .. path end
function systitle(path) return systheme("/titlebar") .. path end
-- }}}

-- {{ Main
theme = {}
theme.wallpaper             = hometheme("/wall.jpg")
theme.font                  = "Monaco 8"
theme.menu_height           = 15
theme.menu_width            = 100
-- }}}n

-- {{{ Colors
theme.fg_normal             = "#aaaaaa"
theme.fg_focus              = "#111111"
theme.fg_urgent             = "#af1d18"
theme.fg_tooltip            = "#1a1a1a"
theme.fg_em                 = "#d6d6d6"
theme.fg_widget             = "#908884"
theme.fg_center_widget      = "#636363"
theme.fg_end_widget         = theme.fg_tooltip

theme.bg_normal             = theme.fg_tooltip
theme.bg_focus              = theme.fg_widget
theme.bg_urgent             = "#cd7171"
theme.bg_tooltip            = "4a4a4a#"
theme.bg_em                 = "#5a5a5a"
theme.bg_systray            = theme.fg_tooltip
theme.bg_widget             = "#2a2a2a"

theme.border_width          = 1
theme.border_normal         = "#1c2022"
theme.border_focus          = theme.bg_focus
theme.border_marked         = "#3ca4d8"
theme.border_tooltip        = "#444444"
theme.border_widget         = "#3f3f3f"

theme.menu_border_width     = 0
theme.menu_width            = 130
theme.menu_fg_normal        = "#aaaaaa"
theme.menu_fg_focus         = "#ff8c00"
theme.menu_bg_normal        = "#050505dd"
theme.menu_bg_focus         = "#050505dd"

theme.titlebar_bg_focus     = theme.border_widget
theme.titlebar_bg_normal    = theme.border_widget

theme.mouse_finder_color    = "#cc9393"
-- }}}

-- {{{ Icons
theme.taglist_squares_sel   = hometags("/square_a.png")
theme.taglist_squares_unsel = hometags("/square_b.png")

theme.awesome_icon          = hometheme("/icons/awesome-icon.png")
theme.menu_submenu_icon     = systheme("/submenu.png")

theme.layout_tile           = homelayouts("/tile.png")
theme.layout_tileleft       = homelayouts("/tileleft.png")
theme.layout_tilebottom     = homelayouts("/tilebottom.png")
theme.layout_tiletop        = homelayouts("/tiletop.png")
theme.layout_fairv          = homelayouts("/fairv.png")
theme.layout_fairh          = homelayouts("/fairh.png")
theme.layout_spiral         = homelayouts("/spiral.png")
theme.layout_dwindle        = homelayouts("/dwindle.png")
theme.layout_max            = homelayouts("/max.png")
theme.layout_fullscreen     = homelayouts("/fullscreen.png")
theme.layout_magnifier      = homelayouts("/magnifier.png")
theme.layout_floating       = homelayouts("/floating.png")

theme.widget_disk           = homewidgets("/disk.png")
theme.widget_ac             = homewidgets("/ac.png")
theme.widget_acblink        = homewidgets("/acblink.png")
theme.widget_blank          = homewidgets("/blank.png")
theme.widget_batt           = homewidgets("/bat.png")
theme.widget_batfull        = homewidgets("/batfull.png")
theme.widget_batmed         = homewidgets("/batmed.png")
theme.widget_batlow         = homewidgets("/batlow.png")
theme.widget_batempty       = homewidgets("/batempty.png")
theme.widget_clock          = homewidgets("/clock.png")
theme.widget_vol            = homewidgets("/vol.png")
theme.widget_mute           = homewidgets("/mute.png")
theme.widget_note           = homewidgets("/note.png")
theme.widget_note_in        = homewidgets("/note_on.png")
theme.widget_pac            = homewidgets("/pac.png")
theme.widget_pacnew         = homewidgets("/pacnew.png")
theme.widget_mail           = homewidgets("/mail.png")
theme.widget_mailnew        = homewidgets("/mailnew.png")
theme.widget_temp           = homewidgets("/temp.png")
theme.widget_tempwarn       = homewidgets("/tempwarm.png")
theme.widget_temphot        = homewidgets("/temphot.png")
theme.widget_netup          = homewidgets("/net_up.png")
theme.widget_netdown        = homewidgets("/net_down.png")
theme.widget_wifi           = homewidgets("/wifi.png")
theme.widget_nowifi         = homewidgets("/nowifi.png")
theme.widget_mpd            = homewidgets("/mpd.png")
theme.widget_play           = homewidgets("/play.png")
theme.widget_pause          = homewidgets("/pause.png")
theme.widget_ram            = homewidgets("/ram.png")
theme.widget_weather        = homewidgets("/dish.png")

theme.widget_cpu0           = hometp("/cpu.png")
theme.widget_cpux           = hometp("/cpux.png")
theme.widget_mem            = hometp("/ram.png")
theme.widget_swap           = hometp("/swap.png")
theme.widget_fs             = hometp("/fs.png")
--theme.widget_fs             = hometp("/fs_01.png")
theme.widget_fs2            = hometp("/fs_02.png")
theme.widget_up             = hometp("/up.png")
theme.widget_down           = hometp("/down.png")

theme.titlebar_close_button_focus               = hometitle("/close_focus.png")
theme.titlebar_close_button_normal              = hometitle("/close_normal.png")

theme.titlebar_ontop_button_focus_active        = hometitle("/ontop_focus_active.png")
theme.titlebar_ontop_button_normal_active       = hometitle("/ontop_normal_active.png")
theme.titlebar_ontop_button_focus_inactive      = hometitle("/ontop_focus_inactive.png")
theme.titlebar_ontop_button_normal_inactive     = hometitle("/ontop_normal_inactive.png")

theme.titlebar_sticky_button_focus_active       = hometitle("/sticky_focus_active.png")
theme.titlebar_sticky_button_normal_active      = hometitle("/sticky_normal_active.png")
theme.titlebar_sticky_button_focus_inactive     = hometitle("/sticky_focus_inactive.png")
theme.titlebar_sticky_button_normal_inactive    = hometitle("/sticky_normal_inactive.png")

theme.titlebar_floating_button_focus_active     = hometitle("/floating_focus_active.png")
theme.titlebar_floating_button_normal_active    = hometitle("/floating_normal_active.png")
theme.titlebar_floating_button_focus_inactive   = hometitle("/floating_focus_inactive.png")
theme.titlebar_floating_button_normal_inactive  = hometitle("/floating_normal_inactive.png")

theme.titlebar_maximized_button_focus_active    = hometitle("/maximized_focus_active.png")
theme.titlebar_maximized_button_normal_active   = hometitle("/maximized_normal_active.png")
theme.titlebar_maximized_button_focus_inactive  = hometitle("/maximized_focus_inactive.png")
theme.titlebar_maximized_button_normal_inactive = hometitle("/maximized_normal_inactive.png")

return theme
