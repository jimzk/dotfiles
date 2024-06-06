-- Delete buffer after x minutes
return {
  "chrisgrieser/nvim-early-retirement",
  event = "VeryLazy",
  opts = {
    retirementAgeMins = 20,
  },
}
