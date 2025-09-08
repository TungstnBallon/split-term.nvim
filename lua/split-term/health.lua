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
	if vertical == nil then
		vim.health.info("g:splitterm_vertical is unset. Splitting horizontally")
		return
	end

	if type(vertical) == "function" then
		vertical = vertical()
		vim.health.info("g:splitterm_vertical is a function evaluating to `" .. tostring(vertical) .. "`")
	end

	local ok, err = pcall(vim.validate, "g:splitterm_vertical", vertical, "boolean")
	if ok == false then
		vim.health.error(assert(err), "See `:help |g:splitterm_vertical|`")
	else
		local msg = vertical and "true. Splitting vertically" or "false. Splitting hotizontally"
		vim.health.ok("g:splitterm_vertical is " .. msg)
	end
end

local M = {}
function M.check()
	check_shell()
	check_orientation()
end
return M
