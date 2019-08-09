require 'aurora'
kosmo = ondemand('kosmo')


local kosmoConfig = {}
local root = arg[0]:match"^(.+)/.+$"
if not root:sub(1):match"[%./]" then root = './'..root end
package.path = root..'/?/init.lua;/?.lua;'..package.path

--[[md
kosmo.root() : path=string
* path=string: root path for the project
]]

function kosmo.root() 
	return root
end




--[[md
kosmo.config(name) : conf=table
* name: name of config scope, as found in kosmo cfg folder
* conf=table : table returned with the properties set on file
]]

function kosmo.config(name)
	if name then
		if not kosmoConfig[name] then 
			kosmoConfig[name] = dofile(root..'/cfg/'..name..'.lua')
		end
		return kosmoConfig[name] or false
	end
	return kosmoConfig
end

function kosmo.run()
	assert(dofile(root..'/lib/'..arg[1]:gsub('%.','/'):gsub('$','.lua')),'Usage: ./run <lib>')
end
