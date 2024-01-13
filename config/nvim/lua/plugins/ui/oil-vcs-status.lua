return {
  -- https://www.reddit.com/r/neovim/s/KrWuH4McDW
  "SirZenith/oil-vcs-status",
  opts = function()
    local status_const = require("oil-vcs-status.constant.status")
    local StatusType = status_const.StatusType
    return {
      status_symbol = {
        [StatusType.Added] = "",
        [StatusType.Copied] = "󰆏",
        [StatusType.Deleted] = "",
        [StatusType.Ignored] = "",
        [StatusType.Modified] = "",
        [StatusType.Renamed] = "",
        [StatusType.TypeChanged] = "󰉺",
        [StatusType.Unmodified] = " ",
        [StatusType.Unmerged] = "",
        [StatusType.Untracked] = "",
        [StatusType.External] = "",

        [StatusType.UpstreamAdded] = "󰈞",
        [StatusType.UpstreamCopied] = "󰈢",
        [StatusType.UpstreamDeleted] = "",
        [StatusType.UpstreamIgnored] = " ",
        [StatusType.UpstreamModified] = "󰏫",
        [StatusType.UpstreamRenamed] = "",
        [StatusType.UpstreamTypeChanged] = "󱧶",
        [StatusType.UpstreamUnmodified] = " ",
        [StatusType.UpstreamUnmerged] = "",
        [StatusType.UpstreamUntracked] = " ",
        [StatusType.UpstreamExternal] = "",
      },
    }
  end,
}
