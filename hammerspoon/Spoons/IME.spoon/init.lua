-- from: https://github.com/wangshub/hammerspoon-config/blob/master/ime/ime.lua
local obj={}
obj.__index = obj

local function Chinese()
    hs.keycodes.currentSourceID("com.apple.inputmethod.SCIM.Shuangpin")
end

local function English()
    hs.keycodes.currentSourceID("com.apple.keylayout.US")
end

local app2Chinese = {
    "WeChat",
    "NeteaseMusic",
    "Discord",
    "TickTick",
}

function updateFocusAppInputMethod()
    local focusAppPath = hs.window.frontmostWindow():application():path()
    local switchToChinese = false
    for index, value in ipairs(app2Chinese) do
        if focusAppPath == '/Applications/'..value..'.app' then
            switchToChinese = true
            break
        end
    end
    if switchToChinese then
        Chinese()
    else
        English()
    end
end

-- helper hotkey to figure out the app path and name of current focused window
-- hs.hotkey.bind({'ctrl', 'cmd'}, ".", function()
--     hs.alert.show("App path:        "
--     ..hs.window.focusedWindow():application():path()
--     .."\n"
--     .."App name:      "
--     ..hs.window.focusedWindow():application():name()
--     .."\n"
--     .."IM source id:  "
--     ..hs.keycodes.currentSourceID())
-- end)

-- Handle cursor focus and application's screen manage.
function applicationWatcher(appName, eventType, appObject)
    if (eventType == hs.application.watcher.activated) then
        updateFocusAppInputMethod()
    end
end

function obj:init()
    appWatcher = hs.application.watcher.new(applicationWatcher)
    appWatcher:start()
end

return obj
