---@param name string
---@param value any
---@param optional boolean?
---@return boolean continue
local function check_shell_variable(name, value, optional)
	local ok, err = pcall(vim.validate, name, value, "string", optional)
	if ok == false then
		vim.health.error(assert(err))
		return false
	end
	if value ~= nil then
		vim.health.ok(name .. " = " .. value)
		return false
	else
		vim.health.info(name .. " is unset. Using fallback.")
		return true
	end
end
local function check_shell()
	vim.health.start("Shell")
	vim.health.info("See `:help split-term-shell` for more information")

	if not check_shell_variable("g:splitterm_shell", vim.g.splitterm_shell, true) then
		return
	end
	if not check_shell_variable("$NVIM_SHELL", vim.env.NVIM_SHELL, true) then
		return
	end

	shell = vim.o.shell
	vim.health.ok("'shell' = " .. shell)
end

local function check_orientation()
	vim.health.start("Orientation")
	vim.health.info("See `:help split-term-orientation` for more information")
	local vertical = vim.g.splitterm_vertical
	local name = "vim.g.splitterm_vertical"
	if type(vertical) == "function" then
		vim.health.info(name .. " is a function")
		vertical = vertical()
		name = name .. "()"
	end
	if vertical == nil then
		vim.health.ok(name .. " is unset. Splitting vertically if the terminal window has more than 130 colums")
		vertical = vim.o.columns > 130
	end
	local ok, err = pcall(vim.validate, name, vertical, "boolean")
	if ok == false then
		vim.health.error(assert(err))
		return false
	end
end

local M = {}
function M.check()
	check_shell()
	check_orientation()
end
return M

