local M = spoon.ModalMgr:newModal("bookmark", "#a9dcad")

local open = function(url)
    return function()
        M.deactivate()
        url = hs.http.encodeForQuery(url)
        hs.execute("open " .. url)
    end
end

M.modal
    :bind("", "t", "Twitter", open("https://twitter.com/home"))
    :bind("", "g", "GitHub Notification", open("https://github.com/notifications"))
    :bind("", "l", "Bilibili Watch List", open("https://www.bilibili.com/watchlater"))
    :bind("", "m", "Gmail", open("https://mail.google.com/mail"))

return M
