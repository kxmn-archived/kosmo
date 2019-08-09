local M = ondemand('kosmo.ws')
function M.new()
	return aurora.ws.new(kosmo.config('ws'))
end

return M