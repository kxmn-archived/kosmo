--[[md
	# Introduction
	Kosmo is a framework and, as the greek name says, will help you
	to develop in a MVC, minimum organized environment and provide
	some useful integrations.

	The main objective is not be exhaustively complete, but provide
	some easy to go patterns to start and handle projects with less
	efforts.
]]

--[[md
	# Kosmo configuration methods

	The following methods are used to configure path settings,
	command line execution control, etc
]]

require 'aurora'
kosmo = ondemand('kosmo')

local kosmoConfig = {}
local root = arg[0]:match"^(.+)/.+$"
if not root:sub(1):match"[%./]" then root = './'..root end
package.path = root..'/lib/?.lua;'..root..'/lib/?/init.lua;'..package.path


--[[md
	## kosmo.root() : pathString
	Get the project pathstring to use building path for other resources
	* `pathString` root path for the project
]]

function kosmo.root()
	return root
end

--[[md
	## kosmo.config(name) : confTable
	Get configuration from files stored in kosmo file hierarchy
	* `name` name of config scope, as found in kosmo cfg folder
	* `confTable` table returned with the properties set on file
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

--[[md
	## kosmo.run()
	Helper to load and run special lua files from the the lib project folder.

	These files should be put under the 'run' folder in path.
	i.e., in project under the lib/run/
	Example: calling `./run myProj myComm` should require `run.myProj` and call
	the `myComm` function. The file `myProj.lua` shoud be writen as a regular
	module returning a table with properties that could be called by run

	If you want your myProj be auto executable, just return the module with a main
	function that, in absence of a method call will tried.

	This pattern creates a cozy way to create and run backends inside your project.

]]
function kosmo.run()
	local run = require('run.'..arg[1])
	if arg[2] then
		if type (arg[2]) == 'function' then
			run[arg[2]]()
		else
			for i,v in pairs(run) do
				print('Possible commands to '..arg[1]..':')
				if type(run[i]) == 'function' then
					print(i)
				end
			end
		end
	else
		if type (run.main) == 'function' then
			run.main()
		end
	end
end
