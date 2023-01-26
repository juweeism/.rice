local wibox = require("wibox")
local awful = require("awful")
require("math")

local Battery = { mt = {}, wmt = {} }
Battery.wmt.__index = Battery
Battery.__index = Battery

config = awful.util.getdir("config")

local function run(command)
	local prog = io.popen(command)
	local result = prog:read('*all')
	prog:close()
	return result
end

local function round(num)
	if num - math.floor(num) >= 0.5 then
		return math.floor(num)+1
	else
		return math.floor(num)
	end
end
	

function Battery:new(args)
	local obj = setmetatable({}, Battery)

	obj.batteryDir = args.batteryDir or "/sys/class/power_supply/"
	obj.battery = args.battery or "BAT0"
	obj.capacityFile = args.capacityFile or "capacity"
	obj.statusFile = args.statusFile or "status"
	obj.isChargingIndicator = args.isChargingIndicator or "Charging"

	-- Create imagebox widget
	obj.widget = wibox.widget.imagebox()
	obj.widget:set_resize(false)
	obj.widget:set_image(config.."/awesome.battery-widget/icons/12.png")

	-- Add a tooltip to the imagebox
	obj.tooltip = awful.tooltip({ objects = { K },
		timer_function = function() return obj:tooltipText() end } )
	obj.tooltip:add_to_object(obj.widget)

	-- Check battery level every 5 seconds
	obj.timer = timer({timeout = 5})
	obj.timer:connect_signal("timeout", function() obj:update({}) end)
	obj.timer:start()

	obj:update({})

	return obj
end

function Battery:tooltipText()
	return self:getCapacity().."% Battery Life"
end

function Battery:update(status)
	local sprite = round((self:getCapacity() / 100)*12)
	local suffix = ""
	if self:getCharging()  then
		suffix = "c"
	end
	self.widget:set_image(config.."/awesome.battery-widget/icons/"..sprite..suffix..".png")
end

function Battery:getCapacity()
	return tonumber(run("cat "..self.batteryDir..self.battery.."/"..self.capacityFile))
end

function Battery:getCharging()
	local status = run("cat "..self.batteryDir..self.battery.."/"..self.statusFile)
	if status:find("Charging") ~= nil then
		return true
	end
	return false
end

function Battery.mt:__call(...)
	return Brightness.new(...)
end

return Battery
