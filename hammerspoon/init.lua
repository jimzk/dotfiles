-- ref: https://github.com/sugood/hammerspoon

hs.configdir = os.getenv('HOME') .. '/.hammerspoon'
package.path = hs.configdir .. '/?.lua;' .. hs.configdir .. '/?/init.lua;' .. hs.configdir .. '/Spoons/?.spoon/init.lua;' .. package.path

require "modules/reload"
require "modules/hotkey"
require "modules/windows"
