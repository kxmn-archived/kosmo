local M = ondemand('kosmo.ws')

--[[Todo:
# Document Webserver config and plan integration with luapage beyond CGI
]]
function M.new()
	return aurora.ws.new(kosmo.config('ws'))
end

return M