local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")
local gears = require("gears")
local module_path = (...):match ("(.+/)[^/]+$") or ""

local indicator = {}
local function worker(args)
  local args = args or {}
  local widget = wibox.container.background()
  local wired = wibox.widget.imagebox()
  local wired_na = wibox.widget.imagebox()
  -- Settings
  local interfaces_matches = string.gmatch(io.popen("ip addr show"):read("*a"), "enp[a-z0-9]+")
  local interfaces = {}
  
  for i in interfaces_matches do
    table.insert(interfaces, i)
  end

  local ICON_DIR = awful.util.getdir("config").."/"..module_path.."/net_widgets/icons/"
  local timeout = args.timeout or 5
  local font = args.font or beautiful.font
  local onclick = args.onclick
  local hidedisconnected = args.hidedisconnected
  local popup_position = args.popup_position or naughty.config.defaults.position

  local connected = false
  local function text_grabber()
    local msg = ""
    if connected then
      for _, i in pairs(interfaces) do

        local map = "N/A"
        local inet = "N/A"
        f = io.popen("ip addr show "..i)
        for line in f:lines() do
          -- inet 192.168.1.190/24 brd 192.168.1.255 scope global enp3s0
          inet = string.match(line, "inet (%d+%.%d+%.%d+%.%d+)") or inet
          -- link/ether 1c:6f:65:3f:48:9a brd ff:ff:ff:ff:ff:ff
          mac = string.match(line, "link/ether (%x?%x?:%x?%x?:%x?%x?:%x?%x?:%x?%x?:%x?%x?)") or mac
        end
        f:close()

        msg = "<span font_desc=\""..font.."\">"..
        "┌["..i.."]\n"..
        "├IP:\t"..inet.."\n"..
        "└MAC:\t"..mac.."</span>"

	if int ~= "N/A" then
	  break
        end
      end
    else
      msg = "<span font_desc=\""..font.."\">Wired network is disconnected</span>"
    end

    return msg
  end

  wired:set_image(ICON_DIR.."wired.png")
  wired_na:set_image(nil)
  widget:set_widget(wired_na)
  local function net_update()
    connected = false
    for _, i in pairs(interfaces) do
      awful.spawn.easy_async("bash -c \"ip link show "..i.." | awk 'NR==1 {printf \\\"%s\\\", $9}'\"", function(stdout, stderr, reason, exit_code)
          state = stdout:sub(1, stdout:len() - 1)
          if (state == "UP") then
            connected = true
          end
          if connected then
            widget:set_widget(wired)
          else
            if not hidedisconnected then
              widget:set_widget(wired_na)
            else
              widget:set_widget(nil)
            end
          end
        end)
    end

    return true
  end

  net_update()

  gears.timer.start_new(timeout, net_update)

  local notification = nil
  function widget:hide()
    if notification ~= nil then
      naughty.destroy(notification)
      notification = nil
    end
  end

  function widget:show(t_out)
    widget:hide()

    notification = naughty.notify({
        preset = fs_notification_preset,
        text = text_grabber(),
        timeout = t_out,
        screen = mouse.screen,
        position = popup_position
      })
  end

  -- Bind onclick event function
  if onclick then
    widget:buttons(awful.util.table.join(
        awful.button({}, 1, function() awful.util.spawn(onclick) end)
    ))
  end

  widget:connect_signal('mouse::enter', function () widget:show(0) end)
  widget:connect_signal('mouse::leave', function () widget:hide() end)
  return widget
end
return setmetatable(indicator, {__call = function(_,...) return worker(...) end})
