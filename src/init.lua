require 'aurora'
kosmo = ondemand('kosmo')
--print(package.path); os.exit()

local root = arg[0]:match"^(.+)/.+$"
if not root:sub(1):match"[%./]" then root = './'..root end
package.path = root..'/?/init.lua;/?.lua;'..package.path
function kosmo.root() 
	return root
end

local kosmoConfig = {}
function kosmo.configure(name)
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
