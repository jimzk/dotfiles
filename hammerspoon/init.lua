-- http://www.hammerspoon.org/go/#fancyreload
function reloadConfig(files)
    doReload = false
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

-- vim mode anywhere
--- https://github.com/dbalatero/VimMode.spoon
local VimMode = hs.loadSpoon('VimMode')
local vim = VimMode:new()
vim
    :disableForApp('iTerm')
    :disableForApp('Terminal')
    :disableForApp('Code')
    :disableForApp('MacVim')
    :disableForApp('zoom.us')
    :shouldDimScreenInNormalMode(false)
    :bindHotKeys({ enter = {{"alt", "ctrl", "cmd", "shift"}, 'V'} })

-- ModalMgr
-- https://github.com/ashfinal/awesome-hammerspoon
hs.hotkey.alertDuration = 0
hs.hints.showTitleThresh = 0
hs.window.animationDuration = 0

-- ModalMgr Spoon must be loaded explicitly, because this repository heavily relies upon it.
hs.loadSpoon("ModalMgr")

-- Define default Spoons which will be loaded later
if not hspoon_list then
    hspoon_list = {
        "BingDaily",
        "ClipShow",
        "WinWin",
        "KSheet",
        "IME",
    }
end

-- Load those Spoons
for _, v in pairs(hspoon_list) do
    hs.loadSpoon(v)
end

----------------------------------------------------------------------------------------------------
-- Then we create/register all kinds of modal keybindings environments.
----------------------------------------------------------------------------------------------------
-- Register windowHints (Register a keybinding which is NOT modal environment with modal supervisor)

spoon.ModalMgr.supervisor:bind({"alt", "shift"}, "/", 'Show Window Hints', function()
    spoon.ModalMgr.deactivateAll()
    hs.hints.windowHints()
end)
spoon.ModalMgr.supervisor:bind({"alt", "shift"}, ".", "Next Window", function()
    spoon.ModalMgr.deactivateAll()
    hs.window.switcher.nextWindow()
end)
spoon.ModalMgr.supervisor:bind({"alt", "shift"}, ",", "Previous Window", function()
    spoon.ModalMgr.deactivateAll()
    hs.window.switcher.previousWindow()
end)

----------------------------------------------------------------------------------------------------
-- appM modal environment
spoon.ModalMgr:new("appM")
local cmodal = spoon.ModalMgr.modal_list["appM"]
cmodal:bind('', 'escape', 'Deactivate appM', function() spoon.ModalMgr:deactivate({"appM"}) end)
cmodal:bind('', 'Q', 'Deactivate appM', function() spoon.ModalMgr:deactivate({"appM"}) end)
cmodal:bind('', 'tab', 'Toggle Cheatsheet', function() spoon.ModalMgr:toggleCheatsheet({"appM"}, true) end)

cmodal:bind('cmd', 'C', 'Clipboard', function()
    -- We need to take action upon hsclipsM_keys is pressed, since pressing another key to showing ClipShow panel is redundant.
    spoon.ClipShow:toggleShow()
    -- Need a little trick here. Since the content type of system clipboard may be "URL", in which case we don't need to activate clipshowM.
    if spoon.ClipShow.canvas:isShowing() then
        spoon.ModalMgr:deactivate({"appM"})
        spoon.ModalMgr:activate({"clipshowM"})
    end
end)

cmodal:bind("cmd", 'S', 'Cheatsheet', function()
    spoon.ModalMgr:deactivate({"appM"})
    spoon.KSheet:show()
    spoon.ModalMgr:activate({"cheatsheetM"})
end)

cmodal:bind('cmd', '.', 'Reload HammerSpoon Configuration', function()
    spoon.ModalMgr:deactivate({"appM"})
    hs.reload()
end)
cmodal:bind('alt', '.', 'HammerSpoon Help', function()
    spoon.ModalMgr:deactivate({"appM"})
    hs.doc.hsdocs.forceExternalBrowser(true)
    hs.doc.hsdocs.moduleEntitiesInSidebar(true)
    hs.doc.hsdocs.help()
end)

cmodal:bind('cmd', 'w', 'Quick add Ticktick task', function()
    spoon.ModalMgr:deactivate({"appM"})
    hs.eventtap.keyStroke({"alt", "ctrl", "cmd", "shift"}, '5')
end)

hsapp_list = {
    {key = 'w', id = 'com.TickTick.task.mac'},
    {key = 'e', name = 'Finder'},
    {key = 'd', name = 'iTerm', key_stroke = {{"cmd", "ctrl", "alt", "shift"}, "'"}},
    {key = 's', id = 'com.microsoft.VSCode'},
    {key = 'c', id = 'com.microsoft.edgemac'},
    {key = 'r', id = 'com.reederapp.5.macOS'},
    {key = 'f', id = 'md.obsidian'},
    {key = 'g', id = 'abnerworks.Typora'},
    {key = 'u', name = 'Unclutter', key_stroke = {{"cmd", "ctrl", "alt", "shift"}, "7"}},
    {key = 'y', id = 'com.youdao.YoudaoDict'},
    {key = 'p', id = 'com.apple.systempreferences'},
    {key = 'x', id = 'com.hnc.Discord'},
    {key = 'z', id = 'com.tencent.xinWeChat'},
    {key = 'p', id = 'com.readdle.PDFExpert-Mac'},
    {key = 'n', id = 'com.apple.Notes'},
    {key = 'm', id = 'com.apple.ActivityMonitor'},
    {key = '.', id = 'org.hammerspoon.Hammerspoon'},
}

for _, v in ipairs(hsapp_list) do
    if v.id then
        local located_name = hs.application.nameForBundleID(v.id)
        if located_name then
            cmodal:bind('', v.key, located_name, function()
                spoon.ModalMgr:deactivate({"appM"})
                if hs.application.frontmostApplication():name() == located_name then
                    hs.eventtap.keyStroke('cmd', 'H')
                else
                    hs.application.launchOrFocusByBundleID(v.id)
                end
            end)
        end
    elseif v.key_stroke then
        cmodal:bind('', v.key, v.name, function()
            spoon.ModalMgr:deactivate({"appM"})
            hs.eventtap.keyStroke(v.key_stroke[1], v.key_stroke[2])
        end)
    elseif v.name then
        cmodal:bind('', v.key, v.name, function()
            spoon.ModalMgr:deactivate({"appM"})
            hs.application.launchOrFocus(v.name)
        end)
    end
end

-- Then we register some keybindings with modal supervisor
spoon.ModalMgr.supervisor:bind({"alt", "ctrl", "cmd", "shift"}, "D", "Enter AppM Environment", function()
    spoon.ModalMgr:deactivateAll()
    -- Show the keybindings cheatsheet once appM is activated
    spoon.ModalMgr:activate({"appM"}, "#FFBD2E", false)
end)

----------------------------------------------------------------------------------------------------
-- resizeM modal environment
if spoon.WinWin then
    spoon.ModalMgr:new("resizeM")
    local cmodal = spoon.ModalMgr.modal_list["resizeM"]
    cmodal:bind('', 'escape', 'Deactivate resizeM', function() spoon.ModalMgr:deactivate({"resizeM"}) end)
    cmodal:bind('', 'Q', 'Deactivate resizeM', function() spoon.ModalMgr:deactivate({"resizeM"}) end)
    cmodal:bind('', 'tab', 'Toggle Cheatsheet', function() spoon.ModalMgr:toggleCheatsheet() end)
    cmodal:bind('', '`', 'Center Cursor', function() spoon.WinWin:centerCursor() end)

    cmodal:bind('', 'A', 'Move Leftward', function() spoon.WinWin:stepMove("left") end, nil, function() spoon.WinWin:stepMove("left") end)
    cmodal:bind('', 'D', 'Move Rightward', function() spoon.WinWin:stepMove("right") end, nil, function() spoon.WinWin:stepMove("right") end)
    cmodal:bind('', 'W', 'Move Upward', function() spoon.WinWin:stepMove("up") end, nil, function() spoon.WinWin:stepMove("up") end)
    cmodal:bind('', 'S', 'Move Downward', function() spoon.WinWin:stepMove("down") end, nil, function() spoon.WinWin:stepMove("down") end)

    cmodal:bind('', 'F', 'Fullscreen', function() spoon.WinWin:moveAndResize("fullscreen") end)
    cmodal:bind('', 'C', 'Center Window', function() spoon.WinWin:moveAndResize("center") end)

    cmodal:bind('', '=', 'Expand', function() spoon.WinWin:moveAndResize("expand") end, nil, function() spoon.WinWin:moveAndResize("expand") end)
    cmodal:bind('', '-', 'Shrink', function() spoon.WinWin:moveAndResize("shrink") end, nil, function() spoon.WinWin:moveAndResize("shrink") end)

    cmodal:bind('shift', 'H', 'Horizontal Shrink', function() spoon.WinWin:stepResize("left") end, nil, function() spoon.WinWin:stepResize("left") end)
    cmodal:bind('shift', 'L', 'Horizontal Expand', function() spoon.WinWin:stepResize("right") end, nil, function() spoon.WinWin:stepResize("right") end)
    cmodal:bind('shift', 'J', 'Vertical Expand', function() spoon.WinWin:stepResize("down") end, nil, function() spoon.WinWin:stepResize("down") end)
    cmodal:bind('shift', 'K', 'Vertical Shrink', function() spoon.WinWin:stepResize("up") end, nil, function() spoon.WinWin:stepResize("up") end)

    cmodal:bind('', 'Y', 'Left Top', function() resizeWindow("[0, 0, 50, 50]") end)
    cmodal:bind('', 'U', 'Right Top', function() resizeWindow("[50, 0, 100, 50]") end)
    cmodal:bind('', 'I', 'Left Bottom', function() resizeWindow("[0, 50, 50, 100]") end)
    cmodal:bind('', 'O', 'Right Bottom', function() resizeWindow("[50, 50, 100, 100]") end)

    cmodal:bind('', 'H', '50 Left', function() resizeWindow("[0, 0, 50, 100]") end)
    cmodal:bind('', 'L', '', function() resizeWindow("[50, 0, 100, 100]") end)
    cmodal:bind('', 'J', '', function() resizeWindow("[0, 50, 100, 100]") end)
    cmodal:bind('', 'K', '', function() resizeWindow("[0, 0, 100, 50]") end)
    cmodal:bind('alt', 'H', '35 Left', function() resizeWindow("[0, 0, 35, 100]") end)
    cmodal:bind('alt', 'L', '', function() resizeWindow("[65, 0, 100, 100]") end)
    cmodal:bind('alt', 'J', '', function() resizeWindow("[0, 65, 100, 100]") end)
    cmodal:bind('alt', 'K', '', function() resizeWindow("[0, 0, 100, 35]") end)
    cmodal:bind('cmd', 'H', '65 Left', function() resizeWindow("[0, 0, 65, 100]") end)
    cmodal:bind('cmd', 'L', '', function() resizeWindow("[35, 0, 100, 100]") end)
    cmodal:bind('cmd', 'J', '', function() resizeWindow("[0, 35, 100, 100]") end)
    cmodal:bind('cmd', 'K', '', function() resizeWindow("[0, 0, 100, 65]") end)

    cmodal:bind('ctrl', 'H', '50 Left (Fill)', function() resizeWindow("[0, 0, 50, 100]", "[50, 0, 100, 100]") end)
    cmodal:bind('ctrl', 'L', '', function() resizeWindow("[50, 0, 100, 100]", "[0, 0, 50, 100]") end)
    cmodal:bind('ctrl', 'J', '', function() resizeWindow("[0, 50, 100, 100]", "[0, 0, 100, 50]") end)
    cmodal:bind('ctrl', 'K', '', function() resizeWindow("[0, 0, 100, 50]", "[0, 50, 100, 100]") end)
    cmodal:bind('{ctrl, alt}', 'H', '35 Left (Fill)', function() resizeWindow("[0, 0, 35, 100]", "[35, 0, 100, 100]") end)
    cmodal:bind('{ctrl, alt}', 'L', '', function() resizeWindow("[65, 0, 100, 100]", "[0, 0, 65, 100]") end)
    cmodal:bind('{ctrl, alt}', 'J', '', function() resizeWindow("[0, 65, 100, 100]", "[0, 0, 100, 65]") end)
    cmodal:bind('{ctrl, alt}', 'K', '', function() resizeWindow("[0, 0, 100, 35]", "[0, 35, 100, 100]") end)
    cmodal:bind('{ctrl, cmd}', 'H', '65 Left (Fill)', function() resizeWindow("[0, 0, 65, 100]", "[65, 0, 100, 100]") end)
    cmodal:bind('{ctrl, cmd}', 'L', '', function() resizeWindow("[35, 0, 100, 100]", "[0, 0, 35, 100]") end)
    cmodal:bind('{ctrl, cmd}', 'J', '', function() resizeWindow("[0, 35, 100, 100]", "[0, 0, 100, 35]") end)
    cmodal:bind('{ctrl, cmd}', 'K', '', function() resizeWindow("[0, 0, 100, 65]", "[0, 65, 100, 100]") end)

    cmodal:bind('', 'left', 'Move to Left Monitor', function() spoon.WinWin:moveToScreen("left") end)
    cmodal:bind('', 'right', 'Move to Right Monitor', function() spoon.WinWin:moveToScreen("right") end)
    cmodal:bind('', 'up', 'Move to Above Monitor', function() spoon.WinWin:moveToScreen("up") end)
    cmodal:bind('', 'down', 'Move to Below Monitor', function() spoon.WinWin:moveToScreen("down") end)
    cmodal:bind('', 'space', 'Move to Next Monitor', function() spoon.WinWin:moveToScreen("next") end)

    -- Register resizeM with modal supervisor
    spoon.ModalMgr.supervisor:bind({"alt", "ctrl", "cmd", "shift"}, "W", "resizeM Environment", function()
        -- Deactivate some modal environments or not before activating a new one
        spoon.ModalMgr:deactivateAll()
        -- Show an status indicator so we know we're in some modal environment now
        spoon.ModalMgr:activate({"resizeM"}, "#B22222")
    end)

end

function resizeWindow(size1, size2)
    local w1 = hs.window.focusedWindow()
    if w1 then
        w1:moveToUnit(size1, 0)
        -- hs.alert("w1: ".. w1:application():name()..", "..w1:id().." size: "..size1)
        if size2 then
            w1:sendToBack()
            local w2 = hs.window.focusedWindow()
            local i = 0
            local ws = hs.window.orderedWindows()
            -- the other window should be a different one
            while w2 and (w2:id() == w1:id() or w2:screen() ~= w1:screen()) do
                i = i + 1
                w2 = ws[i]
                -- hs.alert.show("i: "..i)
            end
            if w2 then
                w2:moveToUnit(size2, 0)
                -- hs.alert("w2: ".. w2:application():name()..", "..w2:id().." size: "..size2)
            else
                hs.alert.show("No another window found!")
            end
        end
        w1:focus()
    else
        hs.alert.show("No focused window found!")
    end
end

----------------------------------------------------------------------------------------------------
-- clipshowM modal environment
if spoon.ClipShow then
    spoon.ModalMgr:new("clipshowM")
    local cmodal = spoon.ModalMgr.modal_list["clipshowM"]
    cmodal:bind('', 'escape', 'Deactivate clipshowM', function()
        spoon.ClipShow:toggleShow()
        spoon.ModalMgr:deactivate({"clipshowM"})
    end)
    cmodal:bind('', 'Q', 'Deactivate clipshowM', function()
        spoon.ClipShow:toggleShow()
        spoon.ModalMgr:deactivate({"clipshowM"})
    end)
    cmodal:bind('', 'N', 'Save this Session', function()
        spoon.ClipShow:saveToSession()
    end)
    cmodal:bind('', 'R', 'Restore last Session', function()
        spoon.ClipShow:restoreLastSession()
    end)
    cmodal:bind('', 'B', 'Open in Browser', function()
        spoon.ClipShow:openInBrowserWithRef()
        spoon.ClipShow:toggleShow()
        spoon.ModalMgr:deactivate({"clipshowM"})
    end)
    cmodal:bind('', 'S', 'Search with Bing', function()
        spoon.ClipShow:openInBrowserWithRef("https://www.bing.com/search?q=")
        spoon.ClipShow:toggleShow()
        spoon.ModalMgr:deactivate({"clipshowM"})
    end)
    cmodal:bind('', 'G', 'Search with Google', function()
        spoon.ClipShow:openInBrowserWithRef("https://www.google.com/search?q=")
        spoon.ClipShow:toggleShow()
        spoon.ModalMgr:deactivate({"clipshowM"})
    end)
    cmodal:bind('', 'H', 'Search in Github', function()
        spoon.ClipShow:openInBrowserWithRef("https://github.com/search?q=")
        spoon.ClipShow:toggleShow()
        spoon.ModalMgr:deactivate({"clipshowM"})
    end)
    cmodal:bind('', 'D', 'Save to Desktop', function()
        spoon.ClipShow:saveToFile()
        spoon.ClipShow:toggleShow()
        spoon.ModalMgr:deactivate({"clipshowM"})
    end)
    cmodal:bind('', 'V', 'Edit in VSCode', function()
        spoon.ClipShow:EditWithCommand("/usr/local/bin/code")
        spoon.ClipShow:toggleShow()
        spoon.ModalMgr:deactivate({"clipshowM"})
    end)
end

----------------------------------------------------------------------------------------------------
-- cheatsheetM modal environment (Because KSheet Spoon is NOT loaded, cheatsheetM will NOT be activated)
if spoon.KSheet then
    spoon.ModalMgr:new("cheatsheetM")
    local cmodal = spoon.ModalMgr.modal_list["cheatsheetM"]
    cmodal:bind('', 'escape', 'Deactivate cheatsheetM', function()
        spoon.KSheet:hide()
        spoon.ModalMgr:deactivate({"cheatsheetM"})
    end)
    cmodal:bind('', 'Q', 'Deactivate cheatsheetM', function()
        spoon.KSheet:hide()
        spoon.ModalMgr:deactivate({"cheatsheetM"})
    end)
end

----------------------------------------------------------------------------------------------------
-- Finally we initialize ModalMgr supervisor
spoon.ModalMgr.supervisor:enter()
