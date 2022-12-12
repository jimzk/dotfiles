hs.ipc.cliInstall("/opt/homebrew")
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
hs.alert.show("Hammerspoon Config Reloaded")

-- ModalMgr
-- https://github.com/ashfinal/awesome-hammerspoon
hs.hotkey.alertDuration = 0
hs.hints.showTitleThresh = 0
hs.window.animationDuration = 0

-- ModalMgr Spoon must be loaded explicitly, because this repository heavily relies upon it.
hs.loadSpoon("ModalMgr")

-- Define default Spoons which will be loaded later
local hspoon_list = {
  -- "BingDaily",
  -- "ClipShow",
  "WinWin",
  -- "KSheet",
  "IME",
}

-- Load those Spoons
for _, v in pairs(hspoon_list) do
  hs.loadSpoon(v)
end

----------------------------------------------------------------------------------------------------
-- Then we create/register all kinds of modal keybindings environments.
----------------------------------------------------------------------------------------------------
-- Window move and windowHints

hs.hotkey.bind({ "ctrl", "cmd", "shift" }, "/", function()
  hs.hints.windowHints()
end)
hs.hotkey.bind({ "ctrl", "cmd", "shift" }, ".", function()
  hs.window.switcher.nextWindow()
end)
hs.hotkey.bind({ "ctrl", "cmd", "shift" }, ",", function()
  hs.window.switcher.previousWindow()
end)

---------------------------------------------------------------------------------------------------
-- appM modal environment
spoon.ModalMgr:new("appM")
local cmodal = spoon.ModalMgr.modal_list["appM"]
cmodal:bind('', 'escape', 'Deactivate appM', function() spoon.ModalMgr:deactivate({ "appM" }) end)
cmodal:bind('', 'Q', 'Deactivate appM', function() spoon.ModalMgr:deactivate({ "appM" }) end)
cmodal:bind('', 'tab', 'Toggle Cheatsheet', function() spoon.ModalMgr:toggleCheatsheet() end)
cmodal:bind('shift', '/', 'Toggle Cheatsheet', function() spoon.ModalMgr:toggleCheatsheet() end)

cmodal:bind('cmd', '.', 'Reload HammerSpoon', function()
  spoon.ModalMgr:deactivate({ "appM" })
  hs.reload()
end)
cmodal:bind('alt', '.', 'HammerSpoon Help', function()
  spoon.ModalMgr:deactivate({ "appM" })
  hs.doc.hsdocs.forceExternalBrowser(true)
  hs.doc.hsdocs.moduleEntitiesInSidebar(true)
  hs.doc.hsdocs.help()
end)

hsapp_list = {
  { key = 'w', id = 'com.TickTick.task.mac' },
  { mod = 'cmd', key = 'w', key_stroke = { { "alt", "ctrl", "cmd", "shift" }, '5' }, message = 'Add TickTick Task' },
  { key = 'e', id = 'com.apple.finder' },
  { key = 'r', id = 'com.reederapp.5.macOS' },
  { key = 'y', id = 'com.youdao.YoudaoDict' },
  { key = 'u', key_stroke = { { "cmd", "ctrl", "alt", "shift" }, "7" }, message = 'Unclutter' },
  { key = 'p', id = 'com.jetbrains.intellij' },
  { key = 'p', id = 'com.readdle.PDFExpert-Mac' },
  { key = 's', id = 'com.microsoft.VSCode', message = 'VSCoded' },
  -- {key = 'd', id = 'com.googlecode.iterm2'},
  { key = 'f', id = 'md.obsidian' },
  { key = 'g', id = 'abnerworks.Typora' },
  { key = 'z', id = 'com.tencent.xinWeChat' },
  { key = 'x', id = 'com.hnc.Discord' },
  { key = 'c', id = 'com.microsoft.edgemac' },
  { key = 'n', id = 'com.apple.Notes' },
  { key = 'm', id = 'com.apple.ActivityMonitor' },
  { key = ',', id = 'com.apple.systempreferences' },
  { key = '.', id = 'org.hammerspoon.Hammerspoon' },
}

for _, v in ipairs(hsapp_list) do
  local mod = v.mod and v.mod or ''
  if v.id then
    local located_name = hs.application.nameForBundleID(v.id)
    local message = v.message and v.message or located_name
    if located_name then
      cmodal:bind(mod, v.key, message, function()
        spoon.ModalMgr:deactivate({ "appM" })
        if hs.application.frontmostApplication():name() == located_name then
          hs.application.frontmostApplication():hide()
        else
          hs.application.launchOrFocusByBundleID(v.id)
        end
      end)
    end
  elseif v.key_stroke then
    cmodal:bind(mod, v.key, v.message, function()
      spoon.ModalMgr:deactivate({ "appM" })
      hs.eventtap.keyStroke(v.key_stroke[1], v.key_stroke[2])
    end)
  elseif v.name then
    cmodal:bind('', v.key, v.name, function()
      spoon.ModalMgr:deactivate({ "appM" })
      hs.application.launchOrFocus(v.name)
    end)
  else
    hs.alert.show("Can't find application!")
  end
end

-- Register keybindings with modal supervisor
spoon.ModalMgr.supervisor:bind({ "alt", "ctrl", "cmd", "shift" }, "f1", "Enter AppM Environment", function()
  spoon.ModalMgr:deactivateAll()
  -- Show the keybindings cheatsheet once appM is activated
  spoon.ModalMgr:activate({ "appM" }, "#FFBD2E", false)
end)

----------------------------------------------------------------------------------------------------
-- resizeM modal environment
if spoon.WinWin then
  spoon.ModalMgr:new("resizeM")
  local cmodal = spoon.ModalMgr.modal_list["resizeM"]
  cmodal:bind('', 'escape', 'Deactivate resizeM', function() spoon.ModalMgr:deactivate({ "resizeM" }) end)
  cmodal:bind('', 'Q', 'Deactivate resizeM', function() spoon.ModalMgr:deactivate({ "resizeM" }) end)
  cmodal:bind('', 'tab', 'Toggle Cheatsheet', function() spoon.ModalMgr:toggleCheatsheet() end)
  cmodal:bind('shift', '/', 'Toggle Cheatsheet', function() spoon.ModalMgr:toggleCheatsheet() end)
  cmodal:bind('', '`', 'Center Cursor', function() spoon.WinWin:centerCursor() end)

  cmodal:bind('', '-', 'Shrink', function() spoon.WinWin:moveAndResize("shrink") end, nil,
    function() spoon.WinWin:moveAndResize("shrink") end)
  cmodal:bind('', '=', 'Expand', function() spoon.WinWin:moveAndResize("expand") end, nil,
    function() spoon.WinWin:moveAndResize("expand") end)

  cmodal:bind('shift', 'H', 'Horizontal Shrink', function() spoon.WinWin:stepResize("left") end, nil,
    function() spoon.WinWin:stepResize("left") end)
  cmodal:bind('shift', 'L', 'Horizontal Expand', function() spoon.WinWin:stepResize("right") end, nil,
    function() spoon.WinWin:stepResize("right") end)
  cmodal:bind('shift', 'J', 'Vertical Expand', function() spoon.WinWin:stepResize("down") end, nil,
    function() spoon.WinWin:stepResize("down") end)
  cmodal:bind('shift', 'K', 'Vertical Shrink', function() spoon.WinWin:stepResize("up") end, nil,
    function() spoon.WinWin:stepResize("up") end)

  cmodal:bind('', 'F', 'Fullscreen', function() spoon.WinWin:moveAndResize("fullscreen") end)
  cmodal:bind('', 'C', 'Center', function() spoon.WinWin:moveAndResize("center") end)

  cmodal:bind('', 'Y', 'Left Top', function() resizeWindow("[0, 0, 50, 50]") end)
  cmodal:bind('', 'U', 'Right Top', function() resizeWindow("[50, 0, 100, 50]") end)
  cmodal:bind('', 'I', 'Left Bottom', function() resizeWindow("[0, 50, 50, 100]") end)
  cmodal:bind('', 'O', 'Right Bottom', function() resizeWindow("[50, 50, 100, 100]") end)

  cmodal:bind('', 'H', '1/2 Left', function() resizeWindow("[0, 0, 50, 100]") end)
  cmodal:bind('', 'L', '', function() resizeWindow("[50, 0, 100, 100]") end)
  cmodal:bind('', 'J', '', function() resizeWindow("[0, 50, 100, 100]") end)
  cmodal:bind('', 'K', '', function() resizeWindow("[0, 0, 100, 50]") end)
  cmodal:bind('alt', 'H', '1/3 Left', function() resizeWindow("[0, 0, 34, 100]") end)
  cmodal:bind('alt', 'L', '', function() resizeWindow("[66, 0, 100, 100]") end)
  cmodal:bind('alt', 'J', '', function() resizeWindow("[0, 66, 100, 100]") end)
  cmodal:bind('alt', 'K', '', function() resizeWindow("[0, 0, 100, 34]") end)
  cmodal:bind('cmd', 'H', '2/3 Left', function() resizeWindow("[0, 0, 66, 100]") end)
  cmodal:bind('cmd', 'L', '', function() resizeWindow("[34, 0, 100, 100]") end)
  cmodal:bind('cmd', 'J', '', function() resizeWindow("[0, 34, 100, 100]") end)
  cmodal:bind('cmd', 'K', '', function() resizeWindow("[0, 0, 100, 66]") end)

  cmodal:bind('ctrl', 'H', '1/2 Left (Fill)', function() resizeWindow("[0, 0, 50, 100]", "[50, 0, 100, 100]") end)
  cmodal:bind('ctrl', 'L', '', function() resizeWindow("[50, 0, 100, 100]", "[0, 0, 50, 100]") end)
  cmodal:bind('ctrl', 'J', '', function() resizeWindow("[0, 50, 100, 100]", "[0, 0, 100, 50]") end)
  cmodal:bind('ctrl', 'K', '', function() resizeWindow("[0, 0, 100, 50]", "[0, 50, 100, 100]") end)
  cmodal:bind('{ctrl, alt}', 'H', '1/3 Left (Fill)', function() resizeWindow("[0, 0, 34, 100]", "[34, 0, 100, 100]") end)
  cmodal:bind('{ctrl, alt}', 'L', '', function() resizeWindow("[66, 0, 100, 100]", "[0, 0, 66, 100]") end)
  cmodal:bind('{ctrl, alt}', 'J', '', function() resizeWindow("[0, 66, 100, 100]", "[0, 0, 100, 66]") end)
  cmodal:bind('{ctrl, alt}', 'K', '', function() resizeWindow("[0, 0, 100, 34]", "[0, 34, 100, 100]") end)
  cmodal:bind('{ctrl, cmd}', 'H', '2/3 Left (Fill)', function() resizeWindow("[0, 0, 66, 100]", "[66, 0, 100, 100]") end)
  cmodal:bind('{ctrl, cmd}', 'L', '', function() resizeWindow("[34, 0, 100, 100]", "[0, 0, 34, 100]") end)
  cmodal:bind('{ctrl, cmd}', 'J', '', function() resizeWindow("[0, 34, 100, 100]", "[0, 0, 100, 34]") end)
  cmodal:bind('{ctrl, cmd}', 'K', '', function() resizeWindow("[0, 0, 100, 66]", "[0, 66, 100, 100]") end)

  cmodal:bind('', 'A', 'Move Leftward', function() spoon.WinWin:stepMove("left") end, nil,
    function() spoon.WinWin:stepMove("left") end)
  cmodal:bind('', 'D', '', function() spoon.WinWin:stepMove("right") end, nil,
    function() spoon.WinWin:stepMove("right") end)
  cmodal:bind('', 'W', '', function() spoon.WinWin:stepMove("up") end, nil, function() spoon.WinWin:stepMove("up") end)
  cmodal:bind('', 'S', '', function() spoon.WinWin:stepMove("down") end, nil,
    function() spoon.WinWin:stepMove("down") end)

  cmodal:bind('', 'left', 'Move to Left Monitor', function() spoon.WinWin:moveToScreen("left") end)
  cmodal:bind('', 'right', '', function() spoon.WinWin:moveToScreen("right") end)
  cmodal:bind('', 'up', '', function() spoon.WinWin:moveToScreen("up") end)
  cmodal:bind('', 'down', '', function() spoon.WinWin:moveToScreen("down") end)
  cmodal:bind('', 'space', 'Move to Next Monitor', function() spoon.WinWin:moveToScreen("next") end)

  -- Register resizeM with modal supervisor
  spoon.ModalMgr.supervisor:bind({ "alt", "ctrl", "cmd", "shift" }, "f2", "resizeM Environment", function()
    -- Deactivate some modal environments or not before activating a new one
    spoon.ModalMgr:deactivateAll()
    -- Show an status indicator so we know we're in some modal environment now
    spoon.ModalMgr:activate({ "resizeM" }, "#B22222")
  end)

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

function SafeOpen(bundleId)
  -- bundleId = "com.apple.systempreferences"  -- test
  local runningApps = hs.application.get(bundleId)
  if runningApps then
    hs.application.launchOrFocusByBundleID(bundleId)
  else
    hs.alert.show("⚠️[ " .. bundleId .. " ] is not running")
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

function MoveFocusedWindowToScreen(direction)
  local cwin = hs.window.focusedWindow()
  if cwin then
    local cscreen = cwin:screen()
    if direction == "previous" then
      cwin:moveToScreen(cscreen:previous(), false, true)
    else
      cwin:moveToScreen(cscreen:next(), false, true)
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

----------------------------------------------------------------------------------------------------
-- Finally we initialize ModalMgr supervisor
spoon.ModalMgr.supervisor:enter()
