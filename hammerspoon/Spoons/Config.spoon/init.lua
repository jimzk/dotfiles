local M = spoon.ModalMgr:newModal("config", "#1fffff")

M.open = function(url)
    url = hs.http.encodeForQuery(url)
    hs.execute("open " .. url)
end

M.modal
    :bind("", "escape", "cheatsheet_ignore", M.deactivate)
    :bind("shift", "/", "cheatsheet_ignore", function() spoon.ModalMgr:toggleCheatsheet() end)
M.modal
    :bind("", "G", "Reload goku", function()
        M.deactivate()
        local msg, _, _, return_code = hs.execute("/opt/homebrew/bin/goku 2>&1")
        if return_code == 0 then
            hs.alert("Goku configuratioin reloaded")
        else
            hs.alert("⚠️Fail to reload Goku: " .. msg)
        end
    end)
    :bind("", "H", "Reload Hammerspoon", function()
        M.deactivate()
        hs.reload()
    end)
    :bind("", "C", "Edit cheatsheet", function()
        M.deactivate()
        hs.execute("/usr/local/bin/code ~/.dotfiles/cheatsheets/navi")
    end)
M.modal
    :bind("", "1", "Doc: goku", function()
        M.deactivate()
        M.open("https://github.com/yqrashawn/GokuRakuJoudo/blob/master/src/karabiner_configurator/keys_info.clj")
        M.open("https://github.com/yqrashawn/GokuRakuJoudo/blob/master/tutorial.md")
        M.open("https://github.com/yqrashawn/GokuRakuJoudo/blob/master/examples.org")
        M.open("https://github.com/yqrashawn/GokuRakuJoudo/blob/master/resources/configurations/edn/example.edn")
        M.open("https://github.com/nikitavoloboev/dotfiles/blob/master/karabiner/karabiner.edn")
    end)
    :bind("", "2", "Doc: Hammerspoon", function()
        M.deactivate()
        M.open("https://www.hammerspoon.org/docs/index.html")
    end)
    :bind("", "3", "Doc: AppScript", function()
        M.deactivate()
        M.open("https://eastmanreference.com/complete-list-of-applescript-key-codes")
        M.open("https://sspai.com/post/46912")
        M.open("https://sspai.com/post/43758")
    end)
return M
