-- window management
local application = require "hs.application"
local hotkey = require "hs.hotkey"
local window = require "hs.window"
local layout = require "hs.layout"
local grid = require "hs.grid"
local hints = require "hs.hints"
local screen = require "hs.screen"
local alert = require "hs.alert"
local fnutils = require "hs.fnutils"
local geometry = require "hs.geometry"
local mouse = require "hs.mouse"

-- default 0.2
window.animationDuration = 0

-- left half
hotkey.bind(hyperShift, "H", function()
    if window.focusedWindow() then
        window.focusedWindow():moveToUnit(layout.left50)
    else
        alert.show("No active window")
    end
end)

-- right half
hotkey.bind(hyperShift, "L", function()
    window.focusedWindow():moveToUnit(layout.right50)
end)

-- top half
hotkey.bind(hyperShift, "K", function()
    window.focusedWindow():moveToUnit'[0,0,100,50]'
end)

-- bottom half
hotkey.bind(hyperShift, "J", function()
    window.focusedWindow():moveToUnit'[0,50,100,100]'
end)

-- left top quarter
hotkey.bind(hyperShift, "Y", function()
    window.focusedWindow():moveToUnit'[0,0,50,50]'
end)

-- right top quarter
hotkey.bind(hyperShift, "U", function()
    window.focusedWindow():moveToUnit'[50,0,100,50]'
end)

-- left bottom quarter
hotkey.bind(hyperShift, "I", function()
    window.focusedWindow():moveToUnit'[0,50,50,100]'
end)

-- right bottom quarter
hotkey.bind(hyperShift, "O", function()
    window.focusedWindow():moveToUnit'[50,50,100,100]'
end)

-- full screen
hotkey.bind(hyperShift, 'F', function()
    window.focusedWindow():toggleFullScreen()
end)

-- center window
hotkey.bind(hyperShift, 'C', function()
    window.focusedWindow():centerOnScreen()
end)

-- maximize window
hotkey.bind(hyperShift, 'M', function() toggle_maximize() end)

-- defines for window maximize toggler
local frameCache = {}
-- toggle a window between its normal size, and being maximized
function toggle_maximize()
    local win = window.focusedWindow()
    if frameCache[win:id()] then
        win:setFrame(frameCache[win:id()])
        frameCache[win:id()] = nil
    else
        frameCache[win:id()] = win:frame()
        win:maximize()
    end
end

-- display a keyboard hint for switching focus to each window
hotkey.bind(hyperShift, '/', function()
    hints.windowHints()
    -- Display current application window
    -- hints.windowHints(hs.window.focusedWindow():application():allWindows())
end)

-- switch to next active window
hotkey.bind(hyperShift, ".", function()
    window.switcher.nextWindow()
end)

-- switch to previous active window
hotkey.bind(hyperShift, ",", function()
    window.switcher.previousWindow()
end)

-- move active window to previous monitor
hotkey.bind(hyperShift, ";", function()
    window.focusedWindow():moveOneScreenWest()
end)

-- move active window to next monitor
hotkey.bind(hyperShift, "'", function()
    window.focusedWindow():moveOneScreenEast()
end)
