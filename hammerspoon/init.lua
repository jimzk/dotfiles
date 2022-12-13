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
if spoon.WinWin then
  spoon.ModalMgr:new("resizeM")
  local cmodal = spoon.ModalMgr.modal_list["resizeM"]
  local deactivate = function()
    spoon.ModalMgr:deactivate({ "resizeM" })
  end
  local w = spoon.WinWin
  cmodal:bind('', 'escape', 'cheatsheet_ignore', function() spoon.ModalMgr:deactivate({ "resizeM" }) end)
  cmodal:bind('', 'Q', 'Deactivate resizeM', function() spoon.ModalMgr:deactivate({ "resizeM" }) end)
  cmodal:bind('', 'tab', 'Toggle Cheatsheet', function() spoon.ModalMgr:toggleCheatsheet() end)
  cmodal:bind('shift', '/', 'cheatsheet_ignore', function() spoon.ModalMgr:toggleCheatsheet() end)
  -- cmodal:bind('', '`', 'Center Cursor', function() spoon.WinWin:centerCursor() end)

  cmodal:bind('', '-', 'Shrink', function() w:moveAndResize("shrink") end, nil,
    function() w:moveAndResize("shrink") end)
  cmodal:bind('', '=', 'Expand', function() w:moveAndResize("expand") end, nil,
    function() w:moveAndResize("expand") end)

  cmodal:bind('shift', 'H', 'Resize (⇧ + HJKL)', function() w:stepResize("left") end, nil,
    function() w:stepResize("left") end)
  cmodal:bind('shift', 'L', 'cheatsheet_ignore', function() w:stepResize("right") end, nil,
    function() w:stepResize("right") end)
  cmodal:bind('shift', 'J', 'cheatsheet_ignore', function() w:stepResize("down") end, nil,
    function() w:stepResize("down") end)
  cmodal:bind('shift', 'K', 'cheatsheet_ignore', function() w:stepResize("up") end, nil,
    function() w:stepResize("up") end)

  cmodal:bind('', 'f', 'Fullscreen', function() w:toggleFullScreen(); deactivate() end)
  cmodal:bind('', 'G', 'Fullscreen (local)', function() w:moveAndResize("fullscreen"); deactivate() end)
  cmodal:bind('', 'C', 'Center', function() ResizeWindow('[20, 0, 80, 100]'); deactivate() end)
  cmodal:bind('', 'V', 'Center Larger', function() ResizeWindow('[10, 0, 90, 100]'); deactivate() end)

  cmodal:bind('', 'Y', 'Corner (YUIO)', function() ResizeWindow("[0, 0, 50, 50]"); deactivate() end)
  cmodal:bind('', 'U', 'cheatsheet_ignore', function() ResizeWindow("[50, 0, 100, 50]"); deactivate() end)
  cmodal:bind('', 'I', 'cheatsheet_ignore', function() ResizeWindow("[0, 50, 50, 100]"); deactivate() end)
  cmodal:bind('', 'O', 'cheatsheet_ignore', function() ResizeWindow("[50, 50, 100, 100]"); deactivate() end)

  cmodal:bind('', 'A', '1/2 Left (ADSW)', function() ResizeWindow("[0, 0, 50, 100]"); deactivate() end)
  cmodal:bind('', 'D', 'cheatsheet_ignore', function() ResizeWindow("[50, 0, 100, 100]"); deactivate() end)
  cmodal:bind('', 'S', 'cheatsheet_ignore', function() ResizeWindow("[0, 50, 100, 100]"); deactivate() end)
  cmodal:bind('', 'W', 'cheatsheet_ignore', function() ResizeWindow("[0, 0, 100, 50]"); deactivate() end)

  cmodal:bind('', 'H', '1/2 Left Fill (HJKL)',
    function() ResizeWindow("[0, 0, 50, 100]", "[50, 0, 100, 100]"); deactivate() end)
  cmodal:bind('', 'L', 'cheatsheet_ignore',
    function() ResizeWindow("[50, 0, 100, 100]", "[0, 0, 50, 100]"); deactivate() end)
  cmodal:bind('', 'J', 'cheatsheet_ignore',
    function() ResizeWindow("[0, 50, 100, 100]", "[0, 0, 100, 50]"); deactivate() end)
  cmodal:bind('', 'K', 'cheatsheet_ignore',
    function() ResizeWindow("[0, 0, 100, 50]", "[0, 50, 100, 100]"); deactivate() end)

  cmodal:bind('ctrl', 'A', '2/3 Left', function() ResizeWindow("[0, 0, 66, 100]"); deactivate() end)
  cmodal:bind('ctrl', 'D', 'cheatsheet_ignore', function() ResizeWindow("[34, 0, 100, 100]"); deactivate() end)
  cmodal:bind('ctrl', 'S', 'cheatsheet_ignore', function() ResizeWindow("[0, 34, 100, 100]"); deactivate() end)
  cmodal:bind('ctrl', 'W', 'cheatsheet_ignore', function() ResizeWindow("[0, 0, 100, 66]"); deactivate() end)
  cmodal:bind('ctrl', 'H', '2/3 Left Fill',
    function() ResizeWindow("[0, 0, 66, 100]", "[66, 0, 100, 100]"); deactivate() end)
  cmodal:bind('ctrl', 'L', 'cheatsheet_ignore',
    function() ResizeWindow("[34, 0, 100, 100]", "[0, 0, 34, 100]"); deactivate() end)
  cmodal:bind('ctrl', 'J', 'cheatsheet_ignore',
    function() ResizeWindow("[0, 34, 100, 100]", "[0, 0, 100, 34]"); deactivate() end)
  cmodal:bind('ctrl', 'K', 'cheatsheet_ignore',
    function() ResizeWindow("[0, 0, 100, 66]", "[0, 66, 100, 100]"); deactivate() end)

  cmodal:bind('cmd', 'A', '1/3 Left', function() ResizeWindow("[0, 0, 34, 100]"); deactivate() end)
  cmodal:bind('cmd', 'D', 'cheatsheet_ignore', function() ResizeWindow("[66, 0, 100, 100]"); deactivate() end)
  cmodal:bind('cmd', 'S', 'cheatsheet_ignore', function() ResizeWindow("[0, 66, 100, 100]"); deactivate() end)
  cmodal:bind('cmd', 'W', 'cheatsheet_ignore', function() ResizeWindow("[0, 0, 100, 34]"); deactivate() end)
  cmodal:bind('cmd', 'H', '1/3 Left Fill',
    function() ResizeWindow("[0, 0, 34, 100]", "[34, 0, 100, 100]"); deactivate() end)
  cmodal:bind('cmd', 'L', 'cheatsheet_ignore',
    function() ResizeWindow("[66, 0, 100, 100]", "[0, 0, 66, 100]"); deactivate() end)
  cmodal:bind('cmd', 'J', 'cheatsheet_ignore',
    function() ResizeWindow("[0, 66, 100, 100]", "[0, 0, 100, 66]"); deactivate() end)
  cmodal:bind('cmd', 'K', 'cheatsheet_ignore',
    function() ResizeWindow("[0, 0, 100, 34]", "[0, 34, 100, 100]"); deactivate() end)

  cmodal:bind('', 'left', 'Move (⬆︎⬇︎⬅︎➡︎)', function() w:stepMove("left") end, nil,
    function() w:stepMove("left") end)
  cmodal:bind('', 'right', 'cheatsheet_ignore', function() w:stepMove("right") end, nil,
    function() w:stepMove("right") end)
  cmodal:bind('', 'up', 'cheatsheet_ignore', function() w:stepMove("up") end, nil,
    function() w:stepMove("up") end)
  cmodal:bind('', 'down', 'cheatsheet_ignore', function() w:stepMove("down") end, nil,
    function() spoon.WinWin:stepMove("down") end)

  cmodal:bind('', 'space', 'Send to Next Screen', function() w:moveToScreen("next"); deactivate() end)
end

function EnterWin()
  -- Deactivate some modal environments or not before activating a new one
  spoon.ModalMgr:deactivateAll()
  -- Show an status indicator so we know we're in some modal environment now
  spoon.ModalMgr:activate({ "resizeM" }, "#B22222")
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
  if w1 then
    w1:moveToUnit(size1, 0)
    -- hs.alert("w1: ".. w1:application():name()..", "..w1:id().." size: "..size1)
    if size2 then
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
    end
    w1:focus()
  else
    hs.alert.show("No focused window found!")
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
