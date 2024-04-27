hs.ipc.cliInstall("/opt/homebrew")
-- Configuration resources
-- https://github.com/ashfinal/awesome-hammerspoon
-- https://github.com/Hammerspoon/Spoons/

-- http://www.hammerspoon.org/go/#fancyreload
local function reloadConfig(files)
  local doReload = false
  for _, file in pairs(files) do
    if file:sub(-4) == ".lua" then
      doReload = true
    end
  end
  if doReload then
    hs.reload()
  end
end

hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon", reloadConfig):start()
hs.hotkey.alertDuration = 0
hs.hints.showTitleThresh = 0
hs.window.animationDuration = 0

-- ModalMgr Spoon must be loaded explicitly, because this repository heavily relies upon it.
hs.loadSpoon("EmmyLua")
-- hs.loadSpoon("IME")
hs.loadSpoon("ModalMgr")
hs.loadSpoon("Win")
hs.loadSpoon("Config")
hs.loadSpoon("Bookmark")

----------------------------------------------------------------------------------------------------
-- Then we create/register all kinds of modal keybindings environments.
----------------------------------------------------------------------------------------------------
-- Window move and windowHints

-- hs.hotkey.bind({ "ctrl", "cmd", "shift" }, "/", function()
--   hs.hints.windowHints()
-- end)
-- hs.hotkey.bind({ "ctrl", "cmd", "shift" }, ".", function()
--   hs.window.switcher.nextWindow()
-- end)
-- hs.hotkey.bind({ "ctrl", "cmd", "shift" }, ",", function()
--   hs.window.switcher.previousWindow()
-- end)

----------------------------------------------------------------------------------------------------
function SafeOpen(bundleId)
  -- bundleId = "com.apple.systempreferences"  -- test
  local runningApps = hs.application.get(bundleId)
  if runningApps then
    hs.application.launchOrFocusByBundleID(bundleId)
  else
    hs.alert.show("⚠️[ " .. bundleId .. " ] is not running")
  end
end

-- Utility functions for goku / karabiner
function Alfred(text, execute)
  hs.eventtap.keyStroke({ "ctrl", "cmd", "alt", "shift" }, "space")
  hs.eventtap.keyStrokes(text)
  if execute then
    hs.timer.doAfter(0.1, function()
      hs.eventtap.keyStroke({}, "return")
    end)
  end
end

function ShowFocusedWindowInfo()
  local application = hs.application.frontmostApplication()
  local screen = hs.window.focusedWindow():screen()
  local screenFrame = screen:fullFrame()
  local focusedSpace = hs.spaces.focusedSpace()
  local spaces = hs.spaces.spacesForScreen()
  local focusedSpaceIndex = nil
  for k, space in pairs(spaces) do
    if space == focusedSpace then
      focusedSpaceIndex = k
      break
    end
  end
  local spaceInfo = focusedSpaceIndex .. " / " .. #spaces
  hs.alert.show("Display: " .. screen:name() ..
    "\nSceen  : " .. math.floor(screenFrame.w) .. " x " .. math.floor(screenFrame.h) ..
    "\nApp    : " .. application:name() ..
    "\nSpace  : " .. spaceInfo
    ,
    {
      radius = 10,
      textFont = "Monaco",
      atScreenEdge = 0 -- screen center
    }, screen, 2)
end

function FocusScreen(direction)
  local cwin = hs.window.focusedWindow()
  if cwin then
    local otherScreen = cwin:screen():next()
    if direction == "previous" then
      otherScreen = cwin:screen():previous()
    end
    local windows = hs.fnutils.filter(hs.window.orderedWindows(),
      hs.fnutils.partial(function(screen, win) return win:screen() == screen end, otherScreen))
    if #windows > 0 then
      windows[1]:focus()
    else
      hs.window.desktop():focus()
    end
  else
    hs.alert.show("No focused window!")
  end
end

function MoveFocusedWindowToSpace(direction, toFocus)
  local focusedSpace = hs.spaces.focusedSpace()
  local spaces = hs.spaces.spacesForScreen()
  local targetIndex = nil
  local offset = direction == "next" and 1 or -1
  for k, space in pairs(spaces) do
    if space == focusedSpace then
      targetIndex = k + offset
      break
    end
  end
  if targetIndex < 1 or targetIndex > #spaces then
    hs.alert.show("No " .. direction .. " space to move")
    return
  end
  local cwin = hs.window.focusedWindow()
  hs.spaces.moveWindowToSpace(cwin, spaces[targetIndex])
  if toFocus then
    cwin:focus()
  end
end

function RightClickFocusedWindow()
  local cwin = hs.window.focusedWindow()
  local wf = cwin:frame()
  local m = hs.mouse.absolutePosition()
  if cwin then
    if m.x > wf.x and m.x < (wf.x + wf.w) and m.y > wf.y and m.y < (wf.y + wf.h) then
      -- Right click on current position
      hs.eventtap.rightClick({ x = m.x, y = m.y })
    else
      -- Center the cursor on the focused window and right click
      hs.eventtap.rightClick({ x = wf.x + wf.w / 2, y = wf.y + wf.h / 2 })
    end
  else
    -- Right click on current position
    hs.eventtap.rightClick({ x = m.x, y = m.y })
  end
end

hs.alert.show("Hammerspoon Config Reloaded")
spoon.ModalMgr.supervisor:enter()
