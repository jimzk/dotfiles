-- from: https://github.com/wangshub/hammerspoon-config/blob/master/ime/ime.lua
local obj={}
obj.__index = obj

local function Chinese()
    hs.keycodes.currentSourceID("com.apple.inputmethod.SCIM.Shuangpin")
end

local function English()
    hs.keycodes.currentSourceID("com.apple.keylayout.US")
end

-- app to expected ime config
local app2Ime = {
    {'/Applications/iTerm.app', 'English'},
    {'/Applications/Xcode.app', 'English'},
    {'/Applications/Visual Studio Code.app', 'English'},
    {'/Applications/Microsoft Edge.app', 'English'},
    {'/System/Library/CoreServices/Finder.app', 'English'},
    {'/Applications/NeteaseMusic.app', 'Chinese'},
    {'/Applications/微信.app', 'Chinese'},
    {'/Applications/Discord.app', 'Chinese'},
    {'/Applications/System Preferences.app', 'English'},
    {'/Applications/Dash.app', 'English'},
    {'/Applications/Preview.app', 'Chinese'},
    {'/Applications/Sketch.app', 'English'},
}

function updateFocusAppInputMethod()
    local focusAppPath = hs.window.frontmostWindow():application():path()
    for index, app in pairs(app2Ime) do
        local appPath = app[1]
        local expectedIme = app[2]

        if focusAppPath == appPath then
            if expectedIme == 'English' then
                English()
            else
                Chinese()
            end
            break
        end
    end
end

-- helper hotkey to figure out the app path and name of current focused window
hs.hotkey.bind({'ctrl', 'cmd'}, ".", function()
    hs.alert.show("App path:        "
    ..hs.window.focusedWindow():application():path()
    .."\n"
    .."App name:      "
    ..hs.window.focusedWindow():application():name()
    .."\n"
    .."IM source id:  "
    ..hs.keycodes.currentSourceID())
end)

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
