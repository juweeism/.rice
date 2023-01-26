# Battery Widget
Provides a simple battery widget for the Awesome window manager. It's about as simple as it gets.

### Deprecation Notice

This widget has been deprecated. I'm not personally using it anymore. I will
happily take pull requests but I won't be actively maintaining it myself.

If you want a window manager-agnostic battery indicator, I would recommend
cbatticon. It has the benefit of using your icon pack instead of the crappy
custom icons I made.

### Dependencies

No extra Awesome libraries are required, but you have to be using an operating system with the `/sys/class/power_supply/`
directory or a directory with the same functionality somewhere else. This is where the widget checks your battery
percentage. Any modern Linux distribution should have this set up already.

### Setup

1. Navigate to your Awesome config directory (usually `~/.config/awesome`) and clone this repository with the following
command:

	```
	git clone https://github.com/velovix/awesome.battery-widget
	```
2. Create a symlink for the battery-widget.lua file. This is done so that your rc.lua can find the code, and so you can
update the widget by simply pulling in changes from this repository later. While still in the Awesome config directory,
run the following:

	```
	ln -s awesome.battery-widget/battery-widget.lua battery-widget.lua
	```
3. In your rc.lua, add the following near the beginning of the file. This loads up the library and has you access it
through the new battery_widget table we're creating.

	```
	local battery_widget = require("battery-widget")
	```
4. Add the following line near the beginning of your rc.lua, but after the line in the previous step. Providing an
empty table sets all configurations to their defaults. This should work for most users. See the configuration section
if you think you're special.

	```
	local battery = battery_widget:new({})
	```
5. Finally, to add your widget to the bar, you'll have to add the following line somewhere after the `right_layout`
table is created.

	```
	right_layout:add(battery.widget)
	```
6. Restart Awesome WM and you're finished! You should see a white battery icon on the top right of the screen!

### Configuration

For most cases, the default configuration will work fine. Unless you know for sure that you're different, you should
try this first and see what kind of results you get. If you do need special configuration options, there are five
provided. Feed them into your `new` function instead of the default empty table.

- **batteryDir**: The directory of the battery information files. The default is `/sys/class/power_supply/`.
- **battery**: The name of your battery. You may have to change this if you have multiple batteries. The default is
`BAT0`.
- **capacityFile**: The name of the file that contains the current battery percentage. The default is `capacity`.
- **statusFile**: The name of the file that contains the battery charging status. The default is `status`.
- **isChargingIndicator**: The text to look for in the status file that indicates the battery is charging. The
default is `Charging`.
