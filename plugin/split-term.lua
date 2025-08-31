vim.keymap.set({ "n", "i", "v", "o" }, "<Plug>SplitTermToggle", function()
	require("split-term").toggle()
end)
