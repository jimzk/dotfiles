return {
  -- fine-grained word movement
  -- https://www.reddit.com/r/neovim/comments/181bsu8/my_take_on_a_word_movement/
  -- enabled = false,
  "chrisgrieser/nvim-spider",
  enabled = true,
  event = "VeryLazy",
  keys = function()
    local motion = function(key, motionOpts)
      motionOpts = motionOpts or {}
      if not motionOpts.customPatterns then
        motionOpts.customPatterns = {
          -- Extend the default word pattern.
          patterns = { ".$" },
          overrideDefault = false,
        }
      end
      return function()
        require("spider").motion(key, motionOpts)
      end
    end
    return {
      { "w", motion("w"), mode = { "n", "o", "x" } },
      { "b", motion("b"), mode = { "n", "o", "x" } },
      { "e", motion("e"), mode = { "n", "o", "x" } },
      { "ge", motion("ge"), mode = { "n", "o", "x" } },
    }
  end,
  opts = {
    subwordMovement = false,
    skipInsignificantPunctuation = true,
  },
}
