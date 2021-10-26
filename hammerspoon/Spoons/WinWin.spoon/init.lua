--- === WinWin ===
---
--- Windows manipulation
---
--- Download: [https://github.com/Hammerspoon/Spoons/raw/master/Spoons/WinWin.spoon.zip](https://github.com/Hammerspoon/Spoons/raw/master/Spoons/WinWin.spoon.zip)

local obj={}
obj.__index = obj

-- Windows manipulation history. Only the last operation is stored.
obj.history = {}

--- WinWin.gridparts
--- Variable
--- An integer specifying how many gridparts the screen should be divided into. Defaults to 30.
obj.gridparts = 30

--- WinWin:stepMove(direction)
--- Method
--- Move the focused window in the `direction` by on step. The step scale equals to the width/height of one gridpart.
---
--- Parameters:
---  * direction - A string specifying the direction, valid strings are: `left`, `right`, `up`, `down`.
function obj:stepMove(direction)
    local cwin = hs.window.focusedWindow()
    if cwin then
        local cscreen = cwin:screen()
        local cres = cscreen:fullFrame()
        local stepw = cres.w/obj.gridparts
        local steph = cres.h/obj.gridparts
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
        cwin:move({x, y}, true)
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
function obj:stepResize(direction)
    local cwin = hs.window.focusedWindow()
    if cwin then
        local cscreen = cwin:screen()
        local cres = cscreen:fullFrame()
        local stepw = cres.w/obj.gridparts
        local steph = cres.h/obj.gridparts
        local wsize = cwin:size()
        if direction == "left" then
            cwin:setSize({w=wsize.w-stepw, h=wsize.h})
        elseif direction == "right" then
            cwin:setSize({w=wsize.w+stepw, h=wsize.h})
        elseif direction == "up" then
            cwin:setSize({w=wsize.w, h=wsize.h-steph})
        elseif direction == "down" then
            cwin:setSize({w=wsize.w, h=wsize.h+steph})
        end
    else
        hs.alert.show("No focused window!")
    end
end

function obj:moveAndResize(option)
    local cwin = hs.window.focusedWindow()
    if cwin then
        local cscreen = cwin:screen()
        local cres = cscreen:fullFrame()
        local stepw = cres.w/obj.gridparts
        local steph = cres.h/obj.gridparts
        local wf = cwin:frame()
        if option == "fullscreen" then
            cwin:setFrame({x=cres.x, y=cres.y, w=cres.w, h=cres.h})
        elseif option == "center" then
            cwin:centerOnScreen()
        elseif option == "expand" then
            cwin:setFrameInScreenBounds({x=wf.x-stepw, y=wf.y-steph, w=wf.w+(stepw*2), h=wf.h+(steph*2)})
        elseif option == "shrink" then
            cwin:setFrameInScreenBounds({x=wf.x+stepw, y=wf.y+steph, w=wf.w-(stepw*2), h=wf.h-(steph*2)})
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
function obj:moveToScreen(direction)
    local cwin = hs.window.focusedWindow()
    if cwin then
        local cscreen = cwin:screen()
        if direction == "up" then
            cwin:moveOneScreenNorth(true, true)
        elseif direction == "down" then
            cwin:moveOneScreenSouth(true, true)
        elseif direction == "left" then
            cwin:moveOneScreenWest(true, true)
        elseif direction == "right" then
            cwin:moveOneScreenEast(true, true)
        elseif direction == "next" then
            cwin:moveToScreen(cscreen:next(), true, true)
        end
    else
        hs.alert.show("No focused window!")
    end
end

--- WinWin:centerCursor()
--- Method
--- Center the cursor on the focused window.
---

function obj:centerCursor()
    local cwin = hs.window.focusedWindow()
    local wf = cwin:frame()
    local cscreen = cwin:screen()
    local cres = cscreen:fullFrame()
    if cwin then
        -- Center the cursor one the focused window
        hs.mouse.setAbsolutePosition({x=wf.x+wf.w/2, y=wf.y+wf.h/2})
    else
        -- Center the cursor on the screen
        hs.mouse.setAbsolutePosition({x=cres.x+cres.w/2, y=cres.y+cres.h/2})
    end
end

return obj
