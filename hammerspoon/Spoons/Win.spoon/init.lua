--- === WinWin ===
---
--- Windows manipulation
---
--- Download: [https://github.com/Hammerspoon/Spoons/raw/master/Spoons/WinWin.spoon.zip](https://github.com/Hammerspoon/Spoons/raw/master/Spoons/WinWin.spoon.zip)

local M = spoon.ModalMgr:newModal("resize_win", "#b22222")

M.__index = M

-- Windows manipulation history. Only the last operation is stored.
M.history = {}

--- WinWin.gridparts
--- Variable
--- An integer specifying how many gridparts the screen should be divided into. Defaults to 30.
M.gridparts = 40

--- WinWin:stepMove(direction)
--- Method
--- Move the focused window in the `direction` by on step. The step scale equals to the width/height of one gridpart.
---
--- Parameters:
---  * direction - A string specifying the direction, valid strings are: `left`, `right`, `up`, `down`.
function M.stepMove(direction)
    local cwin = hs.window.focusedWindow()
    if cwin then
        local cscreen = cwin:screen()
        local cres = cscreen:fullFrame()
        local stepw = cres.w / M.gridparts
        local steph = cres.h / M.gridparts
        local x = 0
        local y = 0
        if direction == "left" then
            x = -stepw
        elseif direction == "right" then
            x = stepw
        elseif direction == "up" then
            y = -steph
        elseif direction == "down" then
            y = steph
        end
        cwin:move({ x, y }, true)
    else
        hs.alert.show("No focused window!")
    end
end

--- WinWin:stepResize(direction)
--- Method
--- Resize the focused window in the `direction` by on step.
---
--- Parameters:
---  * direction - A string specifying the direction, valid strings are: `left`, `right`, `up`, `down`.
function M.stepResize(direction)
    local cwin = hs.window.focusedWindow()
    if cwin then
        local cscreen = cwin:screen()
        local cres = cscreen:fullFrame()
        local stepw = cres.w / M.gridparts
        local steph = cres.h / M.gridparts
        local wsize = cwin:size()
        if direction == "left" then
            cwin:setSize({ w = wsize.w - stepw, h = wsize.h })
        elseif direction == "right" then
            cwin:setSize({ w = wsize.w + stepw, h = wsize.h })
        elseif direction == "up" then
            cwin:setSize({ w = wsize.w, h = wsize.h - steph })
        elseif direction == "down" then
            cwin:setSize({ w = wsize.w, h = wsize.h + steph })
        end
    else
        hs.alert.show("No focused window!")
    end
end

local constrain = function(value, minimum, maximum)
    if value < minimum then return minimum end
    if value > maximum then return maximum end
    return value
end

function M.resize(stepUp, stepDown, stepLeft, stepRight)
    local cwin = hs.window.focusedWindow()
    if not cwin then
        return
    end
    local sf = cwin:screen():frame()
    if math.abs(stepLeft) < 1 then stepLeft = stepLeft * sf.w end
    if math.abs(stepRight) < 1 then stepRight = stepRight * sf.w end
    if math.abs(stepUp) < 1 then stepUp = stepUp * sf.h end
    if math.abs(stepDown) < 1 then stepDown = stepDown * sf.h end

    local wf = cwin:frame()
    local left = wf.x - stepLeft
    local right = wf.x + wf.w + stepRight
    left = constrain(left, sf.x, wf.x + wf.w)
    right = constrain(right, math.min(wf.x, left), sf.x + sf.w)
    local up = wf.y - stepUp
    local down = wf.y + wf.h + stepDown
    up = constrain(up, sf.y, wf.y + wf.h)
    down = constrain(down, math.min(wf.y, up), sf.y + sf.h)

    local x = left
    local y = up
    local w = right - left
    local h = down - up
    cwin:setFrameInScreenBounds({ x, y, w, h })
end

function M.moveAndResize(option)
    local cwin = hs.window.focusedWindow()
    if cwin then
        local cscreen = cwin:screen()
        local cres = cscreen:fullFrame()
        local stepw = cres.w / M.gridparts
        local steph = cres.h / M.gridparts
        local wf = cwin:frame()
        if option == "fullscreen" then
            cwin:setFrame({ x = cres.x, y = cres.y, w = cres.w, h = cres.h })
        elseif option == "center" then
            cwin:centerOnScreen()
        elseif option == "expand" then
            cwin:setFrameInScreenBounds({
                x = wf.x - stepw,
                y = wf.y - steph,
                w = wf.w + (stepw * 2),
                h = wf.h + (steph * 2)
            })
        elseif option == "shrink" then
            cwin:setFrameInScreenBounds({
                x = wf.x + stepw,
                y = wf.y + steph,
                w = wf.w - (stepw * 2),
                h = wf.h - (steph * 2)
            })
        end
    else
        hs.alert.show("No focused window!")
    end
end

--- WinWin:moveToScreen(direction)
--- Method
--- Move the focused window between all of the screens in the `direction`.
---
--- Parameters:
---  * direction - A string specifying the direction, valid strings are: `left`, `right`, `up`, `down`, `next`.
function M.moveToScreen(direction)
    local cwin = hs.window.focusedWindow()
    if cwin then
        local cscreen = cwin:screen()
        if direction == "up" then
            cwin:moveOneScreenNorth(false, true)
        elseif direction == "down" then
            cwin:moveOneScreenSouth(false, true)
        elseif direction == "left" then
            cwin:moveOneScreenWest(false, true)
        elseif direction == "right" then
            cwin:moveOneScreenEast(false, true)
        elseif direction == "next" then
            cwin:moveToScreen(cscreen:next(), false, true)
        end
    else
        hs.alert.show("No focused window!")
    end
end

--- WinWin:centerCursor()
--- Method
--- Center the cursor on the focused window.
---
function M.centerCursor()
    local cwin = hs.window.focusedWindow()
    local wf = cwin:frame()
    local cscreen = cwin:screen()
    local cres = cscreen:fullFrame()
    if cwin then
        -- Center the cursor on the focused window
        hs.mouse.absolutePosition({ x = wf.x + wf.w / 2, y = wf.y + wf.h / 2 })
    else
        -- Center the cursor on the screen
        hs.mouse.absolutePosition({ x = cres.x + cres.w / 2, y = cres.y + cres.h / 2 })
    end
end

function M.toggleFullScreen()
    M.deactivate()
    local cwin = hs.window.focusedWindow()
    cwin:toggleFullScreen()
end

function M.resizeWindow(size1, fill)
    M.deactivate()
    local w1 = hs.window.focusedWindow()
    w1:setFullScreen(false)
    if not w1 then
        hs.alert.show("No focused window found!")
        return
    end
    w1:moveToUnit(size1, 0)
    if not fill then
        return
    end
    local size2 = {}
    size2.x = (size1.x + size1.w) % 1
    size2.y = (size1.y + size1.h) % 1
    size2.h = size1.h == 1 and 1 or (1 - size1.h)
    size2.w = size1.w == 1 and 1 or (1 - size1.w)
    local w2
    local ws = hs.window.orderedWindows()
    local i = 0
    repeat
        i = i + 1
        w2 = ws[i]
    until not w2 or (w2:id() ~= w1:id()
        and w2:screen() == w1:screen()
        and not w2:isMinimized()
        and w2:isVisible()
        and w2:isStandard())
    if w2 then
        w2:moveToUnit(size2, 0)
    else
        hs.alert.show("No another window found!")
    end
    w1:focus()
end

local resize = function(size1, tiling)
    return function() M.resizeWindow(size1, tiling) end
end

-- https://www.reddit.com/r/hammerspoon/comments/og0tio/move_mouse_linearly/
function M.moveCusorSmoothly(x1, y1, x2, y2, sleep)
    local xdiff = x2 - x1
    local ydiff = y2 - y1
    local loop = math.floor(math.sqrt((xdiff * xdiff) + (ydiff * ydiff))) * 5
    local xinc = xdiff / loop
    local yinc = ydiff / loop
    sleep = math.floor((sleep * 1000000) / loop)
    for i = 1, loop do
        x1 = x1 + xinc
        y1 = y1 + yinc
        hs.mouse.absolutePosition({ x = math.floor(x1), y = math.floor(y1) })
        hs.timer.usleep(sleep)
    end
    hs.mouse.absolutePosition({ x = math.floor(x2), y = math.floor(y2) })
end

function M.moveCursor(xfactor, yFactor)
    local cscreen = hs.screen.mainScreen()
    local cres = cscreen:fullFrame()
    local xOffset = cres.w / 250 * xfactor
    local yOffset = cres.h / 120 * yFactor
    return function()
        local point = hs.mouse.getAbsolutePosition()
        M.moveCusorSmoothly(point.x, point.y, point.x + xOffset, point.y + yOffset, 0.0001)
    end
end

function M.scroll(xdiff, ydiff)
    M.centerCursor()
    hs.eventtap.scrollWheel({ xdiff, ydiff }, {})
end

function M.switchApp()
    M.deactivate()
    hs.eventtap.keyStroke({ "cmd" }, "tab")
    hs.eventtap.keyStroke({}, "space")
    M.centerCursor()
end

M.modal
    :bind("", "tab", "Send Window to Next Display", function() M.moveToScreen("next") end)
    :bind("", "'", "Move Window to Next Desktop", function() MoveFocusedWindowToSpace("next", true) end)
    :bind("", ";", "Move Window to Prev Desktop", function() MoveFocusedWindowToSpace("prev", true) end)
M.modal
    :bind("", "return", "Fullscreen", M.toggleFullScreen)
    :bind("", "space", "Fullscreen (local)", resize({ x = 0, y = 0, w = 1, h = 1 }))
    :bind("shift", "F", "Fullscreen (local)", resize({ x = 0, y = 0, w = 1, h = 1 }))
    :bind("", "F", "Center Larger", resize({ x = 0.1, y = 0, w = 0.8, h = 1 }))
local scale = 1 / 60
local stepResize = function(u, d, l, r) return function() M.resize(u, d, l, r) end end
M.modal
    :bind("shift", "H", "Horizontal Shrink", stepResize(0, 0, -scale, -scale), nil, stepResize(0, 0, -scale, -scale))
    :bind("shift", "L", "Horizontal Expand", stepResize(0, 0, scale, scale), nil, stepResize(0, 0, scale, scale))
    :bind("shift", "J", "Vertical Expand", stepResize(scale, scale, 0, 0), nil, stepResize(scale, scale, 0, 0))
    :bind("shift", "K", "Vertical Shrink", stepResize(-scale, -scale, 0, 0), nil, stepResize(-scale, -scale, 0, 0))
    :bind("", "H", "Move Window Left", function() M.stepMove("left") end, nil, function() M.stepMove("left") end)
    :bind("", "L", "cheatsheet_ignore", function() M.stepMove("right") end, nil, function() M.stepMove("right") end)
    :bind("", "J", "cheatsheet_ignore", function() M.stepMove("down") end, nil, function() M.stepMove("down") end)
    :bind("", "K", "cheatsheet_ignore", function() M.stepMove("up") end, nil, function() M.stepMove("up") end)

-- M.modal
--     :bind("", "H", "Move Cursor Left", M.moveCursor(-1, 0), nil, M.moveCursor(-1, 0))
--     :bind("", "L", "cheatsheet_ignore", M.moveCursor(1, 0), nil, M.moveCursor(1, 0))
--     :bind("", "J", "cheatsheet_ignore", M.moveCursor(0, 1), nil, M.moveCursor(0, 1))
--     :bind("", "K", "cheatsheet_ignore", M.moveCursor(0, -1), nil, M.moveCursor(0, -1))
--     :bind("shift", "L", "cheatsheet_ignore", M.moveCursor(2, 0), nil, M.moveCursor(2, 0))
--     :bind("shift", "H", "Move Cursor Left Fast", M.moveCursor(-2, 0), nil, M.moveCursor(-2, 0))
--     :bind("shift", "J", "cheatsheet_ignore", M.moveCursor(0, 2), nil, M.moveCursor(0, 2))
--     :bind("shift", "K", "cheatsheet_ignore", M.moveCursor(0, -2), nil, M.moveCursor(0, -2))
--     :bind("", "M", "Center Cursor", M.centerCursor)
--     :bind("", "N", "Scroll Down", function() M.scroll(0, -5) end, nil, function() M.scroll(0, -5) end)
--     :bind("", "P", "Scroll Up", function() M.scroll(0, 5) end, nil, function() M.scroll(0, 5) end)

M.modal
    :bind("", "Y", "Corner (YUIO)", resize({ x = 0, y = 0, w = 0.5, h = 0.5 }))
    :bind("", "U", "cheatsheet_ignore", resize({ x = 0.5, y = 0, w = 0.5, h = 0.5 }))
    :bind("", "I", "cheatsheet_ignore", resize({ x = 0, y = 0.5, w = 0.5, h = 0.5 }))
    :bind("", "O", "cheatsheet_ignore", resize({ x = 0.5, y = 0.5, w = 0.5, h = 0.5 }))
M.modal
    :bind("", "A", "1/2 Left", resize({ x = 0, y = 0, w = 0.5, h = 1 }))
    :bind("", "D", "cheatsheet_ignore", resize({ x = 0.5, y = 0, w = 0.5, h = 1 }))
    :bind("", "S", "cheatsheet_ignore", resize({ x = 0, y = 0.5, w = 1, h = 0.5 }))
    :bind("", "W", "cheatsheet_ignore", resize({ x = 0, y = 0, w = 1, h = 0.5 }))
    :bind("alt", "A", "1/2 Left Fill", resize({ x = 0, y = 0, w = 0.5, h = 1 }, true))
    :bind("alt", "D", "cheatsheet_ignore", resize({ x = 0.5, y = 0, w = 0.5, h = 1 }, true))
    :bind("alt", "S", "cheatsheet_ignore", resize({ x = 0, y = 0.5, w = 1, h = 0.5 }, true))
    :bind("alt", "W", "cheatsheet_ignore", resize({ x = 0, y = 0, w = 1, h = 0.5 }, true))
M.modal
    :bind("shift", "A", "2/3 Left", resize({ x = 0, y = 0, w = 0.66, h = 1 }))
    :bind("shift", "D", "cheatsheet_ignore", resize({ x = 0.34, y = 0, w = 0.66, h = 1 }))
    :bind("shift", "S", "cheatsheet_ignore", resize({ x = 0, y = 0.34, w = 1, h = 0.66 }))
    :bind("shift", "W", "cheatsheet_ignore", resize({ x = 0, y = 0, w = 1, h = 0.66 }))
    :bind({ "shift", "alt" }, "A", "2/3 Left Fill", resize({ x = 0, y = 0, w = 0.66, h = 1 }, true))
    :bind({ "shift", "alt" }, "D", "cheatsheet_ignore", resize({ x = 0.34, y = 0, w = 0.66, h = 1 }, true))
    :bind({ "shift", "alt" }, "S", "cheatsheet_ignore", resize({ x = 0, y = 0.34, w = 1, h = 0.66 }, true))
    :bind({ "shift", "alt" }, "W", "cheatsheet_ignore", resize({ x = 0, y = 0, w = 1, h = 0.66 }, true))
M.modal
    :bind("cmd", "A", "1/3 Left", resize({ x = 0, y = 0, w = 0.34, h = 1 }))
    :bind("cmd", "D", "cheatsheet_ignore", resize({ x = 0.66, y = 0, w = 0.34, h = 1 }))
    :bind("cmd", "S", "cheatsheet_ignore", resize({ x = 0, y = 0.66, w = 1, h = 0.34 }))
    :bind("cmd", "W", "cheatsheet_ignore", resize({ x = 0, y = 0, w = 1, h = 0.34 }))
    :bind({ "cmd", "alt" }, "A", "1/3 Left Fill", resize({ x = 0, y = 0, w = 0.34, h = 1 }, true))
    :bind({ "cmd", "alt" }, "D", "cheatsheet_ignore", resize({ x = 0.66, y = 0, w = 0.34, h = 1 }, true))
    :bind({ "cmd", "alt" }, "S", "cheatsheet_ignore", resize({ x = 0, y = 0.66, w = 1, h = 0.34 }, true))
    :bind({ "cmd", "alt" }, "W", "cheatsheet_ignore", resize({ x = 0, y = 0, w = 1, h = 0.34 }, true))

local appName = {
    ["Code"] = "Visual Studio Code",
    ["Things"] = "Things3",
    ["iTerm2"] = "iTerm",
}
function M.openOrHideApp(name)
    local frontmostApp = hs.application.frontmostApplication()
    local frontmostAppName = frontmostApp:name()
    if frontmostAppName == name or appName[frontmostAppName] == name then
        frontmostApp:hide()
        return
    end
    hs.application.launchOrFocus(name)
    -- hs.timer.delayed.new(0.01, function()
    --     M.centerCursor()
    -- end):start()
end

-- local apps = {
--     E = "WeChat",
--     T = "Telegram",
--     G = "Discord",
--     Q = "flomo",
--     V = "Visual Studio Code",
--     F = "Finder",
-- }
-- for key, app in pairs(apps) do
--     M.modal:bind("", key, "Open " .. app, M.openApp(app))
-- end
return M
