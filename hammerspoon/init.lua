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
hs.loadSpoon("ModalMgr")
hs.loadSpoon("EmmyLua")
hs.loadSpoon("IME")
hs.loadSpoon("WinWin")

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
-- resizeM modal environment
_G.w = spoon.WinWin
local winModalName = "resizeM"
if spoon.WinWin then
  spoon.ModalMgr:new(winModalName)
  local cmodal = spoon.ModalMgr.modal_list[winModalName]
  cmodal
      :bind('', 'escape', 'cheatsheet_ignore', function() spoon.ModalMgr:deactivate({ winModalName }) end)
      :bind('', 'X', 'Deactivate', function() spoon.ModalMgr:deactivate({ winModalName }) end)
      :bind('shift', '/', 'cheatsheet_ignore', function() spoon.ModalMgr:toggleCheatsheet() end)
      :bind('', 'tab', 'Send Window to Next Display', function() w:moveToScreen("next") end)
      :bind('', 'E', 'Move Window to Next Desktop', function() MoveFocusedWindowToSpace('next', true) end)
      :bind('', 'Q', 'Move Window to Prev Desktop', function() MoveFocusedWindowToSpace('prev', true) end)

  cmodal
      :bind('', 'F', 'Fullscreen', function() w:toggleFullScreen() end)
      :bind('', 'G', 'Fullscreen (local)', function() w:moveAndResize("fullscreen") end)
      :bind('', 'V', 'Center Larger', function() ResizeWindow('[10, 0, 90, 100]') end)
      :bind('', 'C', 'Center', function() ResizeWindow('[20, 0, 80, 100]') end)

  local scale = 1 / 60
  local resize = function(u, d, l, r) return function() w:resize(u, d, l, r) end end
  cmodal
      :bind("ctrl", 'H', 'Horizontal Shrink', resize(0, 0, -scale, -scale), nil, resize(0, 0, -scale, -scale))
      :bind("ctrl", 'L', 'Horizontal Expand', resize(0, 0, scale, scale), nil, resize(0, 0, scale, scale))
      :bind("ctrl", 'J', 'Vertical Expand', resize(scale, scale, 0, 0), nil, resize(scale, scale, 0, 0))
      :bind("ctrl", 'K', 'Vertical Shrink', resize(-scale, -scale, 0, 0), nil, resize(-scale, -scale, 0, 0))
      :bind('', 'H', 'Move Window Left', function() w:stepMove("left") end, nil, function() w:stepMove("left") end)
      :bind('', 'L', 'cheatsheet_ignore', function() w:stepMove("right") end, nil, function() w:stepMove("right") end)
      :bind('', 'J', 'cheatsheet_ignore', function() w:stepMove("down") end, nil, function() w:stepMove("down") end)
      :bind('', 'K', 'cheatsheet_ignore', function() w:stepMove("up") end, nil, function() w:stepMove("up") end)

  cmodal
      :bind('', 'Y', 'Corner (YUIO)', function() ResizeWindow("[0, 0, 50, 50]") end)
      :bind('', 'U', 'cheatsheet_ignore', function() ResizeWindow("[0, 50, 50, 100]") end)
      :bind('', 'I', 'cheatsheet_ignore', function() ResizeWindow("[50, 0, 100, 50]") end)
      :bind('', 'O', 'cheatsheet_ignore', function() ResizeWindow("[50, 50, 100, 100]") end)

  cmodal
      :bind('', 'A', '1/2 Left', function() ResizeWindow("[0, 0, 50, 100]") end)
      :bind('', 'D', 'cheatsheet_ignore', function() ResizeWindow("[50, 0, 100, 100]") end)
      :bind('', 'S', 'cheatsheet_ignore', function() ResizeWindow("[0, 50, 100, 100]") end)
      :bind('', 'W', 'cheatsheet_ignore', function() ResizeWindow("[0, 0, 100, 50]") end)
      :bind('ctrl', 'A', '1/2 Left Fill', function() ResizeWindow("[0, 0, 50, 100]", "[50, 0, 100, 100]") end)
      :bind('ctrl', 'D', 'cheatsheet_ignore', function() ResizeWindow("[50, 0, 100, 100]", "[0, 0, 50, 100]") end)
      :bind('ctrl', 'S', 'cheatsheet_ignore', function() ResizeWindow("[0, 50, 100, 100]", "[0, 0, 100, 50]") end)
      :bind('ctrl', 'W', 'cheatsheet_ignore', function() ResizeWindow("[0, 0, 100, 50]", "[0, 50, 100, 100]") end)

  cmodal
      :bind('cmd', 'A', '2/3 Left', function() ResizeWindow("[0, 0, 66, 100]") end)
      :bind('cmd', 'D', 'cheatsheet_ignore', function() ResizeWindow("[34, 0, 100, 100]") end)
      :bind('cmd', 'S', 'cheatsheet_ignore', function() ResizeWindow("[0, 34, 100, 100]") end)
      :bind('cmd', 'W', 'cheatsheet_ignore', function() ResizeWindow("[0, 0, 100, 66]") end)
      :bind({ 'ctrl', 'cmd' }, 'A', '2/3 Left Fill',
        function() ResizeWindow("[0, 0, 66, 100]", "[66, 0, 100, 100]") end)
      :bind({ 'ctrl', 'cmd' }, 'D', 'cheatsheet_ignore',
        function() ResizeWindow("[34, 0, 100, 100]", "[0, 0, 34, 100]") end)
      :bind({ 'ctrl', 'cmd' }, 'S', 'cheatsheet_ignore',
        function() ResizeWindow("[0, 34, 100, 100]", "[0, 0, 100, 34]") end)
      :bind({ 'ctrl', 'cmd' }, 'W', 'cheatsheet_ignore',
        function() ResizeWindow("[0, 0, 100, 66]", "[0, 66, 100, 100]") end)

  cmodal
      :bind('alt', 'A', '1/3 Left', function() ResizeWindow("[0, 0, 34, 100]") end)
      :bind('alt', 'D', 'cheatsheet_ignore', function() ResizeWindow("[66, 0, 100, 100]") end)
      :bind('alt', 'S', 'cheatsheet_ignore', function() ResizeWindow("[0, 66, 100, 100]") end)
      :bind('alt', 'W', 'cheatsheet_ignore', function() ResizeWindow("[0, 0, 100, 34]") end)
      :bind({ 'ctrl', 'alt' }, 'A', '1/3 Left Fill', function() ResizeWindow("[0, 0, 34, 100]", "[34, 0, 100, 100]") end)
      :bind({ 'ctrl', 'alt' }, 'D', 'cheatsheet_ignore',
        function() ResizeWindow("[66, 0, 100, 100]", "[0, 0, 66, 100]") end)
      :bind({ 'ctrl', 'alt' }, 'S', 'cheatsheet_ignore',
        function() ResizeWindow("[0, 66, 100, 100]", "[0, 0, 100, 66]") end)
      :bind({ 'ctrl', 'alt' }, 'W', 'cheatsheet_ignore',
        function() ResizeWindow("[0, 0, 100, 34]", "[0, 34, 100, 100]") end)
end

function EnterWin()
  -- Deactivate some modal environments or not before activating a new one
  spoon.ModalMgr:deactivateAll()
  -- Show an status indicator so we know we're in some modal environment now
  spoon.ModalMgr:activate({ winModalName }, "#B22222")
end

function SafeOpen(bundleId)
  -- bundleId = "com.apple.systempreferences"  -- test
  local runningApps = hs.application.get(bundleId)
  if runningApps then
    hs.application.launchOrFocusByBundleID(bundleId)
  else
    hs.alert.show("⚠️[ " .. bundleId .. " ] is not running")
  end
end

function ResizeWindow(size1, size2)
  local w1 = hs.window.focusedWindow()
  if not w1 then
    hs.alert.show("No focused window found!")
    return
  end
  w1:moveToUnit(size1, 0)
  if not size2 then
    return
  end
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
