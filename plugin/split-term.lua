vim.keymap.set({ "n", "i", "v", "o", "t" }, "<Plug>SplitTermToggle", function()
	require("split-term").toggle()
end)
