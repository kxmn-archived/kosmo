local M = ondemand('kosmo')

local root = arg[0]:match"^(.+)/.+$"
if not root:sub(1):match"[%./]" then root = './'..root end
function M.root() 
	return root
end

local kosmoConfig = {}
function M.configure()
	kosmoConfig = dofile(root..'/cfg/kosmo.lua')
	kosmoConfig.webserver = dofile(root..'/cfg/webserver.lua')
end





