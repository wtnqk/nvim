return {
	"sakakibara/organ.nvim",
	dependencies = {
		"sakakibara/tablature.nvim",
		"sakakibara/narrow.nvim",
	},
	build = function()
		require("organ.grammar_install").install()
	end,
	config = function()
		require("organ").setup({
			org_dir = vim.fn.expand("~/org"),
		})
	end,
}
