return {
	"rainbowhxch/accelerated-jk.nvim",
	event = "BufReadPost",
	enabled = true,
	opts = {
		-- mode = "position_driven",
		enable_deceleration = true,
		acceleration_table = { 100 },
	},
	config = function(_, opts)
		copy(opts)
		require("accelerated-jk").setup(opts)
		map("n", "j", "<Plug>(accelerated_jk_gj)")
		map("n", "k", "<Plug>(accelerated_jk_gk)")
	end,
}
